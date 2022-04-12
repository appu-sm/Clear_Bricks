import 'package:flutter/material.dart';
import 'package:clear_bricks/main.dart';
import 'package:clear_bricks/panel/controller.dart';
import 'package:clear_bricks/panel/screen.dart';

/* Ad related content */
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'page_land.dart';

class PagePortrait extends StatefulWidget {
  PagePortrait({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PagePortraitState createState() => _PagePortraitState();
}

class _PagePortraitState extends State<PagePortrait> {
  bool _isAdLoaded = false;
  BannerAd banner;
//  InterstitialAd _interstitialAd;
  var myInterstitial;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ads();
    });
  }

  ads() async {
/*
    myInterstitial = InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            this._interstitialAd = ad;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
    this._interstitialAd.show();
*/
    banner = BannerAd(
      adUnitId: "ca-app-pub-7184380873624694/9250388614",
      // "ca-app-pub-3940256099942544/6300978111", // testing ID
      //"ca-app-pub-7184380873624694/9250388614", //App ID
      request: AdRequest(),
      size: AdSize(
          height: 70, width: MediaQuery.of(context).size.width.truncate()),
      listener: BannerAdListener(
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('Ad failed to load: $error');
        },
        onAdLoaded: (_) {
          setState(() {
            _isAdLoaded = true;
          });
        },
      ),
    );
    banner.load().whenComplete(() => {
          if (this.mounted)
            {
              setState(() {
                _isAdLoaded = true;
              })
            }
        });
  }

  @override
  void dispose() {
    banner?.dispose();
    banner = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenW = size.width * 0.9;

    return SizedBox.expand(
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: MediaQuery.of(context).padding,
          child: Column(
            children: <Widget>[
              (_isAdLoaded)
                  ? Container(
                      alignment: Alignment.topCenter,
                      child: AdWidget(ad: banner),
                      width: banner.size.width.toDouble(),
                      height: banner.size.height.toDouble(),
                    )
                  : Spacer(),
              Spacer(),
              _ScreenDecoration(child: Screen(width: screenW)),
              SizedBox(height: 20),
              GameController(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScreenDecoration extends StatelessWidget {
  final Widget child;

  const _ScreenDecoration({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: SCREEN_BORDER_WIDTH),
          left: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: SCREEN_BORDER_WIDTH),
          right: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: SCREEN_BORDER_WIDTH),
          bottom: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: SCREEN_BORDER_WIDTH),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(border: Border.all(color: Colors.black54)),
        child: Container(
          padding: const EdgeInsets.all(3),
          color: SCREEN_BACKGROUND,
          child: child,
        ),
      ),
    );
  }
}
