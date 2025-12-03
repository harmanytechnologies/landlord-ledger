import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:landlordledger/views/properties/property_list_view.dart';

import 'bindings/get_pages.dart';
import 'helper/hive_keys.dart';
import 'helper/theme.dart';

late Box box;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  await _initHive();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    // SystemUiOverlayStyle(
    // statusBarColor: Colors.white,
    // statusBarIconBrightness: Brightness.dark,
    // );
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    runApp(const MyApp());
  });
}

_initHive() async {
  await Hive.initFlutter();
  box = await Hive.openBox('landlord-ledger');
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // navigatorKey: globalNavState,
      debugShowCheckedModeBanner: false,
      theme: Styles.themeData(context), //custom theme
      builder: EasyLoading.init(),
      getPages: GetPageList.pages,
      initialRoute: PropertyListView.routeName,
    );
  }
}
