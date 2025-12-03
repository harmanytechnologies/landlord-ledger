import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:landlordledger/helper/colors.dart';
// import 'package:google_fonts/google_fonts.dart';

extension CustomTextStyle on TextTheme {
  TextStyle get medium => const TextStyle(fontWeight: FontWeight.w500); //Poppins-Medium.ttf
  TextStyle get regular => const TextStyle(fontWeight: FontWeight.w400, color: kTextColor); //Poppins-Regular.ttf
  TextStyle get bold => const TextStyle(
        fontWeight: FontWeight.w700,
      ); //Poppins-Bold.ttf
  TextStyle get extraBold => const TextStyle(
        fontWeight: FontWeight.w800,
      ); //Poppins-Bold.ttf
  TextStyle get light => const TextStyle(
        fontWeight: FontWeight.w300,
      ); //Poppins-Light.ttf
}
