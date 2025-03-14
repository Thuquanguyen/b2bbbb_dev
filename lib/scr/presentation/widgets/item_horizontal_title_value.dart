import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/presentation/widgets/app_divider.dart';
import 'package:flutter/material.dart';

Widget itemTextHorizontalTitleValue(
    {required String title,
    TextStyle? titleStyle,
    String? value,
    TextStyle? valueStyle,
    bool? showBottomDivider = false}) {
  return Column(
    children: [
      Row(
        mainAxisSize: MainAxisSize.max,
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: titleStyle ?? TextStyles.itemText.inputTextColor,
          ),
          if (value != null) const SizedBox(width: 6),
          if (value != null)
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.centerRight,
                child: Text(
                  value,
                  style: valueStyle ?? TextStyles.itemText.inputTextColor,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
        ],
      ),
      if (showBottomDivider == true)
        const SizedBox(
          height: 8,
        ),
      if (showBottomDivider == true)
        AppDivider(height: 0.5, color: const Color.fromRGBO(186, 205, 223, 1)),
    ],
  );
}
