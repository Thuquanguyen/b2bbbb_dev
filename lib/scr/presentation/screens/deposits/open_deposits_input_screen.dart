import 'dart:async';

import 'package:b2b/commons.dart';
import 'package:b2b/config.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/deposits/open_online_deposits_bloc.dart';
import 'package:b2b/scr/core/environment/app_enviroment_manager.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/open_saving/rollover_term.dart';
import 'package:b2b/scr/data/model/open_saving/rollover_term_rate.dart';
import 'package:b2b/scr/data/model/open_saving/saving_deposits_product_response.dart';
import 'package:b2b/scr/data/model/open_saving/saving_init_request.dart';
import 'package:b2b/scr/data/model/open_saving/settelment.dart';
import 'package:b2b/scr/presentation/screens/deposits/confirm_open_deposits_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/render_deposits_input.dart';
import 'package:b2b/scr/presentation/screens/term/term_screen.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/dropdown_item.dart';
import 'package:b2b/scr/presentation/widgets/keyboard_aware_scroll_view.dart';
import 'package:b2b/scr/presentation/widgets/rounded_button_widget.dart';
import 'package:b2b/utilities/input_item_data.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bottom_sheet.dart';

enum DepositsInputType {
  ACCOUNT,
  AMOUNT,
  PREVIOS //ky hạn
  ,
  EVOUCHER,
  DUE_PROCESS_METHOD,
  ACCOUNT_GET_PROFIT,
  CIF_REFER,
  NOTE,
}

class OpenDepositsInputScreen extends StatefulWidget {
  const OpenDepositsInputScreen({Key? key}) : super(key: key);

  static const String routeName = 'OpenDepositsInputScreen';

  @override
  _OpenDepositsInputScreenState createState() =>
      _OpenDepositsInputScreenState();
}

class _OpenDepositsInputScreenState extends State<OpenDepositsInputScreen> {
  List<InputItemData> inputs = [];

  TextEditingController amountController = TextEditingController();
  TextEditingController voucherController = TextEditingController();
  TextEditingController cifReferController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  FocusNode amountFocusNode = FocusNode();

  final StreamController<bool> _continueButtonStream =
      StreamController<bool>.broadcast();

  late OpenOnlineDepositsBloc depositsBloc;

  @override
  void initState() {
    super.initState();
    depositsBloc = BlocProvider.of<OpenOnlineDepositsBloc>(context);
    depositsBloc.add(OpenDepositsInitEvent());
  }

