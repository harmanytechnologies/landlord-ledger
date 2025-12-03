import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:landlordledger/helper/colors.dart';
import 'package:landlordledger/helper/text_style.dart';

Widget customTextFormField(context,
    {Function? onPressed,
    // var color = themeClr,
    var labelText,
    var suffix,
    final FormFieldSetter<String>? onSaved,
    final Widget? prefixIcon,
    final Widget? suffixIcon,
    // final String? label,
    final String? hintText,
    final bool obscureText = false,
    final FormFieldValidator<String>? validator,
    final keyboardType,
    var textInputAction = TextInputAction.next,
    final border,
    final minLines,
    final controller,
    final maxLines,
    final bool enabled = true,
    final style,
    final onChanged,
    // final Color filledClr = lightClr,
    var inputFormatters,
    var prefix,
    var maxLength,
    bool showBorder = false}) {
  var border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
      color: kBackgroundVarientColor,
    ),
  );

  var focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
      color: kSecondaryColor,
    ),
  );

  var boarder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
      color: kRedColor,
    ),
  );

  return TextFormField(
    maxLength: maxLength,
    keyboardType: keyboardType,
    onSaved: onSaved,
    onChanged: onChanged,
    // style: TextStyle(color: Colors.white, fontSize: 12),
    decoration: InputDecoration(
      hintStyle: Theme.of(context).textTheme.regular.copyWith(color: Colors.grey),
      errorStyle: Theme.of(context).textTheme.regular.copyWith(color: kRedColor),
      // labelText: labelText,
      hintText: hintText,
      prefixIcon: prefixIcon,
      prefix: prefix,
      suffixIcon: suffixIcon,
      contentPadding: EdgeInsets.only(bottom: 5, top: 5, left: 10, right: 10),
      filled: true,
      fillColor: kBackgroundVarientColor,
      border: showBorder ? focusedBorder : border,
      enabledBorder: showBorder ? focusedBorder : border,
      disabledBorder: border,
      focusedBorder: focusedBorder,
      errorBorder: boarder,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    ),
    inputFormatters: inputFormatters,
    controller: controller,
    validator: validator,
    autofocus: false,
    obscureText: obscureText,
    textInputAction: textInputAction,
    minLines: minLines,
    cursorColor: kTextColor,
    maxLines: maxLines,
    enabled: enabled,
  );
}
