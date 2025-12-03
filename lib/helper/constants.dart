import 'package:get/get_utils/src/extensions/internacionalization.dart';

enum Recurring {
  // Weekly,
  Monthly,
  Yearly,
}

enum BlockStatus {
  block,
  unblock,
}



class Constants {
  //fcm
  static const String serverKey = "AAAAD0fKnA8:APA91bHwo0J6xcbgeBkiTkZJnNyfxkJWlcANmmYn86_0Nk_sQf1kpVYi9T7HmUDanh0JxESR3m-HU3FwAeXJxoEprMQ1slmLmqCWU1X8rImLY3PY6-SP9w_mrT0LW8nbfMSKe3mpiukJ";
  static const String firebaseApiKey = 'AIzaSyAjI-9KmccsxVtD7ErjHQo34tvG1IOnEGU';
  static const String googleApiKey = 'AIzaSyDPX2XU1r5XFr0dmuQj4diOvRhfzCoF-rQ';
  static const String appId = '1:65628969999:ios:65ce6dffa4ca5132b3977a';
  static const String messagingSenderId = '65628969999';
  static const String projectId = 'alphafit-8d7d4';

  //user roles
  static String admin = 'admin';
  static String trainee = 'trainee';
  static String cleaner = 'cleaner';

  //login types
  static String phone = 'phone';
  static String google = 'google';
  static String facebook = 'facebook';
  static String apple = 'apple';

  static int singleBookingPrice = 20;
  static int monthlyBookingPrice = 18;

  //status
  static String stPendingCancellation = 'pending_cancellation';

  static String contactEmail = 'support@alphafitgym.ca';

  static List<String> daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];

  static List<String> recurringList = ['Monthly', 'Yearly'];

  static List<String> weeklyIterations = ['1', '2', '3'];
  static List<String> monthlyIterations = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11'];
  static List<String> yearlyIterations = ['1', '2', '3', '4', '5'];

  static List<Map<String, dynamic>> languages = [
    {"code": "en", "country_code": "US", "language": "English"},
    {"code": "fr", "country_code": "FR", "language": "French"},
  ];

  static List<String> slidableQuotes = [
    'quote_1'.tr,
    'quote_2'.tr,
    'quote_3'.tr,
  ];

  static List<Map<String, dynamic>> gymEquipments = [
    {"id": "1", "name": "AB Crunch Machine", "icon": "assets/icons/ab_crunch_machine.svg"},
    {"id": "2", "name": "Adjustable Bench Inclined", "icon": "assets/icons/adjustable_bench_inclined.svg"},
    {"id": "3", "name": "Adjustable Bench Reverse Inclined", "icon": "assets/icons/adjustable_bench_reverse_inclined.svg"},
    {"id": "4", "name": "Adjustable Bench Upper Inclined", "icon": "assets/icons/adjustable_bench_upper_inclined.svg"},
    {"id": "5", "name": "Adjustable Bench", "icon": "assets/icons/adjustable_bench.svg"},
    {"id": "6", "name": "Barbell", "icon": "assets/icons/barbell.svg"},
    {"id": "7", "name": "Bench", "icon": "assets/icons/bench.svg"},
    {"id": "8", "name": "Cable Pulley Machine", "icon": "assets/icons/cable_pulley_machine.svg"},
    {"id": "9", "name": "Chest Press Rack", "icon": "assets/icons/chest_press_rack.svg"},
    {"id": "10", "name": "Climbing Rope", "icon": "assets/icons/climbing_rope.svg"},
    {"id": "11", "name": "Dip Machine", "icon": "assets/icons/dip_machine.svg"},
    {"id": "12", "name": "Dumbell", "icon": "assets/icons/dumbell.svg"},
    {"id": "13", "name": "Elliptical", "icon": "assets/icons/elliptical.svg"},
    {"id": "14", "name": "Exercice Bike", "icon": "assets/icons/exercice_bike.svg"},
    {"id": "15", "name": "EZ Curl Bar", "icon": "assets/icons/ez_curl_bar.svg"},
    {"id": "16", "name": "Hamstring Curl", "icon": "assets/icons/hamstring_curl.svg"},
    {"id": "17", "name": "Dip Station", "icon": "assets/icons/dip_station.svg"},
    {"id": "18", "name": "icone18", "icon": "assets/icons/hammer_strength.svg"},
    {"id": "19", "name": "Icone_19", "icon": "assets/icons/Icone_19.svg"},
    {"id": "20", "name": "Icone_20", "icon": "assets/icons/Icone_20.svg"},
    {"id": "21", "name": "Icone_21", "icon": "assets/icons/Icone_21.svg"},
    {"id": "22", "name": "Icone_24", "icon": "assets/icons/Icone_24.svg"},
    {"id": "23", "name": "Icone_31", "icon": "assets/icons/Icone_31.svg"},
    {"id": "24", "name": "Kettle Bell", "icon": "assets/icons/kettle_bell.svg"},
    {"id": "25", "name": "Lat Pull Down Machine", "icon": "assets/icons/lat_pull_down_machine.svg"},
    {"id": "26", "name": "Leg Press Machine", "icon": "assets/icons/leg_press_machine.svg"},
    {"id": "27", "name": "Low Pulley Cable Bench", "icon": "assets/icons/low_pulley_cable_bench.svg"},
    {"id": "28", "name": "Rower", "icon": "assets/icons/rower.svg"},
    {"id": "29", "name": "Seated Bike", "icon": "assets/icons/seated_bike.svg"},
    {"id": "30", "name": "Skipping Rope", "icon": "assets/icons/skipping_rope.svg"},
    {"id": "31", "name": "Squat Rack", "icon": "assets/icons/squat_rack.svg"},
    {"id": "32", "name": "Stair Master", "icon": "assets/icons/stair_master.svg"},
    {"id": "33", "name": "Standard Barbell", "icon": "assets/icons/standard_barbell.svg"},
    {"id": "34", "name": "T Barbell", "icon": "assets/icons/TBarbell.svg"},
    {"id": "35", "name": "Tire", "icon": "assets/icons/tire.svg"},
    {"id": "36", "name": "Treadmill", "icon": "assets/icons/treadmill.svg"}
  ];
}
