import 'package:flutter/cupertino.dart';

class AppColors {
  /* Start of Colors */

  static const Color kTextGreyColor = Color(0xff858585);
  static const Color kGreenColor = Color(0xff00796a);
  static const Color kTextWhiteColor = Color(0xffffffff);
  static const Color kIconWhiteColor = Color(0xffffffff);
  static const Color kTextDarkColor = Color(0xff1c2c3f);
  static const Color kTextBlackColor = Color(0xff000000);
  static const Color kTextSkyColor = Color(0xff02BBBD);
  static const Color kTextGreenColor = Color(0xff00796a);
  static const Color kPrimaryAppColor = Color(0xff02BBBD);
  static const Color kSecondaryAppColor = Color(0xff01D3C7);

  static const Color kThemePinkColor = Color(0xfffe6464);
  static const Color kThemeYellowColor = Color(0xffFF9F00);

  static const Color kFocusBorderPinkColor = Color(0xfffe6464);
  static const Color kBorderGreyColor = Color(0xff858585);
  static const Color kBorderLightColor = Color(0xff97bce8);

  static const Color kAppBackgroundColor = Color(0xfffafafa);
  static const Color kWhite = Color(0xffffffff);
  static const Color kWhiteF7 = Color(0xfff7f7f7);
  static const Color kWhiteFA = Color(0xffFAFAFA);
  static const Color kWhiteEF = Color(0xffEFEFEF);

  static const Color kBlack = Color(0xff000000);
  static const Color kBlack0D = Color(0xff0d0d0d);

  static const Color kGrey = Color(0xffD7D7D7);
  static const Color kGreyB7 = Color(0xffB7B7B7);
  static const Color kGrey8E = Color(0xff8E8E8E);
  static const Color kGrey83 = Color(0xff838383);
  static const Color kGrey85 = Color(0xff858585);

  static const Color kAlertColor = Color(0xFFFF0000);
  static const Color kTransparentColor = Color(0x00FFFFFF);

  /* End of Colors */

// =========================== //

/* Start of Gradient Style */

  static const Gradient kPrimaryLinearGradient = LinearGradient(
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
    colors: <Color>[

      Color(0xff00796a),
      Color(0xff00796a),
      Color(0xff00796a),
      Color(0xff00796a),
    ],
    // stops: [0.0, 0.3, 0.5, 0.7, 1.0],
    tileMode: TileMode.clamp,
  );

  static const Gradient kPrimaryLinearGradientDark = LinearGradient(
    begin: Alignment(0, -1),
    end: Alignment(1.838, 1.31),
    colors: <Color>[Color(0xff97bce8), Color(0xff2866b0)],
    stops: <double>[0, 1],
  );

/* End of Gradient Style */

// =========================== //
}
