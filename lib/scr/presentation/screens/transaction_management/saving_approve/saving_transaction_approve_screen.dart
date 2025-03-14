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
import 'package:b2b/scr/data/model/saving_transaction_model.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/saving_approve/saving_transaction_approve_contract_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/saving_approve/saving_transaction_approve_detail_widget.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/saving_approve/saving_transaction_approve_result_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_approve/transaction_approve_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_management_screen.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavingTransactionApproveScreenArguments {
  SavingTransactionApproveScreenArguments({
    required this.transactionCode,
    this.fallbackRoute,
    required this.actionType,
  });

  final String transactionCode;
  final String? fallbackRoute;
  final CommitActionType? actionType;
}

class SavingTransactionApproveScreen extends StatefulWidget {
  const SavingTransactionApproveScreen({Key? key}) : super(key: key);
  static const String routeName = 'saving-transaction-approve-screen';

  @override
  _SavingTransactionApproveScreenState createState() => _SavingTransactionApproveScreenState();
}

class _SavingTransactionApproveScreenState extends State<SavingTransactionApproveScreen> {
  late TransactionManagerBloc _transactionBloc;
  TextEditingController rejectReasonTxtCtl = TextEditingController();
  String? reasonError;
  bool isInited = false;

  late SavingTransactionApproveScreenArguments? arguments;
  bool isChecker = false;
  String title = AppTranslate.i18n.dmsTitleStr.localized;

