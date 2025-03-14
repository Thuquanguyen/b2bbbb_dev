import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:flutter/material.dart';

import 'item_input_custom.dart';

// ignore: must_be_immutable
class ItemInputInfoTransfer extends StatelessWidget {
  ItemInputInfoTransfer(
    this.title,
    this.textEditingController,
    this.inputType, {
    Key? key,
    this.onchange,
    this.hintText,
    this.height = 28,
    this.suffix,
    this.suffixIcon,
    this.contentPadding = const EdgeInsets.fromLTRB(0, 0, 0, 18),
    this.textStyle,
    this.onCompleted,
    this.focusNode,
  }) : super(key: key) {
    textStyle ??= TextStyles.semiBoldText.normalColor.regular;
  }

  final Function(String)? onchange;
  final Function()? onCompleted;
  final String? hintText;
  final double height;
  late TextStyle? textStyle;
  final String? suffix;
  final Widget? suffixIcon;
  final String title;
  final TextEditingController textEditingController;
  final TextInputType inputType;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyles.captionText.slateGreyColor),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: kBorderSide,
            ),
          ),
          child: ItemInputCustom(
            height: height,
            textStyle: textStyle!,
            inputType: inputType,
            controller: textEditingController,
            inputDecoration: InputDecoration(
              hintText: hintText,
              // TODO
              hintStyle: textStyle!.regular,
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              suffixText: suffix,
              suffixIcon: suffixIcon,
              suffixStyle: TextStyles.headerText,
              contentPadding: contentPadding,
            ),
            onChange: onchange,
            onEdittingComplete: onCompleted,
            focusNode: focusNode,
          ),
        ),
      ],
    );
  }
}
