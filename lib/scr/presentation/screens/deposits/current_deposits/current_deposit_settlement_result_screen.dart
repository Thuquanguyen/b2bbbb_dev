import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/saving_transaction_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/widgets/transaction_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b2b/scr/bloc/deposits/current_deposits/current_deposits_bloc.dart';

class CurrentDepositSettlementResultScreen extends StatefulWidget {
  const CurrentDepositSettlementResultScreen({Key? key}) : super(key: key);
  static const String routeName = 'current-deposit-settlement-result-screen';

  @override
  State<StatefulWidget> createState() =>
      CurrentDepositSettlementResultScreenState();
}

class CurrentDepositSettlementResultScreenState
    extends State<CurrentDepositSettlementResultScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CurrentDepositsBloc, CurrentDepositsState>(
      listenWhen: (p, c) {
        return p.confirmState?.dataState != c.confirmState?.dataState;
      },
      listener: (_, __) {},
      builder: _contentBuilder,
    );
  }

  Widget _contentBuilder(BuildContext context, CurrentDepositsState state) {
    TransactionSavingModel? tran = state.initState?.transactionSaving;

    return TransactionResult(
      showLogo: true,
      headerText: tran?.transCode,
      infoList: [
        TransactionResultItem(
          title: AppTranslate.i18n.tiSavingAccFullStr.localized,
          value: tran?.bankId,
        ),
        TransactionResultItem(
            title: AppTranslate.i18n.cddsAmountStr.localized,
            value: TransactionManage()
                    .tryFormatCurrency(tran?.amount, tran?.amountCcy) +
                ' ' +
                (tran?.amountCcy ?? ''),
            valueStyle: TextStyles.semiBoldText
                .setColor(const Color.fromRGBO(52, 52, 52, 1)),
            description: tran?.amountSpell
                ?.localization(defaultValue: ' ')
                .toTitleCase()),
        TransactionResultItem(
          title: AppTranslate.i18n.cddsPeriodStr.localized,
          value: tran?.termDisplay?.localization(defaultValue: ' '),
          valueStyle: TextStyles.semiBoldText
              .setColor(const Color.fromRGBO(52, 52, 52, 1)),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.cddsEffectiveDateStr.localized,
          value: tran?.startDate,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.cddsMaturityDateStr.localized,
          value: tran?.endDate,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.cddsInterestRateStr.localized,
          value: AppTranslate.i18n.tiInterestRateValueStr.localized
              .interpolate({'i': tran?.rate}),
          valueStyle: TextStyles.semiBoldText
              .setColor(const Color.fromRGBO(52, 52, 52, 1)),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.cddsInterestEarlyStr.localized,
          value: AppTranslate.i18n.tiInterestRateValueStr.localized
              .interpolate({'i': tran?.demandRate}),
          valueStyle: TextStyles.semiBoldText
              .setColor(const Color.fromRGBO(52, 52, 52, 1)),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.cddsSettlementAccountStr.localized,
          value: state.selectedNominationAcc,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.cddsReferralCifStr.localized,
          value: tran?.introducerCif,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.cddsNoteStr.localized,
          value: tran?.contractNumber,
        ),
      ],
      status: NameModel(
        key: 'CLS_WAI',
        valueEn: AppTranslate.i18n.tsApproveWaitStr.localized,
        valueVi: AppTranslate.i18n.tsApproveWaitStr.localized,
      ),
    );
  }
}
