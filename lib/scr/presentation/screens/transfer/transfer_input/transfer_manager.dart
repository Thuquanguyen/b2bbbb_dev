import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_state.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/search/beneficiary_saved_model.dart';
import 'package:b2b/scr/data/model/base_item_model.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/presentation/widgets/item_account_service/account_info_item.dart';
import 'package:b2b/scr/presentation/widgets/item_check_list.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/material.dart';

class InputItemKey {
  static String accountNumber = "account_number";
  static String saveBeneficiary = "save_beneficiary";
  static String memoBeneficiaryName = "memo_beneficiary_name";
  static String amountNumber = "amount_number";
  static String amountContent = "amount_content";
  static String feeAccount = "fee_account";
  static String locationInterbank = 'location_interbank';
  static String branchInterbank = 'branch_interbank';
  static String beneficiaryName = 'beneficiary_name';
  static String feeType = 'fee_type';
}

class TransferManager {
  factory TransferManager() => _instance;

  TransferManager._();

  static final _instance = TransferManager._();

  List<BeneficiarySavedModel> inHouseBenLists = [];
  List<BeneficiarySavedModel> napasAccountBenLists = [];
  List<BeneficiarySavedModel> napasCardBenLists = [];
  List<BeneficiarySavedModel> internetBenLists = [];

  BeneficiarySavedModel? findInHouseBen(String account) {
    try {
      return inHouseBenLists
          .firstWhere((element) => element.benAccount == account);
    } catch (e) {
      return null;
    }
  }

  BeneficiarySavedModel? findNapasAccountBen(String account) {
    try {
      return napasAccountBenLists
          .firstWhere((element) => element.benAccount == account);
    } catch (e) {
      return null;
    }
  }

  BeneficiarySavedModel? findNapasCardBen(String account) {
    try {
      return napasCardBenLists
          .firstWhere((element) => element.benAccount == account);
    } catch (e) {
      return null;
    }
  }

  BeneficiarySavedModel? findInternetBen(String account) {
    try {
      return internetBenLists
          .firstWhere((element) => element.benAccount == account);
    } catch (e) {
      return null;
    }
  }

  List<BaseItemModel> feeTypes = [
    BaseItemModel(
        title: AppTranslate.i18n.transferCostStr.localized
            .interpolate({'vat': ''}),
        isCheck: true,
        fee: 'OUR'),
    BaseItemModel(
        title: AppTranslate.i18n.paidRecipientsStr.localized
            .interpolate({'vat': ''}),
        fee: 'BEN')
  ];

  void resetData() {
    feeTypes = [
      BaseItemModel(
          title: AppTranslate.i18n.transferCostStr.localized
              .interpolate({'vat': ''}),
          isCheck: true,
          fee: 'OUR'),
      BaseItemModel(
          title: AppTranslate.i18n.paidRecipientsStr.localized
              .interpolate({'vat': ''}),
          fee: 'BEN')
    ];
  }

  void initFeeType(TransferBloc transferBloc) {
    resetData();
    transferBloc.add(ChangeInterbankFeeTypeEvent(baseItemModel: feeTypes[0]));
  }

  void showChangeFeeType(BuildContext context, TransferBloc transferBloc) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // set this to true
        builder: (_) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(14),
              ),
            ),
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: feeTypes
                    .map(
                      (item) => StatefulBuilder(builder: (context, state) {
                        int index = feeTypes.indexOf(item);
                        return ItemCheckList(
                          item: item,
                          isLast: index == (feeTypes.length - 1),
                          callBack: () {
                            for (BaseItemModel item in feeTypes) {
                              item.isCheck = false;
                            }
                            item.isCheck = true;
                            transferBloc.add(ChangeInterbankFeeTypeEvent(
                                baseItemModel: item));
                            Navigator.of(context).pop();
                          },
                        );
                      }),
                    )
                    .toList()),
            padding: EdgeInsets.only(bottom: SizeConfig.bottomSafeAreaPadding),
          );
        });
  }

  void showChangeFeeAccount(BuildContext context, TransferBloc transferBloc) {
    String? debitCcy = transferBloc.state.debitAccountDefault?.accountCurrency;
    List<DebitAccountModel>? dataList = transferBloc.state.listDebitAccount
        ?.where((element) =>
            element.accountCurrency == debitCcy ||
            element.accountCurrency == 'VND')
        .toList();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true, // set this to true
        builder: (_) {
          return Container(
            height: SizeConfig.screenHeight / 2,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(kDefaultPadding),
                topRight: Radius.circular(kDefaultPadding),
              ),
            ),
            margin: const EdgeInsets.only(top: kToolbarHeight),
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
              vertical: kTopPadding,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: dataList?.length ?? 0,
              itemBuilder: (context, index) {
                final item = dataList?[index];
                if (item == null) {
                  return const SizedBox();
                }
                return Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: kBorderSide,
                    ),
                  ),
                  padding: const EdgeInsets.only(
                    top: kDefaultPadding,
                    bottom: kTopPadding,
                  ),
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
                            transferBloc.state.transferInterbankState.feeAccount
                                ?.accountNumber
                        ? AssetHelper.icoCheck
                        : null,
                    margin: EdgeInsets.zero,
                    onPress: () {
                      Navigator.of(context).pop();
                      transferBloc.add(
                        ChangeInterbankFeeAccountEvent(debitAccountModel: item),
                      );
                    },
                  ),
                );
              },
            ),
          );
        });
  }
}
