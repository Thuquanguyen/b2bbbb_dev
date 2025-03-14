import 'dart:async';

import 'package:b2b/commons.dart';
import 'package:b2b/scr/bloc/bloc.dart';
import 'package:b2b/scr/bloc/card/payment_card/payment_card_bloc.dart';
import 'package:b2b/scr/bloc/card/payment_card/payment_card_event.dart';
import 'package:b2b/scr/bloc/card/payment_card/payment_card_state.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/data/model/card/benefit_contract.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/data/model/transfer/amount_info.dart';
import 'package:b2b/scr/data/model/transfer/init_transfer_model.dart';
import 'package:b2b/scr/data/repository/card_repository.dart';
import 'package:b2b/scr/presentation/screens/cards/card_list/card_list_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/card_list/item_card_view.dart';
import 'package:b2b/scr/presentation/screens/cards/card_list/item_contract_view.dart';
import 'package:b2b/scr/presentation/screens/cards/payment/payment_card_confirm_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/payment/payment_card_result_screen.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:b2b/scr/presentation/screens/transfer/transfer_input/transfer_manager.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/item_account_service/account_info_item.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/input_item_data.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../constants.dart';
import '../card_manager.dart';
import 'amount_frame.dart';

class PaymentCardScreen extends StatefulWidget {
  const PaymentCardScreen({Key? key}) : super(key: key);

  static String routeName = 'PaymentCardScreen';

  @override
  _PaymentCardScreenState createState() => _PaymentCardScreenState();
}

class _PaymentCardScreenState extends State<PaymentCardScreen> {
  late PaymentCardBloc _bloc;
  TextEditingController amountController = TextEditingController();
  late InputItemData amountInputData;
  final StreamController<bool> _checkBuildDefaultButton =
      StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();

    _bloc = PaymentCardBloc(
      CardRepository(
        RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
      ),
    );

    _bloc.add(PaymentCardInitEvent());

    WidgetsBinding.instance?.addPostFrameCallback(
      (timeStamp) {
        CardModel? cardModel = getArguments(context) as CardModel?;
        _bloc.add(ChangeSelectedCardEvent(cardModel));
        _bloc.add(GetCardContractListEvent(cardModel));
      },
    );

