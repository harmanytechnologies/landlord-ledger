import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:landlordledger/helper/colors.dart';

Widget customButton({
  var onPressed,
  double? fontSize,
  Widget? child,
  bool isEnable = false,
  color,
}) {
  return ElevatedButton(
    onPressed: onPressed,
    child: child,
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      backgroundColor: color ?? kSecondaryColor,
      minimumSize: Size(80, 50),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    ),
  );
}
