import 'dart:collection';

import 'package:b2b/scr/bloc/rollover_term_saving/rollover_term_saving_bloc.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/saving/item_term_saving_model.dart';
import 'package:b2b/scr/data/model/saving/rollover_term_saving_model.dart';

/*
 * Các mốc (Cái này có confirm rồi mà a Quân chốt fix cái này dưới client)
 * < 500tr
 * 500tr -> 5 tỏi
 * > 5 tỏi
 * Bất kỳ
 */

enum InterestRateDisplayType {
  GROUP_NAME, //Số tiền gửi từ 50 triệu đến dưới 500 triệu
  DES, // Kỳ hạn Lãi suất (%/năm)
  DATA // Item data
}

class InterestRateDisplayModel {
  InterestRateDisplayType type;
  String? groupName;
  ItemTermSavingModel? itemData;

  InterestRateDisplayModel({required this.type, this.groupName, this.itemData});
}

class InterestRateManager {
  static final InterestRateManager _singleton = InterestRateManager._internal();

  factory InterestRateManager() {
    return _singleton;
  }

  InterestRateManager._internal();

  //Lai cuoi ky
  List<InterestRateDisplayModel> getDisplayEndOfPreviousList(RolloverTermSavingModel data) {
    var listItem = data.endOfPeriod?.data;
    if (listItem == null || listItem.isEmpty) {
      return [];
    }

    Map<String, bool> checkType = HashMap();

    List<InterestRateDisplayModel> result1 = []; // tiền gửi bất kỳ
    List<InterestRateDisplayModel> result2 = []; // <500m
    List<InterestRateDisplayModel> result3 = []; // 500m -> 5 tỏi
    List<InterestRateDisplayModel> result4 = []; // lớn hơn 5 tỏi

    for (var element in listItem) {
      if (element == null) {
        continue;
      }
      if (element.minAmt == -1 && element.maxAmt == -1) {
        if (checkType[AppTranslate.i18n.otherAmountStr.localized] == null) {
          checkType[AppTranslate.i18n.otherAmountStr.localized] = true;
          result1.add(InterestRateDisplayModel(
              type: InterestRateDisplayType.GROUP_NAME, groupName: AppTranslate.i18n.otherAmountStr.localized));

          result1.add(InterestRateDisplayModel(type: InterestRateDisplayType.DES));
        }

        if (element.termCode != 'R') {
          result1.add(InterestRateDisplayModel(type: InterestRateDisplayType.DATA, itemData: element));
        }
      }

      double fiveM = 499999999.0; // 500 tr
      double fiveB = 4999999999.0; // 5 tỉ

      // < 500 tr
      if (element.maxAmt == fiveM) {
        if (checkType[AppTranslate.i18n.amount0to500mStr.localized] == null) {
          checkType[AppTranslate.i18n.amount0to500mStr.localized] = true;
          result2.add(InterestRateDisplayModel(
              type: InterestRateDisplayType.GROUP_NAME, groupName: AppTranslate.i18n.amount0to500mStr.localized));
          result2.add(InterestRateDisplayModel(type: InterestRateDisplayType.DES));
        }

        if (element.termCode != 'R') {
          result2.add(InterestRateDisplayModel(type: InterestRateDisplayType.DATA, itemData: element));
        }
      }

      // 500 tr đến < 5 toỉ
      if (element.minAmt == fiveM && element.maxAmt == fiveB) {
        if (checkType[AppTranslate.i18n.amount500mto5bStr.localized] == null) {
          checkType[AppTranslate.i18n.amount500mto5bStr.localized] = true;
          result3.add(InterestRateDisplayModel(
              type: InterestRateDisplayType.GROUP_NAME, groupName: AppTranslate.i18n.amount500mto5bStr.localized));

          result3.add(InterestRateDisplayModel(type: InterestRateDisplayType.DES));
        }

        if (element.termCode != 'R') {
          result3.add(InterestRateDisplayModel(type: InterestRateDisplayType.DATA, itemData: element));
        }
      }

      // từ 5 toỉ
      if (element.minAmt! >= fiveB) {
        if (checkType[AppTranslate.i18n.amountBigger5bStr.localized] == null) {
          checkType[AppTranslate.i18n.amountBigger5bStr.localized] = true;
          result4.add(InterestRateDisplayModel(
              type: InterestRateDisplayType.GROUP_NAME, groupName: AppTranslate.i18n.amountBigger5bStr.localized));

          result4.add(InterestRateDisplayModel(type: InterestRateDisplayType.DES));
        }
        result4.add(InterestRateDisplayModel(type: InterestRateDisplayType.DATA, itemData: element));
      }
    }

    List<InterestRateDisplayModel> result = [];
    result.addAll(result1);
    result.addAll(result2);
    result.addAll(result3);
    result.addAll(result4);

    return result;
  }

  //Tiền gửi lãi định kỳ
  List<InterestRateDisplayModel> getDisplayPeriodically(RolloverTermSavingModel? data, TermSavingPeriodically type) {
    if (data == null) {
      return [];
    }
    List<ItemTermSavingModel?>? listItem;

    Periodically? periodically = data.periodically;

    switch (type) {
      case TermSavingPeriodically.monthly:
        listItem = periodically?.monthly?.data;
        break;
      case TermSavingPeriodically.every6Months:
        listItem = periodically?.every6Months?.data;
        break;
      case TermSavingPeriodically.quarterly:
        listItem = periodically?.quarterly?.data;
        break;
      case TermSavingPeriodically.yearly:
        listItem = periodically?.yearly?.data;
        break;
    }

    if (listItem == null || listItem.isEmpty) {
      return [];
    }

    List<InterestRateDisplayModel> result = [];
    result.add(InterestRateDisplayModel(type: InterestRateDisplayType.DES));

    for (var element in listItem) {
      if (element == null) {
        continue;
      }

      if (element.termCode != 'R') {
        result.add(InterestRateDisplayModel(type: InterestRateDisplayType.DATA, itemData: element));
      }
    }

    return result;
  }

  //Tiền gửi lãi trước
  List<InterestRateDisplayModel> getDisplayPrepaid(RolloverTermSavingModel data) {
    var listItem = data.prepaid?.data;
    if (listItem == null || listItem.isEmpty) {
      return [];
    }

    Map<String, bool> checkType = HashMap();

    List<InterestRateDisplayModel> result = [];
    result.add(InterestRateDisplayModel(type: InterestRateDisplayType.DES));

    for (var element in listItem) {
      if (element == null) {
        continue;
      }

      if (element.termCode != 'R') {
        result.add(InterestRateDisplayModel(type: InterestRateDisplayType.DATA, itemData: element));
      }
    }

    return result;
  }
}
