import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:flutter/material.dart';

Widget buildItemInfo({
  required String title,
  String? value,
  String? description,
  TextStyle? valueStyle,
  TextStyle? desStyle,
  double? paddingTop,
}) {
  if (value == null) return const SizedBox();
  valueStyle ??=
      TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1));
  final descriptionStyles =
  TextStyles.smallText.setColor(const Color.fromRGBO(102, 102, 103, 1));
  return Padding(
    padding: EdgeInsets.only(top: paddingTop ?? kItemPadding),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            textAlign: TextAlign.end,
            style: TextStyles.normalText.semibold,
          ),
        ),
        const SizedBox(
          width: kMediumPadding,
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: valueStyle,
              ),
              if (description != null)
                Padding(
                  padding: const EdgeInsets.only(top: kMinPadding - 2),
                  child: Text(
                    description,
                    style: desStyle ?? descriptionStyles,
                  ),
                )
            ],
          ),
        ),
      ],
    ),
  );
}