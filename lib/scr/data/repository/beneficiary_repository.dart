import 'dart:convert';

import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/model/transfer/benefician_account_model.dart';
import 'package:flutter/services.dart';

abstract class BeneficiaryRepository {
  Future<SingleResponse<dynamic>> getListBeneficiary(String username);
}

class BeneficiaryRepositoryImpl extends BeneficiaryRepository {
  BeneficiaryRepositoryImpl({required this.apiProvider}) : super();

  final ApiProviderRepository apiProvider;

  @override
  Future<SingleResponse<BaseResponseModel<BeneficianAccountModel>>> getListBeneficiary(String username) async {
    try {
      final String data = await rootBundle.loadString('assets/datas/data_beneficiary.json');
      final Map<String, dynamic> beneficiaryDataJson = await json.decode(data);
      return SingleResponse<BaseResponseModel<BeneficianAccountModel>>(beneficiaryDataJson, (dynamic item) {
        return BaseResponseModel.fromJson(item);
      });
    } catch (e) {
      rethrow;
    }
  }
}
