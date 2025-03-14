import 'package:json_annotation/json_annotation.dart';

part 'banner_ad_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class BannerAdModel {
  BannerAdModel({
    this.img,
    this.desc,
    this.href,
  });

  String? img;
  String? desc;
  String? href;

  factory BannerAdModel.fromJson(Map<String, dynamic> json) => _$BannerAdModelFromJson(json);
  Map<String, dynamic> toJson() => _$BannerAdModelToJson(this);
}
