part of 'transfer_input_screen.dart';

class TransferInterbank extends StatefulWidget {
  const TransferInterbank({
    Key? key,
    required this.onInitTransfer,
  }) : super(key: key);

  static const String routeName = '/transfer_interbank';

  final void Function({
    required String city,
    required String cityName,
    required String branch,
    required String branchName,
    required String accountName,
    required String accountNumber,
    required String bankCode,
    required String amount,
    required String memo,
    required String outBenFee,
    required bool checkSaveAccount,
    String? aliasName,
    DebitAccountModel? chargeAccount,
    String? amountCcy,
    String? benCcy,
  }) onInitTransfer;

  @override
  _TransferInterbankState createState() => _TransferInterbankState();
}

class _TransferInterbankState extends State<TransferInterbank> {
  List<InputItemData> inputs = [];
  final StateHandler _stateHandler = StateHandler(TransferInterbank.routeName);
  final StreamController<bool> _checkBuildDefaultButton =
      StreamController<bool>.broadcast();
  late TransferBloc _transferBloc;
  late TransferRateBloc _rateBloc;

  TextEditingController beneficiaryNameInputController =
      TextEditingController();
  TextEditingController cityNameInputController = TextEditingController();
  TextEditingController? accountInputController = TextEditingController();
  TextEditingController amountInputController = TextEditingController();
  TextEditingController feeTypeInputController = TextEditingController();
  TextEditingController memoInputController = TextEditingController();
  TextEditingController feeAccountInputController = TextEditingController();

  FocusNode beneficiaryNameFocusNode = FocusNode();
  final FocusNode amountInputFocusNode = FocusNode();

  String accountkey = 'internet_account_key';
  TextInputType accountInputType = TextInputType.number;
  FocusNode? accountFocusNode = FocusNode();

  void initData() {
    inputs.addAll([
      InputItemData(
          title: AppTranslate.i18n.titleBankStr.localized,
          type: InputItemType.BANK,
          onTap: onChangeBank),
      InputItemData(
          key: InputItemKey.locationInterbank,
          title: AppTranslate.i18n.pickBankPlaceStr.localized,
          type: InputItemType.TEXT_CHOICE,
          onTap: onChangeLocation),
      InputItemData(
          key: InputItemKey.branchInterbank,
          title: AppTranslate.i18n.tasTdBenBranchStr.localized,
          type: InputItemType.TEXT_CHOICE,
          onTap: onChangeBranch),
      InputItemData(
          key: InputItemKey.accountNumber,
          // controller: accountInputController,
          title: AppTranslate.i18n.accountNumberStr.localized,
          type: InputItemType.ACCOUNT,
          onSuffixIconClick: onSuffixBenListPress,
          onTextChange: onChangeAccountNumber,
          focusNode: accountFocusNode),
      InputItemData(
          key: InputItemKey.beneficiaryName,
          controller: beneficiaryNameInputController,
          title: AppTranslate.i18n.titleBeneficiaryNameStr.localized,
          type: InputItemType.FIELD,
          onTextChange: onChangeBeneficiaryName,
          focusNode: beneficiaryNameFocusNode),
      InputItemData(
          key: InputItemKey.saveBeneficiary,
          title: AppTranslate.i18n.saveBeneficiaryStr.localized,
          type: InputItemType.SAVE_BEN,
          value: SaveBen(),
          focusNode: FocusNode(),
          controller: TextEditingController()),
      InputItemData(
          key: InputItemKey.amountNumber,
          focusNode: amountInputFocusNode,
          controller: amountInputController,
          title: AppTranslate.i18n.transferAmountStr.localized,
          type: InputItemType.AMOUNT),
      InputItemData(key: '', type: InputItemType.RATE, title: ''),
      InputItemData(
          key: InputItemKey.feeType,
          title: AppTranslate.i18n.feeTypeStr.localized,
          type: InputItemType.TEXT_CHOICE,
          onTap: onChangeFeeType),
      InputItemData(
          key: InputItemKey.amountContent,
          controller: memoInputController,
          title: AppTranslate.i18n.descriptionTransferStr.localized,
          type: InputItemType.FIELD),
      InputItemData(
          key: InputItemKey.feeAccount,
          title: AppTranslate.i18n.feeAccountStr.localized,
          type: InputItemType.FEE_ACCOUNT,
          onTap: onChangeFeeAccount),
    ]);
  }

