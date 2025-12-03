import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:landlordledger/helper/utils.dart';

class HideKeypadOnOutsideTouch extends StatelessWidget {
  final child;

  HideKeypadOnOutsideTouch({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.hideKeypad(context),
      child: child,
    );
  }
}
