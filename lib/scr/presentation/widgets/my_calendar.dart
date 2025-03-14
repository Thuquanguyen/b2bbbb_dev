import 'dart:math';

import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/presentation/widgets/state_builder.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyCalendar {
  factory MyCalendar() => _instance;

  MyCalendar._();

  static final _instance = MyCalendar._();

  int currentSelectedDay = 0, currentSelectedMonth = 0, currentSelectedYear = 0;
  double cellWidth = 0, cellHeight = 0, paddingTour = 0, calendarHeight = 0;
  DateTime today = DateTime.now();
  DateTime? currentSelectedDate, minDate, maxDate;
  bool isShowChooseYear = false;

  int fromYear = 0, toYear = 0;

  late StateHandler? _stateHandler;

  static const dayTitles = [
    {'en': 'Mon', 'vi': 'T2'},
    {'en': 'Tue', 'vi': 'T3'},
    {'en': 'Wed', 'vi': 'T4'},
    {'en': 'Thu', 'vi': 'T5'},
    {'en': 'Fri', 'vi': 'T6'},
    {'en': 'Sat', 'vi': 'T7'},
    {'en': 'Sun', 'vi': 'CN'},
  ];

  static const monthTitles = [
    {'vi': 'Tháng 1', 'en': 'January'},
    {'vi': 'Tháng 2', 'en': 'February'},
    {'vi': 'Tháng 3', 'en': 'March'},
    {'vi': 'Tháng 4', 'en': 'April'},
    {'vi': 'Tháng 5', 'en': 'May'},
    {'vi': 'Tháng 6', 'en': 'June'},
    {'vi': 'Tháng 7', 'en': 'July'},
    {'vi': 'Tháng 8', 'en': 'August'},
    {'vi': 'Tháng 9', 'en': 'September'},
    {'vi': 'Tháng 10', 'en': 'October'},
    {'vi': 'Tháng 11', 'en': 'November'},
    {'vi': 'Tháng 12', 'en': 'December'},
  ];

  // viết lại cho dễ dùng
  int findDayOfDate(int d, int m, int y) {
    DateTime date = DateTime(y, m, d);
    return date.weekday;
  }

  int isLeap(year) {
    if ((year % 4 > 0) || ((year % 100 == 0) && (year % 400))) {
      return 0;
    } else {
      return 1;
    }
  }

  DateTime date(int d, int m, int y) {
    return DateTime.utc(y, m, d);
  }

  int lastDateOfMonth(int month, int year) {
    return month == 2 ? (28 + isLeap(year)) : 31 - (month - 1) % 7 % 2;
  }

  List<int> daysInMonth(month, year) {
    int startIndex = (findDayOfDate(1, month, year)).toInt();
    int endIndex = lastDateOfMonth(month, year);
    if (startIndex == 0) {
      startIndex = 7;
    }
    final numOfCell = endIndex + startIndex - 1 > 35
        ? 42
        : (endIndex + startIndex - 1 > 28 ? 35 : 28);
    final result = List.filled(numOfCell, 0, growable: false);
    for (int i = startIndex; i < endIndex + startIndex; i++) {
      result[i - 1] = (i - startIndex) + 1;
    }
    return result;
  }

  bool isToday(int day, int month, int year) {
    try {
      return day == today.day && month == today.month && year == today.year;
    } catch (e) {
      Logger.debug(e.toString());
    }
    return false;
  }

  bool isSelectedDay(int day, int month, int year) {
    try {
      return day == currentSelectedDate?.day &&
          month == currentSelectedDate?.month &&
          year == currentSelectedDate?.year;
    } catch (e) {
      Logger.debug(e.toString());
    }
    return false;
  }

  bool isGte(int day, int month, int year) {
    if (minDate != null) {
      try {
        return year > minDate!.year ||
            (year == minDate!.year && month > minDate!.month) ||
            (day >= minDate!.day &&
                month == minDate!.month &&
                year == minDate!.year);
      } catch (e) {
        Logger.debug(e.toString());
      }
    }
    return true;
  }

  bool isLte(int day, int month, int year) {
    if (maxDate != null) {
      try {
        return year < maxDate!.year ||
            (year == maxDate!.year && month < maxDate!.month) ||
            (day <= maxDate!.day &&
                month == maxDate!.month &&
                year == maxDate!.year);
      } catch (e) {
        Logger.debug(e.toString());
      }
    }
    return true;
  }

  bool isAvailable(int day, int month, int year) {
    return isLte(day, month, year) && isGte(day, month, year);
  }

  void onNext() {
    if (isShowChooseYear) {
      fromYear = fromYear + 20;
      toYear = toYear + 20;
    } else {
      currentSelectedMonth = currentSelectedMonth + 1;
      if (currentSelectedMonth == 13) {
        currentSelectedMonth = 1;
        currentSelectedYear = currentSelectedYear + 1;
      }
    }
    _stateHandler?.refresh();
  }

  void onBack() {
    if (isShowChooseYear) {
      fromYear = fromYear - 20;
      toYear = toYear - 20;
    } else {
      currentSelectedMonth = currentSelectedMonth - 1;
      if (currentSelectedMonth == 0) {
        currentSelectedMonth = 12;
        currentSelectedYear = currentSelectedYear - 1;
      }
    }
    _stateHandler?.refresh();
  }

  Widget renderYearTitle(BuildContext context, String? dialogTitle) {
    return Container(
      width: SizeConfig.screenWidth,
      padding: const EdgeInsets.only(top: 10, left: 16, right: 16),
      child: Row(
        children: [
          TextButton(
              onPressed: () {
                fromYear = currentSelectedYear ~/ 10 * 10;
                toYear = currentSelectedYear ~/ 10 * 10 + 20;
                isShowChooseYear = !isShowChooseYear;
                _stateHandler?.refresh();
              },
              child: Row(
                children: [
                  Text('$currentSelectedYear', style: TextStyles.headerText),
                  const Icon(Icons.arrow_drop_down, size: 24)
                ],
              )),
          Expanded(
            child: Text(
              dialogTitle ?? '',
              style: TextStyles.normalText,
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
              onPressed: () {
                popScreen(context);
              },
              child: Text(AppTranslate.i18n.accountManageTitleDoneStr.localized,
                  style: TextStyles.headerText.greenColor)),
        ],
      ),
    );
  }

  Widget renderYearNavBar() {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
              onPressed: () {
                onBack();
              },
              child: const Icon(
                Icons.arrow_left,
                size: 30,
              )),
          Container(
              width: 100,
              alignment: Alignment.center,
              child: Text('$fromYear - ${toYear - 1}',
                  style: TextStyles.gHeader.greenColor)),
          TextButton(
              onPressed: () {
                onNext();
              },
              child: const Icon(
                Icons.arrow_right,
                size: 30,
              ))
        ],
      ),
    );
  }

  Widget renderMonthNavBar() {
    return SizedBox(
      width: SizeConfig.screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TextButton(
              onPressed: () {
                onBack();
              },
              child: const Icon(
                Icons.arrow_left,
                size: 30,
              )),
          Container(
              width: 100,
              alignment: Alignment.center,
              child: Text(
                  monthTitles[currentSelectedMonth - 1]
                      [AppTranslate().currentLanguage.value]!,
                  style: TextStyles.gHeader)),
          TextButton(
              onPressed: () {
                onNext();
              },
              child: const Icon(
                Icons.arrow_right,
                size: 30,
              ))
        ],
      ),
    );
  }

  Widget renderTitle() {
    // final titles = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
      width: SizeConfig.screenWidth,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: dayTitles
            .map((e) => Text(e[AppTranslate().currentLanguage.value]!))
            .toList(growable: false),
      ),
    );
  }

  Widget renderRow(
      BuildContext context, int r, List<int> calendar, Function onSelected) {
    List<Widget> row = [];
    int first = r * 7;
    int last = min(calendar.length, r * 7 + 7);
    for (int i = first; i < last; i++) {
      String day = '';
      if (calendar[i] > 0) {
        day = '${calendar[i]}';
      }
      bool _isAvailable =
          isAvailable(calendar[i], currentSelectedMonth, currentSelectedYear);
      row.add(
        Container(
          width: cellWidth,
          height: cellHeight,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(cellWidth / 2)),
            border: Border.all(
                width: isSelectedDay(
                        calendar[i], currentSelectedMonth, currentSelectedYear)
                    ? 1
                    : 0,
                color: isSelectedDay(
                        calendar[i], currentSelectedMonth, currentSelectedYear)
                    ? Colors.green
                    : Colors.transparent),
            color: isToday(
              calendar[i],
              currentSelectedMonth,
              currentSelectedYear,
            )
                ? Colors.grey.shade200
                : Colors.transparent,
          ),
          child: day.isNotEmpty
              ? TextButton(
                  onPressed: _isAvailable
                      ? () {
                          setTimeout(() {
                            onSelected(DateTime.utc(currentSelectedYear,
                                currentSelectedMonth, calendar[i]));
                          }, 300);
                          popScreen(context);
                        }
                      : null,
                  child: Text(
                    day,
                    style: TextStyle(
                      height: 1.4,
                      fontSize: 16,
                      color: _isAvailable
                          ? AppColors.gTextColor
                          : AppColors.gDisableTextColor,
                    ),
                  ),
                )
              : null,
        ),
      );
    }
    return SizedBox(
      width: SizeConfig.screenWidth - 32,
      height: cellHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: row.toList(),
      ),
    );
  }

  Widget renderCalendarBoard(
      BuildContext context, int day, int month, int year, Function onSelected) {
    List<Widget> data = [];
    List<int> calendar = daysInMonth(month, year);
    int numRow = calendar.length ~/ 7 + (calendar.length % 7 == 0 ? 0 : 1);
    Logger.debug(calendar.length % 7);
    for (int r = 0; r < numRow; r++) {
      data.add(renderRow(context, r, calendar, onSelected));
    }
    return Container(
      width: SizeConfig.screenWidth,
      height: calendarHeight,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: data.toList(),
      ),
    );
  }

  Widget renderYearBoard() {
    List<Widget> data = [];
    int numRow = 5;
    int numberOfCell = 4;
    for (int r = 0; r < numRow; r++) {
      data.add(Container(
        width: SizeConfig.screenWidth - 32,
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
                numberOfCell,
                (index) => TextButton(
                      onPressed: () {
                        currentSelectedYear =
                            fromYear + r * numberOfCell + index;
                        isShowChooseYear = false;
                        _stateHandler?.refresh();
                      },
                      child: Text('${fromYear + r * numberOfCell + index}',
                          style: const TextStyle(height: 1.4, fontSize: 16)
                              .setColor(AppColors.slateGrey2)),
                    ))),
      ));
    }
    return Container(
      width: SizeConfig.screenWidth,
      height: calendarHeight + 30,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: data.toList(),
      ),
    );
  }

  Widget renderContent(
      BuildContext context, Function onSelected, String? modalTitle) {
    return Container(
      width: SizeConfig.screenWidth,
      height: calendarHeight + 150 + SizeConfig.bottomSafeAreaPadding,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(kDefaultPadding),
          topRight: Radius.circular(kDefaultPadding),
        ),
      ),
      // padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kTopPadding),
      child: StateBuilder(
        builder: () {
          return Column(
            children: [
              renderYearTitle(context, modalTitle),
              if (isShowChooseYear) renderYearNavBar(),
              if (isShowChooseYear) renderYearBoard(),
              if (!isShowChooseYear) renderMonthNavBar(),
              if (!isShowChooseYear) renderTitle(),
              if (!isShowChooseYear)
                renderCalendarBoard(
                  context,
                  currentSelectedDay,
                  currentSelectedMonth,
                  currentSelectedYear,
                  onSelected,
                )
            ],
          );
        },
        routeName: 'Calendar',
      ),
    );
  }

  void showDatePicker(BuildContext context,
      {DateTime? selectedDate,
      DateTime? minDate,
      DateTime? maxDate,
      String? modalTitle,
      required Function(DateTime? date) onSelected}) {
    cellWidth = (SizeConfig.screenWidth - 32) / 7;
    cellHeight = cellWidth;
    paddingTour = cellWidth / 5;
    calendarHeight = 6 * cellHeight;
    _stateHandler = StateHandler('Calendar');
    isShowChooseYear = false;
    currentSelectedDate = selectedDate;
    this.minDate = minDate;
    this.maxDate = maxDate;
    selectedDate ??= DateTime.now();
    currentSelectedDay = selectedDate.day;
    currentSelectedMonth = selectedDate.month;
    currentSelectedYear = selectedDate.year;
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_context) {
          return renderContent(
            context,
            onSelected,
            modalTitle,
          );
        });
  }
}
