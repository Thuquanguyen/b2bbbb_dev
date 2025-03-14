import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/presentation/widgets/app_divider.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';

import '../../../constants.dart';

class TextDropDown extends StatelessWidget {
  final String? title;
  final String value;
  final Function()? onPress;
  final bool? isShimmer;

  const TextDropDown(
      {Key? key, this.title, required this.value, this.onPress, this.isShimmer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isShimmer == true) {
      return AppShimmer(
        Container(
            width: double.infinity,
            height: 30.toScreenSize,
            alignment: Alignment.centerRight,
            decoration: kDecoration,margin: const EdgeInsets.only(top: kDefaultPadding),),
      );
    }
    return TouchableRipple(
      onPressed: onPress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title.isNotNullAndEmpty)
            Text(
              title ?? '',
              style: TextStyles.smallText,
            ),
          if (title.isNotNullAndEmpty)
          const SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: TextStyles.itemText.medium
                    .copyWith(color: AppColors.blackTextColor),
              ),
              ImageHelper.loadFromAsset(
                AssetHelper.icArrowDown,
                width: 18.toScreenSize,
                height: 18.toScreenSize,
              ),
            ],
          ),
          const SizedBox(height: 8,),
          AppDivider(),
        ],
      ),
    );
  }
}
