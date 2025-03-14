import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:json_annotation/json_annotation.dart';

part 'transaction_filter_request.g.dart';

class TransactionFilterCategory {
  final String icon;
  final String iconSelected;
  final String nameUnlocalized;
  final String key;
  final Function(TransactionFilterCategory)? onTap;

  TransactionFilterCategory({
    required this.icon,
    required this.iconSelected,
    required this.nameUnlocalized,
    required this.key,
    this.onTap,
  });

  TransactionFilterCategory copyWith(
      {Function(TransactionFilterCategory)? onTap}) {
    return TransactionFilterCategory(
      icon: icon,
      iconSelected: iconSelected,
      nameUnlocalized: nameUnlocalized,
      key: key,
      onTap: onTap ?? this.onTap,
    );
  }

  String get name {
    return nameUnlocalized.localized;
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class TransactionFilterRequest {
  String serviceType;
  String status;
  String transCode;
  String accountingEntry;
  double fromAmount;
  double toAmount;
  String fromDate;
  String toDate;

  TransactionFilterRequest({
    this.serviceType = '',
    this.status = '',
    this.transCode = '',
    this.accountingEntry = '',
    this.fromAmount = -1,
    this.toAmount = -1,
    this.fromDate = '',
    this.toDate = '',
  });

  bool get isFilterActive {
    return serviceType != '' ||
        status != '' ||
        transCode != '' ||
        accountingEntry != '' ||
        fromAmount != -1 ||
        toAmount != -1 ||
        fromDate != '' ||
        toDate != '';
  }

  factory TransactionFilterRequest.fromJson(Map<String, dynamic> json) =>
      _$TransactionFilterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$TransactionFilterRequestToJson(this);
}
