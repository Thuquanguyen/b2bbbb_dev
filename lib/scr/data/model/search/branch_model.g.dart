// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branch_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BranchModel _$BranchModelFromJson(Map<String, dynamic> json) {
  return BranchModel(
    branchCode: json['branch_code'] as String?,
    branchName: json['branch_name'] as String?,
    cityCode: json['city_code'] as String?,
    bankNo: json['bank_no'] as String?,
  );
}

Map<String, dynamic> _$BranchModelToJson(BranchModel instance) =>
    <String, dynamic>{
      'branch_code': instance.branchCode,
      'branch_name': instance.branchName,
      'city_code': instance.cityCode,
      'bank_no': instance.bankNo,
    };
