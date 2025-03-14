import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_event.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_state.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/data/model/otp/verify_otp_data_model.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/data/model/transaction_payroll_model.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/payroll_approve/payroll_approve_detail.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/payroll_approve/payroll_approve_result_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_management_screen.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PayrollApproveScreenArguments {
  PayrollApproveScreenArguments({
    required this.fileCode,
    this.transCode,
    required this.actionType,
    this.fallbackRoute,
  });

  final String fileCode;
  final String? transCode;
  final String? fallbackRoute;
  final CommitActionType? actionType;
}

class PayrollApproveScreen extends StatefulWidget {
  const PayrollApproveScreen({Key? key}) : super(key: key);
  static const String routeName = 'PayrollApproveDetailScreen';

  @override
  State<StatefulWidget> createState() => PayrollApproveScreenState();
}

class PayrollApproveScreenState extends State<PayrollApproveScreen> {
  late TransactionManagerBloc _transactionBloc;
  late PayrollApproveScreenArguments? arguments;
  bool isChecker = false;
  bool isInited = false;
  TextEditingController rejectReasonTxtCtl = TextEditingController();
  String? reasonError;

  @override
  initState() {
    super.initState();
    _transactionBloc = context.read<TransactionManagerBloc>();
    _transactionBloc.add(ClearPayrollTransactionManageInitConfirmState());
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInited) {
      isInited = true;
      isChecker = RolePermissionManager().isChecker();
      arguments = getArguments<PayrollApproveScreenArguments>(context);
      if (arguments == null) {
      } else {
        _transactionBloc.add(
          InitPayrollTransactionManageEvent(
            fileCode: arguments?.fileCode,
            transCode: arguments?.transCode,
          ),
        );
      }
    }
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

  bool _shouldRebuild(TransactionManagerState p, TransactionManagerState c) {
    return p.payrollManageInitState?.dataState != c.payrollManageInitState?.dataState;
  }

  bool _confirmStateListenWhen(TransactionManagerState p, TransactionManagerState c) {
    return p.payrollManageConfirmState?.dataState != c.payrollManageConfirmState?.dataState;
  }

  void _stateListener(BuildContext context, TransactionManagerState state) {
    if (state.payrollManageInitState?.dataState == DataState.data) {
      _transactionBloc.add(
        GetAdditionalInfoTransactionManageEvent(
          accountNumber: state.payrollManageInitState?.data?.transactions?.debitAccountNumber,
        ),
      );
    }

    if (state.payrollManageInitState?.dataState == DataState.error) {
      showDialogCustom(
        context,
        AssetHelper.icoStatementComplate,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        state.payrollManageInitState?.errorMessage ?? AppTranslate.i18n.errorNoReasonStr.localized,
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
    if (state.payrollManageConfirmState?.dataState == DataState.preload) {
      showLoading();
    } else {
      hideLoading();
    }

    if (state.payrollManageConfirmState?.dataState == DataState.data) {
      CommitActionType? type = state.payrollManageConfirmState?.type;
      if (type == null) return;
      final args = CommitPayrollApproveOTPArgs(
        transCode: state.payrollManageInitState?.data?.transactions?.transCode ?? '',
        secureTrans: state.payrollManageInitState?.data?.secureTrans ?? '',
        verifyTransId: state.payrollManageConfirmState?.data?.verifyTransId ?? '',
        verifyOtpDisplayType: state.payrollManageConfirmState?.data?.verifyOtpDisplayType ?? -1,
        note: state.payrollManageConfirmState?.rejectReason,
        message: state.payrollManageConfirmState?.successMessage,
        actionType: type,
      );

      SmartOTPManager().verifyOTP(
        context,
        args,
        onResult: (isSuccess, data) {
          _transactionBloc.add(ClearPayrollTransactionManageInitConfirmState());
          MessageHandler().notify(
            TransactionManageScreen.TRANSACTION_NEED_RELOAD,
          );
          if (isSuccess == true) {
            MessageHandler().notify(
              TransactionManageScreen.TRANSACTION_ACTION_COMPLETED,
              data: type,
            );

            TransactionMainModel? transaction = state.payrollManageInitState?.data?.transactions;
            if (type == CommitActionType.APPROVE) {
              if (data?.model is VerifyOtpDataModel) {
                transaction?.bankId = data?.model?.bankId;
                transaction?.dateApprover = data?.model?.createdDate;
                transaction?.transCode = data?.model?.transCode;
              }
              Navigator.of(context).pushNamedAndRemoveUntil(
                PayrollApproveResultScreen.routeName,
                (route) => route.settings.name == (arguments?.fallbackRoute ?? TransactionManageScreen.routeName),
                arguments: {
                  'transaction': transaction,
                  'benCount': (state.payrollManageInitState?.data?.totalInhouse ?? 0) +
                      (state.payrollManageInitState?.data?.totalOther ?? 0),
                },
              );
            } else {
              Navigator.of(context).popUntil(
                (route) => route.settings.name == (arguments?.fallbackRoute ?? TransactionManageScreen.routeName),
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
                      (route) => route.settings.name == (arguments?.fallbackRoute ?? TransactionManageScreen.routeName),
                    );
                  },
                ),
              );
            }
          }
        },
      );
    }

    if (state.payrollManageConfirmState?.dataState == DataState.error) {
      showDialogCustom(
        context,
        AssetHelper.icoStatementComplate,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        state.payrollManageConfirmState?.errorMessage ?? AppTranslate.i18n.errorNoReasonStr.localized,
        button1: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.dialogButtonCloseStr.localized,
        ),
      );
    }
  }

  Widget _contentBuilder(BuildContext context, TransactionManagerState state) {
    String title = AppTranslate.i18n.prDetailScreenTitleStr.localized;

    return AppBarContainer(
      appBarType: AppBarType.NORMAL,
      title: title,
      child: _buildLayout(
        state.payrollManageInitState?.data?.transactions,
        state.payrollManageInitState?.data?.totalInhouse,
        state.payrollManageInitState?.data?.totalOther,
        state.payrollManageInitState?.dataState == DataState.data,
      ),
    );
  }

  Widget _buildLayout(
    TransactionMainModel? tran,
    int? totalInhouse,
    int? totalOther,
    bool isDataLoaded,
  ) {
    Widget? approveButton = RolePermissionManager().isChecker()
        ? RoundedButtonWidget(
            title: AppTranslate.i18n.approveStr.localized.toUpperCase(),
            height: 44,
            radiusButton: 40,
            onPress: () {
              handleAction(CommitActionType.APPROVE, isDataLoaded, tran?.transCode);
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
          handleAction(CommitActionType.REJECT, isDataLoaded, tran?.transCode);
        } else {
          handleAction(CommitActionType.CANCEL, isDataLoaded, tran?.transCode);
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
          child: PayrollTransactionApproveDetail(
            payroll: tran,
            totalInhouse: totalInhouse,
            totalOther: totalOther,
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
                      handleAction(actionType, isDataLoaded, tran?.transCode);
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

  void handleAction(CommitActionType actionType, bool isDataLoaded, String? transCode) {
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
                ConfirmPayrollTransactionManageEvent(
                  transCode: transCode,
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
        ConfirmPayrollTransactionManageEvent(
          transCode: transCode,
          rejectReason: '',
          type: actionType,
        ),
      );
    }
  }
}
