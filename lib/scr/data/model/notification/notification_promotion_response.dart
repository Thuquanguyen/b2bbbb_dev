import 'package:b2b/scr/data/model/notification/notification_promote_content.dart';

class NotificationPromotionResponse {
  int? page;
  List<NotificationPromoteContent>? content;

  NotificationPromotionResponse({this.page, this.content});

  NotificationPromotionResponse.fromJson(Map<String, dynamic> json) {
    page = json['page_index']?.toInt();
    if (json['list_notification'] != null) {
      final v = json['list_notification'];
      final arr0 = <NotificationPromoteContent>[];
      v.forEach((v) {
        arr0.add(NotificationPromoteContent.fromJson(v));
      });
      content = arr0;
    }
  }
}
