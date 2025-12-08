import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../helper/colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final Color? backgroundColor;
  final Color? setStatusbarColor;

  CustomAppBar({
    this.title,
    this.actions,
    this.showBackButton = false,
    this.backgroundColor = kBackgroundColor,
    this.setStatusbarColor = kBackgroundColor,
  });

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      centerTitle: true,
      backgroundColor: backgroundColor,
      automaticallyImplyLeading: false,
      leading: showBackButton ? backButton(context) : null,
      title: title,
      actions: actions,
      systemOverlayStyle: SystemUiOverlayStyle(
        // Status bar color
        statusBarColor: setStatusbarColor,

        // Status bar brightness (optional)
        statusBarIconBrightness: Brightness.dark, // For Android (dark icons for light theme)
        statusBarBrightness: Brightness.light, // For iOS (light icons for light theme)
      ),
    );
  }
}

Widget backButton(context) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: RawMaterialButton(
      onPressed: () {
        Navigator.pop(context);
      },
      elevation: 5.0,
      fillColor: kPrimaryColor,
      child: Center(
        child: Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
        ),
      ),
      shape: CircleBorder(),
    ),
  );
}
