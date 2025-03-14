import 'package:b2b/scr/data/model/card/card_visual.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'card_model.g.dart';

enum CardType { DEBIT, CREDIT }

@JsonSerializable(fieldRename: FieldRename.snake)
class CardModel {
  final String? taxCode;
  final String? cardId;
  final int? departmentId;
  final String? companyId;
  final String? companyContractNumber;
  final String? departmentContractNumber;
  final String? cardNumber;
  final String? departmentName;
  final String? clientName;
  final double? comLimit;
  final double? depLimit;
  final double? cardLimit;
  final double? companyBlocked;
  final double? departmentLocked;
  final double? cardBlocked;
  final double? companyTotalBalance;
  final double? depTotalBalance;
  final double? cardTotalBalance;
  final double? comAvail;
  final double? depAvail;
  final double? cardAvail;
  final String? dateOpen;
  final String? dayOpen;
  final String? comDateOpen;
  final String? cardExpire;
  final String? government;
  final String? cardType;
  final String? name;
  final String? cardComRegNumber;
  final String? cardDepRegNumber;
  final String? cardCurrency;
  final String? fbranch;
  final String? statusEcom;
  final NameModel? statusEcomDisplay;
  final String? clientAddress;
  final String? contractNumberMasked;
  final String? custcif;
  final String? contrStatus;
  final String? dateExpire;
  final double? minPaymentCard;
  final double? minPaymentDepContract;
  final double? minPaymentComContract;
  final double? fullPaymentCard;
  final double? fullPaymentDepContract;
  final double? fullPaymentComContract;
  final String? depMainName;
  final String? comMainName;
  final String? productionStatus;
  final String? comAddress;
  final String? ebsNumber;
  final String? payType;
  final String? cardNumberMasked;
  final String? cardProductCode;
  final String? productCode;
  final String? phoneNumber;
  final String? otpType;
  final String? rbsNumber;
  final List<CardModel>? cardSub;
  @JsonKey(ignore: true)
  CardType? type;

  CardModel({
    this.taxCode,
    this.cardId,
    this.departmentId,
    this.companyId,
    this.companyContractNumber,
    this.departmentContractNumber,
    this.cardNumber,
    this.departmentName,
    this.clientName,
    this.comLimit,
    this.depLimit,
    this.cardLimit,
    this.companyBlocked,
    this.departmentLocked,
    this.cardBlocked,
    this.companyTotalBalance,
    this.depTotalBalance,
    this.cardTotalBalance,
    this.comAvail,
    this.depAvail,
    this.cardAvail,
    this.dateOpen,
    this.dayOpen,
    this.comDateOpen,
    this.cardExpire,
    this.government,
    this.cardType,
    this.name,
    this.cardComRegNumber,
    this.cardDepRegNumber,
    this.cardCurrency,
    this.fbranch,
    this.statusEcom,
    this.statusEcomDisplay,
    this.clientAddress,
    this.contractNumberMasked,
    this.custcif,
    this.contrStatus,
    this.dateExpire,
    this.minPaymentCard,
    this.minPaymentDepContract,
    this.minPaymentComContract,
    this.fullPaymentCard,
    this.fullPaymentDepContract,
    this.fullPaymentComContract,
    this.depMainName,
    this.comMainName,
    this.productionStatus,
    this.comAddress,
    this.ebsNumber,
    this.payType,
    this.cardNumberMasked,
    this.cardProductCode,
    this.productCode,
    this.phoneNumber,
    this.otpType,
    this.rbsNumber,
    this.cardSub,
    this.type,
  });