  bool _checkBuildDefaultButtonFunction() {
    if (amountInputController.text.isNotEmpty &&
        beneficiaryNameInputController.text.isNotEmpty &&
        memoInputController.text.isNotEmpty &&
        (accountInputController?.text.isNotNullAndEmpty ?? false) &&
        _transferBloc.state.transferInterbankState.cityModel != null) {
      double amount = 0;
      try {
        amount = double.parse(
            amountInputController.text.toString().replaceAll(' ', ''));
      } catch (e) {}
      if (amount > 0) {
        return true;
      }
      return false;
    }
    return false;
  }

  void onChangeBank() {
    Navigator.of(context).pushNamed(NormalSearchScreen.routeName,
        arguments: SearchArgument(
            searchCallBack: (args) {
              BenBankModel benBankModel = args as BenBankModel;
              Logger.debug("Search Callback ${benBankModel.toJson()}");
              _transferBloc
                  .add(UpdateTransferInterbankEvent(benBank: benBankModel));
              FocusManager.instance.primaryFocus?.unfocus();
            },
            searchType: SearchType.BANK));
  }

  void _onInitTransfer() {
    amountInputFocusNode.unfocus();
    bool checkSaveAccount = false;
    String? aliasName;
    String amount = amountInputController.text;
    amount = amount.replaceAll(' ', '');
    String memo = memoInputController.text;
    for (var element in inputs) {
      if (element.key == InputItemKey.saveBeneficiary) {
        checkSaveAccount = (element.value as SaveBen).isSave ?? false;
        aliasName = (element.value as SaveBen).value;
      }
    }
    DebitAccountModel? feeAccount =
        _transferBloc.state.transferInterbankState.feeAccount;
    CityModel? cityModel = _transferBloc.state.transferInterbankState.cityModel;
    BranchModel? branchModel =
        _transferBloc.state.transferInterbankState.branchModel;
    String feeType =
        _transferBloc.state.transferInterbankState.baseItemModel?.fee ?? 'OUR';

    widget.onInitTransfer(
        amount: amount,
        city: cityModel?.cityCode ?? '',
        cityName: cityModel?.cityName ?? '',
        branch: branchModel?.branchCode ?? '',
        branchName: branchModel?.branchName ?? '',
        accountNumber: accountInputController?.text ?? '',
        bankCode:
            _transferBloc.state.transferInterbankState.benBank?.bankNo ?? '',
        accountName: beneficiaryNameInputController.text,
        memo: memo,
        checkSaveAccount: checkSaveAccount,
        aliasName: aliasName,
        outBenFee: feeType,
        chargeAccount: feeType == 'OUR' ? feeAccount : null,
        amountCcy: 'VND',
        benCcy: _transferBloc.state.transferInterbankState.saveBen?.benCcy);
  }

  void onChangeBeneficiaryName(String value) {
    _transferBloc
        .add(ChangeInterbankBeneficiaryNameEvent(beneficiaryName: value));
  }

  void onChangeLocation() {
    Navigator.of(context).pushNamed(NormalSearchScreen.routeName,
        arguments: SearchArgument(
            searchCallBack: (args) {
              FocusManager.instance.primaryFocus?.unfocus();
              CityModel cityModel = args as CityModel;
              _transferBloc
                  .add(ChangeInterbankLocationEvent(cityModel: cityModel));
              inputs.forEach((element) {
                if (element.key == InputItemKey.branchInterbank) {
                  element.isEnable = true;
                }
                if (element.key == InputItemKey.locationInterbank) {
                  element.isInlineLoading = true;
                  _transferBloc.add(
                    SearchBranchListInterbankEvent(
                      bankCode: _transferBloc
                              .state.transferInterbankState.benBank?.bankNo ??
                          '',
                      cityCode: cityModel.cityCode ?? '',
                    ),
                  );
                }
              });
            },
            searchType: SearchType.BANK_PLACE));
  }

  void onChangeBranch() {
    Navigator.of(context).pushNamed(NormalSearchScreen.routeName,
        arguments: SearchArgument(
            searchCallBack: (args) {
              FocusManager.instance.primaryFocus?.unfocus();
              BranchModel branchModel = args as BranchModel;
              _transferBloc
                  .add(ChangeInterbankBranchEvent(branchModel: branchModel));
            },
            bankCode:
                _transferBloc.state.transferInterbankState.benBank?.bankNo,
            cityCode:
                _transferBloc.state.transferInterbankState.cityModel?.cityCode,
            searchType: SearchType.BRANCH_LIST));
  }

