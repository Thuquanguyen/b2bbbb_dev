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
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_approve/transaction_approve_detail_multiple_widget.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_approve/transaction_approve_detail_widget.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_approve_result_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_management_screen.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b2b/utilities/message_handler.dart';

class TransactionApproveScreenArguments {
  TransactionApproveScreenArguments({
    required this.transactionsCode,
    this.fallbackRoute,
    required this.filterRequest,
    required this.actionType,
    this.isFx,
  });

  final List<String?> transactionsCode;
  final String? fallbackRoute;
  final TransactionFilterRequest? filterRequest;
  final CommitActionType? actionType;
  final bool? isFx;
}

class TransactionApproveScreen extends StatefulWidget {
  const TransactionApproveScreen({Key? key}) : super(key: key);
  static const String routeName = 'transaction-approve-screen';

  @override
  _TransactionApproveScreenState createState() =>
      _TransactionApproveScreenState();
}

class _TransactionApproveScreenState extends State<TransactionApproveScreen> {
  late TransactionManagerBloc _transactionBloc;
  TextEditingController rejectReasonTxtCtl = TextEditingController();
  String? reasonError;
  bool isInited = false;

  late TransactionApproveScreenArguments? arguments;
  bool isChecker = false;
  bool isSingleTransaction = true;
  bool isFx = false;

  @override
  initState() {
    super.initState();
    _transactionBloc = context.read<TransactionManagerBloc>();
    _transactionBloc.add(ClearTransactionManageInitConfirmState());
  }

