import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_state.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/saving_transaction_model.dart';
import 'package:b2b/scr/presentation/screens/deposits/current_deposits/current_deposit_settlement_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/widgets/saving_transaction_detail.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/widgets/transaction_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b2b/scr/bloc/deposits/current_deposits/current_deposits_bloc.dart';

class CurrentDepositDetailScreen extends StatelessWidget {
  const CurrentDepositDetailScreen({Key? key}) : super(key: key);
  static const String routeName = 'current-deposit-detail-screen';

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      appBarType: AppBarType.NORMAL,
      showBackButton: true,
      onTap: () {},
      title: AppTranslate.i18n.cazInfoScreenTitleStr.localized,
      child: BlocConsumer<CurrentDepositsBloc, CurrentDepositsState>(
        buildWhen: (p, c) => p.singleDetail?.dataState != c.singleDetail?.dataState,
        listenWhen: (p, c) => p.singleDetail?.dataState != c.singleDetail?.dataState,
        listener: _stateListener,
        builder: _contentBuilder,
      ),
    );
  }

  void _stateListener(context, state) {
    if (state.singleDetail?.dataState == DataState.error) {
      showDialogErrorForceGoBack(
        context,
        state.singleDetail?.error ?? '',
        () {
          Navigator.of(context).pop();
        },
        barrierDismissible: false,
      );
    }
  }

  Widget _contentBuilder(BuildContext context, CurrentDepositsState state) {
    TransactionSavingModel? tran = state.singleDetail?.transactionSaving;
    DebitAccountInfo? debitAccountInfo = state.singleDetail?.additionalInfo?.accountInfo;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
          bottom: 24,
        ),
        child: tran == null
            ? const TransactionApproveDetailShimmer(
                transType: TransactionSavingModel,
              )
            : SavingTransactionDetailWidget(
                debitAccountInfo: debitAccountInfo,
                savingTransaction: tran,
                forceShowMandustry: true,
                button1: RolePermissionManager().isMaker() &&
                        RolePermissionManager().shouldShowSettlementButton() &&
                        tran.getProductType == SavingProductType.CLOSEAZ
                    ? RoundedButtonWidget(
                        title: AppTranslate.i18n.cddsFinalSettlementStr.localized.toUpperCase(),
                        height: 44,
                        radiusButton: 40,
                        onPress: () {
                          context.read<CurrentDepositsBloc>().add(
                                CurrentDepositsGetListDebitAccountEvent(
                                  secureId: tran.secureId,
                                  productId: tran.fkProductId,
                                ),
                              );
                          pushReplacementNamed(context, CurrentDepositSettlementScreen.routeName);
                        },
                        backgroundButton: AppColors.gPrimaryColor,
                      )
                    : const SizedBox(),
              ),
      ),
    );
  }
}
