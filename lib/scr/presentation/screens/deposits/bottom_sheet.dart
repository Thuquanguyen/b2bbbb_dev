import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/deposits/open_online_deposits_bloc.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/open_saving/rollover_term.dart';
import 'package:b2b/scr/data/model/open_saving/settelment.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/presentation/widgets/item_account_service/account_info_item.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';

void changeAccount(BuildContext context, OpenOnlineDepositsBloc bloc,
    OpenOnlineDepositsState state, bool isRootAccount) {
  DebitAccountModel? currentDebitAccount =
      isRootAccount ? state.rootAccountDebit : state.receiveAccountProfit;

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
            itemCount: state.listDebitAccount?.length,
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
                  workingBalance:
                      item.availableBalance?.toInt().toString().toMoneyFormat ??
                          '0',
                  accountCurrency: item.accountCurrency,
                  accountNumber: item.getSubtitle(),
                  isLastIndex: true,
                  icon: item.accountNumber == currentDebitAccount?.accountNumber
                      ? AssetHelper.icoCheck
                      : null,
                  margin: EdgeInsets.zero,
                  onPress: () {
                    Navigator.of(context).pop();
                    bloc.add(
                      ChangeDebitAccountEvent(
                          debitAccountModel: item,
                          isRootAccount: isRootAccount),
                    );
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

//Kỳ hạn
void showBottomSheetChangeRolloverTerm(BuildContext context,
    OpenOnlineDepositsState state, Function(RolloverTerm) onChange) {
  if ((state.depositsInputState?.rollOverTermList?.length ?? 0) < 1) return;
  RolloverTerm? currentRolloverTerm =
      state.depositsInputState?.selectedRollOverTerm;

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
          child: ListView.separated(
              itemBuilder: (context, index) {
                RolloverTerm? rolloverTerm =
                    state.depositsInputState?.rollOverTermList?[index];
                if (rolloverTerm == null) {
                  return const SizedBox();
                }
                return Touchable(
                  onTap: () {
                    onChange.call(rolloverTerm);
                    setTimeout(() {
                      Navigator.of(context).pop();
                    }, 100);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding, vertical: 10),
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Row(
                      children: [
                        Opacity(
                          opacity: rolloverTerm.termCode ==
                                  currentRolloverTerm?.termCode
                              ? 1
                              : 0,
                          child: ImageHelper.loadFromAsset(AssetHelper.icoCheck,
                              width: 24, height: 24),
                        ),
                        const SizedBox(width: kDefaultPadding),
                        Text(rolloverTerm.getValue() ?? '',
                            style: TextStyles.normalText.normalColor)
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount:
                  state.depositsInputState?.rollOverTermList?.length ?? 0),
        ),
      );
    },
  );
}

//Phương thức nhận lãi
void showBottomSheetSettElement(BuildContext context,
    OpenOnlineDepositsBloc bloc, OpenOnlineDepositsState state,
    {Function()? conChange}) {
  if ((state.depositsInputState?.listSettelment?.length ?? 0) < 1) return;
  Settelment? currentSettelment = state.depositsInputState?.selectedSettelment;

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
          child: ListView.separated(
              itemBuilder: (context, index) {
                Settelment? settElment =
                    state.depositsInputState?.listSettelment?[index];
                if (settElment == null) {
                  return const SizedBox();
                }
                return Touchable(
                  onTap: () {
                    bloc.add(
                      ChangeSettElementEvent(settElment),
                    );
                    setTimeout(() {
                      Navigator.of(context).pop();
                      conChange?.call();
                    }, 100);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding, vertical: 10),
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Row(
                      children: [
                        Opacity(
                          opacity: settElment.settleCode ==
                                  currentSettelment?.settleCode
                              ? 1
                              : 0,
                          child: ImageHelper.loadFromAsset(AssetHelper.icoCheck,
                              width: 24, height: 24),
                        ),
                        const SizedBox(width: kDefaultPadding),
                        Expanded(
                          child: Text(settElment.name ?? '',
                              maxLines: 2,
                              style: TextStyles.normalText.normalColor),
                        )
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: state.depositsInputState!.listSettelment!.length),
        ),
      );
    },
  );
}