  _checkBuildDefaultButtonFunction() {
    OpenOnlineDepositsState state = depositsBloc.state;
    RolloverTerm? rolloverTerm = state.depositsInputState?.selectedRollOverTerm;
    Settelment? settelment = state.depositsInputState?.selectedSettelment;

    Logger.debug('selectedSettelment $settelment');
    Logger.debug('rolloverTerm $rolloverTerm');

    if (rolloverTerm != null && settelment != null) {
      Logger.debug('_checkBuildDefaultButtonFunction true');
      _continueButtonStream.add(true);
      return;
    }
    Logger.debug('_checkBuildDefaultButtonFunction false');
    _continueButtonStream.add(false);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
    Logger.debug('------- zzzzzz dispose');
    depositsBloc.add(ClearInputState());
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      scaffoldkey: _scaffoldKey,
      isShowKeyboardDoneButton: true,
      title: AppTranslate.i18n.openOnlineDepositsStr.localized,
      appBarType: AppBarType.NORMAL,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<OpenOnlineDepositsBloc, OpenOnlineDepositsState>(
            listenWhen: (pre, current) {
              return (pre.depositsInputState?.rollOverTermListDataState !=
                  current.depositsInputState?.rollOverTermListDataState);
            },
            listener: (context, state) {
              Logger.debug('---------------------- open deposits listenner');
              if (state.depositsInputState?.rollOverTermListDataState ==
                  DataState.error) {
                showToast(AppTranslate.i18n.getRolloverErrMsgStr.localized);
              }
            },
          ),
          BlocListener<OpenOnlineDepositsBloc, OpenOnlineDepositsState>(
            listenWhen: (pre, current) {
              return pre.initDepositsDataState != current.initDepositsDataState;
            },
            listener: (context, state) {
              Logger.debug('----------AAAAAFAGHFAGFAGHAFAH');
              if (state.initDepositsDataState == DataState.preload) {
                showLoading();
              } else if (state.initDepositsDataState == DataState.data) {
                hideLoading();
                Navigator.of(context).pushNamed(
                  ConfirmDepositsScreen.routeName,
                  arguments: context,
                );
              } else if (state.initDepositsDataState == DataState.error) {
                showDialogErrorForceGoBack(
                    context, (state.errorMessage ?? ''), () {});
                hideLoading();
                return;
              }
            },
          ),
          BlocListener<OpenOnlineDepositsBloc, OpenOnlineDepositsState>(
            listenWhen: (pre, current) {
              return pre.debitAccountDataState != current.debitAccountDataState;
            },
            listener: (context, state) {
              if (state.depositsSavingProductState == DataState.error) {
                showDialogErrorForceGoBack(
                  context,
                  (state.errorMessage ?? ''),
                  () {
                    popScreen(context);
                  },
                );
              }
            },
          )
        ],
        child: Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _interestValue(),
              const SizedBox(
                height: kDefaultPadding,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  decoration: kDecoration,
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: KeyboardAwareScrollView(
                          // reverse: MediaQuery.of(context).viewInsets.bottom == 0 ? false : true,
                          // padding: EdgeInsets.only(bottom: paddingKeyboard),
                          child: SingleChildScrollView(
                            child: _inputContent(),
                          ),
                        ),
                      ),
                      StreamBuilder<bool>(
                        initialData: false,
                        stream: _continueButtonStream.stream,
                        builder: (context, snapshot) {
                          return !isKeyboardShowing(context)
                              ? RoundedButtonWidget(
                                  onPress:
                                      snapshot.data! ? _createDeposits : null,
                                  title: AppTranslate.i18n.continueStr.localized
                                      .toUpperCase()
                                      .toUpperCase(),
                                  textStyle: TextStyles.headerText
                                      .copyWith(color: Colors.white),
                                )
                              : const SizedBox();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _createDeposits() {
    // Navigator.of(context).pushNamed(
    //   ConfirmDepositsScreen.routeName,
    //   arguments: context,
    // );
    // return;

    String? note = noteController.text.toString().trim();
    String? cifRefer = cifReferController.text.toString().trim();
    String? voucher = voucherController.text.toString().trim();

    Logger.debug('_createDeposits $note');

    OpenOnlineDepositsState state = depositsBloc.state;

    SavingReceiveMethod? receiveMethod = state.savingReceiveMethod;

    //phuong thuc nhan lai
    Settelment? settelment = state.depositsInputState?.selectedSettelment;
    RolloverTerm? rolloverTerm = state.depositsInputState?.selectedRollOverTerm;
    double? amount = getAmountValue();

    if (receiveMethod == null ||
        settelment == null ||
        rolloverTerm == null ||
        amount == null) {
      return;
    }

    SavingInitRequest initRequest = SavingInitRequest(
      productId: receiveMethod.productId,
      secureId: receiveMethod.secureId,
      amount: amount,
      debitAccountNumber: state.rootAccountDebit?.accountNumber,
      termCode: rolloverTerm.termCode,
      mandustry: settelment.settleCode,
      nominatedAccountNumber: state.receiveAccountProfit?.accountNumber,
      introducerCif: cifRefer,
      promotionCode: voucher,
      contractNumber: note,
      startDate: state.depositsInputState?.rolloverTermRate?.startDate,
      endDate: state.depositsInputState?.rolloverTermRate?.endDate,
      rate: state.depositsInputState?.rolloverTermRate?.interestRate,
    );

    depositsBloc.add(
      InitDepositsEvent(initRequest),
    );
  }

  _interestValue() {
    return BlocBuilder<OpenOnlineDepositsBloc, OpenOnlineDepositsState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: kDecoration,
          child: Column(
            children: [
              interestItem(
                  AppTranslate.i18n.listedInterestRateStr.localized,
                  state.depositsInputState?.rolloverTermRate
                          ?.getInterestRate() ??
                      '',
                  state,
                  shimmerWidth: 20),
              const SizedBox(height: 8),
              interestItem(
                  AppTranslate.i18n.expertProfitStr.localized,
                  state.depositsInputState?.rolloverTermRate
                          ?.getAmountInterestRate() ??
                      '',
                  state,
                  shimmerWidth: 150),
              const SizedBox(height: 8),
              interestItem(AppTranslate.i18n.receiveInterestMethodStr.localized,
                  state.savingReceiveMethod?.interrestPreiod ?? '', state,
                  forceShow: true),
            ],
          ),
        );
      },
    );
  }

  interestItem(String title, String value, OpenOnlineDepositsState state,
      {bool? forceShow = false, double? shimmerWidth}) {
    DataState? rollOverDataState =
        state.depositsInputState?.rollTermRateDataState;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Text(
          title,
          style: TextStyles.smallText.copyWith(
            color: const Color(0xff22313F),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        if (rollOverDataState == DataState.preload && forceShow == false)
          AppShimmer(
            Container(
              width: shimmerWidth ?? 80,
              padding: const EdgeInsets.only(left: 8, right: 8),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(kCornerRadius),
                  color: AppColors.shimmerItemColor),
              child: Text(
                '',
                maxLines: 2,
                style: TextStyles.headerText.regular.inputTextColor
                    .copyWith(fontSize: 14),
              ),
            ),
          ),
        if (rollOverDataState != DataState.preload || forceShow == true)
          value.isNullOrEmpty
              ? const SizedBox()
              : Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xffE6F7ED),
                        borderRadius: BorderRadius.circular(kCornerRadius),
                      ),
                      padding: const EdgeInsets.only(
                          top: 4, bottom: 4, left: 8, right: 8),
                      child: Text(
                        value,
                        maxLines: 2,
                        style: TextStyles.headerText.regular.inputTextColor
                            .copyWith(fontSize: 14),
                      ),
                    ),
                  ),
                ),
      ],
    );
  }

  //tk gốc
  showBottomSheetRootAccount(OpenOnlineDepositsState state) {
    Logger.debug('showBottomSheetRootAccount');
    FocusManager.instance.primaryFocus?.unfocus();
    changeAccount(context, depositsBloc, state, true);
  }

  //tk nhận lãi
  showBottomSheetReceiveProfitAccount(OpenOnlineDepositsState state) {
    Logger.debug('showBottomSheetReceiveProfitAccount');
    FocusManager.instance.primaryFocus?.unfocus();
    changeAccount(context, depositsBloc, state, false);
  }

  // phương thức nhận lãi
  showBottomSheetChangeSettElement(
      OpenOnlineDepositsBloc depositsBloc, OpenOnlineDepositsState state) {
    Logger.debug('showBottomSheetChangeSettElement');
    FocusManager.instance.primaryFocus?.unfocus();
    showBottomSheetSettElement(
      context,
      depositsBloc,
      state,
      conChange: () {
        _checkBuildDefaultButtonFunction();
      },
    );
  }

  void _onCompleteAmount(String value) {
    Logger.debug('_onCompleteAmount');
    value = value.replaceAll(' ', '');
    if (value.length < 0) {
      return;
    }
    try {
      double amount = double.parse(value);
      //Min tiền gửi là 10tr
      if (amount < 10000000) {
        showToast(AppTranslate.i18n.noticeMinimumSavingAmountStr.localized);
        return;
      }
      depositsBloc.add(
        GetRollOverTermListEvent(amount),
      );
    } catch (e) {}
  }

  void _onAmountChange(String value) {
    double? value = getAmountValue();
    if (value == null) {
      return;
    }

    if (depositsBloc.state.depositsInputState?.rollTermRateDataState ==
            DataState.data ||
        depositsBloc.state.depositsInputState?.rollOverTermListDataState ==
            DataState.data) {
      depositsBloc.add(
        ClearRolloverTermRateEvent(),
      );

      setTimeout(() {
        _checkBuildDefaultButtonFunction();
      }, 100);
    }
  }

  double? getAmountValue() {
    try {
      String value = amountController.text;
      value = value.replaceAll(' ', '');
      return double.parse(value);
    } catch (e) {
      return null;
    }
  }

  //ky hạn nhận lãi
  void changeRollOverTerm(RolloverTerm rolloverTerm) {
    double? amount = getAmountValue();
    if (amount == null) {
      return;
    }
    depositsBloc.add(ChangeRolloverTermEvent(rolloverTerm, amount));
    setTimeout(() {
      _checkBuildDefaultButtonFunction();
    }, 100);
  }

  _inputContent() {
    return BlocConsumer<OpenOnlineDepositsBloc, OpenOnlineDepositsState>(
      listener: (context, state) {
        if (state.debitAccountDataState == DataState.error) {
          showDialogErrorForceGoBack(
              context, (state.errorMessage ?? ''), () {});
          hideLoading();
          return;
        }
      },
      builder: (context, state) {
        Logger.debug('Rebuild Open Deposits input');
        return Column(
          children: [
            accountWidget(state, onPress: () {
              showBottomSheetRootAccount(state);
            },
                showRequire: true,
                showAvailableBalance: true,
                isRootAccount: true,
                title: AppTranslate
                    .i18n.transferToAccountTitleSourceAccountStr.localized),
            const SizedBox(
              height: kDefaultPadding,
            ),
            amountNumberWidget('VND', amountController, amountFocusNode,
                onComplete: _onCompleteAmount, onTextChange: _onAmountChange),
            periodWidget(
              state,
              showRequire: true,
              changeRolloverTerm: () {
                showBottomSheetChangeRolloverTerm(
                  context,
                  state,
                  (rollOver) {
                    changeRollOverTerm(rollOver);
                  },
                );
              },
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            inputValueWidget(
                title: AppTranslate.i18n.evoucherCodeStr.localized,
                controller: voucherController,
                hint: AppTranslate.i18n.enterEvoucherStr.localized),
            settElementWidget(
              state,
              () {
                showBottomSheetChangeSettElement(depositsBloc, state);
              },
            ),
            accountWidget(state, onPress: () {
              showBottomSheetReceiveProfitAccount(state);
            },
                showRequire: true,
                isRootAccount: false,
                title: AppTranslate.i18n.accountReceiveProfitStr.localized),
            const SizedBox(
              height: kDefaultPadding,
            ),
            inputValueWidget(
                title: AppTranslate.i18n.cifReferStr.localized,
                hint: AppTranslate.i18n.notRequireStr.localized,
                controller: cifReferController),
            inputValueWidget(
                title: AppTranslate.i18n.titleNoteStr.localized,
                hint: AppTranslate.i18n.notRequireStr.localized,
                controller: noteController),
            noteWidget(openTermAndCondition),
            const SizedBox(
              height: 8,
            ),
          ],
        );
      },
    );
  }

  openTermAndCondition() {
    String url = AppEnvironmentManager.apiUrl;
    url = url.replaceAll('/api', '');
    url = '$url/MB01.Q%C4%90-NH%C4%90T-Dieu-kien-giao-dich-chung.html';
    Logger.debug('openTermAndCondition : $url');
    if (AppEnvironmentManager.environment == AppEnvironment.Pro) {
      url = 'https://api-b2b.vpbank.com.vn/mapi/MB01.Q%C4%90-NH%C4%90T-Dieu-kien-giao-dich-chung.html';
    }
    pushNamed(
      context,
      TermScreen.routeName,
      arguments: TermModel(
        AppTranslate.i18n.homeTitleTermHeaderStr.localized,
        url,
        () {},
      ),
    );
  }
}