  @override
  void dispose() {
    rejectReasonTxtCtl.dispose();
    super.dispose();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInited) {
      isInited = true;
      arguments = getArguments<TransactionApproveScreenArguments>(context);
      if (arguments == null) {
      } else {
        isChecker = RolePermissionManager().userRole == UserRole.CHECKER;
        isSingleTransaction = arguments?.transactionsCode.length == 1;
        isFx = arguments?.isFx ?? false;
        _transactionBloc.add(
          isFx
              ? InitFxTransactionManageEvent(
                  transactions: arguments?.transactionsCode,
                  filterRequest: arguments?.filterRequest,
                )
              : InitTransactionManageEvent(
                  transactions: arguments?.transactionsCode,
                  filterRequest: arguments?.filterRequest,
                ),
        );
      }
    }
  }

  Widget _contentBuilder(BuildContext context, TransactionManagerState state) {
    String title = AppTranslate.i18n.tasScreenTitleSingleStr.localized;
    if (!isSingleTransaction) {
      title = AppTranslate.i18n.tasScreenTitleMultiStr.localized;
    }

    return AppBarContainer(
      appBarType: AppBarType.NORMAL,
      title: title,
      child: _buildLayout(
        state.manageInitState?.data?.transactions ?? [],
        state.manageInitState?.dataState == DataState.data,
      ),
    );
  }

  Widget _buildLayout(List<TransactionMainModel> trans, bool isDataLoaded) {
    Widget? approveButton = isChecker
        ? RoundedButtonWidget(
            title: AppTranslate.i18n.approveStr.localized.toUpperCase(),
            height: 44,
            radiusButton: 40,
            onPress: () {
              handleAction(CommitActionType.APPROVE, isDataLoaded);
            },
            backgroundButton: const Color(0xff00B74F),
          )
        : null;

    Widget rejectButton = RoundedButtonWidget(
      title: isChecker
          ? AppTranslate.i18n.cancelStr.localized.toUpperCase()
          : AppTranslate.i18n.cancelTransactionStr.localized.toUpperCase(),
      height: 44,
      radiusButton: 40,
      onPress: () {
        if (isChecker) {
          handleAction(CommitActionType.REJECT, isDataLoaded);
        } else {
          handleAction(CommitActionType.CANCEL, isDataLoaded);
        }
      },
      backgroundButton: const Color(0xffFF6763),
    );

    CommitActionType? actionType = arguments?.actionType;

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
          child: _switchContentByTransLen(trans),
        ),
        Opacity(
          opacity: isDataLoaded ? 1 : 0.5,
          child: Container(
            padding: const EdgeInsets.only(
                bottom: 24,
                top: kDefaultPadding,
                left: kDefaultPadding,
                right: kDefaultPadding),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14), topRight: Radius.circular(14)),
              boxShadow: [kBoxShadowCenterContainer],
            ),
            child: actionType == null
                ? Row(
                    children: [
                      Expanded(flex: 2, child: rejectButton),
                      SizedBox(
                        width: approveButton != null ? 20 : 0,
                      ),
                      if (approveButton != null)
                        Expanded(flex: 3, child: approveButton),
                    ],
                  )
                : RoundedButtonWidget(
                    title:
                        AppTranslate.i18n.continueStr.localized.toUpperCase(),
                    height: 44,
                    radiusButton: 40,
                    onPress: () {
                      handleAction(actionType, isDataLoaded);
                    },
                    backgroundButton: actionType == CommitActionType.APPROVE
                        ? const Color(0xff00B74F)
                        : const Color(0xffFF6763),
                  ),
          ),
        ),
      ],
    );
  }

  void handleAction(CommitActionType actionType, bool isDataLoaded) {
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
            labelText:
                AppTranslate.i18n.tasRejectDialogMessageLabelStr.localized,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 5,
            ),
            errorText: reasonError,
          ),
        ),
        button1: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.tasRejectDialogCancelStr.localized
              .toUpperCase(),
          textStyle: kDialogButtonBoldText.copyWith(
            color: const Color.fromRGBO(186, 205, 233, 1),
          ),
        ),
        button2: renderDialogTextButton(
          dismiss: false,
          context: context,
          title: AppTranslate.i18n.tasRejectDialogConfirmStr.localized
              .toUpperCase(),
          textStyle: kDialogButtonBoldText,
          onTap: () {
            if (validateReasonInput()) {
              _transactionBloc.add(
                isFx
                    ? ConfirmFxTransactionManageEvent(
                        rejectReason: rejectReasonTxtCtl.text,
                        type: CommitActionType.REJECT,
                      )
                    : ConfirmTransactionManageEvent(
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
        isFx
            ? ConfirmFxTransactionManageEvent(
                rejectReason: '',
                type: actionType,
              )
            : ConfirmTransactionManageEvent(
                rejectReason: '',
                type: actionType,
              ),
      );
    }
  }

  bool validateReasonInput() {
    if (rejectReasonTxtCtl.text.isNotNullAndEmpty) {
      return true;
    } else {
      showToast(AppTranslate.i18n.tasReasonRequiredStr.localized);
      return false;
    }
  }

  Widget _switchContentByTransLen(List<TransactionMainModel> trans) {
    if (isSingleTransaction) {
      return TransactionApproveDetail(
        transaction: trans.length == 1 ? trans.first : null,
      );
    } else {
      return TransactionApproveDetailMulti(
        transactions: trans,
        actionType: arguments?.actionType,
        isFx: isFx,
      );
    }
  }

  void _stateListener(BuildContext context, TransactionManagerState state) {
    if (state.manageInitState?.dataState == DataState.data) {
      List<TransactionMainModel> trans =
          state.manageInitState?.data?.transactions ?? [];
      if (trans.length == 1) {
        _transactionBloc.add(
          GetAdditionalInfoTransactionManageEvent(
            accountNumber: trans.first.debitAccountNumber,
            cityCode: trans.first.city,
            bankCode: trans.first.benBankCode,
            branchCode: trans.first.benBranch,
          ),
        );
      }
    }

    if (state.manageInitState?.dataState == DataState.error) {
      showDialogCustom(
        context,
        AssetHelper.icoStatementComplate,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        state.manageInitState?.errorMessage ??
            AppTranslate.i18n.errorNoReasonStr.localized,
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

  void _confirmStateListener(
      BuildContext context, TransactionManagerState state) {
    if (state.manageConfirmState?.dataState == DataState.preload) {
      showLoading();
    } else {
      hideLoading();
    }

    if (state.manageConfirmState?.dataState == DataState.data) {
      CommitActionType? type = state.manageConfirmState?.type;
      if (type == null) return;
      final args = CommitTransactionOTPArgs(
        transCode: state.manageInitState?.data?.transcodeTrusted ?? '',
        secureTrans: state.manageInitState?.data?.secureTrans ?? '',
        verifyTransId: state.manageConfirmState?.data?.verifyTransId ?? '',
        verifyOtpDisplayType:
            state.manageConfirmState?.data?.verifyOtpDisplayType ?? -1,
        note: state.manageConfirmState?.rejectReason,
        message: state.manageConfirmState?.successMessage,
        actionType: type,
        isFx: isFx,
      );

      SmartOTPManager().verifyOTP(
        context,
        args,
        onResult: (isSuccess, data) {
          _transactionBloc.add(ClearTransactionManageInitConfirmState());
          MessageHandler().notify(
            TransactionManageScreen.TRANSACTION_NEED_RELOAD,
          );
          if (isSuccess == true) {
            MessageHandler().notify(
              TransactionManageScreen.TRANSACTION_ACTION_COMPLETED,
              data: type,
            );
            List<TransactionMainModel>? transactions =
                state.manageInitState?.data?.transactions;
            TransactionMainModel? tran =
                state.manageInitState?.data?.transactions?.first;
            if (data?.model is VerifyOtpDataModel) {
              tran?.bankId = data?.model?.bankId;
              tran?.dateApprover = data?.model?.createdDate;
            }
            if (type == CommitActionType.APPROVE) {
              Navigator.of(context).pushNamedAndRemoveUntil(
                TransactionApproveResultScreen.routeName,
                (route) =>
                    route.settings.name ==
                    (arguments?.fallbackRoute ??
                        TransactionManageScreen.routeName),
                arguments: transactions?.length == 1 ? tran : null,
              );
            } else {
              Navigator.of(context).popUntil(
                (route) =>
                    route.settings.name ==
                    (arguments?.fallbackRoute ??
                        TransactionManageScreen.routeName),
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
                      (route) =>
                          route.settings.name ==
                          (arguments?.fallbackRoute ??
                              TransactionManageScreen.routeName),
                    );
                  },
                ),
              );
            }
          }
        },
      );
    }

    if (state.manageConfirmState?.dataState == DataState.error) {
      showDialogCustom(
        context,
        AssetHelper.icoStatementComplate,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        state.manageConfirmState?.errorMessage ??
            AppTranslate.i18n.errorNoReasonStr.localized,
        button1: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.dialogButtonCloseStr.localized,
        ),
      );
    }
  }

  bool _confirmStateListenWhen(
      TransactionManagerState p, TransactionManagerState c) {
    return p.manageConfirmState?.dataState != c.manageConfirmState?.dataState;
  }

  bool _shouldRebuild(TransactionManagerState p, TransactionManagerState c) {
    return p.manageInitState?.dataState != c.manageInitState?.dataState;
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
