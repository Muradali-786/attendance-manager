import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class AppStyles{

  TextStyle defaultStyle(double size, Color color, FontWeight fw) {
    return TextStyle(
       // Replace 'MyCustomFont' with the actual font name
      fontSize: size,
      color: color,
      fontWeight: fw,
    );
  }

  TextStyle defaultStyleWithHt(double size, Color color, FontWeight fw, double ht) {
    return TextStyle(
      // Replace 'MyCustomFont' with the actual font name
        fontSize: size,
        color: color,
        fontWeight: fw,
        height: ht);
  }
  TextStyle nunitoSans(double size, Color color, FontWeight fw) {
    return TextStyle(
      fontFamily:
      'Nunito Sans', // Replace 'MyCustomFont' with the actual font name
      fontSize: size,
      color: color,
      fontWeight: fw,
    );
  }


  TextStyle safeGoogleFont(
      String fontFamily, {
        TextStyle? textStyle,
        Color? color,
        Color? backgroundColor,
        double? fontSize,
        FontWeight? fontWeight,
        FontStyle? fontStyle,
        double? letterSpacing,
        double? wordSpacing,
        TextBaseline? textBaseline,
        double? height,
        Locale? locale,
        Paint? foreground,
        Paint? background,
        List<Shadow>? shadows,
        List<FontFeature>? fontFeatures,
        TextDecoration? decoration,
        Color? decorationColor,
        TextDecorationStyle? decorationStyle,
        double? decorationThickness,
      }) {
    try {
      return GoogleFonts.getFont(
        fontFamily,
        textStyle: textStyle,
        color: color,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        height: height,
        locale: locale,
        foreground: foreground,
        background: background,
        shadows: shadows,
        fontFeatures: fontFeatures,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
      );
    } catch (ex) {
      return GoogleFonts.getFont(
        "Source Sans Pro",
        textStyle: textStyle,
        color: color,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        height: height,
        locale: locale,
        foreground: foreground,
        background: background,
        shadows: shadows,
        fontFeatures: fontFeatures,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
      );
    }
  }



}