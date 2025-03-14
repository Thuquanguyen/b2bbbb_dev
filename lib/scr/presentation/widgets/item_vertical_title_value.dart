import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';

Widget itemTextVerticalTitleValue(
    {String? title,
    TextStyle? titleStyle,
    String? value,
    TextStyle? valueStyle}) {
  if (value.isNullOrEmpty) {
    return const SizedBox();
  }
  return Container(
    alignment: Alignment.centerLeft,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          textAlign: TextAlign.left,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: titleStyle ?? TextStyles.itemText.inputTextColor,
        ),
        if (!value.isNullOrEmpty && !title.isNullOrEmpty)
          const SizedBox(height: 6),
        if (!value.isNullOrEmpty)
          Text(
            value ?? '',
            style: valueStyle ?? TextStyles.itemText.inputTextColor,
            textAlign: TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
      ],
    ),
  );
}

Widget itemVerticalLabelValueText(String label, String? detail,
    {EdgeInsets? margin, BoxDecoration? decoration, TextStyle? valueStyle}) {
  if (detail == null) return Container();
  return Container(
    margin: margin ?? const EdgeInsets.only(bottom: kDefaultPadding),
    width: double.infinity,
    decoration: decoration ??
        const BoxDecoration(
          border: Border(
            bottom: kBorderSide,
          ),
        ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.captionText.slateGreyColor,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          detail,
          style: valueStyle ?? TextStyles.itemText.inputTextColor,
        ),
      ],
    ),
  );
}
