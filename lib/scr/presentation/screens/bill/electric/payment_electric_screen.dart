import 'dart:async';

import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/bill/bill_bloc.dart';
import 'package:b2b/scr/bloc/bill/electric/payment_electric_bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/extensions/extensions.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/bill/bill_init_request_data.dart';
import 'package:b2b/scr/data/model/bill/bill_provider.dart';
import 'package:b2b/scr/data/model/bill/bill_saved.dart';
import 'package:b2b/scr/presentation/screens/bill/electric/electric_confirm_payment_screen.dart';
import 'package:b2b/scr/presentation/screens/bill/electric/electric_item_widget.dart';
import 'package:b2b/scr/presentation/screens/bill/electric/electric_payment_option_widget.dart';
import 'package:b2b/scr/presentation/screens/bill/electric/search_bill_screen.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/buttons.dart';
import 'package:b2b/scr/presentation/widgets/item_account_service/account_info_item.dart';
import 'package:b2b/scr/presentation/widgets/item_input_transfer.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/logger.dart';
import '../../../../data/model/bill/bill_info.dart';
import '../../../widgets/dialog_widget.dart';
import '../../../widgets/keyboard_aware_scroll_view.dart';
import '../../../widgets/touchable.dart';
import 'package:diacritic/diacritic.dart';

class PaymentElectricScreen extends StatefulWidget {
  static String routeName = '/PaymentElectricScreen';
  static String keyBillProvider = 'keyBillProvider';
  static String keyBillSaved = 'keyBillSaved';

  const PaymentElectricScreen({Key? key}) : super(key: key);

  @override
  _PaymentElectricScreenState createState() => _PaymentElectricScreenState();
}

class _PaymentElectricScreenState extends State<PaymentElectricScreen> {
  late PaymentElectricBloc _bloc;
  TextEditingController accountController = TextEditingController();
  TextEditingController aliasBillController = TextEditingController();

  FocusNode accountFocusNode = FocusNode();

  BillProvider? billProvider;
  BillSaved? billSaved;

  // Ds các kỳ dc chọn để thanh toán
  List<BillInfoBillList?>? listSelectedBillInfoList;

  final StreamController<bool> _checkBuildDefaultButton =
      StreamController<bool>.broadcast();

  bool _checkBuildDefaultButtonFunction() {
    int count = 0;
    listSelectedBillInfoList?.forEach((element) {
      if (element?.isSelected == true) {
        count++;
      }
    });
    if (count == 0) {
      return false;
    }
    return true;
  }

  late BillBloc _billBloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PaymentElectricBloc>(context)
      ..add(
        PaymentElectricInitEvent(),
      );

    _billBloc = BlocProvider.of<BillBloc>(context);

    if (!(accountFocusNode.hasListeners)) {
      accountFocusNode.addListener(
        () {
          if (accountFocusNode.hasFocus == false) {
            _checkBillSaved();
            getBillInfo();
          }
        },
      );
    }

