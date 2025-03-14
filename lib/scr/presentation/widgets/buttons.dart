import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    this.text,
    required this.onPress,
    this.icon,
    this.width,
    this.height,
    this.radius = 16,
    this.isLoading = false,
    this.margin = const EdgeInsets.symmetric(horizontal: kDefaultPadding),
    this.isAllCaps = false,
  }) : super(key: key);

  final String? text;
  final Function()? onPress;
  final Icon? icon;
  final double? width;
  final double? height;
  final double radius;
  final bool? isLoading;
  final EdgeInsets margin;
  final bool isAllCaps;

  @override
  Widget build(BuildContext context) {
    final colorButton = onPress == null
        ? Color.fromRGBO(205, 205, 205, 1)
        : Theme.of(context).buttonColor;
    if (isLoading != null && isLoading! == true) {
      return Container(
        width: (width != null) ? width : SizeConfig.screenWidth,
        height: (height != null) ? height : getInScreenSize(56),
        decoration: BoxDecoration(
            color: colorButton, borderRadius: BorderRadius.circular(radius)),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final Widget? _child = ((text != null) && (text != ''))
        ? Text(
            isAllCaps ? text!.toUpperCase() : text!,
            style: TextStyles.headerText.copyWith(color: Colors.white),
          )
        : (icon != null)
            ? icon
            : null;

    return Container(
      width: (width != null) ? width : SizeConfig.screenWidth,
      height: (height != null) ? height : getInScreenSize(56),
      margin: margin,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(colorButton),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        ),
        onPressed: onPress,
        child: _child!,
      ),
    );
  }
}
