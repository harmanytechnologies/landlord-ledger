import 'package:flutter/material.dart';

import '../widgets/hide_keypad_on_outside_touch.dart';

class LoginView extends StatelessWidget {
  static const routeName = "/login";
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HideKeypadOnOutsideTouch(
      child: Scaffold(
        body: Container(
          child: Center(
            child: Column(
              children: [
                Text('Login'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
