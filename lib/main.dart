import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:landlordledger/controllers/subscription_controller.dart';
import 'package:landlordledger/helper/hive_keys.dart';
import 'package:landlordledger/helper/notification_util.dart';
import 'package:landlordledger/views/properties/property_list_view.dart';

import 'bindings/get_pages.dart';
import 'helper/theme.dart';

late Box box;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await _initHive();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) async {
    // SystemUiOverlayStyle(
    // statusBarColor: Colors.white,
    // statusBarIconBrightness: Brightness.dark,
    // );
    await NotificationUtil.init();

    // Initialize subscription controller and check status
    final subscriptionController = Get.put(SubscriptionController());
    await subscriptionController.checkSubscriptionStatus();

    runApp(const MyApp());
  });
}

_initHive() async {
  await Hive.initFlutter();
  box = await Hive.openBox(HiveKeys.mainBox);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Styles.themeData(context), //custom theme
      builder: EasyLoading.init(),
      getPages: GetPageList.pages,
      initialRoute: PropertyListView.routeName,
    );
  }
}
