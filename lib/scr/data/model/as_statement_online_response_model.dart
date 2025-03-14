import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';
import 'package:b2b/scr/core/language/app_translate.dart';

part 'as_statement_online_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class StatementOnlineResponse {
  StatementOnlineResponse(this.result, this.data);

  final BaseResultModel result;
  @JsonKey(name: "data")
  final StatementOnlineData data;

  factory StatementOnlineResponse.fromJson(Map<String, dynamic> json) => _$StatementOnlineResponseFromJson(json);

  Map<String, dynamic> toJson() => _$StatementOnlineResponseToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class StatementOnlineData {
  StatementOnlineData(this.beginBal, this.endBal, this.stmtData);

  final double? beginBal;
  final double? endBal;
  final List<StmtData>? stmtData;

  factory StatementOnlineData.fromJson(Map<String, dynamic> json) => _$StatementOnlineDataFromJson(json);

  Map<String, dynamic> toJson() => _$StatementOnlineDataToJson(this);

  List<StmtDataGroup> get groupedStmtData {
    if (stmtData == null || stmtData?.isEmpty == true) return [];

    DateFormat displayFormat =
    DateFormat('dd MMMM yyyy', AppTranslate().currentLanguage.locale);
    DateFormat serverFormat = DateFormat('dd/MM/yyyy');
    List<StmtDataGroup> result = [];
    for (StmtData stm in stmtData!) {
      String stmDate = '';

      try {
        DateTime stmDateTime =
        serverFormat.parse(stm.commitTime ?? '');
        stmDate = displayFormat.format(stmDateTime);
      } catch (_) {}

      if (result.any((e) => e.date == stmDate)) {
        result.firstWhere((e) => e.date == stmDate).list.add(stm);
      } else {
        result.add(StmtDataGroup(list: [stm], date: stmDate));
      }
    }

    List<StmtDataGroup> sortedResult = [];
    for (StmtDataGroup tg in result) {
      tg.list.sort((a, b) {
        try {
          int diff = serverFormat
              .parse(b.commitTime ?? '')
              .compareTo(serverFormat.parse(a.commitTime ?? ''));
          return diff;
        } catch (_) {
          return 1;
        }
      });
      sortedResult.add(tg);
    }

    sortedResult.sort((a, b) {
      try {
        int diff =
        displayFormat.parse(b.date).compareTo(displayFormat.parse(a.date));
        return diff;
      } catch (_) {
        return 1;
      }
    });

    return sortedResult;
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class StmtData {
  StmtData(this.bookDate, this.txnAmtFcy, this.txnAmtLcy, this.valueDate, this.commitTime, this.stmtId, this.txnAcctId,
      this.txnCcy, this.txnCode, this.txnNarrative, this.txnRef, this.tnxRemainAmt, this.currBalance);

  final String? bookDate;
  final double? txnAmtFcy;
  final double? txnAmtLcy;
  final String? valueDate;
  final String? commitTime;
  final String? stmtId;
  final String? txnAcctId;
  final String? txnCcy;
  final String? txnCode;
  final String? txnNarrative;
  final String? txnRef;
  final double? tnxRemainAmt;
  final double? currBalance;

  double get amount {
    if (txnCcy?.toLowerCase() == 'vnd') {
      return txnAmtLcy ?? 0;
    } else {
      return txnAmtFcy ?? 0;
    }
  }

  factory StmtData.fromJson(Map<String, dynamic> json) => _$StmtDataFromJson(json);

  Map<String, dynamic> toJson() => _$StmtDataToJson(this);
}

class StmtDataGroup {
  final String date;
  final List<StmtData> list;

  StmtDataGroup({
    required this.date,
    required this.list,
  });
}
