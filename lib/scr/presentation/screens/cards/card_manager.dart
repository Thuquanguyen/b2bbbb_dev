import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/card/payment_card/payment_card_bloc.dart';
import 'package:b2b/scr/bloc/card/payment_card/payment_card_event.dart';
import 'package:b2b/scr/bloc/card/payment_card/payment_card_state.dart';
import 'package:b2b/scr/bloc/deposits/open_online_deposits_bloc.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/card/benefit_contract.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/presentation/screens/cards/card_list/item_card_view.dart';
import 'package:b2b/scr/presentation/screens/cards/card_list/item_contract_view.dart';
import 'package:b2b/scr/presentation/widgets/item_account_service/account_info_item.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';

class CardManager {
  static final CardManager _singleton = CardManager._internal();

  factory CardManager() {
    return _singleton;
  }

  CardManager._internal();

  void showDebitAccountBottomModal(
      PaymentCardBloc bloc, PaymentCardState state, BuildContext context) {
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
                            icon: state.selectedDebitAccount?.accountNumber ==
                                    item.accountNumber
                                ? AssetHelper.icoCheck
                                : null,
                            margin: EdgeInsets.zero,
                            onPress: () {
                              Navigator.of(context).pop();
                              bloc.add(
                                  PaymentCardChangeDebitAccountEvent(item));
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

  void showCardListBottomModal(
      {List<dynamic>? cardList,
      dynamic selectedCard,
      String? selectedID,
      required BuildContext context,
      Function(dynamic cardModel)? callBack,
      required title}) {
    if ((cardList == null || cardList.isEmpty) && selectedCard != null) {
      cardList = [];
      cardList.add(selectedCard);
    }
    if (cardList != null && cardList.isNotEmpty) {
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
                      title,
                      style: TextStyles.headerText.inputTextColor,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: cardList?.length,
                      itemBuilder: (context, index) {
                        dynamic item = cardList?[index];
                        if (item == null) return const SizedBox();
                        if (item is BenefitContract) {
                          return ItemContractView(
                            benefitContract: item,
                            onPress: () {
                              Navigator.of(context).pop();
                              callBack?.call(item);
                            },
                            rightIcon: item.contractId == selectedID
                                ? AssetHelper.icoCheck
                                : null,
                          );
                        }
                        return ItemCardView(
                          cardModel: item,
                          cardName: item.clientName,
                          cardDes:
                              '${item.cardType}|${item.getLastCardNumber()}',
                          onPress: () {
                            Navigator.of(context).pop();
                            callBack?.call(item);
                          },
                          rightIcon: item.cardId == selectedID
                              ? AssetHelper.icoCheck
                              : null,
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

  void showStatementPeriodBottomModal(
      {List<String>? dataList,
      String? selectedValue,
      required BuildContext context,
      Function(String value)? callBack,
      required title}) {
    if (dataList != null && dataList.isNotEmpty) {
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
                      title,
                      style: TextStyles.headerText.inputTextColor,
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        String? item = dataList[index];
                        if (item == null) return const SizedBox();
                        return TouchableRipple(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item,
                                  style: TextStyles.headerText.medium,
                                ),
                                if (item == selectedValue)
                                  ImageHelper.loadFromAsset(
                                    AssetHelper.icoCheck,
                                    width: 18.toScreenSize,
                                    height: 18.toScreenSize,
                                  ),
                              ],
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            callBack?.call(item);
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 1,
                          color: AppColors.dividerColor,
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
}
