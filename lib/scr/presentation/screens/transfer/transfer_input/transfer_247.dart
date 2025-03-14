part of 'transfer_input_screen.dart';

class Transfer247 extends StatefulWidget {
  const Transfer247({
    Key? key,
    required this.onInitTransfer,
  }) : super(key: key);

  final void Function({
    required String amount,
    required String memo,
    required bool checkSaveAccount,
    String? aliasName,
    DebitAccountModel? chargeAccount,
  }) onInitTransfer;

  @override
  _Transfer247State createState() => _Transfer247State();
}

class _Transfer247State extends State<Transfer247> {
  List<InputItemData> inputs = [];

  TextEditingController amountInputController = TextEditingController();
  TextEditingController contentInputController = TextEditingController();
  TextEditingController? accountInputController = TextEditingController();
  FocusNode contentFocusNode = FocusNode();
  FocusNode amountInputFocusNode = FocusNode();
  FocusNode? accountFocusNode = FocusNode();
  String currentBen = '';

  void init() {
    inputs.addAll(
      [
        InputItemData(
            type: InputItemType.BANK,
            title: AppTranslate.i18n.bankDefaultStr.localized,
            onTap: onItemBankPress),
        InputItemData(
            controller: accountInputController,
            key: InputItemKey.accountNumber,
            type: InputItemType.ACCOUNT,
            title: AppTranslate.i18n.accountNumberStr.localized),
        InputItemData(
            type: InputItemType.TEXT,
            title: AppTranslate.i18n.beneficiaryNameStr.localized),
        InputItemData(
            key: InputItemKey.saveBeneficiary,
            type: InputItemType.SAVE_BEN,
            controller: TextEditingController(),
            focusNode: FocusNode(),
            value: SaveBen(),
            title: AppTranslate.i18n.saveBeneficiaryStr.localized),
        InputItemData(
            controller: amountInputController,
            focusNode: amountInputFocusNode,
            key: InputItemKey.amountNumber,
            type: InputItemType.AMOUNT,
            title: AppTranslate.i18n.transferAmountStr.localized),
        InputItemData(
            onTextChange: (String value) {
              // String value = accountInputController.text;
              // value = value.replaceAll(' ', '');
              // _transferBloc.add(Transfer247ChangeAccountEvent(accountInputController.text));
            },
            key: InputItemKey.amountContent,
            type: InputItemType.FIELD,
            title: AppTranslate.i18n.transferContentStr.localized,
            controller: contentInputController,
            focusNode: contentFocusNode),
        InputItemData(
            onTap: onChangeFeeAccount,
            key: InputItemKey.feeAccount,
            type: InputItemType.FEE_ACCOUNT,
            title: AppTranslate.i18n.feeAccountStr.localized)
      ],
    );
  }

  final StreamController<bool> _checkBuildDefaultButton =
      StreamController<bool>.broadcast();

  late TransferBloc _transferBloc;

  String accountkey = '247AccountKey';
  TextInputType accountInputType = TextInputType.number;

