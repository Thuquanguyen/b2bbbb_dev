import 'package:flutter/material.dart';

class Touchable extends StatelessWidget {
  final Function()? onTap;
  final Function(TapDownDetails)? onTapDown;
  final Function()? onLongPress;
  final Widget child;

  const Touchable({
    Key? key,
    this.onTap,
    this.onTapDown,
    this.onLongPress,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onTapDown: onTapDown,
      onLongPress: onLongPress,
      child: Container(
        color: Colors.transparent,
        child: child,
      ),
    );
  }
}
