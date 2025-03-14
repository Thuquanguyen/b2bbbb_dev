import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../utilities/text_formatter.dart';

class VPAmountInput extends StatelessWidget {
  const VPAmountInput({
    Key? key,
    required this.controller,
    required this.title,
    this.hint,
    this.focusNode,
    this.errorText,
    this.onChanged,
    this.textStyle,
    this.currency,
    this.enabled = true,
    this.ccy,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode? focusNode;
  final String title;
  final String? hint;
  final String? errorText;
  final Function(String)? onChanged;
  final TextStyle? textStyle;
  final String? currency;
  final bool enabled;
  final String? ccy;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      keyboardAppearance: Brightness.light,
      focusNode: focusNode,
      enableInteractiveSelection: false,
      enableSuggestions: false,
      autocorrect: false,
      keyboardType: TextInputType.number,
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
        enabledBorder: const UnderlineInputBorder(
          borderSide: kBorderSide1px,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: kBorderSide1px.copyWith(color: AppColors.gPrimaryColor),
        ),
        border: const UnderlineInputBorder(
          borderSide: kBorderSide1px,
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: kBorderSide1px.copyWith(color: AppColors.gRedTextColor),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: kBorderSide1px.copyWith(color: AppColors.gRedTextColor),
        ),
        suffixText: currency,
      ),
      onChanged: (value) {
        // final currentPosition = controller.selection.baseOffset;
        // final currentLength = value.length;
        // if (currentPosition == currentLength) {
        //   controller.selection = TextSelection.fromPosition(
        //     TextPosition(
        //       offset: value.toMoneyFormat.length,
        //     ),
        //   );
        // } else {
        //   controller.selection = TextSelection.fromPosition(
        //     TextPosition(
        //       offset: currentPosition,
        //     ),
        //   );
        // }

        final currentPosition =
            controller.selection.baseOffset;
        final currentLength = value.length;

        controller.text = CurrencyInputFormatter.formatCcyString(value,
            ccy: ccy, isTextInput: true);
        if (currentPosition == currentLength) {
          controller.selection = TextSelection.fromPosition(
            TextPosition(
              offset: controller.text.length,
            ),
          );
        } else {
          controller.selection = TextSelection.fromPosition(
            TextPosition(
              offset: currentPosition,
            ),
          );
        }

        if (onChanged != null) onChanged!(value);
      },
    );
  }
}
