import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class Ads {
  BannerAd banner(context) {
    return BannerAd(
      adUnitId: "ca-app-pub-3940256099942544/6300978111", // testing id
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
          // setState(() {
          //  _isAdLoaded = true;
          // });
        },
      ),
    );
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-7184380873624694/4727028550';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-7184380873624694/4727028550';
    }
    throw new UnsupportedError("Unsupported platform");
  }
}
