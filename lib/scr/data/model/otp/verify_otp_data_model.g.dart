// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'verify_otp_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VerifyOtpDataModel _$VerifyOtpDataModelFromJson(Map<String, dynamic> json) {
  return VerifyOtpDataModel(
    createdDate: json['created_date'] as String?,
    bankId: json['bank_id'] as String?,
    transCode: json['trans_code'] as String?,
    azContractContent: json['az_contract_content'] as String?,
    azContractContentByte: json['az_contract_content_byte'] as String?,
    approved: json['approved'] as bool?,
  );
}

Map<String, dynamic> _$VerifyOtpDataModelToJson(VerifyOtpDataModel instance) =>
    <String, dynamic>{
      'created_date': instance.createdDate,
      'bank_id': instance.bankId,
      'trans_code': instance.transCode,
      'az_contract_content': instance.azContractContent,
      'az_contract_content_byte': instance.azContractContentByte,
      'approved': instance.approved,
    };
