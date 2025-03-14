import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/presentation/widgets/item_form_date.dart';
import 'package:b2b/scr/presentation/widgets/item_form_date_can_clear.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';

class ItemChooseDate extends StatelessWidget {
  const ItemChooseDate({Key? key, required this.fromController, required this.toController, required this.callBack})
      : super(key: key);

  final TextEditingController fromController;
  final TextEditingController toController;
  final Function callBack;

  @override
  Widget build(BuildContext context) {
    Logger.debug("change change change");
    return Container(
      margin: const EdgeInsets.only(top: 7, bottom: 24),
      child: Row(
        children: [
          Expanded(
              child: ItemFormDate(
            controller: fromController,
            title: AppTranslate.i18n.tqsFromDateStr.localized,
            hintText: "dd/MM/yyyy",
            callBack: callBack,
          )),
          const SizedBox(width: 18),
          Expanded(
              child: ItemFormDate(
            controller: toController,
            title: AppTranslate.i18n.tqsToDateStr.localized,
            hintText: "dd/MM/yyyy",
            callBack: callBack,
          ))
        ],
      ),
    );
  }
}