  void onSuffixBenListPress() {
    FocusScope.of(context).unfocus();
    Navigator.of(context).pushNamed(NormalSearchScreen.routeName,
        arguments: SearchArgument(
            searchCallBack: (value) {
              FocusManager.instance.primaryFocus?.unfocus();
              if (value == null) {
                return;
              }
              amountInputController.text = '';
              memoInputController.text = '';

              BeneficiarySavedModel model = value as BeneficiarySavedModel;
              Logger.debug('${model.toJson()}');
              //Update account cho filed account
              updateUICallBack(model);
            },
            transferTypeCode:
                _transferBloc.state.transferType?.getTransferTypeCode,
            searchType: SearchType.BEN_LIST));
  }

  void updateUICallBack(BeneficiarySavedModel model) {
    BenBankModel benBankModel = BenBankModel(
        bankNo: model.benBankCode,
        shortName: model.benBankName,
        bankNapasId: model.bankNapasId);
    if (_transferBloc.state.transferType == TransferType.TRANSINTERBANK) {
      _transferBloc.add(
        UpdateTransferInterbankEvent(benBank: benBankModel),
      );
    }
    inputs.forEach((element) {
      context.read<TransferBloc>().add(
          ChangeInterbankAccountNumberEvent(accountNumber: model.benAccount));
      if (element.type == InputItemType.ACCOUNT) {
        element.value = model.benAccount;
      } else if (element.type == InputItemType.BANK &&
          model.benBankCode != null) {
        element.isEnable = false;
      } else if (element.key == InputItemKey.locationInterbank &&
          model.benCity != null) {
        element.isEnable = false;
        CityModel cityModel =
            CityModel(cityCode: model.benCity, cityName: model.benCityName);
        _transferBloc.add(ChangeInterbankLocationEvent(cityModel: cityModel));
      } else if (element.key == InputItemKey.branchInterbank &&
          model.benBranch != null) {
        element.isEnable = false;
        BranchModel branchModel = BranchModel(
            branchCode: model.benBranch, branchName: model.benBranchName);
        _transferBloc.add(ChangeInterbankBranchEvent(
          branchModel: (model.benBranch.isNullOrEmpty ||
                  model.benBranchName.isNullOrEmpty)
              ? null
              : branchModel,
        ));
        if (model.benBranch.isNullOrEmpty ||
            model.benBranchName.isNullOrEmpty) {
          _transferBloc.add(UpdateListBranchEvent());
        }
      } else if (element.key == InputItemKey.amountNumber ||
          element.key == InputItemKey.amountContent) {
        element.value = '';
      } else if (element.key == InputItemKey.beneficiaryName &&
          model.benName != null) {
        _transferBloc.add(ChangeInterbankBeneficiaryNameEvent(
            beneficiaryName: model.benName));
        element.value = model.benName?.toUpperCase();
        element.isEnable = false;
      } else if (element.key == InputItemKey.saveBeneficiary &&
          model.benAlias != null) {
        element.isEnable = false;
        SaveBen saveBen = SaveBen();
        saveBen.value = model.benAlias ?? '';
        saveBen.benCcy = model.benCcy;
        _transferBloc.add(UpdateInterbankSaveBenEvent(saveBen: saveBen));
      }
    });
  }
  void onChangeAccountNumber(String value) {
    if (value.isEmpty ||
        _transferBloc.state.transferInterbankState.accountNumber == null) {
      return;
    }
    amountInputController.text = '';
    memoInputController.text = '';
    inputs.forEach((element) {
      element.isEnable = true;
      if (element.key == InputItemKey.amountNumber ||
          element.key == InputItemKey.amountContent ||
          element.key == InputItemKey.beneficiaryName) {
        element.value = '';
      } else if (element.key == InputItemKey.saveBeneficiary) {
        element.value = SaveBen();
        element.controller!.text = '';
      }
    });
    context
        .read<TransferBloc>()
        .add(ChangeInterbankAccountNumberEvent(accountNumber: value));
  }

  void onChangeFeeType() {
    FocusManager.instance.primaryFocus?.unfocus();
    TransferManager().showChangeFeeType(context, _transferBloc);
  }

