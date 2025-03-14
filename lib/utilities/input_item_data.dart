import 'package:flutter/material.dart';

enum InputItemType {
  BANK,
  TEXT_CHOICE,
  ACCOUNT,
  SAVE_BEN,
  AMOUNT,
  FIELD,
  TEXT,
  FEE_ACCOUNT,
  OTHER,
  RATE,
}

class InputItemData {
  InputItemData(
      {required this.title,
      required this.type,
      this.key = '',
      this.hint,
      this.value,
      this.error,
      this.isUppercase = false,
      this.isInlineLoading = false,
      this.isEnable = true,
      this.isTextChange = true,
      this.onTap,
      this.onSuffixIconClick,
      this.onComplete,
      this.controller,
      this.focusNode,
      this.onTextChange,
      this.showRequire = false});

  final InputItemType type;
  final String key;
  String title;
  final bool? showRequire;
  String? hint;
  dynamic value;
  String? error;
  bool? isUppercase;
  bool isInlineLoading;
  bool isEnable;
  bool isTextChange;
  FocusNode? focusNode;
  TextEditingController? controller;
  Function()? onTap;
  Function()? onSuffixIconClick;
  Function(String)? onComplete;
  Function(String)? onTextChange;
}
