import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/saving_account_model.dart';
import 'package:b2b/scr/data/model/saving_transaction_model.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/screens/deposits/current_deposits/current_deposit_settlement_confirm_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/widgets/saving_account_detail.dart';
import 'package:b2b/scr/presentation/screens/deposits/widgets/saving_transaction_detail.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b2b/scr/bloc/deposits/current_deposits/current_deposits_bloc.dart';
import 'package:flutter_html/flutter_html.dart';

class CurrentDepositSettlementScreen extends StatefulWidget {
  const CurrentDepositSettlementScreen({Key? key}) : super(key: key);
  static const String routeName = 'current-deposit-settlement-screen';

  @override
  State<StatefulWidget> createState() => CurrentDepositSettlementScreenState();
}

class CurrentDepositSettlementScreenState
    extends State<CurrentDepositSettlementScreen> {
  String? selectedNominationAcc;

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      appBarType: AppBarType.NORMAL,
      showBackButton: true,
      onTap: () {},
      title: AppTranslate.i18n.cazInitScreenTitleStr.localized,
      child: BlocConsumer<CurrentDepositsBloc, CurrentDepositsState>(
        buildWhen: (p, c) =>
            p.debitAccountList?.dataState != c.debitAccountList?.dataState,
        listenWhen: (p, c) => p.initState?.dataState != c.initState?.dataState,
        listener: _stateListener,
        builder: _contentBuilder,
      ),
    );
  }

  void _stateListener(context, state) {
    if (state.initState?.dataState == DataState.preload) {
      showLoading();
    } else {
      hideLoading();
    }

    if (state.initState?.dataState == DataState.data) {
      Navigator.of(context).pushNamed(CurrentDepositSettlementConfirmScreen.routeName);
    }

    if (state.initState?.dataState == DataState.error) {
      showDialogErrorForceGoBack(
        context,
        state.initState?.error ?? '',
        () {
          Navigator.of(context).pop();
        },
        barrierDismissible: false,
      );
    }
  }

  Widget _contentBuilder(BuildContext context, CurrentDepositsState state) {
    TransactionSavingModel? tran = state.singleDetail?.transactionSaving;
    selectedNominationAcc ??= tran?.nominatedacc;
    List<DebitAccountModel>? daList =
        state.debitAccountList?.data?.debbitAccountList;

    if (tran == null) return Container();
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              bottom: kDefaultPadding,
            ),
            child: Container(
              padding: const EdgeInsets.all(
                kDefaultPadding,
              ),
              decoration: BoxDecoration(
                boxShadow: const [kBoxShadowContainer],
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              child: Html(
                style: {
                  'body': Style(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.zero,
                    fontSize: const FontSize(14),
                    lineHeight: const LineHeight(1.4),
                  ),
                  'p': Style(
                    margin: EdgeInsets.zero,
                    fontWeight: FontWeight.w500,
                  ),
                  'span': Style(
                    fontWeight: FontWeight.w600,
                    color: AppColors.gPrimaryColor,
                  ),
                },
                data: AppTranslate.i18n.cddsOnlineNoticeStr.localized,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              bottom: 24,
            ),
            child: SavingTransactionDetailWidget(
              debitAccountInfo: null,
              savingTransaction: tran,
              onAccountSelect: () {
                showAccountSelect(daList);
              },
              nominatedAccount: selectedNominationAcc,
              showDemandRate: true,
              isAccountListLoading:
                  state.debitAccountList?.dataState == DataState.preload,
              button1: RoundedButtonWidget(
                title: AppTranslate.i18n.cddsContinueStr.localized
                    .toUpperCase(),
                height: 44,
                radiusButton: 40,
                onPress: () {
                  context.read<CurrentDepositsBloc>().add(
                        CurrentDepositsInitSettlementEvent(
                          accountNo: tran.bankId,
                          nominatedAcc: selectedNominationAcc,
                        ),
                      );
                },
                backgroundButton: AppColors.gPrimaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void showAccountSelect(
    List<DebitAccountModel>? daList,
  ) {
    if (daList == null) return;

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                AppTranslate.i18n.cddsSettlementAccountStr.localized,
                style: TextStyles.headerText.inputTextColor,
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              Flexible(
                child: ListView.builder(
                  itemCount: daList.length,
                  itemBuilder: (context, i) {
                    return TextButton(
                      style: TextButton.styleFrom(
                          padding: const EdgeInsets.all(0)),
                      onPressed: () {
                        selectedNominationAcc = daList[i].accountNumber;
                        setState(() {});
                        popScreen(context);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 8,
                        ),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: kBorderSide,
                          ),
                        ),
                        child: Row(
                          children: [
                            Opacity(
                              opacity: selectedNominationAcc ==
                                      daList[i].accountNumber
                                  ? 1.0
                                  : 0.0,
                              child: ImageHelper.loadFromAsset(
                                AssetHelper.icoCheck,
                                width: 24,
                                height: 24,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  daList[i].accountNumber ?? '',
                                  style: TextStyles.buttonText.semibold,
                                ),
                                Text(
                                  '${TransactionManage().tryFormatCurrency(daList[i].availableBalance, daList[i].accountCurrency)} ${daList[i].accountCurrency}',
                                  style: TextStyles.smallText,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
            ],
          ),
        );
      },
    );
  }
}
