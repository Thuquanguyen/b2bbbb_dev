import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/item_shimmer.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';

import '../../../../data/model/loan/loan_list_model.dart';

class ItemLoanListLoading extends StatelessWidget {
  const ItemLoanListLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      decoration: kDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ImageHelper.loadFromAsset(AssetHelper.icStar,
                        width: 24.toScreenSize, height: 24.toScreenSize),
                    const SizedBox(
                      width: 8,
                    ),
                    AppShimmer(
                      itemShimmer(width: 100, height: 12),
                    )
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                AppShimmer(
                  itemShimmer(width: 50, height: 12),
                )
              ],
            ),
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          Divider(
            color: AppColors.dividerColor,
            height: 2,
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Text(AppTranslate.i18n.loanBalanceStr.localized),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10, left: kDefaultPadding),
            child: AppShimmer(itemShimmer(width: 200, height: 12)),
          ),
        ],
      ),
    );
  }
}
