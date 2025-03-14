import 'package:b2b/scr/data/model/notification/notification_promote_content.dart';
import 'package:b2b/scr/data/model/notification/notification_transfer_content_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_promote_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationPromoteModel {
  String? fcmRes;
  String? timeCommitFcm;
  String? username;
  String? timeRequest;
  bool? hasRead;
  NotificationPromoteContent? content;
  String? id;

  NotificationPromoteModel(
      {this.fcmRes,
      this.timeCommitFcm,
      this.username,
      this.timeRequest,
      this.hasRead,
      this.content,
      this.id});

  factory NotificationPromoteModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationPromoteModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationPromoteModelToJson(this);
}
