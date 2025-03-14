import 'package:b2b/scr/data/model/card/benefit_contract.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:flutter/material.dart';

class CardContractListResponse {
  final List<CardModel>? card;
  final List<BenefitContract>? contract;

  CardContractListResponse({this.card, this.contract});

  static CardContractListResponse fromJson(Map<String, dynamic> json) {
    return CardContractListResponse(
      card: (json['card'] as List<dynamic>?)
          ?.map((e) => CardModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      contract: (json['contract'] as List<dynamic>?)
          ?.map((e) => BenefitContract.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
