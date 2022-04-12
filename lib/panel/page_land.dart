part of 'page_portrait.dart';

class PageLand extends StatefulWidget {
  @override
  _PageLandState createState() => _PageLandState();
}

class _PageLandState extends State<PageLand> {
  bool _isAdLoaded = false;
  BannerAd banner;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      MobileAds.instance.initialize();
      ads();
    });
  }

  ads() async {
    banner = BannerAd(
      adUnitId: "ca-app-pub-7184380873624694/9250388614",
      // "ca-app-pub-3940256099942544/6300978111", // testing id
      // "ca-app-pub-7184380873624694/9250388614", //App ID
      request: AdRequest(),
      size: AdSize(
          height: 50, width: MediaQuery.of(context).size.width.truncate()),
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
    var height = MediaQuery.of(context).size.height;
    height -= MediaQuery.of(context).viewInsets.vertical;
    return SizedBox.expand(
      child: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: MediaQuery.of(context).padding,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Spacer(),
                    SystemButtonGroup(),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(left: 40, bottom: 40),
                      child: DropButton(),
                    )
                  ],
                ),
              ),
              _ScreenDecoration(child: Screen.fromHeight(height * 0.85)),
              Expanded(
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
                    Row(
                      children: <Widget>[
                        Spacer(),
                        Spacer(),
                      ],
                    ),
                    Spacer(),
                    DirectionController(),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
