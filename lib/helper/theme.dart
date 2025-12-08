import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:landlordledger/helper/colors.dart';

class Styles {
  static ThemeData themeData(BuildContext context, {bool? isDarkTheme}) {
    return ThemeData(
      brightness: Brightness.light,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      primaryColor: kPrimaryColor,
      scaffoldBackgroundColor: kBackgroundColor,
      colorScheme: ColorScheme.light(
        primary: kPrimaryColor,
        secondary: kSecondaryColor,
        surface: kWhite,
        background: kBackgroundColor,
      ),
      textTheme: TextTheme(
        labelLarge: TextStyle(color: kWhite), // replaces 'button'
        bodyLarge: TextStyle(color: kTextColor), // replaces 'bodyText1'
        bodyMedium: TextStyle(color: kTextColor), // replaces 'bodyText2'
        titleLarge: TextStyle(color: kTextColor), // replaces 'subtitle1'
        titleMedium: TextStyle(color: kTextColor), // replaces 'subtitle2'
        titleSmall: TextStyle(color: kTextColor), // commonly used as smaller subtitle
        bodySmall: TextStyle(color: kTextColor.withOpacity(0.7)), // caption/overline merged here
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: kSecondaryColor,
      ),

      // primaryIconTheme: IconThemeData(color: themeClr), // hamburger menu
      iconTheme: IconThemeData(color: kTextColor),
//       textTheme: TextTheme(
//         bodyText1: TextStyle(fontSize: 18.sp, color: themeClr, fontWeight: FontWeight.w600),
//         bodyText2: TextStyle(fontSize: 14.sp, color: Colors.black),
//         button: TextStyle(fontSize: 16.sp, color: Colors.white),
// // caption: TextStyle(fontSize: 26.sp, color: Colors.black, fontWeight: FontWeight.w500),
//         headline1: TextStyle(fontSize: 26.sp, color: Colors.black, fontWeight: FontWeight.w500),
// // overline:
// // subtitle1:
//       ),
      textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
              // backgroundColor: kPrimaryColor,
              )),
      // toggleableActiveColor : themeClr,
      // buttonTheme: ButtonThemeData(
      //     buttonColor: themeClr,
      //     // textTheme: ButtonTextTheme.primary,

      //     colorScheme: Theme.of(context).colorScheme.copyWith(secondary: Colors.white) // Text color
      //     ),

      // primarySwatch: themeClr,
      // colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
      // colorScheme: Theme.of(context).colorScheme.copyWith(primary: themeClr, primaryVariant:themeClr ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: kPrimaryColor,
      ),
      cardColor: kWhite,
      appBarTheme: AppBarTheme(
        backgroundColor: kBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(color: kTextColor),
        titleTextStyle: TextStyle(color: kTextColor, fontSize: 20, fontWeight: FontWeight.w600),
      ),
      // primaryColor: isDarkTheme ? Colors.black : Colors.white,
      // toggleableActiveColor: kPrimaryColor,

      // backgroundColor: isDarkTheme ? Colors.black : Color(0xffF1F5FB),

      // indicatorColor: isDarkTheme ? Color(0xff0E1D36) : Color(0xffCBDCF8),
      // buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),

      // hintColor: isDarkTheme ? Color(0xff280C0B) : Color(0xffEECED3),
      // splashColor: kPrimaryColor.withOpacity(.2),
      // highlightColor:kPrimaryColor.withOpacity(.2),
      // hoverColor: isDarkTheme ? Color(0xff3A3A3B) : Color(0xff4285F4),

      // focusColor: isDarkTheme ? Color(0xff0B2512) : Color(0xffA8DAB5),
      // disabledColor: Colors.grey,
      // textSelectionColor: isDarkTheme ? Colors.white : Colors.black,
      // cardColor: isDarkTheme ? Color(0xFF151515) : Colors.white,
      // canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      // brightness: isDarkTheme ? Brightness.dark : Brightness.light,
      // buttonTheme: Theme.of(context).buttonTheme.copyWith(
      //     colorScheme: isDarkTheme ? ColorScheme.dark() : ColorScheme.light()),
      // appBarTheme: AppBarTheme(
      //   elevation: 0.0,
      // ),
    );
  }
}
