import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

Widget AppDivider({EdgeInsets? margin, double? height, Color? color}) {
  return Container(
    margin: margin,
    color: color ?? AppColors.dividerColor,
    height: height ?? 1.5,
    width: double.infinity,
  );
}
