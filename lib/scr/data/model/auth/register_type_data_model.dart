import 'package:json_annotation/json_annotation.dart';

part 'register_type_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class RegisterTypeDataModel {
  RegisterTypeDataModel({
    this.authenPasswd,
    this.authenType,
  });

  factory RegisterTypeDataModel.fromJson(Map<String, dynamic> json) => _$RegisterTypeDataModelFromJson(json);

  String? authenPasswd;
  int? authenType;

  Map<String, dynamic> toJson() => _$RegisterTypeDataModelToJson(this);
}
