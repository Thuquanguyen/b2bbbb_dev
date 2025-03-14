// Created by Cuonghd2 at 05/08/2021
// Email: cuonghd2@vpbank.com.vn
// Copyright (c) 2020. All rights reserved.

part of 'transfer_input_screen.dart';

class TransferInHouse extends StatefulWidget {
  const TransferInHouse({
    Key? key,
    required this.onInitTransfer,
  }) : super(key: key);

  static const String routeName = '/transfer_in_house';

  final void Function({
    required String amount,
    required String memo,
    required bool checkSaveAccount,
    String? aliasName,
    String? amountCcy,
  }) onInitTransfer;

  @override
  TransferInHouseScreenState createState() => TransferInHouseScreenState();
}

class TransferInHouseScreenState extends State<TransferInHouse> {
  TextEditingController? numberAccountInputController;
  final TextEditingController saveNameAccountInputController =
      TextEditingController();
  final TextEditingController detailTransferInputController =
      TextEditingController();
  final TextEditingController amountTransferInputController =
      TextEditingController();

  final FocusNode amountInputFocusNode = FocusNode();
  final FocusNode saveNameAccountInputFocusNode = FocusNode();
  final FocusNode detailTransferInputFocusNode = FocusNode();
  FocusNode? accountFocusNode;

  final StreamController<bool> _checkBuildDefaultButton =
      StreamController<bool>.broadcast();

  final ScrollController _contentScrollController = ScrollController();

  bool checkSaveAccount = false;
  bool isFocus = false;
  late TransferBloc _transferBloc;
  late TransferRateBloc _rateBloc;

  String? amountCcy = 'VND';

  //Chuyển kiểu bàn phím số or chữ
  TextInputType accountInputType = TextInputType.number;
  String inhouse_accountInputKey = 'inhouse_accountInputKey';

  @override
  void initState() {
    super.initState();

    _rateBloc = BlocProvider.of<TransferRateBloc>(context);
    _transferBloc = BlocProvider.of<TransferBloc>(context);
    _transferBloc.add(
      GetListDebitAccountEvent(
        TransferType.TRANSINHOUSE,
      ),
    );

    _transferBloc.add(GetBenListEvent(TransferType.TRANSINHOUSE));

    amountTransferInputController.addListener(() {
      _checkBuildDefaultButton.add(_checkBuildDefaultButtonFunction());
    });
    detailTransferInputController.addListener(() {
      _checkBuildDefaultButton.add(_checkBuildDefaultButtonFunction());
    });

    detailTransferInputFocusNode.addListener(() {
      if (detailTransferInputController.text.isNotEmpty) {
        detailTransferInputController.text =
            removeDiacritics(detailTransferInputController.text);
      }
    });
    saveNameAccountInputFocusNode.addListener(() {
      if (saveNameAccountInputController.text.isNotEmpty) {
        saveNameAccountInputController.text =
            removeDiacritics(saveNameAccountInputController.text);
      }
    });

    amountInputFocusNode.addListener(() {
      TransferState state = _transferBloc.state;
      if (amountInputFocusNode.hasFocus == false && state.needGetRate()) {
        _getTransferRate(_transferBloc.state);
      }
    });

    MessageHandler().register(TransferInputScreen.eventChangeDebitAccount, () {
      setTimeout(() {
        if (_transferBloc.state.needGetRate()) {
          _getTransferRate(_transferBloc.state);
        }
      }, 50);
    });

    MessageHandler()
        .register(inhouse_accountInputKey, onAccountChangeKeyboardType);
  }

  bool enableGetAccountDetail = true;

  void onAccountChangeKeyboardType() {
    Logger.debug('onAccountChangeKeyboardType');
    FocusScope.of(context).unfocus();
    enableGetAccountDetail = false;
    if (accountInputType == TextInputType.number) {
      setState(() {
        accountInputType = TextInputType.text;
      });
    } else {
      setState(() {
        accountInputType = TextInputType.number;
      });
    }
    setTimeout(() {
      accountFocusNode?.requestFocus();
      enableGetAccountDetail = true;
    }, 50);
  }

  @override
  void dispose() {
    super.dispose();

    MessageHandler().unregister(TransferInputScreen.eventChangeDebitAccount);
    MessageHandler().unregister(inhouse_accountInputKey);
  }

