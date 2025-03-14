import 'package:b2b/scr/data/model/notification/notification_transfer_content_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_transfer_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationTransferModel {
  String? fcmRes;
  String? timeCommitFcm;
  String? username;
  String? timeRequest;
  bool? hasRead;
  NotificationTransferContentModel? content;
  String? id;

  NotificationTransferModel(
      {this.fcmRes,
      this.timeCommitFcm,
      this.username,
      this.timeRequest,
      this.hasRead,
      this.content,
      this.id});

  factory NotificationTransferModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationTransferModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationTransferModelToJson(this);
}
