// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_transfer_content_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationTransferContentModel _$NotificationTransferContentModelFromJson(
    Map<String, dynamic> json) {
  return NotificationTransferContentModel(
    bankId: json['bank_id'] as String?,
    amount: (json['amount'] as num?)?.toDouble(),
    userAppr: json['user_appr'] as String?,
    status: json['status'] as String?,
    functionType: json['function_type'] as String?,
    dateAction: json['date_action'] as String?,
    dateReceive: json['date_receive'] as String?,
    memo: json['memo'] as String?,
    transCode: json['trans_code'] as String?,
    hasRead: json['has_read'] as bool?,
    userReceive: json['user_receive'] as String?,
    debitAccount: json['debit_account'] as String?,
    debitCcy: json['debit_ccy'] as String?,
    id: json['id'] as String?,
  )..timeInDateTime = json['time_in_date_time'] == null
      ? null
      : DateTime.parse(json['time_in_date_time'] as String);
}

Map<String, dynamic> _$NotificationTransferContentModelToJson(
        NotificationTransferContentModel instance) =>
    <String, dynamic>{
      'bank_id': instance.bankId,
      'amount': instance.amount,
      'user_appr': instance.userAppr,
      'status': instance.status,
      'function_type': instance.functionType,
      'date_action': instance.dateAction,
      'date_receive': instance.dateReceive,
      'user_receive': instance.userReceive,
      'memo': instance.memo,
      'trans_code': instance.transCode,
      'time_in_date_time': instance.timeInDateTime?.toIso8601String(),
      'debit_ccy': instance.debitCcy,
      'debit_account': instance.debitAccount,
      'has_read': instance.hasRead,
      'id': instance.id,
    };
