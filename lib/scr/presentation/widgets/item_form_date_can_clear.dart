import 'dart:io';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/presentation/widgets/hintable_text.dart';
import 'package:b2b/scr/presentation/widgets/my_calendar.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:intl/intl.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemFormDateCanClear extends StatefulWidget {
  const ItemFormDateCanClear(
      {Key? key, required this.controller, required this.title, required this.hintText, required this.callBack})
      : super(key: key);

  final String hintText;
  final TextEditingController controller;
  final String title;
  final Function callBack;

  @override
  State<ItemFormDateCanClear> createState() => _ItemFormDateState();
}

class _ItemFormDateState extends State<ItemFormDateCanClear> {
  DateTime _dateTime = DateTime.now();
  String dateTime = "";
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  final DateTime _dateTimeNow = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Touchable(
      child: Stack(
        children: [
          TextFormField(
            keyboardAppearance: Brightness.light,
            enabled: false,
            controller: widget.controller,
            style: TextStyles.itemText
                .copyWith(
                  color: const Color(0xff343434),
                )
                .medium,
            decoration: InputDecoration(
              floatingLabelBehavior: FloatingLabelBehavior.always,
              labelText: widget.title,
              hintText: widget.hintText,
              hintStyle: TextStyles.itemText
                  .copyWith(
                    color: const Color(0xff343434),
                  )
                  .medium,
              labelStyle: TextStyles.itemText.slateGreyColor,
              focusedBorder: const UnderlineInputBorder(
                borderSide: kBorderSide,
              ),
              border: const UnderlineInputBorder(
                borderSide: kBorderSide,
              ),
              enabledBorder: const UnderlineInputBorder(
                borderSide: kBorderSide,
              ),
              isDense: true,
            ),
          ),
          Positioned.fill(
            bottom: 5,
            child: Align(
              alignment: Alignment.bottomRight,
              child: ImageHelper.loadFromAsset(
                AssetHelper.icoCalendar,
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        if (widget.controller.text.isEmpty) {
          _dateTime = DateTime.now();
        } else {
          try {
            _dateTime = dateFormat.parse(widget.controller.text);
          } catch (e) {}
        }
        MyCalendar().showDatePicker(
          context,
          maxDate: DateTime.now(),
          minDate: DateTime.now().subtract(const Duration(days: 180)),
          onSelected: (date) {
            widget.callBack();
            setState(
              () {
                widget.controller.text = dateFormat.format(date!).toString();
                _dateTime = date;
                dateTime = dateFormat.format(date).toString();
              },
            );
          },
        );
      },
    );
  }
}
