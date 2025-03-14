import 'package:b2b/scr/bloc/card/payment_card/payment_card_bloc.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/card/benefit_contract.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/data/model/transfer/init_transfer_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/widgets/transaction_result.dart';
import 'package:flutter/cupertino.dart';

class PaymentCardResultScreen extends StatefulWidget {
  const PaymentCardResultScreen({Key? key}) : super(key: key);
  static const String routeName = '/PaymentCardResultScreen';

  @override
  State<StatefulWidget> createState() => PaymentCardResultScreenState();
}

class PaymentCardResultScreenState extends State<PaymentCardResultScreen> {
  @override
  Widget build(BuildContext context) {
    PaymentCardBloc? bloc = getArguments(context) as PaymentCardBloc?;
    InitTransferModel? tran = bloc?.state.initTransferModel;
    dynamic card = bloc?.state.selectedCardModel;
    DebitAccountModel? debitAccountModel = bloc?.state.selectedDebitAccount;
    if (tran == null) {
      popScreen(context);
      return const SizedBox();
    }

    return TransactionResult(
      showLogo: true,
      headerText: tran.transcode,
      infoList: [
        TransactionResultItem(
          title: AppTranslate
              .i18n.transferToAccountTitleSourceAccountStr.localized,
          value: debitAccountModel?.accountNumber,
        ),
        TransactionResultItem(
          title: AppTranslate
              .i18n.transferToAccountTitleBeneficiaryInformationStr.localized,
          value: (card is CardModel)
              ? card.clientName
              : (card is BenefitContract)
                  ? card.contractName
                  : '',
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.benAccountStr.localized,
          value: (card is CardModel)
              ? card.getContractNumberMasked()
              : (card is BenefitContract)
                  ? card.mainContract
                  : '',
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.prrAmountStr.localized,
          value:
              '${tran.amount?.toInt().toString().toMoneyFormat} ${debitAccountModel?.accountCurrency ?? ''}',
          description:
              tran.amountSpell?.localization(defaultValue: ' ').toTitleCase(),
          valueStyle: TextStyles.itemText.semibold
              .copyWith(color: const Color(0xff22313F)),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.prrMemoStr.localized,
          value: tran.memo,
          valueStyle: TextStyles.itemText,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.chargeAccountStr.localized,
          value: tran.debitAcc,
          valueStyle: TextStyles.semiBoldText
              .setColor(const Color.fromRGBO(52, 52, 52, 1)),
        ),
        // TransactionResultItem(
        //   title: AppTranslate.i18n.prrFeePayerStr.localized,
        //   value: AppTranslate.i18n.prDetailFeePayerOurStr.localized,
        //   valueStyle: TextStyles.itemText,
        // ),
        TransactionResultItem(
          title: AppTranslate.i18n.prrFeeAmountStr.localized +
              AppTranslate.i18n.titleVatIncludeStr.localized,
          value: ((tran.vatFeeAmount ?? 0) == 0.0)
              ? AppTranslate.i18n.freeAmountStr.localized
              : TransactionManage().formatCurrency(
                      ((tran.vatFeeAmount ?? 0)), tran.amountCcy ?? 'VND') +
                  ' ' +
                  (tran.amountCcy ?? ''),
          valueStyle: TextStyles.itemText,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.feeAccountStr.localized,
          value: debitAccountModel?.accountNumber,
          valueStyle: TextStyles.itemText,
        ),
      ],
      status: NameModel(
        key: 'OPEN_WAI',
        valueEn: AppTranslate.i18n.waitApproveStr.localized.toUpperCase(),
        valueVi: AppTranslate.i18n.waitApproveStr.localized.toUpperCase(),
      ),
    );
  }
}
