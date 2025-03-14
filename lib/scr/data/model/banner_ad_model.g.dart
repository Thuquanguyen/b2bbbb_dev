// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'banner_ad_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerAdModel _$BannerAdModelFromJson(Map<String, dynamic> json) {
  return BannerAdModel(
    img: json['img'] as String?,
    desc: json['desc'] as String?,
    href: json['href'] as String?,
  );
}

Map<String, dynamic> _$BannerAdModelToJson(BannerAdModel instance) =>
    <String, dynamic>{
      'img': instance.img,
      'desc': instance.desc,
      'href': instance.href,
    };
