import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/item_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../utilities/image_helper/asset_helper.dart';
import '../../../utilities/image_helper/imagehelper.dart';
import '../../../utilities/logger.dart';
import '../../core/extensions/textstyles.dart';
import '../../core/language/app_translate.dart';

debitAccountWidget(
    {required VoidCallback onTap,
    required String value,
    String? title,
    bool? showRequire,
    bool? hideDropDownIcon = false,
    EdgeInsets? margin,
    bool? isLoading = false}) {
  if (isLoading == true) {
    return AppShimmer(
      itemShimmer(height: 30),
    );
  }
  return Touchable(
    onTap: onTap,
    child: Container(
      color: Colors.transparent,
      margin: margin ?? const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: title ?? AppTranslate.i18n.feeAccountStr.localized,
                    style: TextStyles.captionText.slateGreyColor),
                if (showRequire == true)
                  TextSpan(
                    text: ' \*',
                    style: TextStyles.itemText.copyWith(color: Colors.red),
                  )
              ],
            ),
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          Row(
            children: [
              ImageHelper.loadFromAsset(
                AssetHelper.icoWallet,
                width: 26.toScreenSize,
                height: 26.toScreenSize,
              ),
              const SizedBox(
                width: kDefaultPadding,
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          value,
                          style: TextStyles.itemText.slateGreyColor.regular,
                        ),
                        if (hideDropDownIcon != true)
                          ImageHelper.loadFromAsset(AssetHelper.icoDropDown,
                              width: 18.toScreenSize, height: 18.toScreenSize),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      height: 1,
                      width: double.infinity,
                      color: kColorDivider,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
