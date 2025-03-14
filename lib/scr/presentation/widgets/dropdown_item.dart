import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';

class DropDownItem extends StatelessWidget {
  const DropDownItem(
      {Key? key,
      required this.title,
      required this.value,
      this.isShowDropdown = true,
      this.onTap,
      this.textStyle,
      this.isRequire = false,
      this.leadingIcon})
      : super(key: key);

  final String title;
  final String value;
  final bool? isShowDropdown;
  final Function? onTap;
  final TextStyle? textStyle;
  final bool? isRequire;
  final String? leadingIcon;

  @override
  Widget build(BuildContext context) {
    return Touchable(
        child: Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: kBorderSide,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Row(
              //   children: [
              //     Text(
              //       title,
              //       style: TextStyles.captionText.normalColor,
              //     ),
              //     if (isRequire == true)
              //       Text(
              //         ' *',
              //         style: TextStyles.captionText.copyWith(
              //           color: const Color(0xffe10600),
              //         ),
              //       ),
              //   ],
              // ),
              // const SizedBox(
              //   height: 4,
              // ),
              if (value.isNotNullAndEmpty)
                _buildTitle(title, isRequire: isRequire),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  if (!leadingIcon.isNullOrEmpty)
                    ImageHelper.loadFromAsset(
                      leadingIcon!,
                      width: 26.toScreenSize,
                      height: 26.toScreenSize,
                    ),
                  if (!leadingIcon.isNullOrEmpty)
                    const SizedBox(
                      width: kDefaultPadding,
                    ),
                  if (value.isNotNullAndEmpty)
                    Expanded(
                      child: Text(
                        value,
                        style: textStyle ?? TextStyles.itemText.medium.tabSelctedColor,
                      ),
                    ),
                  if (value.isNullOrEmpty)
                    Expanded(
                      child: _buildTitle(title,
                          isRequire: isRequire,
                          textStyle:
                              textStyle ?? TextStyles.itemText.medium.tabSelctedColor),
                    ),
                  Visibility(
                    child: ImageHelper.loadFromAsset(AssetHelper.icoDropDown,
                        width: 18.toScreenSize, height: 18.toScreenSize),
                    visible: isShowDropdown ?? false,
                  )
                ],
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.only(bottom: 3),
        ),
        onTap: () => onTap?.call());
  }
}

Widget _buildTitle(
  String title, {
  bool? isRequire = false,
  TextStyle? textStyle,
}) {
  return Column(
    children: [
      Row(
        children: [
          Text(
            title,
            style: textStyle ?? TextStyles.captionText.normalColor,
          ),
          if (isRequire == true)
            Text(
              ' *',
              style: TextStyles.captionText.copyWith(
                color: const Color(0xffe10600),
              ),
            ),
        ],
      ),
    ],
  );
}
