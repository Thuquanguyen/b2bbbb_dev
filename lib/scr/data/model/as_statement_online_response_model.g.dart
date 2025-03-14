// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'as_statement_online_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatementOnlineResponse _$StatementOnlineResponseFromJson(
    Map<String, dynamic> json) {
  return StatementOnlineResponse(
    BaseResultModel.fromJson(json['result'] as Map<String, dynamic>),
    StatementOnlineData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$StatementOnlineResponseToJson(
        StatementOnlineResponse instance) =>
    <String, dynamic>{
      'result': instance.result,
      'data': instance.data,
    };

StatementOnlineData _$StatementOnlineDataFromJson(Map<String, dynamic> json) {
  return StatementOnlineData(
    (json['begin_bal'] as num?)?.toDouble(),
    (json['end_bal'] as num?)?.toDouble(),
    (json['stmt_data'] as List<dynamic>?)
        ?.map((e) => StmtData.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$StatementOnlineDataToJson(
        StatementOnlineData instance) =>
    <String, dynamic>{
      'begin_bal': instance.beginBal,
      'end_bal': instance.endBal,
      'stmt_data': instance.stmtData,
    };

StmtData _$StmtDataFromJson(Map<String, dynamic> json) {
  return StmtData(
    json['book_date'] as String?,
    (json['txn_amt_fcy'] as num?)?.toDouble(),
    (json['txn_amt_lcy'] as num?)?.toDouble(),
    json['value_date'] as String?,
    json['commit_time'] as String?,
    json['stmt_id'] as String?,
    json['txn_acct_id'] as String?,
    json['txn_ccy'] as String?,
    json['txn_code'] as String?,
    json['txn_narrative'] as String?,
    json['txn_ref'] as String?,
    (json['tnx_remain_amt'] as num?)?.toDouble(),
    (json['curr_balance'] as num?)?.toDouble(),
  );
}

Map<String, dynamic> _$StmtDataToJson(StmtData instance) => <String, dynamic>{
      'book_date': instance.bookDate,
      'txn_amt_fcy': instance.txnAmtFcy,
      'txn_amt_lcy': instance.txnAmtLcy,
      'value_date': instance.valueDate,
      'commit_time': instance.commitTime,
      'stmt_id': instance.stmtId,
      'txn_acct_id': instance.txnAcctId,
      'txn_ccy': instance.txnCcy,
      'txn_code': instance.txnCode,
      'txn_narrative': instance.txnNarrative,
      'txn_ref': instance.txnRef,
      'tnx_remain_amt': instance.tnxRemainAmt,
      'curr_balance': instance.currBalance,
    };