  CardVisual get visual {
    switch (cardType) {
      case 'Business Debit':
        return CardVisual(
          front: AssetHelper.cardBusinessDebitFront,
          back: AssetHelper.cardTempBack,
          dataColor: Colors.black,
          dataInBack: false,
          nameXOffset: .1,
          nameYOffset: .8,
          companyXOffset: .1,
          companyYOffset: .89,
          numberXOffset: .1,
          numberYOffset: .57,
          openDateXOffset: .27,
          openDateYOffset: .67,
          expiryDateXOffset: .54,
          expiryDateYOffset: .67,
        );
      case 'Business Credit':
        return CardVisual(
          front: AssetHelper.cardBusinessCreditFront,
          back: AssetHelper.cardTempBack,
          dataColor: Colors.black,
          dataInBack: false,
          nameXOffset: .1,
          nameYOffset: .8,
          companyXOffset: .1,
          companyYOffset: .89,
          numberXOffset: .1,
          numberYOffset: .57,
          openDateXOffset: .27,
          openDateYOffset: .67,
          expiryDateXOffset: .54,
          expiryDateYOffset: .67,
        );
      case 'Business Deluxe':
        return CardVisual(
          front: AssetHelper.cardBusinessDeluxeFront,
          back: AssetHelper.cardTempBack,
          dataColor: Colors.white,
          dataInBack: false,
          nameXOffset: .1,
          nameYOffset: .8,
          companyXOffset: .1,
          companyYOffset: .89,
          numberXOffset: .1,
          numberYOffset: .57,
          openDateXOffset: 0,
          openDateYOffset: 0,
          expiryDateXOffset: .25,
          expiryDateYOffset: .69,
        );
      case 'MC Corporate Platinum Credit':
        return CardVisual(
          front: AssetHelper.cardBusinessPlatinumFront,
          back: AssetHelper.cardBusinessPlatinumBack,
          dataColor: Colors.white,
          dataInBack: false,
          nameXOffset: .1,
          nameYOffset: .8,
          companyXOffset: .1,
          companyYOffset: .89,
          numberXOffset: .1,
          numberYOffset: .57,
          openDateXOffset: .27,
          openDateYOffset: .67,
          expiryDateXOffset: .54,
          expiryDateYOffset: .67,
        );
      default:
        return CardVisual(
          front: AssetHelper.cardTempFront,
          back: AssetHelper.cardTempBack,
          dataColor: Colors.white,
          dataInBack: false,
          nameXOffset: .25,
          nameYOffset: .15,
          companyXOffset: .25,
          companyYOffset: .23,
          numberXOffset: .1,
          numberYOffset: .78,
          openDateXOffset: 0,
          openDateYOffset: 0,
          expiryDateXOffset: .1,
          expiryDateYOffset: .67,
        );
    }
  }

  String get dateOpenDisplay {
    try {
      DateTime o = DateFormat("yyyy-MM-dd'T'HH:mm:ss").parse(dateOpen ?? '');
      return DateFormat("MM/yy").format(o);
    } catch (e) {
      return '';
    }
  }

  String get dateExpireDisplay {
    return '${dateExpire?.substring(2, 4) ?? ''}/${dateExpire?.substring(0, 2) ?? ''}';
  }

  String get maskedNumber {
    return '${cardNumber?.substring(0, 4) ?? ''} •••• •••• ${cardNumber?.substring((cardNumber?.length ?? 4) - 4) ?? ''}';
  }

  factory CardModel.fromJson(Map<String, dynamic> json) => _$CardModelFromJson(json);

  Map<String, dynamic> toJSON() => _$CardModelToJson(this);

  String getLastCardNumber() {
    try {
      return '****${cardNumber?.substring((cardNumber?.length ?? 0) - 4)}';
    } catch (e) {
      return '';
    }
  }

  String get getLastCardNumberDotted {
    try {
      return '••••${cardNumber?.substring((cardNumber?.length ?? 0) - 4)}';
    } catch (e) {
      return '';
    }
  }

  String getContractNumberMasked() {
    return contractNumberMasked?.replaceAll('_', '*') ?? '';
  }

  double get cardMinAvail {
    double _comAvail = comAvail ?? 0;
    double _cardAvail = cardAvail ?? 0;
    if (_comAvail < _cardAvail) return _comAvail;
    return _cardAvail;
  }
}
