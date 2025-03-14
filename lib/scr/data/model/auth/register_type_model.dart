import 'package:json_annotation/json_annotation.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:b2b/scr/data/model/auth/register_type_data_model.dart';

part 'register_type_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RegisterTypeModel {
  RegisterTypeModel({
    this.result,
    this.data,
  });

  factory RegisterTypeModel.fromJson(Map<String, dynamic> json) => _$RegisterTypeModelFromJson(json);

  BaseResultModel? result;
  RegisterTypeDataModel? data;

  Map<String, dynamic> toJson() => _$RegisterTypeModelToJson(this);
}
