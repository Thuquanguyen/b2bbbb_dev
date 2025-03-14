import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/commerce/Neogotiating_model.dart';
import 'package:b2b/scr/data/model/commerce/commerce_display_data.dart';
import 'package:b2b/scr/data/model/commerce/lc_model.dart';
import 'package:b2b/scr/presentation/screens/commerece/commerce_detail_screen.dart';
import 'package:b2b/scr/presentation/screens/commerece/commerce_list_screen.dart';
import 'package:b2b/scr/presentation/widgets/item_vertical_title_value.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/utilities/date_utils.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';

class ItemCommerceDiscount extends StatelessWidget {
  final NegotiatingModel? model;

  const ItemCommerceDiscount({Key? key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: kDecoration,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: kDefaultPadding,
          ),
          child: Column(
            children: [
              _header(),
              _daskLine(),
              _value(),
            ],
          ),
        ),
      ),
    );
  }

  _header() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        children: [
          ImageHelper.loadFromAsset(AssetHelper.icDiscount,
              width: 24, height: 24),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Text(
              '${model?.amount?.toMoneyString} ${model?.currency}',
              style: TextStyles.headerText
                  .copyWith(color: AppColors.blackTextColor),
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xff00B74F))),
            child: Text(
              AppTranslate.i18n.detailStr.localized,
              style: TextStyles.itemText.medium
                  .copyWith(color: const Color(0xff00B74F)),
            ),
          ),
        ],
      ),
    );
  }

  _daskLine() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: kDefaultPadding),
      child: Text(
        '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -',
        maxLines: 1,
        style: TextStyles.headerText.copyWith(
          color: const Color(0xffe9eaec),
        ),
      ),
    );
  }

  _value() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          itemTextVerticalTitleValue(
            title: AppTranslate.i18n.contractNumberStr.localized,
            value: model?.contractNo ?? '',
            valueStyle: TextStyles.itemText.medium
                .copyWith(color: AppColors.blackTextColor),
          ),
          itemTextVerticalTitleValue(
            title: AppTranslate.i18n.interestValueStr.localized,
            value: '${model?.rate} %',
            valueStyle: TextStyles.itemText.medium
                .copyWith(color: AppColors.blackTextColor),
          ),
          itemTextVerticalTitleValue(
            title: AppTranslate.i18n.discountDateStr.localized,
            value: VpDateUtils.getDisplayDateTime(model?.discountDate),
            valueStyle: TextStyles.itemText.medium
                .copyWith(color: AppColors.blackTextColor),
          ),
        ],
      ),
    );
  }
}
