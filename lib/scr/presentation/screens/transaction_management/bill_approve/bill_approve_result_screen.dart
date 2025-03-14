import 'package:b2b/scr/core/extensions/datetime_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/bill_payment_model.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/presentation/widgets/transaction_result.dart';
import 'package:flutter/cupertino.dart';

class BillApproveResultScreen extends StatefulWidget {
  const BillApproveResultScreen({Key? key}) : super(key: key);
  static const String routeName = 'BillApproveResultScreen';

  @override
  State<StatefulWidget> createState() => BillApproveResultScreenState();
}

class BillApproveResultScreenState extends State<BillApproveResultScreen> {
  @override
  Widget build(BuildContext context) {
    BillPaymentModel? tran = getArgument<BillPaymentModel>(context, 'transaction');
    bool? approved = getArgument<bool>(context, 'approved');
    if (tran == null) {
      popScreen(context);
      return const SizedBox();
    }

    bool isApproveSuccess = tran.bankId != null || approved == true;

    String? headerText = tran.transCode;
    if (headerText.isNotNullAndEmpty && tran.bankId.isNotNullAndEmpty) headerText = headerText! + '\n' + tran.bankId!;
    headerText ??= tran.bankId;
    return TransactionResult(
      showLogo: true,
      headerText: headerText.isNotNullAndEmpty ? headerText : null,
      infoList: [
        TransactionResultItem(
          title: AppTranslate.i18n.prrAccountNumberStr.localized,
          value: tran.debitAccountNumber,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.bcElecProviderStr.localized,
          value: tran.beneficiaryName,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.bcElecCustomerCodeStr.localized,
          value: tran.billInfo?.cusInfo?.cusCode,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.bcElecCustomerNameStr.localized,
          value: tran.billInfo?.cusInfo?.cusName,
          valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.bcElecCustomerAddressStr.localized,
          value: tran.billInfo?.cusInfo?.cusAddr,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.bcElecTotalAmountStr.localized,
          value: tran.formattedAmount(withCurrency: true),
          description: tran.amountInWords?.localization(defaultValue: ' ').toTitleCase(),
          valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.bcElecPeriodStr.localized,
          value: tran.billInfo?.periodList?.map((p) => p.name).toList().join('\n'),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.prrMemoStr.localized,
          value: tran.memo,
          valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.prrFeeAmountStr.localized,
          value: tran.formattedFeeAmount(withCurrency: true),
          valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.prrFeeAccountStr.localized,
          value: tran.chargesAccount,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.tasTdApprTimeStr.localized,
          value: tran.dateApprover?.convertServerTime?.toDateTime,
        ),
      ],
      status: NameModel(
        key: 'SUC',
        valueEn: isApproveSuccess
            ? AppTranslate.i18n.tsApproveSuccessStr.localized
            : AppTranslate.i18n.tsApproveConfirmStr.localized,
        valueVi: isApproveSuccess
            ? AppTranslate.i18n.tsApproveSuccessStr.localized
            : AppTranslate.i18n.tsApproveConfirmStr.localized,
      ),
    );
  }
}
