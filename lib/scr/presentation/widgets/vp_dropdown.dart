import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/iterable_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/base_item_model.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/scr/presentation/widgets/vp_bottom_model.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VPDropDown<T> extends StatelessWidget {
  const VPDropDown({
    Key? key,
    required this.options,
    this.selectedItemBuilder,
    this.itemBuilder,
    required this.title,
    this.hint,
    this.modalTitle,
    required this.onSelect,
    required this.selectedIndex,
  }) : super(key: key);

  final String title;
  final String? hint;
  final String? modalTitle;
  final List<NameModel<T>>? options;
  final Function(BuildContext, NameModel<T>, int) onSelect;
  final Function(BuildContext)? selectedItemBuilder;
  final Function(BuildContext, NameModel<T>, int)? itemBuilder;
  final int? selectedIndex;

  static List<NameModel<T>>? transformOptions<T>(List<T>? options, {bool? stringDataAsTitle}) {
    if (options?.isNotEmpty == true) {
      return options!
          .map((o) => NameModel(
                data: o,
                valueVi: (stringDataAsTitle == true && o is String) ? o : null,
                valueEn: (stringDataAsTitle == true && o is String) ? o : null,
              ))
          .toList();
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TouchableRipple(
      onPressed: () {
        showSelector(context);
      },
      child: Container(
        padding: const EdgeInsets.only(bottom: 3),
        decoration: const BoxDecoration(
          border: Border(bottom: kBorderSide1px),
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
                  child: selectedItemBuilder != null
                      ? selectedItemBuilder!(context)
                      : Text(
                          getSelectedTitle(),
                          style: TextStyles.itemText.blackColor,
                        ),
                ),
                SvgPicture.asset(
                  AssetHelper.icoChevronDown18,
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

  NameModel<T>? getSelected() {
    if (options?.isNotEmpty == true && options?.safeAt(selectedIndex) != null) {
      return options?.safeAt(selectedIndex);
    }
  }

  String getSelectedTitle() {
    return getSelected()?.localization() ?? (hint ?? '');
  }

  void showSelector(BuildContext context) {
    if (options?.isNotEmpty == true) {
      VPBottomModal.show(
        context,
        title: modalTitle ?? title,
        content: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: kDefaultPadding),
          itemCount: options?.length,
          itemBuilder: (c, i) {
            return TouchableRipple(
              onPressed: () {
                onSelect(context, options![i], i);
                setTimeout(() {
                  Navigator.of(context).pop();
                }, 100);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: kDefaultPadding,
                ),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: kButtonBorder,
                  ),
                ),
                child: Row(
                  children: [
                    Opacity(
                      opacity: selectedIndex == i ? 1 : 0,
                      child: ImageHelper.loadFromAsset(AssetHelper.icoCheck, width: 24, height: 24),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    itemBuilder != null
                        ? itemBuilder!(context, options![i], i)
                        : Text(
                            options![i].localization(),
                            style: TextStyles.normalText
                                .copyWith(fontWeight: selectedIndex == i ? FontWeight.w600 : FontWeight.w500),
                          ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
  }
}
