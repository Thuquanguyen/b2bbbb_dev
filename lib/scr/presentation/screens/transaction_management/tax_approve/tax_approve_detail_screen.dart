import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/otp/otp_bloc.dart';
import 'package:b2b/scr/bloc/tax/tax_manage/tax_manage_bloc.dart';
import 'package:b2b/scr/bloc/tax/tax_manage/tax_manage_events.dart';
import 'package:b2b/scr/bloc/tax/tax_manage/tax_manage_state.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/data/model/otp/verify_otp_data_model.dart';
import 'package:b2b/scr/data/model/tax/tax_online.dart';
import 'package:b2b/scr/presentation/screens/main/home_screen.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:b2b/scr/presentation/screens/tax/tax_list_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/tax_approve/tax_approve_contract_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/tax_approve/tax_approve_detail_widget.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/tax_approve/tax_approve_result_screen.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../tax/tax_screen.dart';

class TaxDetailScreenArgument {
  final String? transCode;
  final CommitActionType? actionType;
  final String? fallbackRoute;

  TaxDetailScreenArgument({this.transCode, this.actionType, this.fallbackRoute});
}

class TaxDetailScreen extends StatefulWidget {
  const TaxDetailScreen({Key? key}) : super(key: key);
  static const String routeName = 'TaxtDetailScreen';

  @override
  State<StatefulWidget> createState() => TaxDetailScreenState();
}

class TaxDetailScreenState extends State<TaxDetailScreen> {
  bool isChecker = false;
  bool isDataLoaded = false;
  CommitActionType? actionType;
  String? transCode;
  TaxOnline? tax;
  TextEditingController rejectReasonTxtCtl = TextEditingController();
  String? reasonError;
  TaxDetailScreenArgument? arguments;

