import 'dart:developer';
import 'dart:io';

import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'constants.dart';

const String defaultAvatar = "https://firebasestorage.googleapis.com/v0/b/podcastapp-a181d.appspot.com/o/default%2Fdefault_avatar.png?alt=media&token=138b6c95-7e54-4ebe-8192-b5787b96b54e";
const String defaultGym = "https://firebasestorage.googleapis.com/v0/b/alphafit-8d7d4.appspot.com/o/default_images%2FdefaultGym.jpeg?alt=media&token=e023163f-b8d2-4f8b-abae-c9aa2eb316cb";

class Utils {
  static setStatusBarColor(color) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: color,
    ));
  }

  static hideKeypad(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  // static launchBrowser(url) async {
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // static launchWhatsApp(phone) async {
  //   var url = "whatsapp://send?phone=$phone";
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // static launchDialer(phone) async {
  //   var url = "tel://$phone";
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // static launchMailBox(email) async {
  //   final params = Uri(
  //     scheme: 'mailto',
  //     path: email,
  //   );
  //   var url = params.toString();
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  // static launchMap(lat, lng) async {
  //   var url = '';
  //   if (Platform.isAndroid) {
  //     url = "https://www.google.com/maps/search/?api=1&query=$lat,$lng";
  //   } else {
  //     url = 'https://maps.apple.com/?q=$lat,$lng';
  //   }

  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     Fluttertoast.showToast(msg: 'no_directions_found'.tr);
  //     throw 'Could not launch $url';
  //   }
  // }

  // static Future<File> pickImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile result = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

  //   File file;
  //   // FilePickerResult result = await FilePicker.platform.pickFiles(
  //   //   type: FileType.image,
  //   //   // allowedExtensions: ['jpg', 'jpeg', 'png'],
  //   // );

  //   if (result != null) {
  //     file = File(result.path);
  //   }

  //   return file;
  // }

  // static Future<List<File>> pickEpisode() async {
  //   List<File> files;
  //   FilePickerResult result = await FilePicker.platform.pickFiles(
  //     allowMultiple: false,
  //     type: FileType.audio,
  //     // allowedExtensions: ['mp3', 'mpeg'],
  //   );

  //   if (result != null) {
  //     files = result.paths.map((path) => File(path)).toList();
  //   }

  //   return files;
  // }

  // static bool isFileGreater(File file) {
  //   int sizeInBytes = file.lengthSync();
  //   double sizeInMb = sizeInBytes / (1024 * 1024);
  //   if (sizeInMb > 10) {
  //     // This file is Longer the
  //     return true;
  //   }
  //   return false;
  // }
}
