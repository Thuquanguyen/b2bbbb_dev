import 'package:json_annotation/json_annotation.dart';

part 'city_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CityModel{
  CityModel({this.cityCode,this.cityName});
  final String? cityName;
  final String? cityCode;

  factory CityModel.fromJson(Map<String,dynamic> json) => _$CityModelFromJson(json);

  Map<String,dynamic> toJson() => _$CityModelToJson(this);
}