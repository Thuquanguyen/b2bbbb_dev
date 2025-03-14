import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';

part 'base_response_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BaseResponseModel<T> {
  BaseResponseModel({
    this.result,
    this.data,
  });

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) => _$BaseResponseModelFromJson(json);
  BaseResultModel? result;
  dynamic data;

  Map<String, dynamic> toJson() => _$BaseResponseModelToJson(this);

  T? toModel(T Function(Map<String, dynamic> json) modelConverter) {
    if (data == null) return null;
    if (data is Map<String,dynamic>) {
      return modelConverter(data!);
    }
    return null;
  }

  List<T> toArrayModel(T Function(dynamic json) modelConverter) {
    List<T> items = [];
    if (data == null) return items;
    final List? list = data as List;
    if (list != null) {
      items.addAll(list.map((e) => modelConverter(e)).toList());
    }
    return items;
  }
}
