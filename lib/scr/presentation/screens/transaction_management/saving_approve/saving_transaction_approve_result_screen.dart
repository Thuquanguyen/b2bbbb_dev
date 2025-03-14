import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/saving_transaction_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/widgets/transaction_result.dart';
import 'package:flutter/cupertino.dart';

class SavingTransactionApproveResultScreen extends StatefulWidget {
  const SavingTransactionApproveResultScreen({Key? key}) : super(key: key);
  static const String routeName = 'saving-transaction-approve-result-screen';

  @override
  State<StatefulWidget> createState() =>
      SavingTransactionApproveResultScreenState();
}

class SavingTransactionApproveResultScreenState
    extends State<SavingTransactionApproveResultScreen> {
  @override
  Widget build(BuildContext context) {
    TransactionSavingModel? tran =
        getArgument<TransactionSavingModel>(context, 'transaction');
    bool showDemandRate = getArgument<bool>(context, 'showDemandRate') ?? false;
    if (tran == null) {
      popScreen(context);
      return const SizedBox();
    }
    String? headerText = tran.transCode;
    if (headerText.isNotNullAndEmpty && tran.bankId.isNotNullAndEmpty) headerText = headerText! + '\n' + tran.bankId!;
    headerText ??= tran.bankId;
    return TransactionResult(
      showLogo: true,
      headerText: headerText.isNotNullAndEmpty ? headerText : null,
      infoList: [
        TransactionResultItem(
          title: AppTranslate.i18n.tiSavingAccFullStr.localized,
          value: tran.bankId,
        ),
        TransactionResultItem(
            title: AppTranslate.i18n.cddsAmountStr.localized,
            value: TransactionManage()
                    .tryFormatCurrency(tran.amount, tran.amountCcy) +
                ' ' +
                (tran.amountCcy ?? ''),
            valueStyle: TextStyles.semiBoldText
                .setColor(const Color.fromRGBO(52, 52, 52, 1)),
            description: tran.amountSpell
                ?.localization(defaultValue: ' ')
                .toTitleCase()),
        TransactionResultItem(
          title: AppTranslate.i18n.cddsPeriodStr.localized,
          value: tran.termDisplay?.localization(defaultValue: ' '),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.cddsEffectiveDateStr.localized,
          value: tran.startDate,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.cddsMaturityDateStr.localized,
          value: tran.endDate,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.cddsInterestRateStr.localized,
          value: AppTranslate.i18n.tiInterestRateValueStr.localized
              .interpolate({'i': tran.rate}),
          valueStyle: TextStyles.semiBoldText
              .setColor(const Color.fromRGBO(52, 52, 52, 1)),
        ),
        if (showDemandRate)
          TransactionResultItem(
            title: AppTranslate.i18n.cddsInterestEarlyStr.localized,
            value: AppTranslate.i18n.tiInterestRateValueStr.localized
                .interpolate({'i': tran.demandRate}),
            valueStyle: TextStyles.semiBoldText
                .setColor(const Color.fromRGBO(52, 52, 52, 1)),
          ),
        TransactionResultItem(
          title: AppTranslate.i18n.cddsSettlementAccountStr.localized,
          value: tran.nominatedacc,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.cddsInterestMethodStr.localized,
          value: tran.productName?.localization(),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.cddsSettlementMethodStr.localized,
          value: tran.mandustryDisplay?.localization(),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.cddsReferralCifStr.localized,
          value: tran.introducerCif,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.cddsNoteStr.localized,
          value: tran.contractNumber,
        ),
      ],
      status: NameModel(
        key: 'SUC',
        valueEn: tran.bankId == null
            ? AppTranslate.i18n.tsApproveConfirmStr.localized
            : AppTranslate.i18n.tsApproveSuccessStr.localized,
        valueVi: tran.bankId == null
            ? AppTranslate.i18n.tsApproveConfirmStr.localized
            : AppTranslate.i18n.tsApproveSuccessStr.localized,
      ),
    );
  }
}
