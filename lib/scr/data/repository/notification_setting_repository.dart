import 'package:b2b/scr/core/api_service/api_endpoint.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/utilities/logger.dart';

abstract class NotificationSettingRepository {
  Future<BaseResponseModel<SingleResponse>> getAccountList();

  Future<BaseResponseModel<SingleResponse>> registerAccountNotification(
      String secureTrans, String accountNumber);

  Future<BaseResponseModel<SingleResponse>> dereRegisterAccountNotification(
      String secureTrans, String accountNumber, String aggregateId);
}

class NotificationSettingImpl extends NotificationSettingRepository {
  NotificationSettingImpl({required this.apiProvider}) : super();
  final ApiProviderRepositoryImpl apiProvider;

  @override
  Future<BaseResponseModel<SingleResponse>> getAccountList() async {
    try {
      final response = await apiProvider.getRequest(
          Endpoint.GET_LIST_ACCOUNT_SETTING_NOTIFICATION.value,
          queryParameters: null);
      return BaseResponseModel<SingleResponse>.fromJson(response.data ?? {});
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<BaseResponseModel<SingleResponse>> registerAccountNotification(
      String secureTrans, String accountNumber) async {
    try {
      final params = {
        'secure_trans': secureTrans,
        'account_number': accountNumber
      };
      final response = await apiProvider.postRequest(
          Endpoint.POST_REGISTER_ACCOUNT_NOTIFICATIONS.value,
          data: params);
      return BaseResponseModel<SingleResponse>.fromJson(response.data ?? {});
    } catch (e) {
      Logger.debug('registerLoginType: catch response error here');
      rethrow;
    }
  }

  @override
  Future<BaseResponseModel<SingleResponse>> dereRegisterAccountNotification(
      String secureTrans, String accountNumber, String aggregateId) async {
    try {
      final params = {
        'secure_trans': secureTrans,
        'account_number': accountNumber,
        'aggregate_id': aggregateId
      };
      final response = await apiProvider.putRequest(
          Endpoint.POST_DEREREGISTER_ACCOUNT_NOTIFICATIONS.value,
          data: params);
      Logger.debug(response);
      return BaseResponseModel<SingleResponse>.fromJson(response.data ?? {});
    } catch (e) {
      Logger.debug('registerLoginType: catch response error here');
      rethrow;
    }
  }
}
