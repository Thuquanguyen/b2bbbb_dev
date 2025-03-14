import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/presentation/widgets/item_form_date_can_clear.dart';
import 'package:flutter/material.dart';

class ItemChooseDateCanClear extends StatelessWidget {
  const ItemChooseDateCanClear({Key? key, required this.fromController, required this.toController, required this.callBack})
      : super(key: key);

  final TextEditingController fromController;
  final TextEditingController toController;
  final Function callBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Expanded(
              child: ItemFormDateCanClear(
            controller: fromController,
            title: AppTranslate.i18n.tqsFromDateStr.localized,
            hintText: AppTranslate.i18n.chooseStr.localized,
            callBack: callBack,
          )),
          const SizedBox(width: 18),
          Expanded(
              child: ItemFormDateCanClear(
            controller: toController,
            title: AppTranslate.i18n.tqsToDateStr.localized,
            hintText: AppTranslate.i18n.chooseStr.localized,
            callBack: callBack,
          ))
        ],
      ),
    );
  }
}
