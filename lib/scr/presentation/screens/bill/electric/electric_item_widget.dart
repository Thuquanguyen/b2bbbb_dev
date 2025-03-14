import 'package:b2b/constants.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/textstyles.dart';


class ElectricItemWidget extends StatelessWidget {
  final String title;
  final Widget content;
  final EdgeInsets? margin;

  const ElectricItemWidget(
      {Key? key, required this.title, required this.content, this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyles.captionText,
          ),
          const SizedBox(
            height: 8,
          ),
          content
        ],
      ),
    );
  }
}
