import 'package:get/get_navigation/src/routes/get_route.dart';

import '../views/login_view.dart';

class GetPageList {
  static List<GetPage> pages = [
    GetPage(
      name: LoginView.routeName,
      page: () => LoginView(),
      // bindings: [
      // BindingsBuilder(() => Get.lazyPut(() => LoginController())),
      // BindingsBuilder(() => Get.lazyPut(() => SocialController())),
      // ],
    ),
    // GetPage(
    //   name: SignupView.routeName,
    //   page: () => SignupView(),
    //   bindings: [
    //     BindingsBuilder(() => Get.lazyPut(() => SignupController())),
    //     BindingsBuilder(() => Get.lazyPut(() => SocialController())),
    //   ],
    // ),
    // GetPage(
    //   name: OtpView.routeName,
    //   page: () => OtpView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => OtpController())),
    // ),
    // GetPage(
    //   name: BookingCasesView.routeName,
    //   page: () => BookingCasesView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => BookingCaseController())),
    // ),
    // GetPage(
    //   name: ForgotPasswordView.routeName,
    //   page: () => ForgotPasswordView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => ForgotPasswordController())),
    // ),
    // GetPage(
    //   name: OtpView.routeName,
    //   page: () => OtpView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => OtpController())),
    // ),
    // GetPage(
    //   name: OtpEmailView.routeName,
    //   page: () => OtpEmailView(),
    //   // binding: BindingsBuilder(() => Get.lazyPut(() => OtpController())),
    // ),
    // GetPage(
    //   name: ForgotPasswordView.routeName,
    //   page: () => ForgotPasswordView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => ForgotPasswordController())),
    // ),
    // GetPage(
    //   name: HomepageView.routeName,
    //   page: () => HomepageView(),
    //   binding: BindingsBuilder(() {
    //     Get.lazyPut(() => HomeController());
    //     Get.lazyPut(() => BookingsController());
    //     Get.lazyPut(() => HelpController());
    //     Get.lazyPut(() => ProfileController());
    //     Get.lazyPut(() => PresentController());
    //     Get.lazyPut(() => FutureTabController());
    //     Get.lazyPut(() => PastTabController());
    //     Get.lazyPut(() => RatingController());
    //     Get.lazyPut(() => SettingsController());
    //     Get.lazyPut(() => BookingController());
    //     Get.lazyPut(() => PaymentMethodController());
    //     Get.lazyPut(() => CarSpecController());
    //     Get.lazyPut(() => OtpController());
    //     Get.lazyPut(() => AddNewCardController());
    //   }),
    // ),
    // GetPage(
    //     name: CarSpecView.routeName,
    //     page: () => CarSpecView(),
    //     // transition: Transition.rightToLeft,
    //     // customTransition:SlideTransitions(),
    //     customTransition: SharedZaxisPageTransition(),
    //     transitionDuration: Duration(milliseconds: 800),
    //     curve: Curves.easeInOut
    //     // binding: BindingsBuilder(() {
    //     //   Get.lazyPut(() => CarSpecController());
    //     // }),
    //     ),
    // GetPage(
    //   name: ValidateInfoView.routeName,
    //   page: () => ValidateInfoView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => ValidateInfoController())),
    // ),
    // GetPage(
    //   name: PaymentMethodsView.routeName,
    //   page: () => PaymentMethodsView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => PaymentMethodController())),
    // ),
    // GetPage(
    //   name: AddNewCardView.routeName,
    //   page: () => AddNewCardView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => AddNewCardController())),
    // ),
    // GetPage(
    //   name: BookingSummaryView.routeName,
    //   page: () => BookingSummaryView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => BookingSummaryController())),
    // ),
    // GetPage(
    //   name: EditProfileView.routeName,
    //   page: () => EditProfileView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => EditProfileController())),
    //   transition: Transition.fadeIn,
    //   transitionDuration: Duration(milliseconds: 800),
    // ),
    // GetPage(
    //   name: SavedCardsView.routeName,
    //   page: () => SavedCardsView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => SavedCardsController())),
    // ),
    // GetPage(
    //   name: ForgotPasswordView.routeName,
    //   page: () => ForgotPasswordView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => ForgotPasswordController())),
    // ),
    // GetPage(
    //   name: NewPasswordView.routeName,
    //   page: () => NewPasswordView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => NewPasswordController())),
    // ),
    // GetPage(
    //   name: AllCarsView.routeName,
    //   page: () => AllCarsView(),
    //   binding: BindingsBuilder(() {
    //     Get.lazyPut(() => AllCarsController());
    //     Get.lazyPut(() => AvailableCarsController());
    //     Get.lazyPut(() => CarPriceTabController());
    //   }),
    // ),
    // GetPage(
    //   name: ChangePasswordView.routeName,
    //   page: () => ChangePasswordView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => ChangePasswordController())),
    // ),
    // GetPage(
    //   name: SettingsView.routeName,
    //   page: () => SettingsView(),
    //   binding: BindingsBuilder(() {
    //     Get.lazyPut(() => SettingsController());
    //     Get.lazyPut(() => ProfileController());
    //   }),
    // ),
    // GetPage(
    //   name: NotificationsView.routeName,
    //   page: () => NotificationsView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => NotificationsController())),
    // ),
    // GetPage(
    //   name: NotificationsSettingsView.routeName,
    //   page: () => NotificationsSettingsView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => NotificationsSettingsController())),
    // ),
    // GetPage(
    //   name: IntroductionView.routeName,
    //   page: () => IntroductionView(),
    // ),
    // GetPage(
    //   name: CompleteProfileView.routeName,
    //   page: () => CompleteProfileView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => CompleteProfileController())),
    // ),
    // GetPage(
    //   name: SearchViewMobile.routeName,
    //   page: () => SearchViewMobile(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => SearchController())),
    // ),
    // GetPage(
    //   name: TermsView.routeName,
    //   page: () => TermsView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => TermsController())),
    // ),
    // GetPage(
    //   name: UniifyView.routeName,
    //   page: () => UniifyView(),
    //   binding: BindingsBuilder(() => Get.lazyPut(() => UniifyController())),
    // ),
    // GetPage(
    //   name: MapView.routeName,
    //   page: () => MapView(),
    // ),
    // GetPage(
    //   name: PaymentMethodsView.routeName,
    //   page: () => PaymentMethodsView(),
    // ),
    // GetPage(
    //   name: GuestMode.routeName,
    //   page: () => GuestMode(),
    // ),
    // GetPage(
    //   name: CalendarView.routeName,
    //   page: () => CalendarView(),
    // ),
  ];
}