    WidgetsBinding.instance?.addPostFrameCallback(
      (timeStamp) {
        var args = getArguments(context) as Map<String, dynamic>;
        if (args[PaymentElectricScreen.keyBillProvider] is BillProvider) {
          billProvider =
              args[PaymentElectricScreen.keyBillProvider] as BillProvider;
          _bloc.setBillProvider(billProvider);
        }
        if (args[PaymentElectricScreen.keyBillSaved] is BillSaved) {
          billSaved = args[PaymentElectricScreen.keyBillSaved];
          billProvider = BillProvider(
              serviceCode: billSaved?.serviceCode,
              providerCode: billSaved?.providerCode,
              providerName: billSaved?.providerName);
          _bloc.setBillProvider(billProvider);
          accountController.text = billSaved?.customerCode ?? '';
          getBillInfo();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: AppTranslate.i18n.electricStr.localized.toUpperCase(),
      isShowKeyboardDoneButton: true,
      appBarType: AppBarType.SEMI_MEDIUM,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      onBack: () {
        Navigator.of(context).pop();
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<PaymentElectricBloc, PaymentElectricState>(
            listener: (c, s) {
              if (s.getBillInfoDataState == DataState.error) {
                showDialogErrorForceGoBack(
                  context,
                  s.getDebitErrMsg ?? '',
                  () {
                    popScreen(context);
                  },
                );
              }
            },
            listenWhen: (pre, cur) {
              return pre.debitDataState != cur.debitDataState;
            },
          ),
          BlocListener<PaymentElectricBloc, PaymentElectricState>(
            listener: (c, s) {
              if (s.initBillDataState == DataState.preload) {
                showLoading();
              } else {
                hideLoading();
                if (s.initBillDataState == DataState.error) {
                  showDialogErrorForceGoBack(
                    context,
                    s.initBillErrMsg ?? '',
                    () {},
                  );
                } else if (s.initBillDataState == DataState.data) {
                  pushNamed(context, ElectricConfirmPaymentScreen.routeName);
                }
              }
            },
            listenWhen: (pre, cur) {
              return pre.initBillDataState != cur.initBillDataState;
            },
          ),
          BlocListener<PaymentElectricBloc, PaymentElectricState>(
            listener: (c, s) {
              if (s.getBillInfoDataState == DataState.error) {
                showDialogErrorForceGoBack(
                  context,
                  s.getBillInfoErrMsg ?? '',
                  () {},
                );
              }
            },
            listenWhen: (pre, cur) {
              return pre.getBillInfoDataState != cur.getBillInfoDataState;
            },
          ),
        ],
        child: BlocConsumer<PaymentElectricBloc, PaymentElectricState>(
          listenWhen: (pre, cur) {
            return pre.debitDataState != cur.debitDataState;
          },
          listener: (context, state) {
            if (state.debitDataState == DataState.error) {
              showDialogErrorForceGoBack(
                context,
                state.getDebitErrMsg ?? '',
                () {
                  popScreen(context);
                },
              );
            }
          },
          builder: (context, state) {
            return Container(
              color: Colors.transparent,
              width: double.infinity,
              margin: const EdgeInsets.only(
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                  bottom: kDefaultPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: kDefaultPadding.toScreenSize,
                  ),
                  Expanded(
                    flex: 1,
                    child:
                        BlocConsumer<PaymentElectricBloc, PaymentElectricState>(
                      listener: (c, s) {},
                      builder: (context, state) {
                        return _buildContent(state);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildContent(PaymentElectricState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          AppTranslate.i18n.transferToAccountTitleSourceAccountStr.localized,
          style: TextStyles.headerText.whiteColor.bold,
        ),
        const SizedBox(
          height: kDefaultPadding,
        ),
        _buildDebitAccount(state),
        SizedBox(
          height: 32.toScreenSize,
        ),
        Row(
          children: [
            ImageHelper.loadFromAsset(AssetHelper.icoAlert),
            const SizedBox(width: 16),
            Text(
              AppTranslate.i18n.paymentInfoStr.localized,
              style: TextStyles.headerText.blackColor.semibold,
            ),
          ],
        ),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ItemInputTransfer(
                          label: AppTranslate.i18n.customerIdStr.localized,
                          hintText:
                              AppTranslate.i18n.customerInfoHintStr.localized,
                          textEditingController: accountController,
                          focusNode: accountFocusNode,
                          regexFormarter: '[a-zA-Z0-9 .+-,/|_()]',
                          suffixIcon: SizedBox(
                            width: 50,
                            height: 20,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (state.getBillInfoDataState ==
                                    DataState.preload)
                                  const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 1.0),
                                  ),
                                const Spacer(),
                                Touchable(
                                  onTap: () {
                                    pushNamed(
                                      context,
                                      SearchBillScreen.routeName,
                                      arguments: (data) {
                                        if (data is BillSaved) {
                                          billSaved = data;
                                          billProvider = BillProvider(
                                              serviceCode:
                                                  billSaved?.serviceCode,
                                              providerCode:
                                                  billSaved?.providerCode,
                                              providerName:
                                                  billSaved?.providerName);
                                          _bloc.setBillProvider(billProvider);
                                          accountController.text =
                                              billSaved?.customerCode ?? '';
                                          getBillInfo();
                                        }
                                      },
                                    );
                                  },
                                  child: ImageHelper.loadFromAsset(
                                    AssetHelper.icBill,
                                    width: 20.toScreenSize,
                                    height: 20.toScreenSize,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          onTextChange: (s) {
                            billSaved = null;
                            if (state.getBillInfoDataState == DataState.data ||
                                state.getBillInfoDataState == DataState.error) {
                              _bloc.add(ClearBillInfoEvent());
                            }
                          },
                          onCompleted: () {
                            hideKeyboard(context);
                            _checkBillSaved();

                            getBillInfo();
                          },
                        ),
                        _itemElectricManufacture(),
                        if (state.getBillInfoDataState == DataState.data)
                          ..._buildInfo(state),
                        const SizedBox(
                          height: 10,
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
                            onPress: snapshot.data! ? initPayment : null,
                            text: AppTranslate.i18n.continueStr.localized
                                .toUpperCase(),
                            height: 45,
                            radius: 32,
                          )
                        : Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool saveBill = false;

  _saveBill() {
    return Column(
      children: [
        Row(
          children: [
            StatefulBuilder(
              builder: (c, s) {
                return TouchableRipple(
                  onPressed: () {
                    s(() => saveBill = !saveBill);
                  },
                  child: Stack(
                    children: [
                      ImageHelper.loadFromAsset(AssetHelper.icoCheckBoxBlank,
                          width: 20, height: 20),
                      if (saveBill)
                        ImageHelper.loadFromAsset(AssetHelper.icoCheck,
                            width: 20, height: 20),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(
              width: 12,
            ),
            Text(
              AppTranslate.i18n.saveBillStr.localized,
              style: TextStyles.itemText,
            ),
          ],
        ),
      ],
    );
  }

  _buildDebitAccount(PaymentElectricState state) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        boxShadow: const [kBoxShadow],
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(kDefaultPadding.toScreenSize),
        ),
      ),
      child: AccountInfoItem(
        margin: EdgeInsets.zero,
        showShimmer: state.debitDataState == DataState.preload,
        workingBalance: state.selectedDebitAccount?.availableBalance
                ?.toInt()
                .toString()
                .toMoneyFormat ??
            '',
        accountCurrency: state.selectedDebitAccount?.accountCurrency,
        accountNumber: state.selectedDebitAccount?.getSubtitle() ?? '',
        isLastIndex: true,
        icon: AssetHelper.icArrowDown,
        prefixIcon: AssetHelper.icoWallet,
        onPress: () {
          _showBottomModalChangeDebitAccount(state);
        },
      ),
    );
  }

  void _showBottomModalChangeDebitAccount(PaymentElectricState state) {
    if (state.listDebitAccount != null && state.listDebitAccount!.isNotEmpty) {
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
                      itemCount: state.listDebitAccount!.length,
                      itemBuilder: (context, index) {
                        final item = state.listDebitAccount![index];
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
                                    state.selectedDebitAccount?.accountNumber
                                ? AssetHelper.icoCheck
                                : null,
                            margin: EdgeInsets.zero,
                            onPress: () {
                              Navigator.of(context).pop();
                              _bloc.add(ChangeDebitAccountEvent(item));
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

  _itemElectricManufacture() {
    return ElectricItemWidget(
      title: AppTranslate.i18n.billProviderStr.localized,
      content: Row(
        children: [
          ImageHelper.loadFromAsset(AssetHelper.electricHcm,
              width: 24, height: 24),
          const SizedBox(
            width: kDefaultPadding,
          ),
          Text(
            AppTranslate.i18n.hcmElectricStr.localized,
            style: TextStyles.itemText.semibold.copyWith(
              color: const Color(0xff22313F),
            ),
          ),
        ],
      ),
    );
  }

  void initPayment() {
    // pushNamed(context, ElectricConfirmPaymentScreen.routeName);

    List<String?> listBillId = [];
    List<BillInfoBillList?> dataList = [];

    //Check dk phải chọn kỳ xa hơn trc
    bool enable = true;
    for (int i = 0; i < (listSelectedBillInfoList?.length ?? 0); i++) {
      if (listSelectedBillInfoList?[i]?.isSelected == true) {
        for (int j = i + 1; j < (listSelectedBillInfoList?.length ?? 0); j++) {
          if (listSelectedBillInfoList?[j]?.isSelected != true) {
            enable = false;
            break;
          }
        }
      }
    }
    if (enable == false) {
      showDialogErrorForceGoBack(
          context, AppTranslate.i18n.paymentNoticeStr.localized, () {});
      return;
    }

    double amount = 0;

    listSelectedBillInfoList?.forEach(
      (element) {
        if (element?.isSelected == true) {
          listBillId.add(element?.billId);
          dataList.add(element);
          amount += element?.billAmt ?? 0;
        }
      },
    );

    _bloc.setSelectedBillList(dataList);
    _bloc.setCustomerCode(accountController.text);
    _bloc.setBillProvider(billProvider);
    PaymentElectricState state = _bloc.state;

    BillInitRequestData requestData = BillInitRequestData(
        debitAccount: state.selectedDebitAccount?.accountNumber,
        serviceCode: BillType.DIEN.getServiceCode(),
        providerCode: billProvider?.providerCode,
        customerCode: accountController.text,
        listOrder: listBillId,
        saveBill: saveBill,
        totalAmount: amount);
    _bloc.add(
      BillInitEvent(requestData),
    );
  }

  void getBillInfo() {
    String customerCode = accountController.text;
    if (customerCode.isNotNullAndEmpty) {
      _bloc.add(
        GetBillInfo(BillType.DIEN.getServiceCode(),
            billProvider?.providerCode ?? '', customerCode),
      );
    }
  }

  _buildInfo(PaymentElectricState state) {
    return [
      ElectricItemWidget(
        title: AppTranslate.i18n.customerNameStr.localized,
        content: Text(
          state.billInfo?.cusInfo?.cusName ?? '',
          style: TextStyles.itemText.medium,
        ),
      ),
      ElectricItemWidget(
        title: AppTranslate.i18n.addressStr.localized,
        content: Text(
          state.billInfo?.cusInfo?.cusAddr ?? '',
          style: TextStyles.itemText.medium,
        ),
      ),
      if (billSaved == null) _saveBill(),
      ElectricPaymentOption(
        billInfo: state.billInfo,
        callBack: (data) {
          listSelectedBillInfoList = data;
          _checkBuildDefaultButton.add(_checkBuildDefaultButtonFunction());
        },
      ),
    ];
  }

  void _checkBillSaved() {
    try {
      billSaved = _billBloc.state.listBillSaved?.firstWhere((element) {
        return element.customerCode?.toLowerCase() ==
            accountController.text.toLowerCase();
      });
    } catch (e) {}
  }
}
