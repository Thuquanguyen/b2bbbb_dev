import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:flutter/material.dart';

class ItemNoteTransaction extends StatelessWidget {
  const ItemNoteTransaction({Key? key, required this.contentNote}) : super(key: key);

  final String contentNote;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: RichText(
          text: TextSpan(
              text: AppTranslate.i18n.titleNoteStr.localized,
              style: TextStyles.itemText.greenColor.copyWith(fontFamily: 'SVN-Gilroy'),
              children: <TextSpan>[
            TextSpan(text: contentNote, style: TextStyles.itemText.slateGreyColor.copyWith(fontFamily: 'SVN-Gilroy'))
          ])),
      margin: const EdgeInsets.only(top: 12, bottom: 73),
    );
  }
}
