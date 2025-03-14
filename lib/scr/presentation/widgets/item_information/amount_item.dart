import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:flutter/material.dart';

class AmountItem extends StatelessWidget {
  const AmountItem(
      {Key? key,
      this.title,
      this.subTitle,
      this.unit,
      this.amountStyle,
      this.unitStyle,
      this.textAmount})
      : super(key: key);

  final String? title;
  final String? subTitle;
  final String? unit;
  final TextStyle? amountStyle;
  final TextStyle? unitStyle;
  final String? textAmount;

  @override
  Widget build(BuildContext context) {
    if (title == null) return Container();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Text(
            title!,
            style: kStyleTitleHeader,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                  child: Text(subTitle ?? '',
                      style: amountStyle ?? kStyleTitleNumber)),
              Text(
                unit ?? '',
                style: unitStyle ?? kStyleTextUnit,
              )
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
          if (textAmount != null)
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    textAmount!,
                    style: TextStyles.captionText.copyWith(fontSize: 9).inputTextColor,
                  ),
                ),
                const Expanded(
                  child: SizedBox(),
                  flex: 1,
                ),
              ],
            ),
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
