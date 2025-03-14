// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'find_atm_marker_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FindATMMarkerModel _$FindATMMarkerModelFromJson(Map<String, dynamic> json) {
  return FindATMMarkerModel(
    json['id'] as String,
    json['title'] as String,
    json['updated'] as String,
    json['category'] as String?,
    json['link'] == null
        ? null
        : ATMParamLink.fromJson(json['link'] as Map<String, dynamic>),
    ATMContentProperties.fromJson(json['content'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$FindATMMarkerModelToJson(FindATMMarkerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'updated': instance.updated,
      'category': instance.category,
      'link': instance.link,
      'content': instance.content,
    };

ATMParamLink _$ATMParamLinkFromJson(Map<String, dynamic> json) {
  return ATMParamLink(
    json['m:inline'] == null
        ? null
        : ATMParamFeeds.fromJson(json['m:inline'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ATMParamLinkToJson(ATMParamLink instance) =>
    <String, dynamic>{
      'm:inline': instance.mInline,
    };

ATMParamFeeds _$ATMParamFeedsFromJson(Map<String, dynamic> json) {
  return ATMParamFeeds(
    json['feed'] == null
        ? null
        : ATMLink.fromJson(json['feed'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ATMParamFeedsToJson(ATMParamFeeds instance) =>
    <String, dynamic>{
      'feed': instance.feed,
    };

ATMLink _$ATMLinkFromJson(Map<String, dynamic> json) {
  return ATMLink(
    json['id'] as String,
    json['title'] as String,
    json['updated'] as String,
    ATMLinkAuthor.fromJson(json['author'] as Map<String, dynamic>),
    json['link'] as String?,
    (json['entry'] as List<dynamic>)
        .map((e) => ATMLinkEntry.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$ATMLinkToJson(ATMLink instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'updated': instance.updated,
      'author': instance.author,
      'link': instance.link,
      'entry': instance.entry,
    };

ATMLinkAuthor _$ATMLinkAuthorFromJson(Map<String, dynamic> json) {
  return ATMLinkAuthor(
    json['feed'] == null
        ? null
        : ATMLinkAuthorName.fromJson(json['feed'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ATMLinkAuthorToJson(ATMLinkAuthor instance) =>
    <String, dynamic>{
      'feed': instance.feed,
    };

ATMLinkAuthorName _$ATMLinkAuthorNameFromJson(Map<String, dynamic> json) {
  return ATMLinkAuthorName(
    json['name'] as String?,
  );
}

Map<String, dynamic> _$ATMLinkAuthorNameToJson(ATMLinkAuthorName instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

ATMLinkEntry _$ATMLinkEntryFromJson(Map<String, dynamic> json) {
  return ATMLinkEntry(
    json['id'] as String,
    json['title'] as String,
    json['updated'] as String,
    json['category'] as String?,
    json['link'] as String?,
    ATMLinkContentProperties.fromJson(json['content'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ATMLinkEntryToJson(ATMLinkEntry instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'updated': instance.updated,
      'category': instance.category,
      'link': instance.link,
      'content': instance.content,
    };

ATMLinkContentProperties _$ATMLinkContentPropertiesFromJson(
    Map<String, dynamic> json) {
  return ATMLinkContentProperties(
    json['m:properties'] == null
        ? null
        : ATMLinkContentValue.fromJson(
            json['m:properties'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ATMLinkContentPropertiesToJson(
        ATMLinkContentProperties instance) =>
    <String, dynamic>{
      'm:properties': instance.value,
    };

ATMLinkContentValue _$ATMLinkContentValueFromJson(Map<String, dynamic> json) {
  return ATMLinkContentValue(
    json['d:Value'] as String?,
  );
}

Map<String, dynamic> _$ATMLinkContentValueToJson(
        ATMLinkContentValue instance) =>
    <String, dynamic>{
      'd:Value': instance.value,
    };

ATMContentProperties _$ATMContentPropertiesFromJson(Map<String, dynamic> json) {
  return ATMContentProperties(
    ATMProperties.fromJson(json['m:properties'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ATMContentPropertiesToJson(
        ATMContentProperties instance) =>
    <String, dynamic>{
      'm:properties': instance.properties,
    };

ATMProperties _$ATMPropertiesFromJson(Map<String, dynamic> json) {
  return ATMProperties(
    json['d:Id'] as String,
    json['d:Name'] as String,
    json['d:Type'] as String,
    json['d:Latitude'] as String,
    json['d:Longitude'] as String,
    json['d:Distance'] as String?,
    json['d:DistanceUnit'] as String,
    ATMAddress.fromJson(json['d:Address'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ATMPropertiesToJson(ATMProperties instance) =>
    <String, dynamic>{
      'd:Id': instance.id,
      'd:Name': instance.name,
      'd:Type': instance.type,
      'd:Latitude': instance.latitude,
      'd:Longitude': instance.longitude,
      'd:Distance': instance.distance,
      'd:DistanceUnit': instance.distanceUnit,
      'd:Address': instance.address,
    };

ATMAddress _$ATMAddressFromJson(Map<String, dynamic> json) {
  return ATMAddress(
    json['d:Street'] as String,
    json['d:Street2'] as String?,
    json['d:Street3'] as String?,
    json['d:City'] as String,
    json['d:State'] as String?,
    json['d:StreetCode'] as String?,
    json['d:Country'] as String,
    json['d:Email'] as String?,
    json['d:Phone'] as String,
    json['d:Phone2'] as String?,
    json['d:ZipCode'] as String?,
    json['d:DataPhone'] as String?,
    json['d:FaxPhone'] as String,
    json['d:PreferredContactMethod'] as String?,
    json['d:preferredLanguage'] as String?,
  );
}

Map<String, dynamic> _$ATMAddressToJson(ATMAddress instance) =>
    <String, dynamic>{
      'd:Street': instance.street,
      'd:Street2': instance.street2,
      'd:Street3': instance.street3,
      'd:City': instance.city,
      'd:State': instance.state,
      'd:StreetCode': instance.streetCode,
      'd:Country': instance.country,
      'd:Email': instance.email,
      'd:Phone': instance.phone,
      'd:Phone2': instance.phone2,
      'd:ZipCode': instance.zipcode,
      'd:DataPhone': instance.dataPhone,
      'd:FaxPhone': instance.faxPhone,
      'd:PreferredContactMethod': instance.preferredContactMethod,
      'd:preferredLanguage': instance.preferredLanguage,
    };