    initAmountInput();
  }

  void removePaymentSelected() {
    _bloc.add(
      PaymentCardChangeStatusEvent(isMinPay: true, isSelected: false),
    );
    _bloc.add(
      PaymentCardChangeStatusEvent(isMinPay: false, isSelected: false),
    );
  }

  @override
  void dispose() {
    super.dispose();
    amountController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  void initAmountInput() {
    amountInputData = InputItemData(
        controller: amountController,
        focusNode: FocusNode(),
        key: InputItemKey.amountNumber,
        type: InputItemType.AMOUNT,
        title: AppTranslate.i18n.transferAmountStr.localized);

    amountController.addListener(() {
      if (amountController.text.isNullOrEmpty) {
        removePaymentSelected();
      }
      try {
        double value = double.parse(amountController.text.replaceAll(' ', ''));
        if (value > 0 && _bloc.state.selectedCardModel != null) {
          if (_bloc.state.selectedCardModel is BenefitContract &&
              _bloc.state.contractInfoDataState != DataState.data) {
            _checkBuildDefaultButton.add(false);
          } else {
            _checkBuildDefaultButton.add(true);
          }
        } else {
          _checkBuildDefaultButton.add(false);
        }
        // CardModel? cardModel = _bloc.state.selectedCardModel;
        // if (value >= (cardModel?.minPaymentCard ?? 0) &&
        //     value > 0 &&
        //     _bloc.state.selectedCardModel != null) {
        //   _checkBuildDefaultButton.add(true);
        // } else {
        //   _checkBuildDefaultButton.add(false);
        // }
        // if (value != cardModel?.minPaymentCard) {
        //   _bloc.add(
        //     PaymentCardChangeStatusEvent(isMinPay: true, isSelected: false),
        //   );
        // }
        // if (value != cardModel?.fullPaymentCard) {
        //   _bloc.add(
        //     PaymentCardChangeStatusEvent(isMinPay: false, isSelected: false),
        //   );
        // }
      } catch (e) {
        _checkBuildDefaultButton.add(false);
        removePaymentSelected();
      }
    });
  }

  bool isShowingDialogErrorForceGoBack = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PaymentCardBloc>(
      create: (context) => _bloc,
      child: AppBarContainer(
        title: AppTranslate.i18n.cardPaymentCreditCardStr.localized,
        isShowKeyboardDoneButton: true,
        appBarType: AppBarType.SEMI_MEDIUM,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        onBack: () {
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
              Expanded(
                child: MultiBlocListener(
                  listeners: [
                    BlocListener<PaymentCardBloc, PaymentCardState>(
                      listenWhen: (pre, curr) {
                        return pre.debitDataState != curr.debitDataState ||
                            pre.cardContractDataState !=
                                curr.cardContractDataState;
                      },
                      listener: (context, state) {
                        if (state.debitDataState == DataState.error) {
                          isShowingDialogErrorForceGoBack = true;
                          showDialogErrorForceGoBack(
                            context,
                            (state.errorMessage ?? ''),
                            () {
                              isShowingDialogErrorForceGoBack = false;
                              Navigator.of(context).pop();
                            },
                            barrierDismissible: false,
                          );
                        }
                      },
                    ),
                    BlocListener<PaymentCardBloc, PaymentCardState>(
                      listenWhen: (pre, curr) {
                        return pre.contractInfoDataState !=
                            curr.contractInfoDataState;
                      },
                      listener: (context, state) {
                        if (state.contractInfoDataState == DataState.error) {
                          isShowingDialogErrorForceGoBack = true;
                          showDialogErrorForceGoBack(
                            context,
                            (state.errorMessage ?? ''),
                            () {
                              isShowingDialogErrorForceGoBack = false;
                            },
                            barrierDismissible: false,
                          );
                        } else if (state.contractInfoDataState ==
                            DataState.data) {
                          amountController.text =
                              '${state.contractInfo?.fullPaymentContract?.toInt() ?? ''}'
                                  .toMoneyFormat;
                        }
                      },
                    ),
                    BlocListener<PaymentCardBloc, PaymentCardState>(
                      listenWhen: (previous, current) {
                        return previous.initPaymentDataState !=
                            current.initPaymentDataState;
                      },
                      listener: (context, state) {
                        try {
                          if (DataState.preload == state.initPaymentDataState) {
                            showLoading();
                            return;
                          } else if (state.initPaymentDataState ==
                              DataState.error) {
                            hideLoading();
                            showDialogErrorForceGoBack(
                                context, (state.errorMessage ?? ''), () {});
                            return;
                          } else if (state.initPaymentDataState ==
                              DataState.data) {
                            hideLoading();

                            InitTransferModel? initModel =
                                state.initTransferModel;

                            Navigator.of(context).pushNamed(
                              PaymentCardConfirmScreen.routeName,
                              arguments: ConfirmPaymentArgument(
                                initTransferModel: initModel,
                                debitAccount: state.selectedDebitAccount,
                                card: state.selectedCardModel,
                                callBack: () {
                                  _bloc.add(PaymentCardConfirmEvent());
                                },
                              ),
                            );
                          }
                        } catch (e) {
                          Logger.error('Exception $e');
                        }
                      },
                    ),
                    BlocListener<PaymentCardBloc, PaymentCardState>(
                      listenWhen: (previous, current) =>
                          previous.confirmPaymentDataState !=
                          current.confirmPaymentDataState,
                      listener: (context, state) {
                        try {
                          if (state.confirmPaymentDataState ==
                              DataState.preload) {
                            showLoading();
                            return;
                          } else if (state.confirmPaymentDataState ==
                              DataState.error) {
                            print('asdasdaasd');
                            showDialogErrorForceGoBack(
                                context, (state.errorMessage ?? ''), () {});
                            hideLoading();
                            return;
                          } else if (state.confirmPaymentDataState ==
                              DataState.data) {
                            hideLoading();
                            _navigatorToOTPScreen();
                          }
                        } catch (e) {
                          Logger.debug('object');
                        }
                      },
                    ),
                  ],
                  child: _buildContent(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildContent() {
    return BlocBuilder<PaymentCardBloc, PaymentCardState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.all(kDefaultPadding),
              decoration: BoxDecoration(
                boxShadow: const [kBoxShadow],
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(kDefaultPadding.toScreenSize),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTranslate.i18n.accountPaymentStr.localized,
                    style: TextStyles.smallText,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  AccountInfoItem(
                    margin: EdgeInsets.zero,
                    showShimmer: state.debitDataState == DataState.preload,
                    workingBalance: state.selectedDebitAccount?.availableBalance
                            ?.toInt()
                            .toString()
                            .toMoneyFormat ??
                        '',
                    accountCurrency:
                        state.selectedDebitAccount?.accountCurrency,
                    accountNumber:
                        state.selectedDebitAccount?.getSubtitle() ?? '',
                    isLastIndex: true,
                    icon: AssetHelper.icArrowDown,
                    prefixIcon: AssetHelper.icoWallet,
                    onPress: () {
                      _showBottomModalChangeDebitAccount();
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    AppTranslate.i18n.destinationCardStr.localized,
                    style: TextStyles.smallText,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  _buildCardContent(state)
                ],
              ),
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            amountFrame(state, amountInputData, _checkBuildDefaultButton,
                amountController, _bloc, _onInitPayment),
          ],
        );
      },
    );
  }

  void _onInitPayment() {
    try {
      double value = double.parse(amountController.text.replaceAll(' ', ''));
      String id = "";
      if (_bloc.state.selectedCardModel is CardModel) {
        id = (_bloc.state.selectedCardModel as CardModel).cardId ?? "";
      } else if (_bloc.state.selectedCardModel is BenefitContract) {
        id =
            (_bloc.state.selectedCardModel as BenefitContract).contractId ?? "";
      }
      _bloc.add(
        InitPaymentCardEvent(
          amountInfo: AmountInfo(
              amount: value,
              currency:
                  _bloc.state.selectedDebitAccount?.accountCurrency ?? 'VND'),
          cardId: id,
          debitAccountModel: _bloc.state.selectedDebitAccount,
        ),
      );
    } catch (e) {}
  }

  void _showBottomModalChangeDebitAccount() {
    CardManager().showDebitAccountBottomModal(_bloc, _bloc.state, context);
  }

  void showChangeCardBottomModal(PaymentCardState state) {
    List<dynamic> cardDataList = [];
    cardDataList.addAll(state.cardContractListResponse?.contract ?? []);
    cardDataList.addAll(state.cardContractListResponse?.card ?? []);
    String? id = "";
    if (state.selectedCardModel is CardModel) {
      id = (state.selectedCardModel as CardModel).cardId;
    } else {
      id = (state.selectedCardModel as BenefitContract).contractId;
    }
    CardManager().showCardListBottomModal(
        context: context,
        callBack: onChangeSelectedCard,
        cardList: cardDataList,
        selectedCard: state.selectedCardModel,
        selectedID: id,
        title: AppTranslate.i18n.pickPaymentCardStr.localized);
  }

  _buildCardContent(PaymentCardState state) {
    if (state.selectedCardModel is BenefitContract) {
      return ItemContractView(
        benefitContract: state.selectedCardModel as BenefitContract,
        rightIcon: AssetHelper.icArrowDown,
        onPress: () {
          showChangeCardBottomModal(state);
        },
        margin: EdgeInsets.zero,
      );
    }
    return ItemCardView(
      isShimmer: state.cardContractDataState == DataState.preload,
      onPress: () {
        showChangeCardBottomModal(state);
      },
      margin: EdgeInsets.zero,
      cardCompanyName: state.selectedCardModel?.comMainName,
      cardName: state.selectedCardModel?.clientName,
      cardDes:
          '${state.selectedCardModel?.cardType} | ${state.selectedCardModel?.getLastCardNumber()}',
      canExpand: true,
      cardModel: state.selectedCardModel,
      isNull: state.selectedCardModel == null,
    );
  }

  void onChangeSelectedCard(dynamic cardModel) {
    _bloc.add(ChangeSelectedCardEvent(cardModel));
    if (cardModel is BenefitContract) {
      _bloc.add(GetContractInfo(contractId: cardModel.contractId));
    } else {
      amountController.clear();
    }
  }

  void _navigatorToOTPScreen() {
    final state = _bloc.state;
    final args = VerifyMadeFundOTPArgs(
      transCode: state.initTransferModel?.transcode ?? '',
      secureTrans: state.initTransferModel?.sercureTrans ?? '',
      verifyOtpDisplayType:
          state.confirmPaymentModel?.verifyOtpDisplayType ?? -1,
      transferTypeCode: TransferType.CARD.getTransferTypeCode,
      message: state.confirmPaymentModel?.message,
    );
    SmartOTPManager().verifyOTP(
      context,
      args,
      onResult: (isSuccess, data) {
        if (isSuccess == true) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            PaymentCardResultScreen.routeName,
            (route) => route.settings.name == CardListScreen.routeName,
            arguments: _bloc,
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
}
