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

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(MyApp());
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
    ColorScheme light = ColorScheme.light(primary: Color(0xffaeea00), secondary: Color(0xFF987f0f));
    ColorScheme dark = ColorScheme.dark(primary: Color(0xffaeea00), secondary: Color(0xFF987f0f));
    return DynamicColorBuilder(builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      return MaterialApp(
        title: 'clearbricks',
        localizationsDelegates: [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate
        ],
        navigatorObservers: [routeObserver],
        supportedLocales: S.delegate.supportedLocales,
        theme: lightDynamic == null ? ThemeData(colorScheme: light) : ThemeData(colorScheme: lightDynamic),
        darkTheme: darkDynamic == null ? ThemeData(colorScheme: dark) : ThemeData(colorScheme: darkDynamic),
        debugShowCheckedModeBanner: false,
        home: Scaffold(
          body: Sound(child: Game(child: KeyboardController(child: _HomePage()))),
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
    bool? platformMessage = data.getBool("networkAlert");

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
                TextButton(onPressed: () => _checkWifi(context), child: Text("Refresh")),
                TextButton(
                    onPressed: () => SystemChannels.platform.invokeMethod('SystemNavigator.pop'),
                    child: Text("Exit"))
              ],
            ));
  }
}
