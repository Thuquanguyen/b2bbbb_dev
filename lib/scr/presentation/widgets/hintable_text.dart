import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:flutter/material.dart';

class HintableText extends StatelessWidget {
  const HintableText({Key? key, required this.title,required this.hintText, required this.value})
      : super(key: key);

  final String title;
  final String hintText;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title, style: TextStyles.captionText.normalColor),
        Text(value.isEmpty ? hintText : value,
            style: value.isEmpty
                ? TextStyles.itemText.hintTextColor
                : TextStyles.itemText.tabSelctedColor)
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
    );
  }
}
