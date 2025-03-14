import 'dart:async';

import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/card/payment_card/payment_card_bloc.dart';
import 'package:b2b/scr/bloc/card/payment_card/payment_card_event.dart';
import 'package:b2b/scr/bloc/card/payment_card/payment_card_state.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/card/benefit_contract.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/buttons.dart';
import 'package:b2b/scr/presentation/widgets/item_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/render_input_item.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/utilities/input_item_data.dart';
import 'package:flutter/material.dart';

amountShimmer() {
  return AppShimmer(
    itemShimmer(
      height: 20,
      width: 50,
    ),
  );
}

amountFrame(
    PaymentCardState state,
    InputItemData amountInputData,
    StreamController<bool> _checkBuildDefaultButton,
    TextEditingController amountController,
    PaymentCardBloc bloc,
    Function() onInitPayment) {
  return Container(
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
        renderAmountItem(
            amountInputData, state.selectedDebitAccount?.accountCurrency),
        if (state.selectedCardModel is BenefitContract)
          _itemPaymentValue(true, state, amountController, bloc),
        if (state.selectedCardModel is BenefitContract)
          const SizedBox(
            height: 10,
          ),
        if (state.selectedCardModel is BenefitContract)
          _itemPaymentValue(false, state, amountController, bloc),
        const SizedBox(
          height: 32,
        ),
        StreamBuilder<bool>(
          initialData: false,
          stream: _checkBuildDefaultButton.stream,
          builder: (context, snapshot) {
            return !isKeyboardShowing(context)
                ? DefaultButton(
                    onPress: snapshot.data! ? onInitPayment : null,
                    text: AppTranslate.i18n.continueStr.localized.toUpperCase(),
                    height: 45.toScreenSize,
                    radius: 32,
                    margin:
                        const EdgeInsets.only(bottom: kDefaultPadding, top: 1),
                  )
                : const SizedBox();
          },
        ),
      ],
    ),
  );
}

_itemPaymentValue(bool isMin, PaymentCardState state,
    TextEditingController amountController, PaymentCardBloc bloc) {
  bool isSelected = false;
  if (isMin && state.isMinPaySelected == true) {
    isSelected = true;
  } else if (!isMin && state.isAllPaySelected == true) {
    isSelected = true;
  }
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        !isMin
            ? AppTranslate.i18n.cardPaymentAllStr.localized
            : AppTranslate.i18n.cardPaymentMinStr.localized,
        style: TextStyles.itemText.medium,
      ),
      const SizedBox(
        width: 5,
      ),
      if (bloc.state.contractInfoDataState != DataState.data)
        amountShimmer(),
      if (bloc.state.contractInfoDataState == DataState.data)
        TouchableRipple(
          onPressed: () {
            amountController.text = (isMin
                    ? state.contractInfo?.minPaymentContract
                        ?.toInt()
                        .toMoneyString
                    : state.contractInfo?.fullPaymentContract
                        ?.toInt()
                        .toMoneyString) ??
                '';
            amountController.selection = TextSelection.fromPosition(
              TextPosition(
                offset: amountController.text.length,
              ),
            );
            bloc.add(
              PaymentCardChangeStatusEvent(isMinPay: isMin, isSelected: true),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected ? const Color(0xff00B74F) : Colors.white,
              border: Border.all(color: const Color(0xff00b74f), width: 1),
            ),
            child: Text(
              isMin
                  ? '${state.contractInfo?.minPaymentContract?.toInt() ?? ''}'
                          .toMoneyFormat +
                      ' ${state.selectedDebitAccount?.accountCurrency}'
                  : '${state.contractInfo?.fullPaymentContract?.toInt() ?? ''}'
                          .toMoneyFormat +
                      ' ${state.selectedDebitAccount?.accountCurrency}',
              style: TextStyles.itemText.copyWith(
                  color: !isSelected ? const Color(0xff00B74F) : Colors.white,
                  fontSize: 13),
            ),
          ),
        ),
    ],
  );
}
