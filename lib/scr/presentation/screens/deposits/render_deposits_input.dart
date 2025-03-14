import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/deposits/open_online_deposits_bloc.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/open_saving/rollover_term_rate.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/dropdown_item.dart';
import 'package:b2b/scr/presentation/widgets/render_input_item.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/input_item_data.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

Widget itemTypeHolder() {
  return Container(
    height: getInScreenSize(36, min: 36),
    padding: const EdgeInsets.only(
        left: kDefaultPadding, right: kDefaultPadding, top: 8, bottom: 8),
    decoration: BoxDecoration(
      color: AppColors.shimmerBackGroundColor,
      border: const Border.symmetric(
          vertical: BorderSide(width: 0.5, color: Colors.black12)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 150,
              height: 8,
              color: AppColors.shimmerItemColor,
            ),
            Container(
              width: 50,
              height: 8,
              color: AppColors.shimmerItemColor,
            ),
          ],
        ),
        Container(
          width: 15,
          height: 15,
          color: AppColors.shimmerItemColor,
        )
      ],
    ),
  );
}

_accountShimmerWidget() {
  return AppShimmer(
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: kDefaultPadding,
        ),
        Container(
          padding: const EdgeInsets.only(
              left: kDefaultPadding, right: kDefaultPadding, top: 8, bottom: 8),
          decoration: BoxDecoration(
            color: AppColors.shimmerItemColor,
            borderRadius: BorderRadius.circular(8),
          ),
          width: 70,
          height: 10,
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                  top: 8,
                  bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.shimmerItemColor,
                borderRadius: BorderRadius.circular(8),
              ),
              width: 10,
              height: 10,
            ),
            const SizedBox(
              width: 5,
            ),
            Container(
              padding: const EdgeInsets.only(
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                  top: 8,
                  bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.shimmerItemColor,
                borderRadius: BorderRadius.circular(8),
              ),
              width: 100,
              height: 10,
            ),
          ],
        ),
      ],
    ),
  );
}

accountWidget(OpenOnlineDepositsState state,
    {bool? showAvailableBalance = false,
    Function()? onPress,
    String? title,
    bool? isRootAccount,
    bool? hideDropDownIcon = false,
    bool? showRequire = false}) {
  if (state.debitAccountDataState != DataState.data) {
    return _accountShimmerWidget();
  }

  Color textColor = const Color(0xff00B74F);

  DebitAccountModel? accountModel = (isRootAccount == true)
      ? state.rootAccountDebit
      : state.receiveAccountProfit;

  InputItemData data = InputItemData(
      title: AppTranslate.i18n.chooseSourceAccountStr,
      type: InputItemType.OTHER,
      onTap: onPress,
      showRequire: showRequire,
      value: accountModel);

  Logger.debug(
      '--------------- DebitAccountModel ${accountModel?.accountNumber}');

  if (accountModel == null) {
    return const SizedBox();
  }

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      renderFeeAccount(data,
          title: title,
          textStyle: TextStyles.itemText.inputTextColor.medium,
          hideDropDownIcon: hideDropDownIcon),
      if (showAvailableBalance == true)
        const SizedBox(
          height: 4,
        ),
      if (showAvailableBalance == true)
        Container(
          alignment: Alignment.centerLeft,
          child: Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                  text:
                      '${AppTranslate.i18n.asAvailableBalancesStr.localized}: ',
                  style:
                      TextStyles.smallText.regular.copyWith(color: textColor),
                ),
                TextSpan(
                  text: accountModel.availableBalance
                          ?.toInt()
                          .toString()
                          .toMoneyFormat ??
                      '',
                  style: TextStyles.smallText.medium.copyWith(color: textColor),
                ),
                TextSpan(
                  text: ' ${accountModel.accountCurrency}',
                  style:
                      TextStyles.smallText.regular.copyWith(color: textColor),
                ),
              ],
            ),
          ),
        )
    ],
  );
}

amountNumberWidget(
    String currency, TextEditingController controller, FocusNode focusNode,
    {Function(String)? onComplete, Function(String)? onTextChange}) {
  InputItemData amount = InputItemData(
      title: AppTranslate.i18n.depositsStr.localized,
      type: InputItemType.AMOUNT,
      controller: controller,
      showRequire: true,
      focusNode: focusNode,
      onComplete: onComplete,
      onTextChange: onTextChange,
      hint: '10 000 000 VND');
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      renderAmountItem(amount, currency, removeDefaultPadding: true),
      const SizedBox(
        height: 4,
      ),
      Text(
        AppTranslate.i18n.minimumStr.localized,
        style: TextStyles.smallText,
      ),
    ],
  );
}