  late TaxManageBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<TaxManageBloc>(context);
    isChecker = RolePermissionManager().userRole == UserRole.CHECKER;
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      arguments = getArguments<TaxDetailScreenArgument>(context);
      actionType = arguments?.actionType;
      transCode = arguments?.transCode;
      _bloc.add(TaxManageInitEvent(transCode: transCode));
      setState(() {});
    });
  }

  bool _initStateListenWhen(TaxManageState p, TaxManageState c) {
    return p.initState?.dataState != c.initState?.dataState;
  }

  void _initStateListener(BuildContext context, TaxManageState state) {
    if (state.initState?.dataState == DataState.preload) {
      showLoading();
    } else {
      hideLoading();
    }

    if (state.initState?.dataState == DataState.data) {
      if (state.initState?.data != null) {
        tax = state.initState?.data;
        isDataLoaded = true;
        setState(() {});
      }
    }

    if (state.initState?.dataState == DataState.error) {
      showDialogErrorForceGoBack(
        context,
        state.initState?.errorMessage ?? AppTranslate.i18n.errorNoReasonStr.localized,
        () {},
        barrierDismissible: false,
      );
    }
  }

  bool _confirmStateListenWhen(TaxManageState p, TaxManageState c) {
    return p.confirmState?.dataState != c.confirmState?.dataState;
  }

  void _confirmStateListener(BuildContext context, TaxManageState state) {
    if (state.confirmState?.dataState == DataState.preload) {
      showLoading();
    } else {
      hideLoading();
    }

    if (state.confirmState?.dataState == DataState.data) {
      CommitActionType? type = state.confirmState?.actionType;
      if (type == null) return;
      final args = CommitTaxOnlineApproveOTPArgs(
        transCode: state.initState?.data?.transInfo?.transCode ?? '',
        secureTrans: state.initState?.data?.transInfo?.sercureTrans ?? '',
        verifyTransId: state.confirmState?.data?.verifyTransId ?? '',
        verifyOtpDisplayType: state.confirmState?.data?.verifyOtpDisplayType ?? -1,
        note: state.confirmState?.rejectReason,
        message: state.confirmState?.successMessage,
        actionType: type,
      );

      SmartOTPManager().verifyOTP(
        context,
        args,
        onResult: (isSuccess, data) {
          _bloc.add(TaxManageClearConfirmEvent());
          MessageHandler().notify(TaxListScreen.TAX_LIST_RELOAD_EVENT);
          if (isSuccess == true) {
            if (type == CommitActionType.APPROVE) {
              String? htmlContractContent;
              String? htmlContractContentType;
              String? bankId;
              if (data?.model is VerifyOtpDataModel) {
                htmlContractContent = data?.model?.azContractContent;
                htmlContractContentType = data?.model?.azContractContentByte;
                bankId = data?.model?.bankId;
              }

              if (bankId != null) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  TaxApproveContractScreen.routeName,
                  (route) => route.settings.name == (arguments?.fallbackRoute ?? HomeScreen.routeName),
                  arguments: {
                    'contractContent': htmlContractContent,
                    'contractContentByte': htmlContractContentType,
                  },
                );
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  TaxApproveResultScreen.routeName,
                  (route) => route.settings.name == (arguments?.fallbackRoute ?? HomeScreen.routeName),
                  arguments: {
                    'tax': state.initState?.data,
                  },
                );
              }
            } else {
              Navigator.of(context).popUntil(
                (route) => route.settings.name == (arguments?.fallbackRoute ?? HomeScreen.routeName),
              );
              MessageHandler().notify(TaxScreen.eventCancelSuccess);
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
                      (route) => route.settings.name == TaxListScreen.routeName,
                    );
                  },
                ),
              );
            }
          }
        },
      );
    }

    if (state.confirmState?.dataState == DataState.error) {
      showDialogCustom(
        context,
        AssetHelper.icoStatementComplate,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        state.confirmState?.errorMessage ?? AppTranslate.i18n.errorNoReasonStr.localized,
        button1: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.dialogButtonCloseStr.localized,
        ),
      );
    }
  }

  Widget _contentBuilder(BuildContext context) {
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

    // CommitActionType? actionType = ar?.actionType;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocListener<TaxManageBloc, TaxManageState>(
          // bloc: _bloc,
          listenWhen: _initStateListenWhen,
          listener: _initStateListener,
          child: const SizedBox(),
        ),
        BlocListener<TaxManageBloc, TaxManageState>(
          // bloc: _bloc,
          listenWhen: _confirmStateListenWhen,
          listener: _confirmStateListener,
          child: const SizedBox(),
        ),
        Expanded(
          child: TaxApproveDetailWidget(
            tax: tax,
          ),
        ),
        if (tax?.shouldShowActionButtons(isChecker, SessionManager().userData?.user?.username) == true)
          Opacity(
            opacity: isDataLoaded ? 1 : 0.5,
            child: Container(
              padding: const EdgeInsets.only(
                  bottom: 24, top: kDefaultPadding, left: kDefaultPadding, right: kDefaultPadding),
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

  void handleAction(CommitActionType? actionType, bool isDataLoaded) {
    if (!isDataLoaded || actionType == null) return;
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
              _bloc.add(
                TaxManageConfirmEvent(
                  transCode: tax?.transInfo?.transCode,
                  secureTrans: tax?.transInfo?.sercureTrans,
                  rejectReason: rejectReasonTxtCtl.text,
                  actionType: CommitActionType.REJECT,
                ),
              );
              popScreen(context);
            }
          },
        ),
      );
    } else {
      _bloc.add(
        TaxManageConfirmEvent(
          transCode: tax?.transInfo?.transCode,
          secureTrans: tax?.transInfo?.sercureTrans,
          rejectReason: '',
          actionType: actionType,
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

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      appBarType: AppBarType.NORMAL,
      title: AppTranslate.i18n.taxApproveScreenTitleStr.localized,
      child: _contentBuilder(context),
    );
  }
}