  @override
  void initState() {
    // WidgetsBinding.instance?.addObserver(this);
    super.initState();

    amountInputController.addListener(() {
      _checkBuildDefaultButton.add(_checkBuildDefaultButtonFunction());
    });

    amountInputFocusNode.addListener(() {
      if (amountInputController.text.isNotEmpty) {
        amountInputController.text =
            amountInputController.text.formatToInt.toMoneyFormat;
        for (var element in inputs) {
          if (element.type == InputItemType.AMOUNT) {
            element.value =
                amountInputController.text.formatToInt.toMoneyFormat;
          }
        }
      }
    });

    contentInputController.addListener(() {
      _checkBuildDefaultButton.add(_checkBuildDefaultButtonFunction());
    });

    _transferBloc = BlocProvider.of<TransferBloc>(context);
    init();

    _transferBloc
        .add(ChangeTransfer247TypeEvent(TransferType.TRANS247_ACCOUNT));
    // _transferBloc.add(GetBankListEvent());
    _transferBloc.add(
      GetListDebitAccountEvent(TransferType.TRANS247_ACCOUNT),
    );

    _transferBloc.add(GetBenListEvent(TransferType.TRANS247_ACCOUNT));

    MessageHandler().register(accountkey, onAccountChangeKeyboardType);
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
      Logger.debug('accountFocusNode.requestFocus');
      enableGetAccountDetail = true;
      accountFocusNode?.requestFocus();
    }, 50);
  }

  bool _checkBuildDefaultButtonFunction() {
    double amount = 0;
    try {
      amount = double.parse(
          amountInputController.text.toString().replaceAll(' ', ''));
    } catch (e) {}
    if (amount > 0 &&
        contentInputController.text.isNotEmpty &&
        _transferBloc.state.detailBeneficianAccount?.accountNumber != null) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    super.dispose();
    MessageHandler().unregister(accountkey);
  }

  void onItemBankPress() {
    Logger.debug("onItemBankPress");
    FocusScope.of(context).unfocus();

    pushNamed(
      context,
      NormalSearchScreen.routeName,
      arguments: SearchArgument(
        searchType: SearchType.BANK,
        transferTypeCode: TransferType.TRANS247_ACCOUNT.getTransferTypeCode,
        searchCallBack: (o) {
          BenBankModel benBank = o as BenBankModel;
          Logger.debug("Search CallBack ${benBank.toJson()}");
          _transferBloc.add(
            UpdateTransfer247BankEvent(benBank: benBank),
          );

          //Chuyển ngân hàng nếu đã có stk ở ô nhập thì call lại getDetail tài khoản
          String account = accountInputController?.text ?? '';
          account = account.replaceAll(' ', '');
          if (account.isNotEmpty) {
            Logger.debug("onItemBankPress search ben detail");
            onGetDetailAccountNumber(account, bankNapasId: benBank.bankNapasId);
          }
        },
      ),
    );
  }

  void onChangeFeeAccount() {
    Logger.debug("start");
    _showChangeFeeAccount();
  }

  void getDetailBen(dynamic value) {
    if (value == null) {
      return;
    }

    BeneficiarySavedModel model = value as BeneficiarySavedModel;

    BenBankModel benBankModel = BenBankModel(
        bankNo: model.benBankCode,
        shortName: model.benBankName,
        bankNapasId: model.bankNapasId);

    if (_transferBloc.state.transferType == TransferType.TRANS247_ACCOUNT) {
      _transferBloc.add(
        UpdateTransfer247BankEvent(benBank: benBankModel),
      );
    }

    getDetailAccountNumberFromListSave(model);
  }

  void onGetDetailAccountNumber(String value, {String? bankNapasId}) {
    Logger.debug("start $value");

    if (value.isEmpty) {
      return;
    }

    _transferBloc.add(GetBenAccountDetailEvent(
      value,
      isAccountBenFromListSaved: false,
      benBank: bankNapasId ??
          (_transferBloc.state.transferType == TransferType.TRANS247_ACCOUNT
              ? _transferBloc.state.transfer247.benBank?.bankNapasId
              : null),
    ));
  }

  Future<void> getDetailAccountNumberFromListSave(
      BeneficiarySavedModel beneficiarySavedModel) async {
    Logger.debug("Start ${beneficiarySavedModel.toJson()}");

    _transferBloc.add(GetBenAccountDetailEvent(
        beneficiarySavedModel.benAccount ?? '',
        isAccountBenFromListSaved: true,
        benBank:
            _transferBloc.state.transferType == TransferType.TRANS247_ACCOUNT
                ? beneficiarySavedModel.bankNapasId
                : null,
        oldAliasName: beneficiarySavedModel.benAlias));
  }

  void updateUICallBack(BeneficiarySavedModel model) {
    print('updateUICallBack');
    accountInputController?.text = model.benAccount ?? '';
    getDetailBen(model);
  }

  /// Để xác định nếu chọn ben từ autocomplete rồi thì khi lost focus ko call API nữa
  BeneficiarySavedModel? _autoBen = null;

  Widget _buildItemAccount(TransferState state) {
    String title = '';
    String hint = '';
    if (state.transferType == TransferType.TRANS247_ACCOUNT) {
      title = AppTranslate.i18n.accountNumberStr.localized;
      hint = AppTranslate.i18n.enterAccountNumberStr.localized;
    } else {
      title = AppTranslate.i18n.cardNumberStr.localized;
      hint = AppTranslate.i18n.enterCardNumberStr.localized;
    }

    var accountItem = ItemInputTransfer(
      id: accountkey,
      onTextChange: (String value) {
        if (state.errorAccountMessage != null) {
          _transferBloc.add(
            ClearAccountErrorMessage(),
          );
        }
      },
      showChangeKeyboardType:
          state.transferType == TransferType.TRANS247_ACCOUNT,
      listData: state.transferType == TransferType.TRANS247_ACCOUNT
          ? TransferManager().napasAccountBenLists
          : TransferManager().napasCardBenLists,
      autoComplete: true,
      label: title,
      hintText: hint,
      textEditingController: accountInputController ?? TextEditingController(),
      inputType: state.transferType == TransferType.TRANS247_ACCOUNT
          ? accountInputType
          : TextInputType.number,
      regexFormarter: '[0-9a-zA-Z]',
      errorText: state.errorAccountMessage,
      suffixIcon: SizedBox(
        width: 50,
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (state.isShowLoadingAccount)
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
                        updateUICallBack(value);
                      }
                    },
                    transferTypeCode: state.transferType?.getTransferTypeCode,
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
        _autoBen = model as BeneficiarySavedModel;
      },
      onCompleted: () {
        final accountTextSearch = accountInputController?.text ?? '';
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
        if (focusNode != accountFocusNode) {
          accountFocusNode = focusNode;
          accountFocusNode?.addListener(
            () {
              print('FCUCKKCKCKCKKCKCKCKCKCKCKCK');
              if ((accountFocusNode != null &&
                      accountFocusNode?.hasFocus == false) &&
                  enableGetAccountDetail == true) {
                if (_autoBen != null) {
                  updateUICallBack(_autoBen!);
                  _autoBen = null;
                  return;
                }
                _transferBloc.add(
                  GetBenAccountDetailEvent(
                    accountInputController?.text ?? '',
                    benBank: (_transferBloc.state.transferType ==
                            TransferType.TRANS247_ACCOUNT
                        ? _transferBloc.state.transfer247.benBank?.bankNapasId
                        : null),
                  ),
                );
              }
            },
          );
        }

        if (controller != null) {
          accountInputController = controller;
        }
      },
    );
    return accountItem;
  }

  Widget renderItem(InputItemData input, TransferState state) {
    switch (input.type) {
      case InputItemType.BANK:
        if (state.transferType == TransferType.TRANS247_CARD) {
          return const SizedBox();
        }
        input.value = state.transfer247.benBank;
        return renderBankItem(input);
      case InputItemType.ACCOUNT:
        return _buildItemAccount(state);
      case InputItemType.TEXT:
        if (state.detailBeneficianAccount?.accountNumber == null ||
            (state.detailBeneficianAccount?.benName == null)) {
          return const SizedBox();
        }
        input.value = state.detailBeneficianAccount?.benName ?? '';
        return renderTextItem(input);
      case InputItemType.SAVE_BEN:
        if (state.detailBeneficianAccount?.accountNumber == null) {
          return Container();
        }

        /**
         *  nếu tk thụ hưởng trc đó đã lưu => gán value alias vào tên gợi nhớ
         *  nếu tk thụ hưởng trc đó đã lưu <ben alias # null> => ko show cái checkbox
         */
        SaveBen saveBen = input.value as SaveBen;
        if (state.detailBeneficianAccount?.benAlias != null) {
          saveBen.value = state.detailBeneficianAccount?.benAlias!;
        }

        input.controller?.text = saveBen.value ?? '';
        return renderSaveBenItem(input,
            defaultAliasName: state.detailBeneficianAccount?.benName,
            isShowCheckbox:
                state.detailBeneficianAccount?.benAlias == null ? true : false);
      case InputItemType.AMOUNT:
        if (state.detailBeneficianAccount?.accountNumber == null) {
          return const SizedBox();
        }
        input.hint = AppTranslate.i18n.enterAmountStr.localized;
        return renderAmountItem(
            input, state.debitAccountDefault?.accountCurrency);
      case InputItemType.FIELD:
        //Ko có detail thụ hưởng => ko có nội dung ck
        if (input.key == InputItemKey.amountContent &&
            state.detailBeneficianAccount?.accountNumber == null) {
          return const SizedBox();
        }

        return renderFiledItem(input);

      case InputItemType.FEE_ACCOUNT:
        if (state.debitAccountDefault == null ||
            state.detailBeneficianAccount?.accountNumber == null) {
          return const SizedBox();
        }
        input.value = state.transfer247.feeAccount;
        return renderFeeAccount(input);

      // return Container(color: Colors.red,height: 50,width: double.infinity,);
      default:
        return Container();
    }
  }

  List<Widget> _buildItems(TransferState state) {
    List<Widget> list = [];
    for (int i = 0; i < inputs.length; i++) {
      final input = inputs[i];

      if (input.type == InputItemType.AMOUNT ||
          input.type == InputItemType.FIELD ||
          input.type == InputItemType.ACCOUNT) {
        input.focusNode ??= FocusNode();
        input.controller ??= TextEditingController();
        input.controller!.text = input.value ?? '';

        input.controller!.selection = TextSelection.fromPosition(
          TextPosition(
            offset: input.controller!.text.length,
          ),
        );

        list.add(
          renderItem(input, state),
        );
      } else {
        list.add(renderItem(input, state));
      }
    }
    list.add(const SizedBox(height: kDefaultPadding));
    return list;
  }

  Widget _buildContent(TransferState state) {
    Logger.debug("$state ${MediaQuery.of(context).viewInsets.bottom}");
    // double paddingKeyboard = MediaQuery.of(context).viewInsets.bottom - 45 - 2 * kDefaultPadding;
    // if (paddingKeyboard < 0) paddingKeyboard = 0;
    if (currentBen != state.detailBeneficianAccount?.accountNumber) {
      currentBen = state.detailBeneficianAccount?.accountNumber ?? '';
      for (var element in inputs) {
        if (element.type == InputItemType.SAVE_BEN) {
          SaveBen? _saveBen = element.value as SaveBen?;
          _saveBen?.value = '';
          _saveBen?.isSave = false;
        }
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTabTransfer(state),
        Expanded(
          flex: 1,
          child: KeyboardAwareScrollView(
            // reverse: MediaQuery.of(context).viewInsets.bottom == 0 ? false : true,
            // padding: EdgeInsets.only(bottom: paddingKeyboard),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildItems(state),
            ),
          ),
        ),
        StreamBuilder<bool>(
          initialData: false,
          stream: _checkBuildDefaultButton.stream,
          builder: (context, snapshot) {
            return !isKeyboardShowing(context)
                ? DefaultButton(
                    onPress: snapshot.data! ? _onInitTransfer : null,
                    text: AppTranslate.i18n.continueStr.localized.toUpperCase(),
                    height: 45,
                    radius: 32,
                    margin:
                        const EdgeInsets.only(bottom: kDefaultPadding, top: 1),
                  )
                : const SizedBox();
          },
        ),
      ],
    );
  }

  void _onInitTransfer() {
    amountInputFocusNode.unfocus();
    bool checkSaveAccount = false;
    String? aliasName;

    //nếu Ko phải account lấy từ ds người thụ hưởng ra thì get thông tin save người thu hưởng từ UI
    // if (!checkSaveAccount) {
    for (int i = 0; i < inputs.length; i++) {
      InputItemData element = inputs[i];
      if (element.key == InputItemKey.saveBeneficiary) {
        checkSaveAccount = (element.value as SaveBen).isSave ?? false;
        aliasName = (element.value as SaveBen).value;
      }
    }
    // }

    String amount = amountInputController.text;
    amount = amount.replaceAll(' ', '');
    String memo = contentInputController.text;
    // BenBankModel? benBankModel = _transferBloc.state.transfer247.benBank;
    DebitAccountModel? feeAccount = _transferBloc.state.transfer247.feeAccount;

    BeneficianAccountModel? benAccount =
        _transferBloc.state.detailBeneficianAccount;

    widget.onInitTransfer(
        amount: amount,
        memo: memo,
        checkSaveAccount: checkSaveAccount,
        aliasName: aliasName,
        chargeAccount: feeAccount);
  }

  Widget _buildTabTransfer(TransferState state) {
    return Container(
      height: getInScreenSize(50, max: 50),
      alignment: Alignment.center,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: _buildTabTitle(
                AppTranslate.i18n.toAccountNumberStr.localized,
                state.transferType == TransferType.TRANS247_ACCOUNT,
                TransferType.TRANS247_ACCOUNT),
          ),
          Expanded(
            flex: 1,
            child: _buildTabTitle(
                AppTranslate.i18n.toCardNumberStr.localized,
                state.transferType == TransferType.TRANS247_CARD,
                TransferType.TRANS247_CARD),
          ),
        ],
      ),
    );
  }

  Widget _buildTabTitle(
      String title, bool isSelected, TransferType transferType) {
    return Touchable(
      onTap: () {
        Logger.debug("Click $transferType");
        _transferBloc.add(ChangeTransfer247TypeEvent(transferType));
        hideKeyboard(context);
        // setTimeout(() {
        //   String account = accountInputController.text;
        //   account = account.replaceAll(' ', '');
        //   if (account.isNotEmpty) {
        //     onGetDetailAccountNumber(account);
        //   }
        // }, 300);
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title,
            style: isSelected
                ? TextStyles.headerText.tabSelctedColor
                : TextStyles.headerText.tabUnSelctedColor,
          ),
          const SizedBox(
            height: 3,
          ),
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            width: double.infinity,
            height: 2,
            color: isSelected ? kColorTabIndicator : Colors.transparent,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransferBloc, TransferState>(
      listenWhen: (previous, current) =>
          previous.detailBeneficianAccountDataState !=
          current.detailBeneficianAccountDataState,
      listener: (context, state) {
        //Nếu đang load thì ko cho load nữa
        if (state.detailBeneficianAccountDataState == DataState.preload) {
          enableGetAccountDetail = false;
        } else {
          enableGetAccountDetail = true;
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        margin: const EdgeInsetsDirectional.only(bottom: kMediumPadding),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(kDefaultPadding),
          ),
        ),
        child: BlocBuilder<TransferBloc, TransferState>(
          builder: (context, state) => _buildContent(state),
        ),
      ),
    );
  }

  void _showChangeFeeAccount() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: SizeConfig.screenHeight / 2,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(kDefaultPadding),
                topRight: Radius.circular(kDefaultPadding),
              ),
            ),
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: kTopPadding),
            child: ListView.builder(
              itemCount: _transferBloc.state.listDebitAccount!.length,
              itemBuilder: (context, index) {
                final item = _transferBloc.state.listDebitAccount![index];
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: kBorderSide,
                    ),
                  ),
                  padding: const EdgeInsets.only(
                      top: kDefaultPadding, bottom: kTopPadding),
                  child: AccountInfoItem(
                    prefixIcon: AssetHelper.icoWallet,
                    workingBalance: item.availableBalance
                            ?.toInt()
                            .toString()
                            .toMoneyFormat ??
                        '0',
                    accountCurrency: item.accountCurrency,
                    accountNumber: item.getSubtitle(),
                    isLastIndex: true,
                    icon: item.accountNumber ==
                            _transferBloc
                                .state.transfer247.feeAccount?.accountNumber
                        ? AssetHelper.icoCheck
                        : null,
                    margin: EdgeInsets.zero,
                    onPress: () {
                      Navigator.of(context).pop();
                      _transferBloc.add(
                          Change247FeeAccountEvent(debitAccountModel: item));
                    },
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
