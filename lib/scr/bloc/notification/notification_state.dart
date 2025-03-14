import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/notification/NotificationPromotionState.dart';
import 'package:b2b/scr/data/model/bloc_model.dart';
import 'package:b2b/scr/data/model/notification/account_register_notification_model.dart';
import 'package:b2b/scr/data/model/notification/account_setting_noti_model.dart';
import 'package:b2b/scr/data/model/notification/notification_item_data.dart';
import 'package:b2b/scr/data/model/notification/notification_model.dart';
import 'package:b2b/scr/data/model/notification/notification_promote_content.dart';
import 'package:b2b/scr/data/model/notification/notification_transfer_content_model.dart';
import 'package:b2b/scr/presentation/screens/notification/notification_enum.dart';
import 'package:equatable/equatable.dart';

class NotificationState extends Equatable {
  int currentPage = 0;

  NotificationState({
    this.currentPage = 0,
    this.listData,
    this.listAccountSetting,
    this.listAccountSettingState = DataState.init,
    this.listNotificationTransfer,
    this.listNotificationBloc,
    this.listNotificationPending,
    this.notificationPendingState,
    this.listNotification,
    this.notificationState,
    this.dataRegister,
    this.registerAccountNotificationState,
    this.dataDereRegister,
    this.dereRegisterAccountNotificationState,
    this.errorMessage,
    this.accountSettingNotiModel,
    this.reload = false,
    this.promotionState ,
  });

  List<NotificationItemData>? listData = [
    NotificationItemData(type: NotificationWidgetType.DATE, data: 1),
    NotificationItemData(
        type: NotificationWidgetType.PENDING_TRANSACTION, data: 1),
    NotificationItemData(
        type: NotificationWidgetType.PENDING_TRANSACTION, data: 1),
    NotificationItemData(type: NotificationWidgetType.BALANCE_CHANGE, data: 1),
    NotificationItemData(type: NotificationWidgetType.BALANCE_CHANGE, data: 1),
    NotificationItemData(
        type: NotificationWidgetType.PENDING_TRANSACTION, data: 1),
    NotificationItemData(type: NotificationWidgetType.PROMOTION, data: 1),
    NotificationItemData(type: NotificationWidgetType.DATE, data: 1),
    NotificationItemData(type: NotificationWidgetType.PROMOTION, data: 1),
  ];

  NotificationState copyWith(
      {int? currentPage,
      List<NotificationItemData>? listData,
      List<AccountSettingNotiModel>? listAccountSetting,
      List<NotificationModel>? listNotification,
      List<NotificationTransferContentModel>? listNotificationTransfer,
      List<BlocModel>? listNotificationBloc,
      List<BlocModel>? listNotificationPending,
      DataState? notificationState,
      DataState? notificationPendingState,
      DataState? listAccountSettingState,
      DataState? registerAccountNotificationState,
      AccountRegisterNotificationModel? dataRegister,
      DataState? dereRegisterAccountNotificationState,
      AccountRegisterNotificationModel? dataDereRegister,
      String? errorMessage,
      AccountSettingNotiModel? accountSettingNotiModel,
      bool? reload,
      NotificationPromotionState? promotionState}) {
    return NotificationState(
        currentPage: currentPage ?? this.currentPage,
        listData: listData ?? this.listData,
        listAccountSetting: listAccountSetting ?? this.listAccountSetting,
        listNotificationTransfer:
            listNotificationTransfer ?? this.listNotificationTransfer,
        listNotification: listNotification ?? this.listNotification,
        listNotificationBloc: listNotificationBloc ?? this.listNotificationBloc,
        notificationState: notificationState ?? this.notificationState,
        listNotificationPending:
            listNotificationPending ?? this.listNotificationPending,
        notificationPendingState:
            notificationPendingState ?? this.notificationPendingState,
        listAccountSettingState:
            listAccountSettingState ?? this.listAccountSettingState,
        dataRegister: dataRegister ?? this.dataRegister,
        registerAccountNotificationState: registerAccountNotificationState ??
            this.registerAccountNotificationState,
        dataDereRegister: dataDereRegister ?? this.dataDereRegister,
        dereRegisterAccountNotificationState:
            dereRegisterAccountNotificationState ??
                this.dereRegisterAccountNotificationState,
        errorMessage: errorMessage,
        accountSettingNotiModel: accountSettingNotiModel,
        reload: reload == true ? !(this.reload ?? false) : this.reload,
        promotionState: promotionState ?? this.promotionState);
  }

  final List<AccountSettingNotiModel>? listAccountSetting;
  final List<NotificationModel>? listNotification;
  final List<NotificationTransferContentModel>? listNotificationTransfer;
  final List<BlocModel>? listNotificationBloc;
  final List<BlocModel>? listNotificationPending;
  final DataState? notificationPendingState;
  final DataState? notificationState;
  final AccountRegisterNotificationModel? dataRegister;
  final DataState? registerAccountNotificationState;
  final AccountRegisterNotificationModel? dataDereRegister;
  final DataState? dereRegisterAccountNotificationState;
  final DataState? listAccountSettingState;
  final bool? reload;
  final AccountSettingNotiModel? accountSettingNotiModel;
  final String? errorMessage;

  final NotificationPromotionState? promotionState ;

  @override
  List<Object?> get props => [
        currentPage,
        listData,
        listAccountSetting,
        listAccountSettingState,
        reload,
        registerAccountNotificationState,
        dereRegisterAccountNotificationState,
        listNotification,
        notificationState,
        listNotificationBloc,
        listNotificationPending,
        notificationPendingState,
        listNotificationTransfer,
        notificationPendingState,
        promotionState
      ];
}
