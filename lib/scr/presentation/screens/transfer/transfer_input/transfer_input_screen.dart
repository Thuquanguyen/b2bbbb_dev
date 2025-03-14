import 'dart:async';

import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/transfer/rate/transfer_rate_bloc.dart';
import 'package:b2b/scr/bloc/transfer/transfer_bloc.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/argument/search_argument.dart';
import 'package:b2b/scr/core/routes/argument/transfer_screen_argument.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/data/model/search/ben_bank_model.dart';
import 'package:b2b/scr/data/model/search/beneficiary_saved_model.dart';
import 'package:b2b/scr/data/model/search/branch_model.dart';
import 'package:b2b/scr/data/model/search/city_model.dart';
import 'package:b2b/scr/data/model/transfer/amount_info.dart';
import 'package:b2b/scr/data/model/transfer/benefician_account_model.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/data/model/transfer/init_transfer_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/screens/confirm_infomation/confirm_information_screen.dart';
import 'package:b2b/scr/presentation/screens/normal_search_screen.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:b2b/scr/presentation/screens/transfer/confirm_transfer_screen.dart';
import 'package:b2b/scr/presentation/screens/transfer/transfer_input/save_ben.dart';
import 'package:b2b/scr/presentation/screens/transfer/transfer_input/transfer_inhouse_amount_item.dart';
import 'package:b2b/scr/presentation/screens/transfer/transfer_input/transfer_manager.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/item_account_service/account_info_item.dart';
import 'package:b2b/scr/presentation/widgets/item_infomation_available.dart';
import 'package:b2b/scr/presentation/widgets/item_input_transfer.dart';
import 'package:b2b/scr/presentation/widgets/item_vertical_title_value.dart';
import 'package:b2b/scr/presentation/widgets/keyboard_aware_scroll_view.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/input_item_data.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/text_formatter.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../constants.dart';
import '../../../../../utilities/message_handler.dart';
import '../../../widgets/render_input_item.dart';
import '../transfer_result.dart';
import '../transfer_screen.dart';
import 'extrange_rate_widget.dart';

part 'transfer_247.dart';

part 'transfer_in_house.dart';

part 'transfer_interbank.dart';

class TransferInputScreen extends StatefulWidget {
  static const String routeName = '/transfer_input_screen';

  static String eventChangeDebitAccount = 'EventChangeDebitAccount';

  const TransferInputScreen({Key? key, required this.transferType})
      : super(key: key);

  final TransferType transferType;

  @override
  _TransferInputScreenState createState() =>
      _TransferInputScreenState(transferType);
}

class _TransferInputScreenState extends State<TransferInputScreen> {
  TransferType transferType;

  _TransferInputScreenState(this.transferType);

  late TransferBloc _transferBloc;
  late TransferRateBloc _rateBloc;

