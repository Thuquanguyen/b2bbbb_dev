import 'package:json_annotation/json_annotation.dart';

part 'benefit_contract.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BenefitContract {
  final String? mainContract;
  final String? contractId;
  final String? contractName;
  final bool? isCredit;
  final int? type;

  BenefitContract(this.mainContract, this.contractId, this.contractName,
      this.isCredit, this.type);

  factory BenefitContract.fromJson(Map<String, dynamic> json) =>
      _$BenefitContractFromJson(json);

  Map<String, dynamic> toJSON() => _$BenefitContractToJson(this);
}
