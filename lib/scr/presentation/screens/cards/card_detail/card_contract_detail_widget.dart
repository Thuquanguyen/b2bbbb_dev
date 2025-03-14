import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:b2b/scr/core/extensions/double_ext.dart';

class CardContractDetailWidget extends StatelessWidget {
  const CardContractDetailWidget({
    Key? key,
    required this.cardModel,
  }) : super(key: key);

  final CardModel cardModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      width: double.infinity,
      child: Container(
        decoration: kDecoration,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(
                  kDefaultPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppColors.whiteGreyBorder)),
                      ),
                      child: Row(
                        children: [
                          ImageHelper.loadFromAsset(AssetHelper.icoInfoCircleGreen, height: 24, width: 24),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            AppTranslate.i18n.cdContractInfoTitleStr.localized,
                            style: TextStyles.normalText.medium.copyWith(
                              color: AppColors.darkInk500,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: kDefaultPadding,
                    ),
                    _buildInfoItem(
                      AppTranslate.i18n.cdContractNumberStr.localized,
                      cardModel.companyContractNumber,
                    ),
                    _buildInfoItem(
                      AppTranslate.i18n.cdContractCusNameStr.localized,
                      cardModel.comMainName,
                    ),
                    if (cardModel.type == CardType.DEBIT)
                      _buildInfoItem(
                        AppTranslate.i18n.cdContractAccNumberStr.localized,
                        cardModel.rbsNumber,
                      ),
                    if (cardModel.type == CardType.CREDIT)
                      _buildInfoItem(
                        AppTranslate.i18n.cdContractLimitStr.localized,
                        cardModel.comLimit.getFormattedWithCurrency(
                          cardModel.cardCurrency,
                          showCurrency: true,
                        ),
                      ),
                    if (cardModel.type == CardType.CREDIT)
                      _buildInfoItem(
                        AppTranslate.i18n.cdContractDebtStr.localized,
                        cardModel.companyTotalBalance.getFormattedWithCurrency(
                          cardModel.cardCurrency,
                          showCurrency: true,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String? value, {double? padding}) {
    if (value == null) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.captionText.copyWith(
            color: AppColors.darkInk300,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          value,
          style: TextStyles.itemText.copyWith(
            color: AppColors.darkInk500,
          ),
        ),
        SizedBox(
          height: padding ?? kDefaultPadding,
        ),
      ],
    );
  }
}
