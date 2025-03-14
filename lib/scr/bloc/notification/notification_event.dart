import 'package:b2b/scr/data/model/notification/account_setting_noti_model.dart';
import 'package:b2b/scr/data/model/notification/notification_model.dart';
import 'package:b2b/scr/data/model/notification/notification_transfer_content_model.dart';

abstract class NotificationEvent {}

class NotiChangeActiveTabEvent extends NotificationEvent {
  int activeTab;

  NotiChangeActiveTabEvent(this.activeTab);
}

class GetListAccountSettingNotiEvent extends NotificationEvent {
  GetListAccountSettingNotiEvent();
}

class HasReadPaymentPendingEvent extends NotificationEvent {
  final String? userName;
  final String? id;
  final String? hashSignature;
  final String? tokenIdentity;
  final String? module;
  final NotificationTransferContentModel notificationModel;

  HasReadPaymentPendingEvent(
      {this.userName,
      this.id,
      this.hashSignature,
      this.tokenIdentity,
      this.module,
      required this.notificationModel});
}

class HasReadNotificationEvent extends NotificationEvent {
  final String? userName;
  final String? id;
  final String? hashSignature;
  final String? tokenIdentity;
  final String? module;
  final NotificationModel notificationModel;

  HasReadNotificationEvent(
      {this.userName,
      this.id,
      this.hashSignature,
      this.tokenIdentity,
      this.module,
      required this.notificationModel});
}

class GetListHistoryBalanceAlertEvent extends NotificationEvent {
  final String? userName;
  final String? hashSignature;
  final String? tokenIdentity;

  GetListHistoryBalanceAlertEvent(
      {this.userName, this.hashSignature, this.tokenIdentity});
}

class GetListPaymentPendingAlertEvent extends NotificationEvent {
  final String? userName;
  final String? hashSignature;
  final String? tokenIdentity;

  GetListPaymentPendingAlertEvent(
      {this.userName, this.hashSignature, this.tokenIdentity});
}

class GetListPromoteEvent extends NotificationEvent {
  final String? userName;
  final String? hashSignature;
  final String? tokenIdentity;
  final int? page;

  GetListPromoteEvent(
      {this.userName, this.hashSignature, this.tokenIdentity, this.page = 1});
}

class UpdateListAccountSettingEvent extends NotificationEvent {
  final AccountSettingNotiModel? accountSettingNotiModel;

  UpdateListAccountSettingEvent({this.accountSettingNotiModel});
}

class RegisterAccountNotificationEvent extends NotificationEvent {
  final String? secureTrans;
  final String? accountNumber;
  final AccountSettingNotiModel accountSettingNotiModel;

  RegisterAccountNotificationEvent(
      {this.secureTrans,
      this.accountNumber,
      required this.accountSettingNotiModel});
}

class DereRegisterAccountNotificationEvent extends NotificationEvent {
  final String? secureTrans;
  final String? accountNumber;
  final String? aggregateId;
  final AccountSettingNotiModel accountSettingNotiModel;

  DereRegisterAccountNotificationEvent(
      {this.secureTrans,
      this.accountNumber,
      this.aggregateId,
      required this.accountSettingNotiModel});
}

class LoadMorePromotionEvent extends NotificationEvent {}
