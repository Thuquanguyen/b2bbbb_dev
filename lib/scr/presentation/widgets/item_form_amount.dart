import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ensure_visible_when_focused.dart';

class ItemFormAmount extends StatelessWidget {
  const ItemFormAmount(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.labelText,
      required this.focusNodeTextField})
      : super(key: key);

  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final FocusNode focusNodeTextField;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: EnsureVisibleWhenFocused(
          focusNode: focusNodeTextField,
          child: TextFormField(
            keyboardAppearance: Brightness.light,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp('[0-9]')),
            ],
            style: TextStyles.itemText
                .copyWith(
                  color: const Color(0xff343434),
                )
                .medium,
            controller: controller,
            focusNode: focusNodeTextField,
            keyboardType: TextInputType.number,
            onChanged: (String value) {
              final currentPosition = controller.selection.baseOffset;
              final currentLength = value.length;
              controller.text = value.toMoneyFormat;
              if (currentPosition == currentLength) {
                controller.selection = TextSelection.fromPosition(
                  TextPosition(
                    offset: value.toMoneyFormat.length,
                  ),
                );
              } else {
                controller.selection = TextSelection.fromPosition(TextPosition(offset: currentPosition));
              }
            },
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(0),
                isDense: true,
                hintText: hintText,
                labelText: labelText,
                border: InputBorder.none,
                labelStyle: TextStyles.itemText.normalColor,
                hintStyle: TextStyles.itemText.hintTextColor),
          ),
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.only(bottom: 3),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(width: 0.5, color: kColorDivider))));
  }
}
