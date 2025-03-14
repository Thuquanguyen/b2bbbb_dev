import 'package:b2b/scr/data/model/name_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'saving_account_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SavingAccountModel {
  String? accountNo;
  String? acountCcy;
  double? balance;
  String? rate;
  String? term;
  NameModel? termDisplay;
  String? startDate;
  String? endDate;
  String? branch;
  String? contractNo;
  bool? isOnline;

  SavingAccountModel({
    this.accountNo,
    this.acountCcy,
    this.balance,
    this.rate,
    this.term,
    this.termDisplay,
    this.startDate,
    this.endDate,
    this.branch,
    this.contractNo,
    this.isOnline,
  });

  factory SavingAccountModel.fromJson(Map<String, dynamic> json) =>
      _$SavingAccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$SavingAccountModelToJson(this);
}
