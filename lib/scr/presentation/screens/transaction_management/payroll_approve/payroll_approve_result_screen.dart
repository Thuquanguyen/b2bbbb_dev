import 'package:b2b/scr/core/extensions/datetime_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/presentation/widgets/transaction_result.dart';
import 'package:flutter/cupertino.dart';

class PayrollApproveResultScreen extends StatefulWidget {
  const PayrollApproveResultScreen({Key? key}) : super(key: key);
  static const String routeName = 'PayrollTransactionApproveResultScreen';

  @override
  State<StatefulWidget> createState() => PayrollApproveResultScreenState();
}

class PayrollApproveResultScreenState extends State<PayrollApproveResultScreen> {
  @override
  Widget build(BuildContext context) {
    TransactionMainModel? tran = getArgument<TransactionMainModel>(context, 'transaction');
    int? benCount = getArgument<int>(context, 'benCount');
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
          title: AppTranslate.i18n.prrAccountNumberStr.localized,
          value: tran.debitAccountNumber,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.prrAccountNameStr.localized,
          value: tran.debitAccountName,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.prrAmountStr.localized,
          value: tran.formattedAmount(withCurrency: true),
          description: tran.amountInWords?.localization(defaultValue: ' ').toTitleCase(),
          valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.prrMemoStr.localized,
          value: tran.memo,
          valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.prrBenCountStr.localized,
          value: '${benCount ?? ''}',
          valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.prrFeeAmountStr.localized,
          value: tran.formattedFeeAmount(withCurrency: true),
          valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.prrFeePayerStr.localized,
          value: tran.charges?.localization(),
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
