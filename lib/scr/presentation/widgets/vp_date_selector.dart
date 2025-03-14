import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/presentation/widgets/my_calendar.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class VPDateInput extends StatelessWidget {
  VPDateInput({
    Key? key,
    required this.title,
    this.hint,
    this.minDate,
    this.maxDate,
    this.currentDate,
    this.onSelect,
    this.disabled = false,
  }) : super(key: key);

  final String title;
  final String? hint;
  final DateTime? minDate;
  final DateTime? maxDate;
  final DateTime? currentDate;
  final Function(DateTime?)? onSelect;
  final bool disabled;

  final DateFormat dateFormat = DateFormat("dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {
    return TouchableRipple(
      onPressed: () {
        if (disabled) return;
        MyCalendar().showDatePicker(
          context,
          modalTitle: title,
          minDate: minDate,
          maxDate: maxDate,
          selectedDate: currentDate,
          onSelected: (date) {
            if (onSelect != null) onSelect!(date);
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 3),
        decoration: BoxDecoration(
          border: disabled ? null : const Border(bottom: kBorderSide1px),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyles.captionText,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    currentDate != null
                        ? dateFormat.format(
                            currentDate!,
                          )
                        : (hint ?? ''),
                    style: TextStyles.itemText.blackColor,
                  ),
                ),
                if (disabled)
                  const SizedBox()
                else
                  ImageHelper.loadFromAsset(
                    AssetHelper.icoCalendar,
                    width: 24,
                    height: 24,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
