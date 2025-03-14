import 'package:b2b/commons.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:b2b/constants.dart';
part 'notification_history_balance_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationHistoryBalanceModel {
  final String? timeRequest;
  final String? username;
  final String? timeCommitFcm;
  final String? fcmRes;
  final bool? hasRead;
  final String? id;
  String? content;
  String? contentDecrypted;

  NotificationHistoryBalanceModel({this.timeRequest, this.username,this.timeCommitFcm,this.fcmRes,this.hasRead,this.id,this.content});

  factory NotificationHistoryBalanceModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationHistoryBalanceModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$NotificationHistoryBalanceModelToJson(this);

  String setContentDecrypt() {
    contentDecrypted = decryptAES(content ?? '', SECURE_PASSWORD);
    return contentDecrypted ?? '';
  }
}
