import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';

import '../../../../data/model/loan/loan_list_model.dart';

class ItemLoanList extends StatelessWidget {
  final LoanListModel? loan;

  const ItemLoanList({Key? key, this.loan}) : super(key: key);

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
                  children: [
                    ImageHelper.loadFromAsset(AssetHelper.icStar,
                        width: 24.toScreenSize, height: 24.toScreenSize),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      loan?.contractNumber ?? '',
                      style: TextStyles.itemText
                          .copyWith(color: AppColors.blackTextColor),
                    ),
                  ],
                ),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                            text:
                                '${AppTranslate.i18n.savingTitlePeriodStr.localized}: ',
                            style: TextStyles.itemText),
                        TextSpan(
                            text: loan?.term?.localization() ?? '',
                            style: TextStyles.itemText.medium),
                      ],
                    ),
                  ),
                ),
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
            margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${loan?.currentOutstanding?.toMoneyString} ${loan?.accountCurrency}',
                    style: TextStyles.itemText.copyWith(
                      fontSize: 16,
                      color: AppColors.blackTextColor,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xff00B74F),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    AppTranslate.i18n.seeDetailStr.localized,
                    style: TextStyles.itemText.copyWith(
                      color: const Color(0xff00B74F),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
