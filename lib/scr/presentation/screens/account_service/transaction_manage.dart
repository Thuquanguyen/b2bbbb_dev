import 'package:b2b/commons.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/base_item_model.dart';
import 'package:b2b/scr/data/model/loan_statement_model.dart';
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/widgets/item_check_list.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum TypeChoose { DATETIME, CURRENCY, FILE, TRANSACTION }

class TransactionManage {
  factory TransactionManage() => _instance;

  TransactionManage._();

  static final _instance = TransactionManage._();

  static TransactionFilterCategory transferCat = TransactionFilterCategory(
    icon: AssetHelper.icoTransferCat,
    iconSelected: AssetHelper.icoTransferCatSelected,
    nameUnlocalized: AppTranslate.i18n.tcTransferStr,
    key: 'ct',
  );
  static TransactionFilterCategory singlePayrollCat = TransactionFilterCategory(
    icon: AssetHelper.icoTransferCat,
    iconSelected: AssetHelper.icoTransferCatSelected,
    nameUnlocalized: AppTranslate.i18n.tcPayrollSingleStr,
    key: 'ct',
  );
  static TransactionFilterCategory savingCat = TransactionFilterCategory(
    icon: AssetHelper.icoSavingCat,
    iconSelected: AssetHelper.icoSavingCatSelected,
    nameUnlocalized: AppTranslate.i18n.tcSavingStr,
    key: 'tg',
  );
  static TransactionFilterCategory payrollCat = TransactionFilterCategory(
    icon: AssetHelper.icoPayrollCat,
    iconSelected: AssetHelper.icoPayrollCatSelected,
    nameUnlocalized: AppTranslate.i18n.tcPayrollStr,
    key: 'ttl',
  );
  static TransactionFilterCategory fxCat = TransactionFilterCategory(
    icon: AssetHelper.icoFx,
    iconSelected: AssetHelper.icoFxSelected,
    nameUnlocalized: AppTranslate.i18n.tcFxStr,
    key: 'fx',
  );
  static TransactionFilterCategory billCat = TransactionFilterCategory(
    icon: AssetHelper.icoBillCat,
    iconSelected: AssetHelper.icoBillCatSelected,
    nameUnlocalized: AppTranslate.i18n.tcBillStr,
    key: 'bill',
  );

  List<TransactionFilterCategory> catList() {
    return [
      ...RolePermissionManager().isPayrollOnly()
          ? [singlePayrollCat] // Change the name only
          : [transferCat],
      ...RolePermissionManager().shouldShowSavingManage() ? [savingCat] : [],
      ...RolePermissionManager().shouldShowPayrollManage() ? [payrollCat] : [],
      ...RolePermissionManager().shouldShowFxManage() ? [fxCat] : [],
      ...RolePermissionManager().shouldShowBillManage() ? [billCat] : [],
    ];
  }

  static bool shouldHideServiceList(String catKey) {
    List<String> list = [TransactionManage.payrollCat.key, TransactionManage.billCat.key];
    return list.contains(catKey);
  }

