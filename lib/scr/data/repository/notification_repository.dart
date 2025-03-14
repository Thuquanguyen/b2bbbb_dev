import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/model/notification/notification_promotion_response.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:dio/dio.dart';
import '../model/notification/notification_promote_content.dart';

abstract class NotificationRepository {
  Future<BaseResponseModel<SingleResponse>> getListHistoryBalanceAlert(
      String userName, String hashSignature, String tokenIdentity);

  Future<BaseResponseModel<SingleResponse>> getListPaymentPendingAlert(
      String userName, String hashSignature, String tokenIdentity);

  Future<BaseResponseModel<SingleResponse>> hasReadNotification(String userName,
      String id, String hashSignature, String tokenIdentity, String module);

  Future<BaseResponseModel<NotificationPromotionResponse>> getListPromote(
      String userName, String hashSignature, String tokenIdentity, int page);
}

class NotificationRepositoryImpl extends NotificationRepository {
  late ApiProviderRepositoryImpl _apiProvider;
  late ApiProviderRepositoryFireBaseImpl _apiProviderFireBase;
  static final NotificationRepositoryImpl _singleton =
      NotificationRepositoryImpl._();

  factory NotificationRepositoryImpl(
      ApiProviderRepositoryImpl apiProviderRepositoryImpl,
      ApiProviderRepositoryFireBaseImpl apiProviderFirebaseRepositoryImpl) {
    _singleton._apiProvider = apiProviderRepositoryImpl;
    _singleton._apiProviderFireBase = apiProviderFirebaseRepositoryImpl;
    return _singleton;
  }

  NotificationRepositoryImpl._();

  @override
  Future<BaseResponseModel<SingleResponse>> getListHistoryBalanceAlert(
      String userName, String hashSignature, String tokenIdentity) async {
    try {
      final params = {
        'username': userName,
        'hash_signature': hashSignature,
        'token_identity_notification': tokenIdentity
      };
      final response = await _apiProviderFireBase.postRequest(
          Endpoint.GET_LIST_HISTORY_BALANCE_ALERT.value,
          data: params);
      return BaseResponseModel<SingleResponse>.fromJson(response.data ?? {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponseModel<SingleResponse>> hasReadNotification(
      String userName,
      String id,
      String hashSignature,
      String tokenIdentity,
      String module) async {
    try {
      final params = {
        'username': userName,
        'id': id,
        'hash_signature': hashSignature,
        'token_identity_notification': tokenIdentity,
        'module': module,
      };
      final response = await _apiProviderFireBase.postRequest(
          Endpoint.POST_HAS_READ_NOTIFICATIONS.value,
          data: params);
      return BaseResponseModel<SingleResponse>.fromJson(response.data ?? {});
    } catch (e) {
      Logger.debug('hasReadNotification error $e');
      rethrow;
    }
  }

  @override
  Future<BaseResponseModel<SingleResponse>> getListPaymentPendingAlert(
      String userName, String hashSignature, String tokenIdentity) async {
    try {
      final params = {
        'username': userName,
        'hash_signature': hashSignature,
        'token_identity_notification': tokenIdentity
      };
      final response = await _apiProviderFireBase.postRequest(
          Endpoint.GET_LIST_PAYMENT_PENDING_ALERT.value,
          data: params);
      return BaseResponseModel<SingleResponse>.fromJson(response.data ?? {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponseModel<NotificationPromotionResponse>> getListPromote(
      String userName,
      String hashSignature,
      String tokenIdentity,
      int page) async {
    try {
      final response = await _apiProvider.postRequest(
        Endpoint.GET_LIST_NOTIFICATION_PROMOTE.value,
        data: {
          'username': userName,
          // 'hash_signature': hashSignature,
          'token_identity_notification': tokenIdentity,
          'page_index': page
        },
      );

      return BaseResponseModel<NotificationPromotionResponse>.fromJson(
          response.data ?? {});
    } catch (e) {
      rethrow;
    }
  }
}
