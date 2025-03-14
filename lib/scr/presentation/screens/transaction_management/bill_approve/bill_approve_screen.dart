import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/otp/otp_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_event.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_state.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/data/model/bill_payment_model.dart';
import 'package:b2b/scr/data/model/otp/verify_otp_data_model.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/bill_approve/bill_approve_result_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/bill_approve/bill_confirm_widget.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_management_screen.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BillApproveScreenArgument {
  final String? transCode;
  final CommitActionType? actionType;
  final String? fallbackRoute;

  BillApproveScreenArgument({this.transCode, this.actionType, this.fallbackRoute});
}

class BillApproveScreen extends StatefulWidget {
  const BillApproveScreen({Key? key}) : super(key: key);
  static const String routeName = 'BillElecApproveScreen';

  @override
  State<StatefulWidget> createState() => BillApproveScreenState();
}

class BillApproveScreenState extends State<BillApproveScreen> {
  late TransactionManagerBloc _transactionBloc;
  late BillApproveScreenArgument? _argument;
  bool isChecker = false;
  bool isInited = false;
  TextEditingController rejectReasonTxtCtl = TextEditingController();
  String? reasonError;

  @override
  initState() {
    super.initState();
    _transactionBloc = context.read<TransactionManagerBloc>();
    _transactionBloc.add(ClearBillTransactionManageInitConfirmState());

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      isChecker = RolePermissionManager().userRole == UserRole.CHECKER;
      _argument = getArguments<BillApproveScreenArgument>(context);
      if (_argument == null) {
      } else {
        _transactionBloc.add(
          InitBillTransactionManageEvent(
            transCode: _argument?.transCode,
          ),
        );
      }
    });
  }

  bool _shouldRebuild(TransactionManagerState p, TransactionManagerState c) {
    return p.billManageInitState?.dataState != c.billManageInitState?.dataState;
  }

  bool _confirmStateListenWhen(TransactionManagerState p, TransactionManagerState c) {
    return p.billManageConfirmState?.dataState != c.billManageConfirmState?.dataState;
  }

  void _stateListener(BuildContext context, TransactionManagerState state) {
    if (state.billManageInitState?.dataState == DataState.data) {
      _transactionBloc.add(
        GetAdditionalInfoTransactionManageEvent(
          accountNumber: state.billManageInitState?.data?.debitAccountNumber,
        ),
      );
    }

    if (state.billManageInitState?.dataState == DataState.error) {
      showDialogCustom(
        context,
        AssetHelper.icoStatementComplate,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        state.billManageInitState?.errorMessage ?? AppTranslate.i18n.errorNoReasonStr.localized,
        barrierDismissible: false,
        onClose: () {
          popScreen(context);
        },
        button1: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.dialogButtonCloseStr.localized,
          onTap: () {
            popScreen(context);
          },
        ),
      );
    }
  }

  void _confirmStateListener(BuildContext context, TransactionManagerState state) {
    if (state.billManageConfirmState?.dataState == DataState.preload) {
      showLoading();
    } else {
      hideLoading();
    }

    if (state.billManageConfirmState?.dataState == DataState.data) {
      CommitActionType? type = state.billManageConfirmState?.type;
      if (type == null) return;
      final args = CommitBillTransactionOTPArgs(
        transCode: state.billManageInitState?.transcodeTrusted ?? '',
        secureTrans: state.billManageInitState?.secureTrans ?? '',
        verifyTransId: state.billManageConfirmState?.data?.verifyTransId ?? '',
        verifyOtpDisplayType: state.billManageConfirmState?.data?.verifyOtpDisplayType ?? -1,
        note: state.billManageConfirmState?.rejectReason,
        message: state.billManageConfirmState?.successMessage,
        actionType: type,
      );

      SmartOTPManager().verifyOTP(
        context,
        args,
        onResult: (isSuccess, data) {
          _transactionBloc.add(ClearBillTransactionManageInitConfirmState());
          MessageHandler().notify(
            TransactionManageScreen.TRANSACTION_NEED_RELOAD,
          );
          if (isSuccess == true) {
            MessageHandler().notify(
              TransactionManageScreen.TRANSACTION_ACTION_COMPLETED,
              data: type,
            );

            BillPaymentModel? transaction = state.billManageInitState?.data;
            if (type == CommitActionType.APPROVE) {
              if (data?.model is VerifyOtpDataModel) {
                transaction?.bankId = data?.model?.bankId;
                transaction?.dateApprover = data?.model?.createdDate;
              }
              Navigator.of(context).pushNamedAndRemoveUntil(
                BillApproveResultScreen.routeName,
                (route) => route.settings.name == (_argument?.fallbackRoute ?? TransactionManageScreen.routeName),
                arguments: {
                  'transaction': transaction,
                  'approved': data?.model?.approved,
                },
              );
            } else {
              Navigator.of(context).popUntil(
                (route) => route.settings.name == (_argument?.fallbackRoute ?? TransactionManageScreen.routeName),
              );
            }
          } else {
            if (data is OtpVerifyMadeFundState) {
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
                      (route) => route.settings.name == (_argument?.fallbackRoute ?? TransactionManageScreen.routeName),
                    );
                  },
                ),
              );
            }
          }
        },
      );
    }

    if (state.billManageConfirmState?.dataState == DataState.error) {
      showDialogCustom(
        context,
        AssetHelper.icoStatementComplate,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        state.billManageConfirmState?.errorMessage ?? AppTranslate.i18n.errorNoReasonStr.localized,
        button1: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.dialogButtonCloseStr.localized,
        ),
      );
    }
  }

  Widget _buildLayout(
    BillPaymentModel? tran,
    bool isDataLoaded,
  ) {
    Widget? approveButton = RolePermissionManager().isChecker()
        ? RoundedButtonWidget(
            title: AppTranslate.i18n.approveStr.localized.toUpperCase(),
            height: 44,
            radiusButton: 40,
            onPress: () {
              handleAction(CommitActionType.APPROVE, isDataLoaded, tran?.periodTransCodes ?? []);
            },
            backgroundButton: const Color(0xff00B74F),
          )
        : null;

    Widget rejectButton = RoundedButtonWidget(
      title: RolePermissionManager().isChecker()
          ? AppTranslate.i18n.cancelStr.localized.toUpperCase()
          : AppTranslate.i18n.cancelTransactionStr.localized.toUpperCase(),
      height: 44,
      radiusButton: 40,
      onPress: () {
        if (RolePermissionManager().isChecker()) {
          handleAction(CommitActionType.REJECT, isDataLoaded, tran?.periodTransCodes ?? []);
        } else {
          handleAction(CommitActionType.CANCEL, isDataLoaded, tran?.periodTransCodes ?? []);
        }
      },
      backgroundButton: const Color(0xffFF6763),
    );

    CommitActionType? actionType;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocListener<TransactionManagerBloc, TransactionManagerState>(
          listenWhen: _confirmStateListenWhen,
          listener: _confirmStateListener,
          child: Container(),
        ),
        Expanded(
          child: BillElecConfirmWidget(
            bill: tran,
          ),
        ),
        Opacity(
          opacity: isDataLoaded ? 1 : 0.5,
          child: Container(
            padding:
                const EdgeInsets.only(bottom: 24, top: kDefaultPadding, left: kDefaultPadding, right: kDefaultPadding),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
              boxShadow: [kBoxShadowCenterContainer],
            ),
            child: actionType == null
                ? Row(
                    children: [
                      Expanded(child: rejectButton),
                      SizedBox(
                        width: approveButton != null ? 20 : 0,
                      ),
                      if (approveButton != null) Expanded(flex: 2, child: approveButton),
                    ],
                  )
                : RoundedButtonWidget(
                    title: AppTranslate.i18n.continueStr.localized.toUpperCase(),
                    height: 44,
                    radiusButton: 40,
                    onPress: () {
                      handleAction(actionType, isDataLoaded, tran?.periodTransCodes ?? []);
                    },
                    backgroundButton:
                        actionType == CommitActionType.APPROVE ? const Color(0xff00B74F) : const Color(0xffFF6763),
                  ),
          ),
        ),
      ],
    );
  }

  bool validateReasonInput() {
    if (rejectReasonTxtCtl.text.isNotNullAndEmpty) {
      return true;
    } else {
      showToast(AppTranslate.i18n.tasReasonRequiredStr.localized);
      return false;
    }
  }

  void handleAction(CommitActionType actionType, bool isDataLoaded, List<String> transCodes) {
    if (!isDataLoaded) return;
    if (actionType == CommitActionType.REJECT) {
      showDialogCustomBody(
        context,
        AssetHelper.icoDialogDecline,
        AppTranslate.i18n.tasRejectDialogTitleStr.localized,
        customBody: TextFormField(
          keyboardAppearance: Brightness.light,
          controller: rejectReasonTxtCtl,
          enableSuggestions: false,
          style: kStyleTitleText,
          autocorrect: false,
          decoration: InputDecoration(
            labelText: AppTranslate.i18n.tasRejectDialogMessageLabelStr.localized,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            errorText: reasonError,
          ),
        ),
        button1: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.tasRejectDialogCancelStr.localized.toUpperCase(),
          textStyle: kDialogButtonBoldText.copyWith(
            color: const Color.fromRGBO(186, 205, 233, 1),
          ),
        ),
        button2: renderDialogTextButton(
          dismiss: false,
          context: context,
          title: AppTranslate.i18n.tasRejectDialogConfirmStr.localized.toUpperCase(),
          textStyle: kDialogButtonBoldText,
          onTap: () {
            if (validateReasonInput()) {
              _transactionBloc.add(
                ConfirmBillTransactionManageEvent(
                  rejectReason: rejectReasonTxtCtl.text,
                  type: CommitActionType.REJECT,
                ),
              );
              popScreen(context);
            }
          },
        ),
      );
    } else {
      _transactionBloc.add(
        ConfirmBillTransactionManageEvent(
          rejectReason: '',
          type: actionType,
        ),
      );
    }
  }

  Widget _contentBuilder(BuildContext context, TransactionManagerState state) {
    String title = AppTranslate.i18n.bcElecApproveScreenTitleStr.localized;

    return AppBarContainer(
      appBarType: AppBarType.NORMAL,
      title: title,
      child: _buildLayout(
        state.billManageInitState?.data,
        state.billManageInitState?.dataState == DataState.data,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionManagerBloc, TransactionManagerState>(
      buildWhen: _shouldRebuild,
      listenWhen: _shouldRebuild,
      listener: _stateListener,
      builder: _contentBuilder,
    );
  }
}