  int validTime(String startTime, String endTime) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    DateTime startDate = dateFormat.parse(startTime);
    DateTime endDate = dateFormat.parse(endTime);
    Logger.debug("DAY =======================> ${endDate.difference(startDate).inDays}");
    return endDate.difference(startDate).inDays;
  }

  String tryFormatCurrency(double? number, String? currency, {bool? showCurrency}) {
    if (number != null && currency != null) {
      return formatCurrency(number, currency) + (showCurrency == true ? ' $currency' : '');
    }

    return '';
  }

  String formatCurrency(double number, String currency) {
    final currencyFormatterVi = NumberFormat('#,##0', 'ID');
    final currencyFormatter = NumberFormat('#,##0.00', 'ID');
    if (currency == 'VND' || currency == 'JPY') {
      return currencyFormatterVi
          .format(double.parse(number.toStringAsFixed(0)))
          .replaceAll('.', ' ')
          .replaceAll(',', ".");
    }
    return currencyFormatter.format(double.parse(number.toStringAsFixed(2))).replaceAll('.', ' ').replaceAll(',', ".");
  }

  void showBottomSheetChoose(
    BuildContext context,
    Function callBack, {
    TypeChoose typeChoose = TypeChoose.DATETIME,
    List<BaseItemModel> listItems = const [],
    Function(BaseItemModel)? callBackRootData,
  }) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
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
                children: listItems
                    .map(
                      (item) => StatefulBuilder(builder: (context, state) {
                        int index = listItems.indexOf(item);
                        return ItemCheckList(
                          item: item,
                          isLast: index == (listItems.length - 1),
                          callBack: () {
                            for (BaseItemModel item in listItems) {
                              item.isCheck = false;
                            }
                            item.isCheck = true;
                            setValueDate(index, (dateFromString, dateToString) {
                              if (typeChoose == TypeChoose.DATETIME) {
                                callBack(dateFromString, dateToString, item.title, item.value ?? 0);
                              } else {
                                callBack(item.title);
                                callBackRootData?.call(item);
                              }
                              setTimeout(() {
                                Navigator.of(context).pop();
                              }, 100);
                            });
                          },
                        );
                      }),
                    )
                    .toList()),
            padding: EdgeInsets.only(bottom: SizeConfig.bottomSafeAreaPadding),
          );
        });
  }

  void setValueDate(int index, Function callBack) {
    String dateFromString = "";
    String dateToString = "";
    switch (index) {
      case 0:
        dateFromString = convertDateToString(DateTime.now().subtract(const Duration(days: 7)));
        dateToString = convertDateToString(DateTime.now());
        break;
      case 1:
        dateFromString = convertDateToString(DateTime.now().subtract(const Duration(days: 14)));
        dateToString = convertDateToString(DateTime.now());
        break;
      case 2:
        dateFromString = convertDateToString(DateTime.now().subtract(const Duration(days: 30)));
        dateToString = convertDateToString(DateTime.now());
        break;
      default:
        break;
    }
    callBack(dateFromString, dateToString);
  }

  String convertDateToString(DateTime dateTime) {
    final DateFormat dateFormat = DateFormat("dd/MM/yyyy");
    return dateFormat.format(dateTime);
  }

  List<LoanStatementGrouped> groupLoanStatement(List<LoanStatementModel>? list) {
    if (list == null || list.isEmpty == true) return [];
    DateFormat displayFormat = DateFormat('dd MMMM yyyy', AppTranslate().currentLanguage.locale);
    DateFormat serverFormat = DateFormat('dd/MM/yyyy');
    List<LoanStatementGrouped> result = [];
    for (LoanStatementModel l in list) {
      String stmDate = '';

      try {
        DateTime stmDateTime = serverFormat.parse(l.transactionDate ?? '');
        stmDate = displayFormat.format(stmDateTime);
      } catch (_) {}

      if (result.any((e) => e.date == stmDate)) {
        result.firstWhere((e) => e.date == stmDate).list.add(l);
      } else {
        result.add(LoanStatementGrouped(list: [l], date: stmDate));
      }
    }

    List<LoanStatementGrouped> sortedResult = [];
    for (LoanStatementGrouped tg in result) {
      tg.list.sort((a, b) {
        try {
          int diff = serverFormat.parse(b.transactionDate ?? '').compareTo(serverFormat.parse(a.transactionDate ?? ''));
          return diff;
        } catch (_) {
          return 1;
        }
      });
      sortedResult.add(tg);
    }

    sortedResult.sort((a, b) {
      try {
        int diff = displayFormat.parse(b.date).compareTo(displayFormat.parse(a.date));
        return diff;
      } catch (_) {
        return 1;
      }
    });

    return sortedResult;
  }
}
