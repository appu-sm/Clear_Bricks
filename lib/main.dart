import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:clear_bricks/gamer/gamer.dart';
import 'package:clear_bricks/generated/i18n.dart';
import 'package:clear_bricks/material/audios.dart';
import 'package:clear_bricks/panel/page_portrait.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'gamer/keyboard.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:dynamic_colorscheme/dynamic_colorscheme.dart';
import 'package:material_color_utilities/material_color_utilities.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  _disableDebugPrint();
  MobileAds.instance.initialize();
  runApp(MyApp());
}

void _disableDebugPrint() {
  bool debug = false;
  assert(() {
    debug = true;
    return true;
  }());
  if (!debug) {
    debugPrint = (String message, {int wrapWidth}) {
      //disable log print when not in debug mode
    };
  }
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    clearPreviousState();
  }

  clearPreviousState() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    data.clear();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme m3Light;
    ColorScheme m3Dark;
    ColorScheme light = ColorScheme.light(
        primary: Color(0xffaeea00), secondary: Color(0xFF987f0f));
    ColorScheme dark = ColorScheme.dark(
        primary: Color(0xffaeea00), secondary: Color(0xFF987f0f));
    return DynamicColorBuilder(builder: (CorePalette palette) {
      if (palette != null) {
        m3Light = DynamicColorScheme.generate(palette, dark: false);
        m3Dark = DynamicColorScheme.generate(palette, dark: true);
      }

      return MaterialApp(
        title: 'clearbricks',
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        navigatorObservers: [routeObserver],
        supportedLocales: S.delegate.supportedLocales,
        theme: m3Light == null
            ? ThemeData(colorScheme: light)
            : ThemeData(colorScheme: m3Light),
        darkTheme: m3Dark == null
            ? ThemeData(colorScheme: dark)
            : ThemeData(colorScheme: m3Dark),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body:
              Sound(child: Game(child: KeyboardController(child: _HomePage()))),
        ),
      );
    });
  }
}

const SCREEN_BORDER_WIDTH = 3.0;

class _HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _checkWifi(context);

    bool land = MediaQuery.of(context).orientation == Orientation.landscape;
    return land ? PageLand() : PagePortrait();
  }

  _checkWifi(context) async {
    var connectivityResult = await (new Connectivity().checkConnectivity());
    bool connectedToWifi = (connectivityResult == ConnectivityResult.wifi);
    bool connectedToMobile = (connectivityResult == ConnectivityResult.mobile);

    SharedPreferences data = await SharedPreferences.getInstance();
    bool platformMessage = data.getBool("networkAlert");

    if (!connectedToWifi && !connectedToMobile) {
      if (platformMessage == null || !platformMessage) {
        showAlert(context);
      }
    } else {
      if (platformMessage != null && platformMessage == true) {
        data.setBool("networkAlert", false);
        Navigator.of(context, rootNavigator: true).pop('dialog');
      }
    }
  }

  void showAlert(BuildContext context) async {
    SharedPreferences data = await SharedPreferences.getInstance();
    data.setBool("networkAlert", true);
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Text("Network Required"),
              content: Text("Network connection is required to play the game"),
              actions: [
                TextButton(
                    onPressed: () => _checkWifi(context),
                    child: Text("Refresh")),
                TextButton(
                    onPressed: () => SystemChannels.platform
                        .invokeMethod('SystemNavigator.pop'),
                    child: Text("Exit"))
              ],
            ));
  }
}
