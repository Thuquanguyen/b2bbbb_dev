import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/presentation/widgets/ensure_visible_when_focused.dart';
import 'package:flutter/material.dart';

import 'keyboard_visibility_view.dart';

class ItemInputContent extends StatelessWidget {
  const ItemInputContent(
      {Key? key,
      required this.controller,
      required this.hintText,
      required this.focusNodeTextField})
      : super(key: key);

  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNodeTextField;

  @override
  Widget build(BuildContext context) {
    if (!focusNodeTextField.hasListeners) {
      focusNodeTextField.addListener(() {
        KeyboardVisibilityView.setCurrentInputType(TextInputType.text);
      });
    }
    return Container(
        margin: EdgeInsets.only(top: 8.toScreenSize, bottom: 12.toScreenSize),
        padding: const EdgeInsets.only(bottom: 3),
        child: Center(
          child: EnsureVisibleWhenFocused(
              child: TextFormField(
                keyboardAppearance: Brightness.light,
                controller: controller,
                focusNode: focusNodeTextField,
                maxLines: null,
                maxLength: kMaxLengthAmountContent,
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: const EdgeInsets.all(4),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: Color.fromRGBO(186, 205, 223, 1), width: 0.8),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(186, 205, 223, 1),
                        width: 0.8,
                      ),
                    ),
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromRGBO(186, 205, 223, 1),
                        width: 0.8,
                      ),
                    ),
                    hintText: hintText,
                    labelText: hintText,
                    hintStyle: TextStyles.itemText.hintTextColor,
                    labelStyle: TextStyles.itemText.normalColor),
              ),
              focusNode: focusNodeTextField),
        ));
  }
}
