import 'dart:convert';
import 'package:b2b/scr/bloc/notification/NotificationPromotionState.dart';
import 'package:b2b/scr/data/model/notification/notification_promote_content.dart';
import 'package:b2b/scr/presentation/screens/notification/notification_page_content.dart';
import 'package:intl/intl.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:b2b/scr/data/model/bloc_model.dart';
import 'package:b2b/scr/data/model/notification/account_register_notification_model.dart';
import 'package:b2b/scr/data/model/notification/account_setting_noti_model.dart';
import 'package:b2b/scr/data/model/notification/notification_history_balance_model.dart';
import 'package:b2b/scr/data/model/notification/notification_model.dart';
import 'package:b2b/scr/data/model/notification/notification_transfer_content_model.dart';
import 'package:b2b/scr/data/model/notification/notification_transfer_model.dart';
import 'package:b2b/scr/data/repository/notification_repository.dart';
import 'package:b2b/scr/data/repository/notification_setting_repository.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:bloc/bloc.dart';

import '../../../commons.dart';
import '../../../constants.dart';
import '../../core/session/session_manager.dart';
import '../../data/model/notification/notification_promotion_response.dart';
import '../../presentation/screens/auth/account_manager.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc(
      {this.notificationRepository, this.notificationSettingRepository})
      : super(
          NotificationState(
            promotionState: NotificationPromotionState(calLoadMore: true),
          ),
        );

  NotificationRepository? notificationRepository;
  NotificationSettingRepository? notificationSettingRepository;

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event) async* {
    switch (event.runtimeType) {
      case NotiChangeActiveTabEvent:
        yield* _mapToChangeActiveTab(event as NotiChangeActiveTabEvent);
        break;
      case GetListAccountSettingNotiEvent:
        yield* _mapToGetListAccountNotificationSetting(
            event as GetListAccountSettingNotiEvent);
        break;
      case RegisterAccountNotificationEvent:
        yield* _mapRegisterAccountNotificationState(
            event as RegisterAccountNotificationEvent);
        break;
      case DereRegisterAccountNotificationEvent:
        yield* _mapDereRegisterAccountNotificationState(
            event as DereRegisterAccountNotificationEvent);
        break;
      case GetListHistoryBalanceAlertEvent:
        yield* _mapGetListHistoryBalanceAlertState(
            event as GetListHistoryBalanceAlertEvent);
        break;
      case GetListPaymentPendingAlertEvent:
        yield* _mapGetListPaymentPendingAlertState(
            event as GetListPaymentPendingAlertEvent);
        break;
      case GetListPromoteEvent:
        yield* _mapGetListPromote(event as GetListPromoteEvent);
        break;
      case HasReadNotificationEvent:
        yield* _maphasReadNotificationState(event as HasReadNotificationEvent);
        break;
      case HasReadPaymentPendingEvent:
        yield* _maphasReadNotificationPaymentPendingState(
            event as HasReadPaymentPendingEvent);
        break;
      case UpdateListAccountSettingEvent:
        if ((event as UpdateListAccountSettingEvent).accountSettingNotiModel !=
            null) {
          int indexModel = state.listAccountSetting?.indexWhere((element) =>
                  element.accountNumber ==
                  event.accountSettingNotiModel?.accountNumber) ??
              -1;
          if (indexModel != -1) {
            state.listAccountSetting?[indexModel] =
                event.accountSettingNotiModel!;
          }
          yield state.copyWith(
              listAccountSetting: state.listAccountSetting,
              listAccountSettingState: DataState.data);
        }
        break;
      default:
        break;
    }

    // if (event is NotiChangeActiveTabEvent) {
    //   yield* _mapToChangeActiveTab(event);
    // } else if (event is GetListAccountSettingNotiEvent) {
    //   yield* _mapToGetListAccountNotificationSetting(event);
    // } else if (event is RegisterAccountNotificationEvent) {
    //   yield* _mapRegisterAccountNotificationState(event);
    // } else if (event is DereRegisterAccountNotificationEvent) {
    //   yield* _mapDereRegisterAccountNotificationState(event);
    // } else if (event is GetListHistoryBalanceAlertEvent) {
    //   yield* _mapGetListHistoryBalanceAlertState(event);
    // } else if (event is GetListPaymentPendingAlertEvent) {
    //   yield* _mapGetListPaymentPendingAlertState(event);
    // } else if (event is GetListPromoteEvent) {
    //   yield* _mapGetListPromote(event);
    // } else if (event is HasReadNotificationEvent) {
    //   yield* _maphasReadNotificationState(event);
    // } else if (event is HasReadPaymentPendingEvent) {
    //   yield* _maphasReadNotificationPaymentPendingState(event);
    // } else if (event is UpdateListAccountSettingEvent) {
    //   if (event.accountSettingNotiModel != null) {
    //     int indexModel = state.listAccountSetting?.indexWhere((element) =>
    //             element.accountNumber ==
    //             event.accountSettingNotiModel?.accountNumber) ??
    //         -1;
    //     if (indexModel != -1) {
    //       state.listAccountSetting?[indexModel] =
    //           event.accountSettingNotiModel!;
    //     }
    //     yield state.copyWith(
    //         listAccountSetting: state.listAccountSetting,
    //         listAccountSettingState: DataState.data);
    //   }
    // }
  }

  Stream<NotificationState> _mapToChangeActiveTab(
      NotiChangeActiveTabEvent event) async* {
    int tabPosition = event.activeTab;
    print('_mapToChangeActiveTab $tabPosition');
    yield state.copyWith(currentPage: tabPosition);
  }

  Stream<NotificationState> _mapToGetListAccountNotificationSetting(
      GetListAccountSettingNotiEvent event) async* {
    yield state.copyWith(listAccountSettingState: DataState.preload);
    try {
      final response = await notificationSettingRepository?.getAccountList();
      if (response?.result!.isSuccess() ?? false) {
        final ListResponse<AccountSettingNotiModel> listAccount =
            ListResponse<AccountSettingNotiModel>(
          response?.data,
          (item) => AccountSettingNotiModel.fromJson(item),
        );
        yield state.copyWith(
            listAccountSetting: listAccount.items,
            listAccountSettingState: DataState.data);
      } else {
        throw response?.result as Object;
      }
    } on BaseResultModel catch (e) {
      Logger.debug('catch error and return fail here' + e.toString());
      yield state.copyWith(
          listAccountSettingState: DataState.error,
          errorMessage: (e is BaseResultModel)
              ? e.getMessage()
              : AppTranslate.i18n.havingAnErrorStr.localized);
    }
  }

  Stream<NotificationState> _maphasReadNotificationState(
      HasReadNotificationEvent event) async* {
    try {
      notificationRepository?.hasReadNotification(
          event.userName ?? '',
          event.id ?? '',
          event.hashSignature ?? '',
          event.tokenIdentity ?? '',
          event.module ?? '');

      int indexModel = state.listNotification?.indexWhere(
              (element) => element.id == event.notificationModel.id) ??
          -1;
      if (indexModel != -1 &&
          indexModel < (state.listNotification?.length ?? 0)) {
        state.listNotification?[indexModel] =
            event.notificationModel.copyWith(hasRead: true);
      }
      List<NotificationModel> tmpList = [];
      tmpList.addAll(state.listNotification ?? []);
      if (indexModel != -1 && indexModel < tmpList.length) {
        tmpList[indexModel] = event.notificationModel.copyWith(hasRead: true);
        List<BlocModel> listNotificationBloc = [];
        for (NotificationModel data in tmpList) {
          String time = data.timeInFormat();
          if (listNotificationBloc.isNotEmpty &&
              listNotificationBloc.last.date == time) {
            listNotificationBloc.last.listData.add(data);
          } else {
            BlocModel blocModel = BlocModel(
              time,
              <NotificationModel>[data],
            );
            listNotificationBloc.add(blocModel);
          }
        }
        yield state.copyWith(listNotificationBloc: listNotificationBloc);
      }
    } on BaseResultModel catch (e) {
      Logger.debug('catch error and return fail here' + e.toString());
      yield state.copyWith(
          errorMessage: (e is BaseResultModel)
              ? e.getMessage()
              : AppTranslate.i18n.havingAnErrorStr.localized);
    }
  }

  Stream<NotificationState> _maphasReadNotificationPaymentPendingState(
      HasReadPaymentPendingEvent event) async* {
    try {
      notificationRepository?.hasReadNotification(
          event.userName ?? '',
          event.id ?? '',
          event.hashSignature ?? '',
          event.tokenIdentity ?? '',
          event.module ?? '');

      int indexModel = state.listNotificationTransfer?.indexWhere(
              (element) => element.id == event.notificationModel.id) ??
          -1;
      if (indexModel != -1 &&
          indexModel < (state.listNotificationTransfer?.length ?? 0)) {
        state.listNotificationTransfer?[indexModel] =
            event.notificationModel.copyWith(hasRead: true);
      }
      List<NotificationTransferContentModel> tmpList = [];
      tmpList.addAll(state.listNotificationTransfer ?? []);

      if (indexModel != -1 && indexModel < tmpList.length) {
        tmpList[indexModel] = event.notificationModel.copyWith(hasRead: true);
        List<BlocModel> listNotificationBloc = [];
        for (NotificationTransferContentModel data in tmpList) {
          String time = data.timeInFormat();
          if (listNotificationBloc.isNotEmpty &&
              listNotificationBloc.last.date == time) {
            listNotificationBloc.last.listData.add(data);
          } else {
            BlocModel blocModel = BlocModel(
              time,
              <NotificationTransferContentModel>[data],
            );
            listNotificationBloc.add(blocModel);
          }
        }

        yield state.copyWith(listNotificationPending: listNotificationBloc);
      }
    } on BaseResultModel catch (e) {
      Logger.debug('catch error and return fail here' + e.toString());
      yield state.copyWith(
          errorMessage: (e is BaseResultModel)
              ? e.getMessage()
              : AppTranslate.i18n.havingAnErrorStr.localized);
    }
  }

  Stream<NotificationState> _mapGetListHistoryBalanceAlertState(
      GetListHistoryBalanceAlertEvent event) async* {
    yield state.copyWith(notificationState: DataState.preload);
    try {
      final response = await notificationRepository?.getListHistoryBalanceAlert(
          event.userName ?? '',
          event.hashSignature ?? '',
          event.tokenIdentity ?? '');

      if (response?.result!.isSuccess() ?? false) {
        final ListResponse<NotificationHistoryBalanceModel> listHistoryBalance =
            ListResponse<NotificationHistoryBalanceModel>(
          response?.data,
          (item) {
            return NotificationHistoryBalanceModel.fromJson(item);
          },
        );
        List<NotificationModel> _listNotification = [];
        listHistoryBalance.items.map((e) {
          if (e.content.isNotNullAndEmpty) {
            e.setContentDecrypt();
            if (e.contentDecrypted.isNotNullAndEmpty) {
              final json = jsonDecode(e.contentDecrypted!);

              NotificationModel notificationModel =
                  NotificationModel.fromJson(json);

              try {
                DateTime createdDateTime = DateFormat('d/M/yyyy HH:mm')
                    .parse(notificationModel.time ?? '');
                notificationModel.dateTime = createdDateTime;
              } catch (e) {
                Logger.debug("---------------Exception $e");
              }
              _listNotification.add(notificationModel);
            }
          }
        }).toList();

        for (int i = 0; i < listHistoryBalance.items.length; i++) {
          NotificationHistoryBalanceModel model = listHistoryBalance.items[i];
          _listNotification[i].hasRead = model.hasRead;
          // _listNotification[i].hasRead = false;
          _listNotification[i].id = model.id;
        }

        _listNotification.sort(
          (a, b) {
            if (a.dateTime == null ||
                b.dateTime == null ||
                a.dateTime == b.dateTime) {
              return 0;
            } else {
              return b.dateTime!.compareTo(a.dateTime!);
            }
          },
        );

        List<BlocModel> listNotificationBloc = [];
        for (NotificationModel data in _listNotification) {
          String time = data.timeInFormat();
          if (listNotificationBloc.isNotEmpty &&
              listNotificationBloc.last.date == time) {
            listNotificationBloc.last.listData.add(data);
          } else {
            BlocModel blocModel = BlocModel(
              time,
              <NotificationModel>[data],
            );
            listNotificationBloc.add(blocModel);
          }
        }

        yield state.copyWith(
            listNotificationBloc: listNotificationBloc,
            listNotification: _listNotification,
            notificationState: DataState.data);
      } else {
        throw response?.result as Object;
      }
    } on BaseResultModel catch (e) {
      Logger.debug('catch error and return fail here' + e.toString());
      yield state.copyWith(
          notificationState: DataState.error,
          errorMessage: (e is BaseResultModel)
              ? e.getMessage()
              : AppTranslate.i18n.havingAnErrorStr.localized);
    }
  }

  Stream<NotificationState> _mapGetListPaymentPendingAlertState(
      GetListPaymentPendingAlertEvent event) async* {
    yield state.copyWith(notificationPendingState: DataState.preload);
    try {
      final response = await notificationRepository?.getListPaymentPendingAlert(
          event.userName ?? '',
          event.hashSignature ?? '',
          event.tokenIdentity ?? '');

      if (response?.result!.isSuccess() ?? false) {
        final ListResponse<NotificationTransferModel> listPaymentPendings =
            ListResponse<NotificationTransferModel>(
          response?.data,
          (item) {
            return NotificationTransferModel.fromJson(item);
          },
        );
        List<NotificationTransferContentModel> _listNotification = [];
        listPaymentPendings.items.map((e) {
          if (e.content != null) {
            _listNotification.add(e.content!);
          }
        }).toList();
        for (int i = 0; i < listPaymentPendings.items.length; i++) {
          NotificationTransferModel model = listPaymentPendings.items[i];
          _listNotification[i].hasRead = model.hasRead;
          // _listNotification[i].hasRead = false;
          _listNotification[i].id = model.id;
        }

        _listNotification.sort(
          (a, b) => double.parse(b.dateAction ?? '0').compareTo(
            double.parse(a.dateAction ?? '0'),
          ),
        );
        List<BlocModel> listNotificationBloc = [];
        for (NotificationTransferContentModel data in _listNotification) {
          String time = data.timeInFormat();
          if (listNotificationBloc.isNotEmpty &&
              listNotificationBloc.last.date == time) {
            listNotificationBloc.last.listData.add(data);
          } else {
            BlocModel blocModel = BlocModel(
              time,
              <NotificationTransferContentModel>[data],
            );
            listNotificationBloc.add(blocModel);
          }
        }

        yield state.copyWith(
            listNotificationPending: listNotificationBloc,
            listNotificationTransfer: _listNotification,
            notificationPendingState: DataState.data);
      } else {
        throw response?.result as Object;
      }
    } on BaseResultModel catch (e) {
      Logger.debug('catch error and return fail here' + e.toString());
      yield state.copyWith(
          notificationPendingState: DataState.error,
          errorMessage: (e is BaseResultModel)
              ? e.getMessage()
              : AppTranslate.i18n.havingAnErrorStr.localized);
    }
  }

  Stream<NotificationState> _mapGetListPromote(
      GetListPromoteEvent event) async* {
    yield state.copyWith(
        promotionState: state.promotionState
            ?.copyWith(dataState: DataState.preload, currentPage: event.page));
    try {
      String hashSignature =
          AccountManager().currentUsername + '_' + SECURE_PASSWORD;
      hashSignature = encryptSha256(hashSignature);
      String userName = AccountManager().currentUsername;
      String tokenIdentity =
          SessionManager().userData?.tokenIdentityNotification ?? '';

      final response = await notificationRepository?.getListPromote(
          userName, hashSignature, tokenIdentity, event.page ?? 1);

      if (response?.result?.isSuccess() == true) {
        NotificationPromotionResponse? promotionResponse = response
            ?.toModel((json) => NotificationPromotionResponse.fromJson(json));

        List<NotificationPromoteContent>? contentList = [];

        if (state.promotionState?.currentPage == 1) {
          contentList = promotionResponse?.content;
        } else {
          state.promotionState?.listPromoteContent
              ?.addAll(promotionResponse?.content ?? []);
          contentList = state.promotionState?.listPromoteContent;
        }

        bool canLoadMore = true;
        if (promotionResponse?.content != null &&
            promotionResponse!.content!.isEmpty) {
          canLoadMore = false;
        }

        yield state.copyWith(
          promotionState: state.promotionState?.copyWith(
              dataState: DataState.data,
              listPromoteContent: contentList,
              calLoadMore: canLoadMore,),
        );
      } else {
        throw response?.result as Object;
      }
    } on BaseResultModel catch (e) {
      yield state.copyWith(
          promotionState:
              state.promotionState?.copyWith(dataState: DataState.error),
          errorMessage: (e is BaseResultModel)
              ? e.getMessage()
              : AppTranslate.i18n.havingAnErrorStr.localized);
    }
  }

  Stream<NotificationState> _mapRegisterAccountNotificationState(
      RegisterAccountNotificationEvent event) async* {
    // throw the loading state
    int indexModel = state.listAccountSetting?.indexWhere((element) =>
            element.accountNumber ==
            event.accountSettingNotiModel.accountNumber) ??
        -1;
    if (indexModel != -1) {
      state.listAccountSetting?[indexModel] =
          event.accountSettingNotiModel.copyWith(enable: true);
    }

    yield state.copyWith(
        registerAccountNotificationState: DataState.preload,
        listAccountSetting: state.listAccountSetting);
    try {
      final responseData =
          await notificationSettingRepository?.registerAccountNotification(
              event.secureTrans ?? '', event.accountNumber ?? '');
      if (responseData?.result?.isSuccess() ?? false) {
        final SingleResponse<AccountRegisterNotificationModel> data =
            SingleResponse<AccountRegisterNotificationModel>(
          responseData?.data,
          (item) => AccountRegisterNotificationModel.fromJson(item),
        );

        if (indexModel != -1) {
          state.listAccountSetting?[indexModel] = event.accountSettingNotiModel
              .copyWith(
                  enable: true,
                  secureTrans: data.item.secureTrans,
                  aggregateId: data.item.aggregateId);
        }

        yield state.copyWith(
            dataRegister: data.item,
            listAccountSetting: state.listAccountSetting,
            registerAccountNotificationState: DataState.data);
      } else {
        throw responseData?.data as Object;
      }
    } catch (e) {
      Logger.debug('catch error and return fail here' + e.toString());
      yield state.copyWith(
          registerAccountNotificationState: DataState.error,
          accountSettingNotiModel: event.accountSettingNotiModel,
          listAccountSetting: state.listAccountSetting,
          errorMessage: (e is BaseResultModel)
              ? e.getMessage()
              : AppTranslate.i18n.havingAnErrorStr.localized);
    }
  }

  Stream<NotificationState> _mapDereRegisterAccountNotificationState(
      DereRegisterAccountNotificationEvent event) async* {
    // throw the loading state
    int indexModel = state.listAccountSetting?.indexWhere((element) =>
            element.accountNumber ==
            event.accountSettingNotiModel.accountNumber) ??
        -1;
    if (indexModel != -1) {
      state.listAccountSetting?[indexModel] =
          event.accountSettingNotiModel.copyWith(enable: false);
    }
    yield state.copyWith(
        registerAccountNotificationState: DataState.preload,
        listAccountSetting: state.listAccountSetting);
    try {
      final responseData =
          await notificationSettingRepository?.dereRegisterAccountNotification(
              event.secureTrans ?? '',
              event.accountNumber ?? '',
              event.aggregateId ?? '');
      if (responseData?.result?.isSuccess() ?? false) {
        final SingleResponse<AccountRegisterNotificationModel> data =
            SingleResponse<AccountRegisterNotificationModel>(
          responseData?.data,
          (item) => AccountRegisterNotificationModel.fromJson(item),
        );

        if (indexModel != -1) {
          state.listAccountSetting?[indexModel] = event.accountSettingNotiModel
              .copyWith(secureTrans: data.item.secureTrans, enable: false);
        }

        yield state.copyWith(
            dataRegister: data.item,
            listAccountSetting: state.listAccountSetting,
            registerAccountNotificationState: DataState.data);
      } else {
        throw responseData?.data as Object;
      }
    } catch (e) {
      Logger.debug('catch error and return fail here' + e.toString());
      yield state.copyWith(
          registerAccountNotificationState: DataState.error,
          accountSettingNotiModel: event.accountSettingNotiModel,
          listAccountSetting: state.listAccountSetting,
          errorMessage: (e is BaseResultModel)
              ? e.getMessage()
              : AppTranslate.i18n.havingAnErrorStr.localized);
    }
  }
}
