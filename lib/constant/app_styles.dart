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


}