import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';

class InfomationItem extends StatelessWidget {
  const InfomationItem(
      {Key? key,
      this.title,
      this.subTitle,
      this.note,
      this.noteStyle,
      this.subTitleStyle})
      : super(key: key);

  final String? title;
  final String? subTitle;
  final String? note;
  final TextStyle? noteStyle;
  final TextStyle? subTitleStyle;

  @override
  Widget build(BuildContext context) {
    if (title == null) return Container();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title!,
            style: kStyleTitleHeader,
          ),
          const SizedBox(height: 6),
          Text(subTitle ?? '',
              style: subTitleStyle ?? TextStyles.itemText.inputTextColor),
          const SizedBox(
            height: 4,
          ),
          if (!note.isNullOrEmpty)
            Text(
              note ?? '',
              style: noteStyle ?? TextStyles.itemText.inputTextColor,
            ),
        ],
      ),
    );
  }
}
