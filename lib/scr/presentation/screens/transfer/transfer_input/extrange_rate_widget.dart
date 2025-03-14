import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/transfer/transfer_rate.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/item_horizontal_title_value.dart';
import 'package:b2b/scr/presentation/widgets/item_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import '../../../../../utilities/logger.dart';
import '../../../../core/extensions/textstyles.dart';
import '../../../widgets/item_vertical_title_value.dart';

class ExchangeRateWidget extends StatelessWidget {
  DataState? rateState;
  TransferRate? rate;
  String? errRateMsg;
  String? amount;
  String? selectedAmountCcy;
  bool isInitTransfer = true;
  EdgeInsets? margin;

  ExchangeRateWidget(
      {Key? key,
      this.isInitTransfer = true,
      this.rateState,
      this.rate,
      this.errRateMsg,
      this.amount,
      this.selectedAmountCcy,
      this.margin})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rateState == DataState.preload) {
      return AppShimmer(itemShimmer(width: double.infinity, height: 40));
    }

    if (rateState == DataState.error) {
      return itemVerticalLabelValueText(
        AppTranslate.i18n.ersExchangeRateInfoStr.localized,
        errRateMsg,
        decoration: const BoxDecoration(),
        margin: const EdgeInsets.only(top: kDefaultPadding, bottom: 4),
        valueStyle: TextStyles.captionText.copyWith(
          color: const Color(0xffFF6763),
        ),
      );
    }

    double amt = 0;
    try {
      amount = amount.toString().replaceAll(' ', '').replaceAll(',', '');
      amt = double.parse(amount ?? '');
    } catch (e) {}

    if (rateState == DataState.data) {
      return Container(
        margin: margin,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            itemVerticalLabelValueText(
              AppTranslate.i18n.ersExchangeRateInfoStr.localized,
              '1 ${rate?.amountCcy} = ${rate?.buyRate?.toMoneyString} VND',
              decoration: const BoxDecoration(),
              margin: const EdgeInsets.only(bottom: 4),
            ),
            if (isInitTransfer == true)
              Text(
                AppTranslate.i18n.fxRateNoteStr.localized,
                style: TextStyles.captionText.copyWith(
                  color: const Color(0xffFF6763),
                ),
              ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            Text(
              selectedAmountCcy == 'VND'
                  ? AppTranslate.i18n.fxDebitAmountStr.localized
                  : AppTranslate.i18n.fxEstimateConversionAmountStr.localized,
              style: TextStyles.captionText.slateGreyColor,
            ),
            const SizedBox(
              height: 5,
            ),
            itemTextHorizontalTitleValue(
                title: selectedAmountCcy == 'VND'
                    ? (amt / (rate?.buyRate ?? 1))
                        .toStringAsFixed(rate?.amountCcy == 'JPY' ? 0 : 2)
                    : (amt * (rate?.buyRate ?? 1))
                        .toStringAsFixed(0)
                        .toMoneyFormat,
                value: selectedAmountCcy == 'VND' ? rate?.amountCcy : 'VND',
                showBottomDivider: isInitTransfer ? true : false),
          ],
        ),
      );
    }
    return const SizedBox();
  }
}
