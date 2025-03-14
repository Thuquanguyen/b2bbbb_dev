import 'package:b2b/scr/data/model/notification/notification_transfer_content_model.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_promote_content.g.dart';

/**
 * Content dạng html.
 * Define href, imgAction:
 * /transfer => vào ck
 * /saving => vào tạo tiền gửi
 * /bill => vào thanh toán hóa đơn
 * http,https => Mở link ngoài
 */

enum PromoteTye { transfer, saving, bill, link }

extension PromoteTyeExt on PromoteTye {
  String getHref() {
    switch (this) {
      case PromoteTye.transfer:
        return '/transfer';
      case PromoteTye.saving:
        return '/saving';
      case PromoteTye.bill:
        return '/bill';
      default:
        return '';
    }
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationPromoteContent {
  String? imageUrl;
  String? imgAction;
  String? content;
  double? id;
  String? backLink;
  String? dateCreated;

  NotificationPromoteContent({this.imageUrl, this.imgAction, this.content, this.id, this.backLink, this.dateCreated});

  factory NotificationPromoteContent.fromJson(Map<String, dynamic> json) => _$NotificationPromoteContentFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationPromoteContentToJson(this);
}
