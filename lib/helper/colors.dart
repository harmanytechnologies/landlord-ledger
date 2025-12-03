import 'package:flutter/material.dart';


const Color kPrimaryColor = Color(0xff4b8e52); // Accent/Button color
const Color kSecondaryColor = Color(0xff257db8);

const Color kBackgroundColor = Color(0xFFFFFFFF); // White background
const Color kBackgroundVarientColor = Color(0xFFF5F5F5); // Light grey for input fields

const Color kTextColor = Color(0xFF333333); // Dark text for light theme
const Color kIconColor = Color(0xFF333333); // Dark icons for light theme


const kPrimary = Color(0xff4b8e52); // Accent color
const kPrimaryColorLight = Color(0xff6ba572); // Lighter shade of accent

const kSecondary = Color(0xffF8A457);


const Color kNearlyWhite = Color(0xFFFEFEFE);
const Color kTransparentColor = Colors.transparent;
const Color kLightPrimaryColor = Color(0xffF8A457);
const Color kChartColor = Color(0xffb87839);
const Color kFacebookIconColor = Color(0xff004DC1);
// const Color kBlackColor = Color(0xff14171A);
const Color kDarkGrey = Color(0xff1657786);
const Color kLightGrey = Color(0xffAAB8C2);
const Color kGreyColor = Color(0xffD9D9D9);
const Color kExtraLightGrey = Color(0xffE1E8ED);
const Color kGreenColor = Color(0xff07D14A);
const Color kDarkGreenColor = Color(0xff3A8753);
const Color kExtraExtraLightGrey = Color(0xfF5F8FA);
const Color kWhite = Color(0xFFffffff);
const Color kNotWhite = Color(0xFFEDF0F2);
const Color kRedColor = Color(0xFFFF0000);

const _primaryColor = 0xff08C277;
const MaterialColor kBlackColor = MaterialColor(
  _primaryColor,
  <int, Color>{
    50: Colors.black,
    100: Colors.black,
    200: Colors.black,
    300: Colors.black,
    400: Colors.black,
    500: Colors.black,
    600: Colors.black,
    700: Colors.black,
    800: Colors.black,
    900: Colors.black,
  },
);

class Palette {
  MaterialColor kPrimarColor = const MaterialColor(
    0xffe55f48, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xff1a1a1a), //10%
      100: const Color(0xff1a1a1a), //20%
      200: const Color(0xff1a1a1a), //30%
      300: const Color(0xff1a1a1a), //40%
      400: const Color(0xff1a1a1a), //50%
      500: const Color(0xff1a1a1a), //60%
      600: const Color(0xff1a1a1a), //70%
      700: const Color(0xff1a1a1a), //80%
      800: const Color(0xff1a1a1a), //90%
      900: const Color(0xff1a1a1a), //100%
    },
  );
}
