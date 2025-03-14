import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget itemShimmer({double ? height, double? width, EdgeInsets? margin}){
  return Container(
    height: height,
    width: width,
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: AppColors.shimmerItemColor
    ),
  );
}