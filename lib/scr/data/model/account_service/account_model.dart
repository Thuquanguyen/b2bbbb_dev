import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountModel {
  AccountModel(this.dataBusinessAccount, this.dataPaymentAccount,
      this.dataSpecializedAccount, this.dataSavingAccount);

  final DataAccount dataBusinessAccount;
  final DataAccount dataPaymentAccount;
  final DataAccount dataSpecializedAccount;
  final DataAccount dataSavingAccount;

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class DataAccount {
  DataAccount(this.groupId, this.groupName, this.data);

  final String groupId;
  final NameModel groupName;
  final List<AccountInfo> data;

  factory DataAccount.fromJson(Map<String, dynamic> json) =>
      _$DataAccountFromJson(json);

  Map<String, dynamic> toJson() => _$DataAccountToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class GroupName {
  GroupName(this.key, this.valueVi, this.valueEn);

  @JsonKey(defaultValue: "")
  final String? key;
  @JsonKey(name: "value_vi")
  final String? valueVi;
  @JsonKey(name: "value_en")
  final String? valueEn;

  factory GroupName.fromJson(Map<String, dynamic> json) =>
      _$GroupNameFromJson(json);

  Map<String, dynamic> toJson() => _$GroupNameToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountInfo {
  AccountInfo(
      this.accountNumber,
      this.accountCurrency,
      this.accountCategory,
      this.accountName,
      this.branchCode,
      this.branchName,
      this.workingBalance,
      this.availableBalance,
      this.lockedAmount,
      this.limitAmount,
      this.openedDate,
      this.azExpriedDate,
      this.azInitRate,
      this.azTerm,
      this.azProductCode,
      this.contractNo,
      this.customerType,
      this.acStatus);

  @JsonKey(name: "account_number")
  final String? accountNumber;
  final String? accountCurrency;
  final String? accountCategory;
  final String? accountName;
  final String? branchCode;
  final String? branchName;
  final double? workingBalance;
  final double? availableBalance;
  final double? lockedAmount;
  final double? limitAmount;
  final String? openedDate;
  final String? azExpriedDate;
  final String? azInitRate;
  final String? azTerm;
  final String? azProductCode;
  final String? contractNo;
  final String? customerType;
  final String? acStatus;

  factory AccountInfo.fromJson(Map<String, dynamic> json) =>
      _$AccountInfoFromJson(json);

  Map<String, dynamic> toJson() => _$AccountInfoToJson(this);

  String getSubtitle({String? value}) {
    if (value != null) {
      return value;
    }
    return AppTranslate.i18n.accountNumberStr.localized + ' $accountNumber';
  }
}
