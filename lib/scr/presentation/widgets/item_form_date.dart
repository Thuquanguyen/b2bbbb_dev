import 'dart:io';
import 'package:b2b/scr/presentation/widgets/hintable_text.dart';
import 'package:b2b/scr/presentation/widgets/my_calendar.dart';
import 'package:intl/intl.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ItemFormDate extends StatefulWidget {
  const ItemFormDate(
      {Key? key,
      required this.controller,
      required this.title,
      required this.hintText,
      required this.callBack})
      : super(key: key);

  final String hintText;
  final TextEditingController controller;
  final String title;
  final Function callBack;

  @override
  State<ItemFormDate> createState() => _ItemFormDateState();
}

class _ItemFormDateState extends State<ItemFormDate> {
  DateTime _dateTime = DateTime.now();
  String dateTime = "";
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Row(
          children: [
            Expanded(
                child: HintableText(
              title: widget.title,
              hintText: widget.hintText,
              value: widget.controller.text,
            )),
            ImageHelper.loadFromAsset(
              AssetHelper.icoCalendar,
              width: 24,
              height: 24,
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.end,
        ),
        decoration: const BoxDecoration(
            border: Border(
          bottom: BorderSide(width: 0.5, color: kColorDivider),
        )),
      ),
      onTap: () {
        if (widget.controller.text.isEmpty) {
          _dateTime = DateTime.now();
        } else {
          _dateTime = dateFormat.parse(widget.controller.text);
        }
        MyCalendar().showDatePicker(context,
            maxDate: DateTime.now(),
            minDate: DateTime.now().subtract(const Duration(days: 180)),
            onSelected: (date) {
              widget.callBack();
              setState(() {
                widget.controller.text = dateFormat.format(date!).toString();
                _dateTime = date;
                dateTime = dateFormat.format(date).toString();
              });
            });
      },
    );
  }
}