  bool _checkBuildDefaultButtonFunction() {
    Logger.debug('m_checkBuildDefaultButtonFunctionsg');
    double amount = 0;
    try {
      amount = double.parse(amountTransferInputController.text
          .toString()
          .replaceAll(' ', '')
          .replaceAll(',', ''));
    } catch (e) {}

    bool checkRate = getCheckRate();

    if (amount > 0 &&
        detailTransferInputController.text.isNotNullAndEmpty &&
        _transferBloc.state.detailBeneficianAccount?.accountNumber != null &&
        checkRate) {
      return true;
    }
    return false;
  }

  bool getCheckRate() {
    bool checkRate = true;
    TransferState state = _transferBloc.state;
    if (state.debitAccountDefault?.accountCurrency != 'VND' &&
        state.detailBeneficianAccount?.accountCurrency == 'VND' &&
        _rateBloc.state.getRateDataState != DataState.data) {
      checkRate = false;
    }
    return checkRate;
  }

  Widget _buildContent() {
    return Column(
      children: [
        Expanded(
          child: KeyboardAwareScrollView(
            controller: _contentScrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: kDefaultPadding,
                ),
                ItemInformationAvailable(
                  title: 'VPBank',
                  iconWidget: ImageHelper.loadFromAsset(
                    AssetHelper.icoVpbankOnly,
                  ),
                  caption: AppTranslate.i18n.bankDefaultStr.localized,
                  onPress: () {},
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                MultiBlocListener(
                  listeners: [
                    BlocListener<TransferBloc, TransferState>(
                      listenWhen: (previous, current) =>
                          previous.debitAccountDefault !=
                          current.debitAccountDefault,
                      listener: (context, state) {
                        amountCcy = state.debitAccountDefault?.accountCurrency;
                      },
                    ),
                    BlocListener<TransferBloc, TransferState>(
                      listenWhen: (previous, current) =>
                          previous.detailBeneficianAccountDataState !=
                          current.detailBeneficianAccountDataState,
                      listener: (context, state) {
                        if (state.needGetRate()) {
                          _getTransferRate(state);
                        }
                      },
                    ),
                  ],
                  child: BlocBuilder<TransferBloc, TransferState>(
                    buildWhen: (previous, current) {
                      return (previous.detailBeneficianAccountDataState !=
                              current.detailBeneficianAccountDataState) ||
                          (previous.debitAccountDefault !=
                              current.debitAccountDefault) ||
                          (previous.errorAccountMessage !=
                              current.errorAccountMessage);
                    },
                    builder: (context, state) {
                      return Column(
                        children: [
                          _buildItemAccount(state),
                          itemVerticalLabelValueText(
                            AppTranslate.i18n.titleBeneficiaryNameStr.localized,
                            state.detailBeneficianAccount?.benName,
                          ),
                          _buildCheckBoxSave(state),
                          _buildAmountWidget(state),
                          _buildRateWidget(state),
                          if (state.detailBeneficianAccount?.accountNumber !=
                              null)
                            ItemInputTransfer(
                              maxLength: kMaxLengthAmountContent,
                              regexFormarter: regexRuleTransferContent,
                              // inputType: TextInputType.multiline,
                              onTextChange: (String value) {
                                String value =
                                    detailTransferInputController.text;
                                if (value.contains('\n')) {
                                  value = value.replaceAll('\n', '');
                                  detailTransferInputController.text = value;
                                  setTimeout(() {
                                    detailTransferInputController.selection =
                                        TextSelection.fromPosition(
                                            TextPosition(offset: value.length));
                                  }, 10);
                                }
                              },
                              textEditingController:
                                  detailTransferInputController,
                              label: AppTranslate
                                  .i18n.transferContentStr.localized,
                              hintText:
                                  AppTranslate.i18n.enterInfoStr.localized,
                              focusNode: detailTransferInputFocusNode,
                              // regexFormarter: '[a-z]',
                            ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).viewInsets.bottom,
                ),
              ],
            ),
          ),
        ),
        StreamBuilder<bool>(
          initialData: false,
          stream: _checkBuildDefaultButton.stream,
          builder: (context, snapshot) {
            return (!isKeyboardShowing(context))
                ? DefaultButton(
                    onPress: snapshot.data! ? _onInitTransfer : null,
                    text: AppTranslate.i18n.continueStr.localized.toUpperCase(),
                    height: 45,
                    radius: 32,
                    margin:
                        const EdgeInsets.symmetric(vertical: kDefaultPadding),
                  )
                : Container();
          },
        ),
      ],
    );
  }

  Widget _buildItemAccount(TransferState transferInHouseState) {
    Logger.debug(
        "transferInHouseState.errorMessage ${transferInHouseState.errorAccountMessage}");
    final accountItem = ItemInputTransfer(
      id: inhouse_accountInputKey,
      onTextChange: (String value) {
        if (transferInHouseState.errorAccountMessage != null) {
          _transferBloc.add(
            ClearAccountErrorMessage(),
          );
        }
      },
      showChangeKeyboardType: true,
      listData: TransferManager().inHouseBenLists,
      autoComplete: true,
      label: AppTranslate.i18n.accountNumberStr.localized,
      textEditingController:
          numberAccountInputController ?? TextEditingController(),
      inputType: accountInputType,
      regexFormarter: '[0-9a-zA-Z]',
      errorText: transferInHouseState.errorAccountMessage,
      suffixIcon: SizedBox(
        width: 50,
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (transferInHouseState.isShowLoading)
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 1.0),
              ),
            const Spacer(),
            Touchable(
              onTap: () {
                if (_transferBloc.state.listDebitAccountDataState !=
                    DataState.data) return;
                pushNamed(
                  context,
                  NormalSearchScreen.routeName,
                  arguments: SearchArgument(
                    searchType: SearchType.BEN_LIST,
                    searchCallBack: (value) {
                      if (value != null && value is BeneficiarySavedModel) {
                        numberAccountInputController?.text = value.benAccount!;
                        _transferBloc.add(
                          GetBenAccountDetailEvent(
                            value.benAccount!,
                            isAccountBenFromListSaved: true,
                          ),
                        );
                      }
                    },
                    transferTypeCode:
                        TransferType.TRANSINHOUSE.getTransferTypeCode,
                  ),
                );
              },
              child: ImageHelper.loadFromAsset(
                AssetHelper.icoAccountTransferSaved,
                width: 20.toScreenSize,
                height: 20.toScreenSize,
              ),
            ),
          ],
        ),
      ),
      onResume: (model) {
        BeneficiarySavedModel beneficiarySavedModel =
            model as BeneficiarySavedModel;
        numberAccountInputController?.text =
            beneficiarySavedModel.benAccount ?? '';
        accountFocusNode?.unfocus();
      },
      onCompleted: () {
        final accountTextSearch = numberAccountInputController?.text ?? '';
        if (accountTextSearch.isNotNullAndEmpty) {
          context
              .read<TransferBloc>()
              .add(GetBenAccountDetailEvent(accountTextSearch));
          accountFocusNode?.unfocus();
        }
      },
      focusNode: accountFocusNode,
    );
    accountItem.setListenerAutoCompleteCreated(
      (controller, focusNode) {
        if (controller != numberAccountInputController) {
          numberAccountInputController = controller;
        }
        if (focusNode != accountFocusNode) {
          accountFocusNode = focusNode;
          accountFocusNode?.addListener(
            () {
              if ((accountFocusNode != null &&
                      accountFocusNode?.hasFocus == false) &&
                  (_transferBloc.state.detailBeneficianAccount?.accountNumber ??
                          '') !=
                      numberAccountInputController?.text &&
                  enableGetAccountDetail) {
                context.read<TransferBloc>().add(
                      GetBenAccountDetailEvent(
                        numberAccountInputController?.text ?? '',
                        isAccountBenFromListSaved: false,
                        benBank: (_transferBloc.state.transferType ==
                                TransferType.TRANS247_ACCOUNT
                            ? _transferBloc
                                .state.transfer247.benBank?.bankNapasId
                            : null),
                      ),
                    );
              }
            },
          );
        }
      },
    );
    return accountItem;
  }

  Widget _buildCheckBoxSave(TransferState transferState) {
    if (transferState.detailBeneficianAccount?.accountNumber == null) {
      return const SizedBox();
    }
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          children: [
            if (transferState.detailBeneficianAccount?.benAlias == null)
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    0, kMediumPadding - kDefaultPadding, 0, kMediumPadding),
                child: Touchable(
                  onTap: () {
                    setState(() => checkSaveAccount = !checkSaveAccount);
                  },
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          ImageHelper.loadFromAsset(
                              AssetHelper.icoCheckBoxBlank,
                              width: 20,
                              height: 20),
                          if (checkSaveAccount)
                            ImageHelper.loadFromAsset(AssetHelper.icoCheck,
                                width: 20, height: 20),
                        ],
                      ),
                      const SizedBox(width: kDefaultPadding),
                      Text(AppTranslate.i18n.saveBeneficiaryStr.localized,
                          style: TextStyles.itemText),
                    ],
                  ),
                ),
              ),
            if (checkSaveAccount)
              if (transferState.detailBeneficianAccount?.benAlias == null)
                ItemInputTransfer(
                  regexFormarter: regexRuleTransferContent,
                  enable:
                      transferState.detailBeneficianAccount?.benAlias == null
                          ? true
                          : false,
                  onTextChange: (String value) {},
                  textEditingController: saveNameAccountInputController,
                  label: AppTranslate.i18n.saveRememberNameStr.localized,
                  focusNode: saveNameAccountInputFocusNode,
                )
              else
                itemVerticalLabelValueText(
                  AppTranslate.i18n.saveRememberNameStr.localized,
                  saveNameAccountInputController.text,
                ),
          ],
        );
      },
    );
  }

  void _onInitTransfer() {
    if (getCheckRate() == false) {
      showToast(AppTranslate.i18n.canNotGetRateStr.localized);
      return;
    }

    accountFocusNode?.unfocus();
    amountInputFocusNode.unfocus();
    saveNameAccountInputFocusNode.unfocus();
    detailTransferInputFocusNode.unfocus();
    String amount = amountTransferInputController.text
        .replaceAll(' ', '')
        .replaceAll(',', '');

    widget.onInitTransfer(
        amount: amount,
        memo: removeDiacritics(detailTransferInputController.text),
        checkSaveAccount: checkSaveAccount,
        aliasName: removeDiacritics(saveNameAccountInputController.text),
        amountCcy: _transferBloc.state.needGetRate()
            ? amountCcy
            : _transferBloc.state.debitAccountDefault?.accountCurrency);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      margin: const EdgeInsetsDirectional.only(bottom: kMediumPadding),
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(kDefaultPadding),
        ),
      ),
      child: _buildContent(),
    );
  }

  void _getTransferRate(TransferState state) {
    String amt = amountTransferInputController.text
        .toString()
        .replaceAll(' ', '')
        .replaceAll(',', '');
    double amount = 0;
    try {
      amount = double.parse(amt);
    } catch (e) {}

    _rateBloc.add(
      GetRateEvent(
        fcy: state.debitAccountDefault?.accountCurrency ?? '',
        amountCcy: amountCcy ?? '',
        amount: amount,
        typeCode: TransferType.TRANSINHOUSE.getTransferTypeCode,
      ),
    );
  }

  _buildAmountWidget(TransferState state) {
    if (state.detailBeneficianAccount?.accountNumber != null) {
      return amountItem(
        debitCcy: state.debitAccountDefault?.accountCurrency,
        benCcy: state.detailBeneficianAccount?.accountCurrency,
        selectedCcy: amountCcy,
        controller: amountTransferInputController,
        focusNode: amountInputFocusNode,
        onChangeCcy: (s) {
          amountCcy = s;
          setState(() {});
          _getTransferRate(state);
        },
        dataList: [
          state.debitAccountDefault?.accountCurrency ?? '',
          state.detailBeneficianAccount?.accountCurrency ?? '',
        ],
      );
    }

    return const SizedBox();
  }

  _buildRateWidget(TransferState state) {
    if (state.debitAccountDefault?.accountCurrency != 'VND' &&
        state.detailBeneficianAccount?.accountCurrency == 'VND') {
      return BlocConsumer<TransferRateBloc, TransferRateState>(
        listener: (context, state) {
          _checkBuildDefaultButton.add(_checkBuildDefaultButtonFunction());
        },
        listenWhen: (pre, cur) {
          return pre.getRateDataState != cur.getRateDataState;
        },
        builder: (context, rateState) {
          return ExchangeRateWidget(
            rateState: rateState.getRateDataState,
            rate: rateState.transferRate,
            errRateMsg: rateState.errMsg,
            amount: amountTransferInputController.text,
            selectedAmountCcy: amountCcy,
            isInitTransfer: true,
            margin: const EdgeInsets.only(bottom: 10),
          );
        },
      );
    } else {
      return const SizedBox();
    }
  }
}
