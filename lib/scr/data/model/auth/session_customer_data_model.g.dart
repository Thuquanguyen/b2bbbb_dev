// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_customer_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SessionCustomerDataModel _$SessionCustomerDataModelFromJson(
    Map<String, dynamic> json) {
  return SessionCustomerDataModel(
    custName: json['cust_name'] as String?,
    custCif: json['cust_cif'] as String?,
    vipType: json['vip_type'] as String?,
    segment: json['segment'] as String?,
    custAddress: json['cust_address'] as String?,
    custType: json['cust_type'] as String?,
    sectorCode: json['sector_code'] as String?,
    custLegalId: json['cust_legal_id'] as String?,
    custGroup: (json['cust_group'] as List<dynamic>?)
        ?.map((e) => e as String)
        .toList(),
    levelCodeDisplay: json['level_code_display'] == null
        ? null
        : NameModel.fromJson(
            json['level_code_display'] as Map<String, dynamic>),
    servicePackageDisplay: json['service_package_display'] == null
        ? null
        : NameModel.fromJson(
            json['service_package_display'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SessionCustomerDataModelToJson(
        SessionCustomerDataModel instance) =>
    <String, dynamic>{
      'cust_name': instance.custName,
      'cust_cif': instance.custCif,
      'vip_type': instance.vipType,
      'segment': instance.segment,
      'cust_address': instance.custAddress,
      'cust_type': instance.custType,
      'sector_code': instance.sectorCode,
      'cust_legal_id': instance.custLegalId,
      'cust_group': instance.custGroup,
      'level_code_display': instance.levelCodeDisplay,
      'service_package_display': instance.servicePackageDisplay,
    };
