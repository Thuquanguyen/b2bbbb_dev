import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_management_screen.dart';
import 'package:b2b/scr/presentation/widgets/dashline_painter.dart';
import 'package:b2b/scr/presentation/widgets/item_vertical_title_value.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'item_horizontal_title_value.dart';

class ItemTransactionManager extends StatelessWidget {
  TransactionMainModel model;
  Function()? onPress;
  Function()? onLongPress;
  bool enableSelected = false;

  ItemTransactionManager(this.model,
      {this.onPress, this.onLongPress, this.enableSelected = false, Key? key})
      : super(key: key);

  TextStyle titleStyle =
      TextStyles.smallText.copyWith(color: AppColors.gTextColor);
  TextStyle valueStyle =
      TextStyles.itemText.medium.copyWith(color: AppColors.gTextColor);

  @override
  Widget build(BuildContext context) {
    Color circleColor;
    if (!enableSelected) {
      circleColor = const Color(0xffF5F7FA);
    } else if (model.isSelected == true) {
      circleColor = const Color(0xff00B74F);
    } else {
      circleColor = const Color(0xffE8E8E8);
    }

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: kDecoration,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        onPressed: onPress,
        onLongPress: onLongPress,
        child: Container(
          padding:
              const EdgeInsets.only(left: 12, right: 17, top: 16, bottom: 16),
          child: Row(
            children: [
              Container(
                height: getInScreenSize(40, min: 40),
                width: getInScreenSize(40, min: 40),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: circleColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: _circleLeftContent(model.createdDate),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: Column(
                  children: [
                    itemTextHorizontalTitleValue(
                      title:
                          "${AppTranslate.i18n.debitAcctStr.localized}: ${model.debitAccountNumber}",
                      titleStyle: titleStyle.copyWith(fontSize: 13),
                      value: model.status?.localization().toUpperCase() ?? '',
                      valueStyle: TextStyles.itemText.copyWith(
                        color: model.status?.statusDetail?.color,
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    itemTextHorizontalTitleValue(
                        title: AppTranslate.i18n.transferAmountStr.localized,
                        titleStyle: titleStyle,
                        value:
                            "${TransactionManage().formatCurrency(model.amount ?? 0, model.currency ?? '')} ${model.currency}",
                        valueStyle: valueStyle),
                    const SizedBox(
                      height: 7,
                    ),
                    itemTextVerticalTitleValue(
                        title: AppTranslate.i18n.pickBeneficiaryStr.localized,
                        titleStyle: titleStyle,
                        value:
                            '${model.benAccountName} - ${model.beneficiaryName?.toUpperCase()}',
                        valueStyle: valueStyle),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _circleLeftContent(String? createdDate) {
    if (!enableSelected) {
      String time = '';
      if (createdDate != null) {
        DateTime createdDateTime =
            DateFormat('M/d/yyyy h:mm:ss a').parse(createdDate);
        time = DateFormat('Hm').format(createdDateTime);
      }
      return Text(
        time,
        style: TextStyles.itemText.slateGreyColor,
      );
    } else {
      return SvgPicture.asset(
        AssetHelper.icWhiteCheck,
        fit: BoxFit.cover,
      );
    }
  }
}

Widget itemTransactionShimmer() {
  return Container(
    padding: const EdgeInsets.all(kDefaultPadding),
    decoration: BoxDecoration(
      color: AppColors.shimmerBackGroundColor,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: getInScreenSize(40, min: 40),
          width: getInScreenSize(40, min: 40),
          decoration: BoxDecoration(
            color: AppColors.shimmerItemColor,
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.shimmerItemColor,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: 80,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.shimmerItemColor,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: 120,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.shimmerItemColor,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: 110,
              height: 10,
              decoration: BoxDecoration(
                color: AppColors.shimmerItemColor,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