  void onChangeFeeAccount() {
    FocusManager.instance.primaryFocus?.unfocus();
    TransferManager().showChangeFeeAccount(context, _transferBloc);
  }

  void checkEnableWidget(InputItemData input, TransferState state) {}

  @override
  void initState() {
    super.initState();
    accountInputController?.addListener(() {
      _checkBuildDefaultButton.add(_checkBuildDefaultButtonFunction());
    });

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

      TransferState state = _transferBloc.state;
      if (amountInputFocusNode.hasFocus == false && state.needGetRate()) {
        _getTransferRate(_transferBloc.state);
      }
    });

    memoInputController.addListener(() {
      _checkBuildDefaultButton.add(_checkBuildDefaultButtonFunction());
    });

    beneficiaryNameInputController.addListener(() {
      _checkBuildDefaultButton.add(_checkBuildDefaultButtonFunction());
    });

    initData();

    _rateBloc = BlocProvider.of<TransferRateBloc>(context);
    _transferBloc = BlocProvider.of<TransferBloc>(context);
    _transferBloc
        .add(ChangeTransferInterbankTypeEvent(TransferType.TRANSINTERBANK));
    // _transferBloc.add(GetBankListEvent());
    _transferBloc.add(
      GetListDebitAccountEvent(
        TransferType.TRANSINTERBANK,
      ),
    );
    _transferBloc.add(GetBenListInterBankEvent(transferTypeOfCode: 1));
    TransferManager().initFeeType(_transferBloc);

    MessageHandler().register(TransferInputScreen.eventChangeDebitAccount, () {
      setTimeout(() {
        if (_transferBloc.state.needGetRate()) {
          _getTransferRate(_transferBloc.state);
        }
      }, 50);
    });
    MessageHandler().register(accountkey, onAccountChangeKeyboardType);
  }

  @override
  void dispose() {
    super.dispose();

    MessageHandler().unregister(TransferInputScreen.eventChangeDebitAccount);
    MessageHandler().unregister(accountkey);
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
      enableGetAccountDetail = true;
      accountFocusNode?.requestFocus();
    }, 50);
  }

  void _getTransferRate(TransferState state) {
    String amt = amountInputController.text
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
        amountCcy: 'VND',
        amount: amount,
        typeCode: TransferType.TRANSINHOUSE.getTransferTypeCode,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransferBloc, TransferState>(
      listenWhen: (previous, current) =>
          previous.isShowLoading != current.isShowLoading,
      listener: (context, state) {},
      child: Container(
        padding: const EdgeInsets.only(
            left: kDefaultPadding,
            right: kDefaultPadding,
            top: kDefaultPadding),
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

  Widget _buildItemAccount(TransferState state) {
    final accountItem = ItemInputTransfer(
      id: accountkey,
      onTextChange: (String value) {
        if (state.errorAccountMessage != null) {
          _transferBloc.add(
            ClearAccountErrorMessage(),
          );
        }
      },
      showChangeKeyboardType: true,
      listData: state.transferInterbankState.listBenModel,
      autoComplete: true,
      label: AppTranslate.i18n.accountNumberStr.localized,
      textEditingController: accountInputController ?? TextEditingController(),
      inputType: accountInputType,
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
                        accountInputController?.text = value.benAccount!;
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
        BeneficiarySavedModel beneficiarySavedModel =
            model as BeneficiarySavedModel;
        accountInputController?.text = beneficiarySavedModel.benAccount ?? '';
        accountFocusNode?.unfocus();
        updateUICallBack(beneficiarySavedModel);
      },
      onCompleted: () {
        accountFocusNode?.unfocus();
      },
      focusNode: accountFocusNode,
    );
    accountItem.setListenerAutoCompleteCreated(
      (controller, focusNode) {
        if (controller != accountInputController) {
          accountInputController = controller;
        }
        if (focusNode != accountFocusNode) {
          accountFocusNode = focusNode;
          // accountFocusNode?.addListener(() {
          //   if ((accountFocusNode != null &&
          //           accountFocusNode?.hasFocus == false) &&
          //       (_transferBloc.state.detailBeneficianAccount?.accountNumber ??
          //               '') !=
          //           accountInputController?.text &&
          //       enableGetAccountDetail == true) {
          //     context.read<TransferBloc>().add(
          //         GetBenAccountDetailEvent(accountInputController?.text ?? ''));
          //   }
          // });
        }
      },
    );
    return accountItem;
  }

  Widget renderItem(InputItemData input, TransferState state) {
    switch (input.type) {
      case InputItemType.BANK:
        input.value = state.transferInterbankState.benBank;
        return renderBankItem(input);
      case InputItemType.TEXT_CHOICE:
        if (input.key == InputItemKey.locationInterbank &&
            state.transferInterbankState.cityModel != null) {
          input.isInlineLoading = state.isShowLoadingBranch;
          input.value = state.transferInterbankState.cityModel?.cityName;
        } else if (input.key == InputItemKey.locationInterbank) {
          input.value = AppTranslate.i18n.titleSelectCityStr.localized;
        }
        if (input.key == InputItemKey.branchInterbank &&
            state.transferInterbankState.branchModel != null) {
          input.value = state.transferInterbankState.branchModel?.branchName;
        } else if (input.key == InputItemKey.branchInterbank &&
            ((state.transferInterbankState.listBranch?.isEmpty ?? false) ||
                state.transferInterbankState.listBranch == null ||
                state.transferInterbankState.cityModel == null)) {
          input.value = null;
        } else if (input.key == InputItemKey.branchInterbank) {
          input.value = AppTranslate.i18n.titleSelectBrachStr.localized;
        }

        if (input.key == InputItemKey.feeType &&
            state.transferInterbankState.baseItemModel != null) {
          input.value = state.transferInterbankState.baseItemModel?.title;
        }
        return renderTextChoiceItem(input);
      case InputItemType.ACCOUNT:
        return _buildItemAccount(state);
      // return renderAccountAutoItem(
      //     accountkey,
      //     input,
      //     AssetHelper.icoAccountTransferSaved,
      //     state.transferInterbankState.listBenModel,
      //     inputType: accountInputType,
      //     callBack: (BeneficiarySavedModel data) {
      //   updateUICallBack(data);
      // }, onCreated: (controller) {
      //   if (controller != null) {
      //     accountInputController = controller;
      //   }
      // });
      // return renderAccountItem(input, AssetHelper.icoAccountTransferSaved);
      case InputItemType.TEXT:
        return renderTextItem(input);
      case InputItemType.SAVE_BEN:
        SaveBen? saveBen = state.transferInterbankState.saveBen;
        if (saveBen == null) {
          input.isEnable = true;
        } else {
          input.controller?.text = saveBen.value ?? "";
        }
        return renderSaveBenInterbankItem(input);
      case InputItemType.AMOUNT:
        input.hint = AppTranslate.i18n.enterAmountStr.localized;
        return renderAmountItem(input, 'VND');
      case InputItemType.FIELD:
        if (input.key == InputItemKey.beneficiaryName &&
            state.transferInterbankState.beneficiaryName != null) {
          input.isUppercase = true;
          return renderFiledItem(input, isUppercase: true);
        }
        return renderFiledItem(input);
      case InputItemType.FEE_ACCOUNT:
        input.value = state.transferInterbankState.baseItemModel?.fee == 'OUR'
            ? state.transferInterbankState.feeAccount
            : null;
        return renderFeeAccount(input);
      default:
        return Container();
    }
  }

  List<Widget> _buildItems(TransferState state) {
    List<Widget> list = [];
    for (var input in inputs) {
      if (input.type == InputItemType.RATE) {
        list.add(_buildRateWidget(state));
        continue;
      }
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
      }
      list.add(renderItem(input, state));
    }
    return list;
  }

  Widget _buildContent(TransferState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: KeyboardAwareScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildItems(state),
          ),
        )),
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
                        const EdgeInsets.symmetric(vertical: kDefaultPadding),
                  )
                : const SizedBox();
          },
        ),
      ],
    );
  }

  _buildRateWidget(TransferState state) {
    if (state.debitAccountDefault?.accountCurrency != 'VND') {
      return BlocBuilder<TransferRateBloc, TransferRateState>(
        builder: (context, rateState) {
          return ExchangeRateWidget(
            rateState: rateState.getRateDataState,
            rate: rateState.transferRate,
            errRateMsg: rateState.errMsg,
            amount: amountInputController.text,
            selectedAmountCcy: 'VND',
            isInitTransfer: true,
            margin: const EdgeInsets.only(bottom: kDefaultPadding),
          );
        },
      );
    } else {
      return const SizedBox();
    }
  }
}
