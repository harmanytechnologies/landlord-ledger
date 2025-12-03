
class Validators {
  static String? validateField(String? value, context) {
    if (value == null || value.isEmpty) {
      return "required";
    }
    return null;
  }

  static String? validateDropdown(var value, context) {
    if (value == null) {
      return "required";
    }
    return null;
  }

  static String? validateOTP(String value, context) {
    if (value.isEmpty) {
      return "OTP is required";
    }
    return null;
  }

  static String? validateEmail( value, context) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern as String);

    if (value.isEmpty) {
      return "required";
    } else if (!regex.hasMatch(value)) {
      return "Incorrect email entered";
    }
    return null;
  }

  static String? validatePassword(String value, context) {
    if (value.isEmpty) {
      return "required";
    } else if (!(value.length >= 6)) {
      return "Minimum 6 characters required";
    }
    return null;
  }
}
