import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TouchableRipple extends StatelessWidget {
  const TouchableRipple({
    Key? key,
    this.onPressed,
    required this.child,
    this.backgroundColor,
  }) : super(key: key);
  final Function()? onPressed;
  final Widget child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: backgroundColor,
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
