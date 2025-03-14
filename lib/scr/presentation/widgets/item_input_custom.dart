// Created by Cuonghd2 at 05/08/2021
// Email: cuonghd2@vpbank.com.vn
// Copyright (c) 2020. All rights reserved.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ItemInputCustom extends StatelessWidget {
  ItemInputCustom({
    Key? key,
    required this.inputType,
    required this.textStyle,
    this.controller,
    this.focusNode,
    this.inputDecoration,
    this.autofocus = false,
    this.maxLines = 1,
    this.textAlign = TextAlign.justify,
    this.obscureText = false,
    this.maxLengthEnforcement = MaxLengthEnforcement.none,
    this.scrollPadding = const EdgeInsets.all(0),
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
    this.enabled = true,
    this.onTap,
    this.onChange,
    this.onSubmitted,
    this.onEdittingComplete,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.onSave,
    this.height = 80,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final InputDecoration? inputDecoration;
  final TextInputType inputType;
  final bool autofocus;
  final int maxLines;
  final TextAlign textAlign;
  final bool obscureText;
  final MaxLengthEnforcement maxLengthEnforcement;
  final EdgeInsets scrollPadding;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final Function()? onTap;
  final Function(String)? onChange;
  final Function(String)? onSubmitted;
  final Function()? onEdittingComplete;
  final AutovalidateMode autovalidateMode;
  final Function(String?)? onSave;
  final double height;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        keyboardAppearance: Brightness.light,
        style: textStyle,
        cursorWidth: 1,
        scrollPadding: scrollPadding,
        controller: controller,
        focusNode: focusNode,
        decoration: inputDecoration,
        keyboardType: inputType,
        textAlign: textAlign,
        autofocus: autofocus,
        maxLines: maxLines,
        textCapitalization: textCapitalization,
        inputFormatters: inputFormatters,
        enabled: enabled,
        onChanged: onChange,
        onEditingComplete: onEdittingComplete,
        autovalidateMode: autovalidateMode,
        onFieldSubmitted: onSubmitted,
        onTap: onTap,
        onSaved: onSave,
      ),
    );
  }
}
