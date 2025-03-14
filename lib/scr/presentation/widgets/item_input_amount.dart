import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/presentation/widgets/dropdown_item.dart';
import 'package:b2b/scr/presentation/widgets/item_form_amount.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';

import 'keyboard_visibility_view.dart';

class ItemInputAmount extends StatelessWidget {
  const ItemInputAmount(
      {Key? key,
      required this.fromController,
      required this.toController,
      required this.nameCurrency,
      required this.focusNodeAmountMin,
      required this.focusNodeAmountMax})
      : super(key: key);

  final TextEditingController fromController;
  final TextEditingController toController;
  final String nameCurrency;
  final FocusNode focusNodeAmountMin;
  final FocusNode focusNodeAmountMax;

  @override
  Widget build(BuildContext context) {
    if (!focusNodeAmountMin.hasListeners) {
      focusNodeAmountMin.addListener(() {
        if (focusNodeAmountMin.hasFocus) {
          KeyboardVisibilityView.setCurrentInputType(TextInputType.number,
              controller: fromController);
        } else {
          KeyboardVisibilityView.setCurrentInputType(TextInputType.text);
        }
      });
    }

    if (!focusNodeAmountMax.hasListeners) {
      focusNodeAmountMax.addListener(() {
        if (focusNodeAmountMax.hasFocus) {
          KeyboardVisibilityView.setCurrentInputType(TextInputType.number,controller: toController);
        } else {
          KeyboardVisibilityView.setCurrentInputType(TextInputType.text);
        }
      });
    }
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: ItemFormAmount(
              controller: fromController,
              hintText: AppTranslate.i18n.titleInputAmountMinStr.localized,
              labelText: AppTranslate.i18n.tqsFromAmountStr.localized,
              focusNodeTextField: focusNodeAmountMin,
            )),
            if (nameCurrency.isNotEmpty) const SizedBox(width: 18),
            if (nameCurrency.isNotEmpty)
              SizedBox(
                width: 60.toScreenSize,
                child: DropDownItem(
                  title: AppTranslate.i18n.titleTypeAmountStr.localized,
                  value: nameCurrency,
                  isShowDropdown: false,
                ),
              )
          ],
        ),
        const SizedBox(height: 10),
        ItemFormAmount(
          controller: toController,
          hintText: AppTranslate.i18n.titleInputAmountMaxStr.localized,
          labelText: AppTranslate.i18n.tqsToAmountStr.localized,
          focusNodeTextField: focusNodeAmountMax,
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.end,
    );
  }
}
