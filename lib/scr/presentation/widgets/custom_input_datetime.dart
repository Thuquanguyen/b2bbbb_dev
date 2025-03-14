import 'dart:io';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textinput_ext.dart';
import 'package:b2b/scr/presentation/widgets/ensure_visible_when_focused.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'bottom_picker.dart';

class CustomInputDateTime extends StatefulWidget {
  const CustomInputDateTime(
      {Key? key,
      required this.controller,
      required this.title,
      required this.callBack,
      required this.focusNodeTextField})
      : super(key: key);
  final TextEditingController controller;
  final String title;
  final Function callBack;
  final FocusNode focusNodeTextField;

  @override
  State<CustomInputDateTime> createState() => _CustomInputDateTimeState();
}

class _CustomInputDateTimeState extends State<CustomInputDateTime> {
  DateTime _dateTime = DateTime.now();
  String dateTime = "";
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  final DateTime _dateTimeNow = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 2),
      decoration: const BoxDecoration(
          border: Border(
        bottom: BorderSide(width: 0.5, color: kColorDivider),
      )),
      child: EnsureVisibleWhenFocused(
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardAppearance: Brightness.light,
                  focusNode: widget.focusNodeTextField,
                  controller: widget.controller,
                  inputFormatters: [
                    DateFormatter(),
                    LengthLimitingTextInputFormatter(10),
                  ],
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.all(0),
                      border: InputBorder.none,
                      hintText: 'dd/MM/yyyy',
                      labelText: widget.title),
                ),
              ),
              Touchable(
                  child: Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.gTextColor,
                    size: 24,
                  ),
                  onTap: () {
                    if (widget.controller.text.isEmpty) {
                      _dateTime = DateTime.now();
                    } else {
                      _dateTime = dateFormat.parse(widget.controller.text);
                    }
                    if (Platform.isAndroid) {
                      showDatePicker(
                              context: context,
                              initialDate: _dateTime,
                              firstDate: DateTime(_dateTimeNow.year, _dateTimeNow.month - 6, _dateTimeNow.day),
                              lastDate: _dateTimeNow)
                          .then((datePicker) {
                        if (datePicker == null) {
                          return;
                        } else {
                          widget.callBack();
                          setState(() {
                            widget.controller.text = dateFormat.format(datePicker);
                            _dateTime = datePicker;
                            dateTime = dateFormat.format(datePicker);
                          });
                        }
                      });
                    } else {
                      showCupertinoModalPopup<void>(
                          context: context,
                          builder: (context) => BottomPicker(
                              dateTime: _dateTime,
                              callBack: (dateString, date) {
                                widget.callBack();
                                setState(() {
                                  widget.controller.text = dateString;
                                  _dateTime = date as DateTime;
                                  dateTime = dateString;
                                });
                              }));
                    }
                  })
            ],
          ),
          focusNode: widget.focusNodeTextField),
    );
  }
}