periodWidget(OpenOnlineDepositsState state,
    {bool? showRequire = false,
    Function? changeRolloverTerm,
    bool? hidePadding = false,
    bool? isShowDropdown = true}) {
  if (state.depositsInputState == null) {
    return const SizedBox();
  }

  if (state.depositsInputState?.rollOverTermListDataState == DataState.init ||
      state.depositsInputState?.rollOverTermListDataState == null) {
    return const SizedBox();
  }

  if (state.depositsInputState?.rollOverTermListDataState ==
      DataState.preload) {
    return AppShimmer(
      Container(
        margin: const EdgeInsets.only(right: 16, top: 16),
        width: double.infinity,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kCornerRadius),
          color: AppColors.shimmerItemColor,
        ),
      ),
    );
  } else if (state.depositsInputState?.rollOverTermListDataState ==
      DataState.error) {
    return const SizedBox();
  }
  RolloverTermRate? rolloverTermRate =
      state.depositsInputState?.rolloverTermRate;

  if ((state.depositsInputState?.rollOverTermList?.length ?? 0) < 1) {
    return const SizedBox();
  }

  return Column(
    children: [
      if (hidePadding != true)
        const SizedBox(
          height: kDefaultPadding,
        ),
      DropDownItem(
        isRequire: showRequire,
        isShowDropdown: isShowDropdown,
        leadingIcon: AssetHelper.icoCalendar,
        title: AppTranslate.i18n.periodStr.localized,
        value: state.depositsInputState?.selectedRollOverTerm?.getValue() ?? '',
        onTap: () {
          Logger.debug('show dropdown change rollover term');
          changeRolloverTerm?.call();
        },
      ),
      if (rolloverTermRate != null)
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTranslate.i18n.effectiveDateStr.localized,
                    style: TextStyles.smallText,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    rolloverTermRate.startDate ?? '',
                    style: TextStyles.itemText.medium.inputTextColor,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTranslate.i18n.expirationDateStr.localized,
                    style: TextStyles.smallText,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    rolloverTermRate.endDate ?? '',
                    style: TextStyles.itemText.medium.tabSelctedColor
                  ),
                ],
              ),
            ),
          ],
        ),
    ],
  );
}

inputValueWidget(
    {required String title,
    String? hint,
    required TextEditingController controller,
    bool? showRequire}) {
  InputItemData inputItemData = InputItemData(
      title: title,
      type: InputItemType.OTHER,
      hint: hint,
      controller: controller,
      showRequire: showRequire);
  return renderFiledItem(inputItemData);
}

noteWidget(Function() onTap) {
  return Text.rich(
    TextSpan(
      children: <TextSpan>[
        TextSpan(
          text: AppTranslate.i18n.noteStr.localized,
          style: TextStyles.buttonText.regular.copyWith(
            color: const Color(0xff00B74F),
          ),
        ),
        TextSpan(
          text: '${AppTranslate.i18n.depositsTerm1Str.localized} ',
          style: TextStyles.buttonText.regular,
        ),
        TextSpan(
          text: AppTranslate.i18n.tradingConditionStr.localized,
          style: TextStyles.buttonText.bold
              .copyWith(color: const Color(0xff00B74F)),
          recognizer: TapGestureRecognizer()..onTap = onTap,
        ),
        TextSpan(
          text: ' ${AppTranslate.i18n.depositsTerm2Str.localized}',
          style: TextStyles.buttonText.regular,
        ),
      ],
    ),
  );
}

//Phương thức xử lý khi đến hạn
settElementWidget(OpenOnlineDepositsState state, Function() onTap) {
  if (state.depositsInputState?.settElmentDataState != DataState.data) {
    return _accountShimmerWidget();
  }
  return DropDownItem(
    isRequire: true,
    title: AppTranslate.i18n.dueProcessingMethodStr.localized,
    value: state.depositsInputState?.selectedSettelment?.name ?? '',
    onTap: onTap,
  );
}
