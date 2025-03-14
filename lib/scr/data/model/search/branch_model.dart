import 'package:json_annotation/json_annotation.dart';

part 'branch_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BranchModel {
  final String? branchCode;
  final String? branchName;
  final String? cityCode;
  final String? bankNo;

  BranchModel({this.branchCode, this.branchName, this.cityCode, this.bankNo});

  factory BranchModel.fromJson(Map<String, dynamic> json) => _$BranchModelFromJson(json);

  Map<String, dynamic> toJson() => _$BranchModelToJson(this);
}
