import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class BottomPicker extends StatefulWidget {
  BottomPicker({Key? key, required this.dateTime, required this.callBack}) : super(key: key);

  DateTime dateTime;
  DateFormat dateFormat = DateFormat("dd/MM/yyyy");
  final Function callBack;
  DateTime dateTimeNow = DateTime.now();

  @override
  State<BottomPicker> createState() => _BottomPickerState();
}

class _BottomPickerState extends State<BottomPicker> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: kPickerSheetHeight,
      padding: EdgeInsets.only(top: 10, bottom: SizeConfig.bottomSafeAreaPadding),
      color: Colors.white,
      child: Touchable(
        child: SafeArea(
          child: Column(children: [
            Container(
                child: Row(children: [
                  Expanded(
                      child: Text(
                    AppTranslate.i18n.titleSelectDateStr.localized,
                    style: TextStyles.headerText.normalColor,
                  )),
                  Touchable(
                    child: Text(
                      AppTranslate.i18n.titleDoneStr.localized,
                      style: TextStyles.buttonText.semibold.unitColor,
                    ),
                    onTap: () {
                      widget.callBack(widget.dateFormat.format(widget.dateTime), widget.dateTime);
                      Navigator.of(context).pop();
                    },
                  )
                ], mainAxisAlignment: MainAxisAlignment.spaceAround),
                margin: const EdgeInsets.only(top: 10, left: 16, right: 16)),
            Expanded(
                child: CupertinoDatePicker(
              onDateTimeChanged: (newDate) {
                setState(() {
                  widget.dateTime = newDate;
                });
              },
              initialDateTime: widget.dateTime,
              maximumDate: widget.dateTimeNow,
              minimumDate: DateTime(widget.dateTimeNow.year, widget.dateTimeNow.month - 6, widget.dateTimeNow.day),
              mode: CupertinoDatePickerMode.date,
            ))
          ]),
          top: false,
          bottom: false,
        ),
        onTap: () {},
      ),
    );
  }
}
