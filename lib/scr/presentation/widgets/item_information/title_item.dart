import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:flutter/material.dart';

class TitleItem extends StatelessWidget {
  const TitleItem({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: kTopPadding),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: TextStyles.headerText.normalColor,
        ),
      ),
    );
  }
}
