import 'package:flutter/cupertino.dart';

class BaseItemModel {
  BaseItemModel(
      {required this.title,
      this.value,
      this.fee,
      this.iconMaterial,
      this.icon,
      this.isCheck = false,
      this.onTap,
      this.rootData});

  final String title;
  final String? fee;
  final int? value;
  final String? icon;
  final IconData? iconMaterial;
  final Function(BuildContext context)? onTap;
  bool isCheck;
  final Object? rootData;
}
