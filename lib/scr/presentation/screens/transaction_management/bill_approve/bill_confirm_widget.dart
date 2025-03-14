import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/bill_payment_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/widgets/transaction_confirm.dart';
import 'package:b2b/scr/presentation/widgets/transaction_shimmer.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/material.dart';

class BillElecConfirmWidget extends StatelessWidget {
  const BillElecConfirmWidget({Key? key, this.bill}) : super(key: key);

  final BillPaymentModel? bill;

  @override
  Widget build(BuildContext context) {
    if (bill == null) {
      return Container(
          padding: const EdgeInsets.only(
            left: kDefaultPadding,
            right: kDefaultPadding,
            bottom: kDefaultPadding,
          ),
          child: const TransactionApproveDetailShimmer());
    }
    return TransactionConfirm(
      infoList: [
        const TransactionConfirmItemDebit(),
        TransactionConfirmItemHeader(title: AppTranslate.i18n.bcElecApprovePaymentInfoStr.localized),
        TransactionConfirmItemBen(
          imagePath: AssetHelper.icoEvn,
          benName: bill?.beneficiaryName ?? '',
          benAccount: bill?.billInfo?.cusInfo?.cusCode,
        ),
        TransactionConfirmItem(title: AppTranslate.i18n.bcElecCustomerNameStr.localized, value: bill?.billInfo?.cusInfo?.cusName),
        TransactionConfirmItem(title: AppTranslate.i18n.bcElecCustomerAddressStr.localized, value: bill?.billInfo?.cusInfo?.cusAddr),
        TransactionConfirmItemMoney(
          title: AppTranslate.i18n.bcElecTotalAmountStr.localized,
          amount: TransactionManage().tryFormatCurrency(bill?.amount, bill?.currency),
          currency: bill?.currency,
          isGreen: true,
        ),
        ...?bill?.billInfo?.periodList
            ?.map((p) => _buildPeriodItem(
                  period: p.name,
                  amount: TransactionManage().tryFormatCurrency(p.amount, bill?.currency, showCurrency: true),
                  type: p.type,
                  code: p.code,
                ))
            .toList(),
        TransactionConfirmItem(title: AppTranslate.i18n.bcElecNoteStr.localized, value: bill?.memo),
        if (bill?.rejectCause?.isNotEmpty == true)
          TransactionConfirmItem(title: AppTranslate.i18n.bcElecRejectReasonStr.localized, value: bill?.rejectCause),
      ],
    );
  }

  Widget _buildPeriodItem({
    String? period,
    String? amount,
    String? type,
    String? code,
  }) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      margin: const EdgeInsets.only(bottom: kDefaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFFF9F9F9),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  AppTranslate.i18n.bcElecPeriodStr.localized,
                  style: TextStyles.itemText.darkInk400,
                ),
              ),
              Text(
                period ?? '',
                style: TextStyles.itemText.medium.darkInk500,
              ),
            ],
          ),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  AppTranslate.i18n.bcElecPeriodAmountStr.localized,
                  style: TextStyles.itemText.darkInk400,
                ),
              ),
              Text(
                amount ?? '',
                style: TextStyles.itemText.semibold.darkInk500,
              ),
            ],
          ),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  AppTranslate.i18n.bcElecPeriodTypeStr.localized,
                  style: TextStyles.itemText.darkInk400,
                ),
              ),
              Text(
                type ?? '',
                style: TextStyles.itemText.darkInk400,
              ),
            ],
          ),
          const SizedBox(
            height: kDefaultPadding / 2,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  AppTranslate.i18n.bcElecPeriodCodeStr.localized,
                  style: TextStyles.itemText.darkInk400,
                ),
              ),
              Text(
                code ?? '',
                style: TextStyles.itemText.darkInk400,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
