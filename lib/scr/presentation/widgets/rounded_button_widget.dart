import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:flutter/material.dart';

class RoundedButtonWidget extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;
  final double? radiusButton;
  final int delay;
  final bool requestHideKeyboard;
  final Color? backgroundButton;
  final FontWeight? fontWeight;
  final Function? onPress;
  final TextStyle? textStyle;
  final ButtonStyle? buttonStyle;

  const RoundedButtonWidget({
    Key? key,
    required this.title,
    this.width,
    this.height,
    this.radiusButton,
    this.buttonStyle,
    this.textStyle,
    this.delay = 100,
    this.requestHideKeyboard = false,
    this.backgroundButton = const Color.fromRGBO(0, 183, 79, 1.0),
    this.fontWeight = FontWeight.w600,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var radius = getInScreenSize(radiusButton ?? 24);
    final colorButton = onPress == null ? const Color.fromRGBO(205, 205, 205, 1) : backgroundButton;

    if (height != null) {
      radius = height! / 2;
    }
    return ElevatedButton(
      // style: ElevatedButton.styleFrom(
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(30.0),
      //   ),
      // ),
      style: buttonStyle ??
          ButtonStyle(
            backgroundColor: MaterialStateProperty.all(colorButton),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
              ),
            ),
          ),
      child: Container(
          height: height ?? getInScreenSize(48),
          alignment: Alignment.center,
          width: width,
          child: Text(title,
              style: textStyle ?? TextStyle(color: Colors.white, fontSize: 16, height: 1.3, fontWeight: fontWeight))),
      onPressed: () {
        if (requestHideKeyboard) {
          hideKeyboard(context);
        }
        if (delay > 0 && onPress != null) {
          setTimeout(onPress!, delay);
        } else {
          onPress?.call();
        }
      },
    );
  }
}
