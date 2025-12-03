import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:landlordledger/helper/colors.dart';

void showLoader() {
  EasyLoading.show(status: 'loading'.tr, dismissOnTap: true, indicator: customProgressIndicator());
}

void hideLoader() {
  EasyLoading.dismiss();
}

Widget customProgressIndicator() {
  return CircularProgressIndicator.adaptive(
    valueColor: AlwaysStoppedAnimation<Color>(kPrimaryColor),
  );
}
