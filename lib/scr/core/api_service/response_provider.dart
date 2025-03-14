import 'package:b2b/scr/data/model/base_result_model.dart';

class ResponseProvider {
  ResponseProvider({this.data, required this.result});

  factory ResponseProvider.fromJson(Map<String, dynamic> rawRes) {
    final BaseResultModel result = BaseResultModel.fromJson(rawRes['result']);
    final dynamic data = rawRes['data'];

    return ResponseProvider(
      result: result,
      data: data,
    );
  }

  BaseResultModel result;
  Map<String, dynamic>? data;
}