  @override
  void initState() {
    super.initState();

    _transferBloc = BlocProvider.of<TransferBloc>(context);
    _rateBloc = BlocProvider.of<TransferRateBloc>(context)
      ..add(ClearTransferRateStateEvent());
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = getArguments(context) as TransferScreenArgument;
    return AppBarContainer(
      title: args.title,
      isShowKeyboardDoneButton: true,
      appBarType: AppBarType.SEMI_MEDIUM,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      onBack: () {
        _transferBloc.add(ClearTransferStateEvent());
        Navigator.of(context).pop();
      },
      child: Container(
        color: Colors.transparent,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: kDefaultPadding.toScreenSize,
            ),
            Text(
              AppTranslate
                  .i18n.transferToAccountTitleSourceAccountStr.localized,
              style: TextStyles.headerText.whiteColor.bold,
            ),
            SizedBox(
              height: kDefaultPadding.toScreenSize,
            ),
            MultiBlocListener(
              listeners: [
                BlocListener<TransferBloc, TransferState>(
                  listenWhen: (previous, current) =>
                      previous.confirmTransferModelDataState !=
                      current.confirmTransferModelDataState,
                  listener: (context, state) {
                    try {
                      if (state.confirmTransferModelDataState ==
                          DataState.preload) {
                        showLoading();
                        return;
                      } else if (state.confirmTransferModelDataState ==
                          DataState.error) {
                        showDialogErrorForceGoBack(
                            context, (state.errorMessage ?? ''), () {});
                        hideLoading();
                        return;
                      } else if (state.confirmTransferModelDataState ==
                          DataState.data) {
                        hideLoading();
                        _navigatorToOTPScreen();
                      }
                    } catch (e) {
                      Logger.debug('object');
                    }
                  },
                ),
                BlocListener<TransferBloc, TransferState>(
                  listenWhen: (previous, current) {
                    return previous.initTransferModelDataState !=
                        current.initTransferModelDataState;
                  },
                  listener: (context, state) {
                    try {
                      if (DataState.preload ==
                          state.initTransferModelDataState) {
                        showLoading();
                        return;
                      } else if (state.initTransferModelDataState ==
                          DataState.error) {
                        showDialogErrorForceGoBack(
                            context, (state.errorMessage ?? ''), () {});
                        hideLoading();
                        return;
                      } else if (state.initTransferModelDataState ==
                          DataState.data) {
                        hideLoading();

                        InitTransferModel? initModel = state.initTransferModel;
                        if (state.transferType ==
                                TransferType.TRANS247_ACCOUNT ||
                            state.transferType == TransferType.TRANS247_CARD ||
                            state.transferType == TransferType.TRANSINTERBANK) {
                          _navigateToConfirmScreen(initModel, state);

                          return;
                        }
                        _navigatorToConfirmTransfer(
                          iconBank: AssetHelper.icoVpbankOnly,
                          amountCcy: state.initTransferModel?.amountCcy,
                          chargeCcy: state.initTransferModel?.chargeCcy,
                          benName: state.initTransferModel?.benName,
                          textAmount: state.initTransferModel?.amountSpell
                              ?.localization(),
                          // TODO: uncheck ben bank
                          accountBenNumber:
                              state.initTransferModel?.getSubTitle(),
                          accountDebitNumber:
                              state.debitAccountDefault?.getSubtitle(),

                          workingBalance: state
                              .debitAccountDefault?.availableBalance
                              ?.toInt()
                              .toString()
                              .toMoneyFormat,
                          amountTransfer:
                              CurrencyInputFormatter.formatCcyString(
                                  state.initTransferModel?.amount.toString() ??
                                      '',
                                  ccy: state.initTransferModel?.amountCcy,
                                  removeDecimal: true),
                          memoTransfer: state.initTransferModel?.memo,
                        );
                      }
                    } catch (e) {
                      Logger.debug('object');
                    }
                  },
                ),
                BlocListener<TransferBloc, TransferState>(
                  listenWhen: (previous, current) {
                    return previous.isShowLoading != current.isShowLoading &&
                        previous.listDebitAccountDataState !=
                            current.listDebitAccountDataState;
                  },
                  listener: (context, state) {
                    if (state.listDebitAccountDataState == DataState.error) {
                      showDialogErrorForceGoBack(
                        context,
                        (state.errorMessage ?? ''),
                        () {
                          _transferBloc.add(ClearTransferStateEvent());
                          Navigator.of(context).pop();
                        },
                        barrierDismissible: false,
                      );
                    }
                  },
                ),
              ],
              child: BlocBuilder<TransferBloc, TransferState>(
                buildWhen: (previous, current) {
                  return previous.isShowLoading != current.isShowLoading &&
                      previous.listDebitAccountDataState !=
                          current.listDebitAccountDataState;
                },
                builder: (context, state) {
                  return Container(
                    height: (40 + kDefaultPadding * 2),
                    decoration: BoxDecoration(
                      boxShadow: const [kBoxShadow],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(kDefaultPadding.toScreenSize),
                      ),
                    ),
                    child: AccountInfoItem(
                      // workingBalance: state.debitAccountDefault?.accountNumber,
                      // accountCurrency: state.debitAccountDefault?.accountCurrency,
                      showShimmer: state.isShowLoading,
                      workingBalance: state
                              .debitAccountDefault?.availableBalance
                              ?.toInt()
                              .toString()
                              .toMoneyFormat ??
                          '',
                      accountCurrency:
                          state.debitAccountDefault?.accountCurrency,
                      accountNumber:
                          state.debitAccountDefault?.getSubtitle() ?? '',
                      isLastIndex: true,
                      icon: AssetHelper.icoDropDown,
                      prefixIcon: AssetHelper.icoWallet,
                      onPress: () {
                        _showBottomModal();
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: 32.toScreenSize,
            ),
            Row(
              children: [
                SvgPicture.asset(AssetHelper.icoAlert),
                const SizedBox(width: 16),
                Text(
                  AppTranslate.i18n.beneficiaryInfoStr.localized,
                  style: TextStyles.headerText.blackColor.semibold,
                ),
              ],
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            Expanded(
              child: _buildContent(),
            ),
          ],
        ),
      ),
    );
  }

  void _showBottomModal() {
    if (_transferBloc.state.listDebitAccount != null &&
        _transferBloc.state.listDebitAccount!.isNotEmpty) {
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
              child: Column(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: kDefaultPadding),
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: kBorderSide,
                      ),
                    ),
                    child: Text(
                      AppTranslate.i18n.chooseSourceAccountStr.localized,
                      style: TextStyles.headerText.inputTextColor,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _transferBloc.state.listDebitAccount!.length,
                      itemBuilder: (context, index) {
                        final item =
                            _transferBloc.state.listDebitAccount![index];
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
                            icon: index == 0 ? AssetHelper.icoCheck : null,
                            margin: EdgeInsets.zero,
                            onPress: () {
                              Navigator.of(context).pop();
                              _transferBloc.add(ChangeDebitAccountEvent(item));
                              MessageHandler().notify(
                                  TransferInputScreen.eventChangeDebitAccount);
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }

  void _onInitTransfer({
    String? city,
    String? cityName,
    String? branch,
    String? branchName,
    String? accountName,
    String? accountNumber,
    String? bankCode,
    String? outBenFee,
    required final String amount,
    required final String memo,
    required final bool checkSaveAccount,
    String? aliasName,
    String? benBank,
    DebitAccountModel? chargeAccount,
    String? amountCcy, // ccy tài nhận tiền.
    String? benCcy,
  }) {
    try {
      _transferBloc.add(
        InitTransferEvent(
            AmountInfo(
              amount: double.parse(amount),
              currency: amountCcy ??
                  _transferBloc.state.debitAccountDefault!.accountCurrency!,
            ),
            checkSaveAccount,
            aliasName,
            memo,
            chargeAccount: chargeAccount,
            city: city,
            branch: branch,
            accountName: accountName,
            accountNumber: accountNumber,
            bankCode: bankCode,
            cityName: cityName,
            branchName: branchName,
            outBenFee: outBenFee,
            benCcy: benCcy),
      );
    } catch (e) {
      Logger.debug("ERROR $e");
    }
  }

  // Function(VerifyOTPArgs? data)? onResend;

  void _navigatorToOTPScreen() {
    final transferState = _transferBloc.state;
    final args = VerifyMadeFundOTPArgs(
      transCode: transferState.initTransferModel?.transcode ?? '',
      secureTrans: transferState.initTransferModel?.sercureTrans ?? '',
      verifyOtpDisplayType:
          transferState.confirmTransferModel?.verifyOtpDisplayType ?? -1,
      transferTypeCode: _transferBloc.state.transferType!.getTransferTypeCode,
      message: transferState.confirmTransferModel?.message,
    );
    SmartOTPManager().verifyOTP(
      context,
      args,
      onResult: (isSuccess, data) {
        if (isSuccess == true) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            TransferResultScreen.routeName,
            (route) => route.settings.name == TransferScreen.routeName,
            arguments: _transferBloc,
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
                    Navigator.of(context).pop();
                  },
                ),
              );
            } else {
              Navigator.of(context).pop();
            }
          }
        }
      },
    );
  }

  void _navigatorToConfirmTransfer({
    final String? iconBank,
    final String? benBankName = 'VPBank',
    final String? accountBenNumber,
    final String? accountDebitNumber,
    final String? amountTransfer,
    final String? memoTransfer,
    final String? benName,
    final String? amountCcy,
    final String? chargeCcy,
    final String? workingBalance,
    final String? textAmount,
  }) {
    TransferState state = _transferBloc.state;

    Navigator.of(context).pushNamed(
      ConfirmInformationScreen.routeName,
      // (route) => route.settings.name == TransferScreen.routeName,
      arguments: ConfirmInformationScreen(
        title: AppTranslate.i18n.otpConfirmInformationStr.localized,
        widgetChild: ContainerItem(
          listItem: [
            SizedBox(
              height: kDefaultPadding.toScreenSize,
            ),
            TitleItem(
              title: AppTranslate
                  .i18n.transferToAccountTitleSourceAccountStr.localized,
            ),
            AccountInfoItem(
              workingBalance: workingBalance,
              accountCurrency: chargeCcy,
              accountNumber: accountDebitNumber,
              isLastIndex: true,
              prefixIcon: AssetHelper.icoWallet,
              margin: const EdgeInsets.symmetric(vertical: kTopPadding),
            ),
            TitleItem(
              title: AppTranslate.i18n
                  .transferToAccountTitleBeneficiaryInformationStr.localized,
            ),
            BeneficiaryBankItem(
              titleHeader: benBankName,
              iconHeader: AssetHelper.icoVpbankOnly,
              titleContent: benName,
              subTitleContent: accountBenNumber,
            ),
            AmountItem(
              title: AppTranslate.i18n.dataHardCoreCountMoneyStr.localized,
              subTitle: amountTransfer,
              unit: amountCcy,
            ),
            if (textAmount != null)
              InfomationItem(
                title: AppTranslate.i18n.numberOfMoneyStr.localized,
                subTitle: textAmount.toTitleCase(),
              ),
            if (_rateBloc.state.getRateDataState == DataState.data &&
                state.needGetRate())
              ExchangeRateWidget(
                rateState: _rateBloc.state.getRateDataState,
                rate: _rateBloc.state.transferRate,
                amount: amountTransfer,
                selectedAmountCcy: amountCcy,
                isInitTransfer: true,
              ),
            if (_rateBloc.state.getRateDataState == DataState.data &&
                state.needGetRate())
              const SizedBox(
                height: 10,
              ),
            InfomationItem(
              title: AppTranslate.i18n.descriptionTransferStr.localized,
              subTitle: memoTransfer,
            ),
          ],
          callBack: () {
            _transferBloc.add(ConfirmTransferEvent());
          },
        ),
      ),
    );
  }

  _buildContent() {
    if (transferType == TransferType.TRANSINHOUSE) {
      return TransferInHouse(
        onInitTransfer: _onInitTransfer,
      );
    } else if (transferType == TransferType.TRANS247_ACCOUNT ||
        transferType == TransferType.TRANS247_CARD) {
      return Transfer247(
        onInitTransfer: _onInitTransfer,
      );
    } else {
      return TransferInterbank(
        onInitTransfer: _onInitTransfer,
      );
    }
  }

  void _navigateToConfirmScreen(
      InitTransferModel? initModel, TransferState state) {
    String iconBank = '';
    if (state.transferType == TransferType.TRANSINTERBANK) {
      iconBank =
          "assets/icons/bank_logo/ic_bank_${_transferBloc.state.transferInterbankState.benBank?.bankNo}.png";
    } else {
      iconBank = (initModel?.benBankCode != null &&
              initModel!.benBankCode!.isNotEmpty)
          ? "assets/icons/bank_logo/ic_bank_${initModel.benBankCode}.png"
          : "assets/icons/bank_logo/ic_bank_${_transferBloc.state.transfer247.benBank?.bankNo}.png";
    }

    DebitAccountModel? debitAccount = _transferBloc.state.debitAccountDefault;
    DebitAccountModel? chargeAccount;
    if (initModel?.chargeAcc != null) {
      chargeAccount = DebitAccountModel(
          accountNumber: initModel?.chargeAcc,
          accountCurrency: initModel?.chargeCcy);
    }

    String benAccount = '';

    if (state.transferType == TransferType.TRANS247_ACCOUNT) {
      benAccount =
          '${state.transfer247.benBank?.shortName} - ${state.detailBeneficianAccount?.accountNumber}';
    } else if (state.transferType == TransferType.TRANS247_CARD) {
      benAccount = _transferBloc.state.initTransferModel
              ?.getSubTitle(isCardNumber: true) ??
          '';
    } else if (state.transferType == TransferType.TRANSINTERBANK) {
      benAccount =
          '${state.transferInterbankState.benBank?.shortName} - ${initModel?.benAcc}';
    }

    String vatFeeAmount = '';
    double feeAmountDouble = initModel?.vatFeeAmount ?? 0;
    if (feeAmountDouble == 0) {
      vatFeeAmount = AppTranslate.i18n.freeAmountStr.localized;
    } else {
      String ccy = initModel?.ourBenFee ?? 'OUR';
      vatFeeAmount = TransactionManage().formatCurrency(
          feeAmountDouble,
          ccy == 'OUR'
              ? (chargeAccount?.accountCurrency ?? 'VND')
              : (initModel?.chargeCcy ?? 'VND'));
    }

    Navigator.of(context).pushNamed(
      ConfirmTransferScreen.routeName,
      arguments: ConfirmTransferArgument(
        title: AppTranslate.i18n.otpConfirmInformationStr.localized,
        amount: initModel?.amount?.toInt().toString().toMoneyFormat ?? '',
        memo: initModel?.memo ?? '',
        benName: initModel?.benName ?? '',
        textAmount: initModel?.amountSpell?.localization(),
        benBankName: initModel?.benBankName ??
            _transferBloc.state.transfer247.benBank?.shortName,
        callBack: () {
          _transferBloc.add(ConfirmTransferEvent());
        },
        benBankIcon: iconBank,
        vatFeeAmount: vatFeeAmount,
        amountCcy: initModel?.amountCcy ?? '',
        chargeCcy: initModel?.chargeCcy ??
            _transferBloc.state.transfer247.feeAccount?.accountCurrency,
        benAccount: benAccount,
        benCcy: initModel?.benCcy,
        transferType: state.transferType,
        debitAccount: debitAccount,
        ourBenFee: initModel?.ourBenFee,
        cityName: initModel?.benCityName,
        branchName: initModel?.benBranchName,
        chargeAccount:
            chargeAccount ?? _transferBloc.state.transfer247.feeAccount,
      ),
    );
  }
}
