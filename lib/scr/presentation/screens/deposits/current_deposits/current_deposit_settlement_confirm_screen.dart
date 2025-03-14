import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/data/model/saving_transaction_model.dart';
import 'package:b2b/scr/presentation/screens/deposits/current_deposits/current_deposit_settlement_result_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/current_deposits/current_deposits_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/widgets/saving_transaction_detail.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b2b/scr/bloc/deposits/current_deposits/current_deposits_bloc.dart';

class CurrentDepositSettlementConfirmScreen extends StatefulWidget {
  const CurrentDepositSettlementConfirmScreen({Key? key}) : super(key: key);
  static const String routeName = 'current-deposit-settlement-confirm-screen';

  @override
  State<StatefulWidget> createState() =>
      CurrentDepositSettlementConfirmScreenState();
}

class CurrentDepositSettlementConfirmScreenState
    extends State<CurrentDepositSettlementConfirmScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      appBarType: AppBarType.NORMAL,
      showBackButton: true,
      onTap: () {},
      title: AppTranslate.i18n.cazConfirmScreenTitleStr.localized,
      child: BlocConsumer<CurrentDepositsBloc, CurrentDepositsState>(
        listenWhen: (p, c) {
          return p.confirmState?.dataState != c.confirmState?.dataState;
        },
        listener: _stateListener,
        builder: _contentBuilder,
      ),
    );
  }

  void _stateListener(BuildContext context, CurrentDepositsState state) {
    if (state.confirmState?.dataState == DataState.preload) {
      showLoading();
    } else {
      hideLoading();
    }

    if (state.confirmState?.dataState == DataState.data) {
      final args = CommitSavingSettlementOTPArgs(
        transCode: state.initState?.transactionSaving?.transCode ?? '',
        secureTrans: state.initState?.transactionSaving?.sercureTrans ?? '',
        verifyOtpDisplayType:
            state.confirmState?.data?.verifyOtpDisplayType ?? -1,
        message: state.confirmState?.successMessage,
      );

      SmartOTPManager().verifyOTP(
        context,
        args,
        onResult: (isSuccess, data) {
          MessageHandler().notify(
            CurrentDepositsScreen.RELOAD_LIST_EVENT,
          );

          if (isSuccess == true) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              CurrentDepositSettlementResultScreen.routeName,
              (route) => route.settings.name == CurrentDepositsScreen.routeName,
            );
          } else {
            if (data is OtpVerifyMadeFundState) {
              if (data.status == OtpStatus.VERIFY_ERROR_00) {
                showDialogCustom(
                  context,
                  AssetHelper.icoAuthError,
                  AppTranslate.i18n.dialogTitleNotificationStr.localized,
                  data.message ?? AppTranslate.i18n.errorNoReasonStr.localized,
                  barrierDismissible: false,
                  showCloseButton: false,
                  button1: renderDialogTextButton(
                    context: context,
                    title: AppTranslate.i18n.dmcdsBackStr.localized,
                    onTap: () {
                      Navigator.of(context).popUntil(
                        (route) =>
                            route.settings.name ==
                            CurrentDepositsScreen.routeName,
                      );
                    },
                  ),
                );
              } else {
                Navigator.of(context).popUntil(
                  (route) =>
                      route.settings.name == CurrentDepositsScreen.routeName,
                );
              }
            }
          }
        },
      );
    }

    if (state.confirmState?.dataState == DataState.error) {
      showDialogErrorForceGoBack(
        context,
        state.confirmState?.error ?? '',
        () {
          Navigator.of(context).pop();
        },
        barrierDismissible: false,
      );
    }
  }

  Widget _contentBuilder(BuildContext context, CurrentDepositsState state) {
    TransactionSavingModel? tran = state.initState?.transactionSaving;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
          bottom: 24,
        ),
        child: SavingTransactionDetailWidget(
          debitAccountInfo: null,
          savingTransaction: tran,
          nominatedAccount: state.selectedNominationAcc,
          showDemandRate: true,
          notice: AppTranslate.i18n.cddsOnlineNoticeStr.localized,
          button1: RoundedButtonWidget(
            title: AppTranslate.i18n.cddsContinueStr.localized.toUpperCase(),
            height: 44,
            radiusButton: 40,
            onPress: () {
              context.read<CurrentDepositsBloc>().add(
                    CurrentDepositsConfirmSettlementEvent(
                      transCode: tran?.transCode,
                      secureTrans: tran?.sercureTrans,
                    ),
                  );
            },
            backgroundButton: AppColors.gPrimaryColor,
          ),
        ),
      ),
    );
  }
}