  @override
  initState() {
    super.initState();
    _transactionBloc = context.read<TransactionManagerBloc>();
    _transactionBloc.add(ClearSavingTransactionManageInitConfirmState());
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
      arguments = getArguments<SavingTransactionApproveScreenArguments>(context);
      if (arguments == null) {
      } else {
        isChecker = RolePermissionManager().isChecker();
        _transactionBloc.add(
          InitSavingTransactionManageEvent(
            transCode: arguments?.transactionCode,
          ),
        );
      }
    }
  }

  Widget _contentBuilder(BuildContext context, TransactionManagerState state) {
    return AppBarContainer(
      appBarType: AppBarType.NORMAL,
      title: title,
      child: _buildLayout(
        state.savingManageInitState?.data,
        state.additionalInfoState?.accountInfo,
        state.savingManageInitState?.dataState == DataState.data,
      ),
    );
  }

  Widget _buildLayout(TransactionSavingModel? tran, DebitAccountInfo? accInfo, bool isDataLoaded) {
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
          child: SavingTransactionApproveDetail(
            transaction: tran,
            debitAccountInfo: accInfo,
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
                      Expanded(flex: 2, child: rejectButton),
                      SizedBox(
                        width: approveButton != null ? 20 : 0,
                      ),
                      if (approveButton != null) Expanded(flex: 3, child: approveButton),
                    ],
                  )
                : RoundedButtonWidget(
                    title: AppTranslate.i18n.continueStr.localized.toUpperCase(),
                    height: 44,
                    radiusButton: 40,
                    onPress: () {
                      handleAction(actionType, isDataLoaded);
                    },
                    backgroundButton:
                        actionType == CommitActionType.APPROVE ? const Color(0xff00B74F) : const Color(0xffFF6763),
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
                ConfirmSavingTransactionManageEvent(
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
        ConfirmSavingTransactionManageEvent(rejectReason: '', type: actionType),
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

  void _stateListener(BuildContext context, TransactionManagerState state) {
    if (state.savingManageInitState?.dataState == DataState.data) {
      TransactionSavingModel? tran = state.savingManageInitState?.data;
      if (tran != null) {
        if (tran.getProductType == SavingProductType.AZ) {
          _transactionBloc.add(
            GetAdditionalInfoTransactionManageEvent(
              accountNumber: tran.debitAccountNumber,
            ),
          );
          title = AppTranslate.i18n.dmsTitleOpenAzStr.localized;
        } else if (tran.getProductType == SavingProductType.CLOSEAZ) {
          title = AppTranslate.i18n.dmsTitleCloseAzStr.localized;
        }
        setState(() {});
      }
    }

    if (state.savingManageInitState?.dataState == DataState.error) {
      showDialogCustom(
        context,
        AssetHelper.icoStatementComplate,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        state.savingManageInitState?.errorMessage ?? AppTranslate.i18n.errorNoReasonStr.localized,
        barrierDismissible: false,
        onClose: () {
          Navigator.of(context).pop();
        },
        button1: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.dialogButtonCloseStr.localized,
          onTap: () {
            Navigator.of(context).pop();
          },
        ),
      );
    }
  }

  void _confirmStateListener(BuildContext context, TransactionManagerState state) {
    if (state.savingManageConfirmState?.dataState == DataState.preload) {
      showLoading();
    } else {
      hideLoading();
    }

    if (state.savingManageConfirmState?.dataState == DataState.data) {
      CommitActionType? type = state.savingManageConfirmState?.type;
      if (type == null) return;
      final args = CommitSavingApproveOTPArgs(
        transCode: state.savingManageInitState?.data?.transCode ?? '',
        secureTrans: state.savingManageInitState?.data?.sercureTrans ?? '',
        verifyTransId: state.savingManageConfirmState?.data?.verifyTransId ?? '',
        verifyOtpDisplayType: state.savingManageConfirmState?.data?.verifyOtpDisplayType ?? -1,
        note: state.savingManageConfirmState?.rejectReason,
        message: state.savingManageConfirmState?.successMessage,
        actionType: type,
      );

      SmartOTPManager().verifyOTP(
        context,
        args,
        onResult: (isSuccess, data) {
          _transactionBloc.add(ClearSavingTransactionManageInitConfirmState());
          MessageHandler().notify(
            TransactionManageScreen.TRANSACTION_NEED_RELOAD,
          );
          if (isSuccess == true) {
            MessageHandler().notify(
              TransactionManageScreen.TRANSACTION_ACTION_COMPLETED,
              data: type,
            );
            TransactionSavingModel? trans = state.savingManageInitState?.data;
            String? htmlContractContent;
            String? htmlContractContentType;
            String? bankId;
            if (data?.model is VerifyOtpDataModel) {
              htmlContractContent = data?.model?.azContractContent;
              htmlContractContentType = data?.model?.azContractContentByte;
              bankId = data?.model?.bankId;
            }
            if (type == CommitActionType.APPROVE) {
              if (trans?.getProductType == SavingProductType.AZ && bankId != null) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  SavingTransactionApproveContractScreen.routeName,
                  (route) => route.settings.name == (arguments?.fallbackRoute ?? TransactionManageScreen.routeName),
                  arguments: {
                    'contractContent': htmlContractContent,
                    'contractContentByte': htmlContractContentType,
                  },
                );
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  SavingTransactionApproveResultScreen.routeName,
                  (route) => route.settings.name == (arguments?.fallbackRoute ?? TransactionManageScreen.routeName),
                  arguments: {
                    'transaction': trans,
                    'showDemandRate': trans?.getProductType == SavingProductType.CLOSEAZ,
                  },
                );
              }
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

    if (state.savingManageConfirmState?.dataState == DataState.error) {
      showDialogCustom(
        context,
        AssetHelper.icoStatementComplate,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        state.savingManageConfirmState?.errorMessage ?? AppTranslate.i18n.errorNoReasonStr.localized,
        button1: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.dialogButtonCloseStr.localized,
        ),
      );
    }
  }

  bool _confirmStateListenWhen(TransactionManagerState p, TransactionManagerState c) {
    return p.savingManageConfirmState?.dataState != c.savingManageConfirmState?.dataState;
  }

  bool _shouldRebuild(TransactionManagerState p, TransactionManagerState c) {
    return p.savingManageInitState?.dataState != c.savingManageInitState?.dataState;
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
