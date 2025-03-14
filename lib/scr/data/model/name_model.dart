import 'dart:ui';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'name_model.g.dart';

enum TransactionType {
  INTERNAL,
  INTERBANK,
  SALARY_INTERBANK,
  SALARY_FILE,
  NAPAS_CARD,
  NAPAS_ACCOUNT,
  CARD_PAYMENT,
}

enum ChargeType {
  OUR,
  BEN,
  SHA,
}

class TransactionStatusDetail {
  final String iconPath;
  final String text;
  final Color color;

  TransactionStatusDetail({
    required this.iconPath,
    required this.text,
    required this.color,
  });
}

@JsonSerializable(fieldRename: FieldRename.snake)
class NameModel<T> {
  NameModel({
    this.key,
    this.valueVi,
    this.valueEn,
    this.data,
  });

  factory NameModel.fromJson(Map<String, dynamic> json) => _$NameModelFromJson(json);

  String? key;
  String? valueVi;
  String? valueEn;
  @JsonKey(ignore: true)
  T? data;

  Map<String, dynamic> toJson() => _$NameModelToJson(this);

  String localization({SupportLanguages? locale, String defaultValue = ''}) {
    locale ??= AppTranslate().currentLanguage;
    if (locale == SupportLanguages.En) {
      return valueEn ?? defaultValue;
    }
    return valueVi ?? defaultValue;
  }

  TransactionStatusDetail? get statusDetail {
    switch (key) {
      case 'WAI':
      case 'OPEN_WAI':
      case 'OPEN_WCF':
      case 'CLS_WAI':
      case 'CLS_WCF':
      case 'WCF':
      case 'APP':
      case 'UNA':
        return TransactionStatusDetail(
          iconPath: AssetHelper.icoProcessing,
          text: localization(),
          color: const Color.fromRGBO(255, 168, 0, 1),
        );
      case 'SUC':
      case 'OPEN_FIN':
      case 'CLS_FIN':
        return TransactionStatusDetail(
          iconPath: AssetHelper.icoChecked,
          text: localization(),
          color: const Color.fromRGBO(0, 183, 79, 1),
        );
      case 'FAL':
      case 'REV':
      case 'OPEN_ERR':
      case 'REJ':
      case 'CLS_ERR':
      case 'OPEN_REJ':
      case 'CLS_REJ':
      case 'DEL':
        return TransactionStatusDetail(
          iconPath: AssetHelper.icoRejected,
          text: localization(),
          color: const Color.fromRGBO(255, 103, 99, 1),
        );
      default:
        return null;
    }
  }

  bool get taxCheckerShowAction {
    switch (key) {
      case 'WAI':
      case 'WCF':
        return true;
      default:
        return false;
    }
  }

  bool get taxMakerShowAction {
    switch (key) {
      case 'WAI':
      case 'WCF':
      case 'REJ':
        return true;
      default:
        return false;
    }
  }

  TransactionType? get transactionType {
    switch (key) {
      case 'DC0C3B99-FFE8-4E00-9E33-708CA02197AE':
        return TransactionType.INTERNAL;
      case '36815B2C-FB2E-4A29-B5BA-DA469AB3E12B':
        return TransactionType.INTERBANK;
      case 'AF63BAB0-D37C-4A63-A6E9-9FB24FB2FED2':
        return TransactionType.NAPAS_ACCOUNT;
      case '2219B61C-3D3F-49FF-81CE-56A551806B6D':
        return TransactionType.NAPAS_CARD;
      case '3E59B5B6-DB0D-48ED-A20C-DADC4630F55E':
        return TransactionType.SALARY_INTERBANK;
      case '0DCC81DC-4EEE-4C10-A6F1-CCB5A0CF0D85':
        return TransactionType.SALARY_FILE;
      case 'FCA3767B-03CF-4659-8984-825D349304FE':
        return TransactionType.CARD_PAYMENT;
    }
  }

  ChargeType? get chargeType {
    switch (key) {
      case 'OUR':
        return ChargeType.OUR;
      case 'BEN':
        return ChargeType.BEN;
      case 'SHA':
        return ChargeType.SHA;
    }
  }
}
