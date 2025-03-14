import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class VPTextInput extends StatelessWidget {
  const VPTextInput({
    Key? key,
    required this.controller,
    required this.title,
    this.hint,
    this.focusNode,
    this.errorText,
    this.onChanged,
    this.textStyle,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String title;
  final String? hint;
  final String? errorText;
  final Function(String)? onChanged;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardAppearance: Brightness.light,
      focusNode: focusNode,
      enableInteractiveSelection: false,
      enableSuggestions: false,
      autocorrect: false,
      // obscureText: !isVisible,
      style: textStyle ?? TextStyles.itemText.blackColor,
      decoration: InputDecoration(
        hintText: hint,
        isDense: true,
        labelText: title,
        contentPadding: const EdgeInsets.only(
          bottom: 5,
        ),
        errorText: errorText,
        labelStyle: TextStyles.itemText,
        focusedBorder: UnderlineInputBorder(
          borderSide: kBorderSide1px.copyWith(color: AppColors.gPrimaryColor),
        ),
        border: const UnderlineInputBorder(
          borderSide: kBorderSide1px,
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: kBorderSide1px,
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: kBorderSide1px.copyWith(color: AppColors.gRedTextColor),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
