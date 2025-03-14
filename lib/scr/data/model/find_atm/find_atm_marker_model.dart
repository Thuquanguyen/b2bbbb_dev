import 'package:json_annotation/json_annotation.dart';

part 'find_atm_marker_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class FindATMMarkerModel {
  FindATMMarkerModel(
    this.id,
    this.title,
    this.updated,
    this.category,
    this.link,
    this.content,
  );
  final String id;
  final String title;
  final String updated;
  final String? category;
  final ATMParamLink? link;
  final ATMContentProperties content;

  factory FindATMMarkerModel.fromJson(Map<String, dynamic> json) =>
      _$FindATMMarkerModelFromJson(json);

  Map<String, dynamic> toJson() => _$FindATMMarkerModelToJson(this);
}

@JsonSerializable()
class ATMParamLink {
  ATMParamLink(this.mInline);
  @JsonKey(name: "m:inline")
  final ATMParamFeeds? mInline;

  factory ATMParamLink.fromJson(Map<String, dynamic> json) =>
      _$ATMParamLinkFromJson(json);

  Map<String, dynamic> toJson() => _$ATMParamLinkToJson(this);
}

@JsonSerializable()
class ATMParamFeeds {
  ATMParamFeeds(this.feed);
  final ATMLink? feed;

  factory ATMParamFeeds.fromJson(Map<String, dynamic> json) =>
      _$ATMParamFeedsFromJson(json);

  Map<String, dynamic> toJson() => _$ATMParamFeedsToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ATMLink {
  ATMLink(
    this.id,
    this.title,
    this.updated,
    this.author,
    this.link,
    this.entry,
  );
  final String id;
  final String title;
  final String updated;
  final ATMLinkAuthor author;
  final String? link;
  final List<ATMLinkEntry> entry;

  factory ATMLink.fromJson(Map<String, dynamic> json) =>
      _$ATMLinkFromJson(json);

  Map<String, dynamic> toJson() => _$ATMLinkToJson(this);
}

@JsonSerializable()
class ATMLinkAuthor {
  ATMLinkAuthor(this.feed);
  final ATMLinkAuthorName? feed;

  factory ATMLinkAuthor.fromJson(Map<String, dynamic> json) =>
      _$ATMLinkAuthorFromJson(json);

  Map<String, dynamic> toJson() => _$ATMLinkAuthorToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ATMLinkAuthorName {
  ATMLinkAuthorName(this.name);
  final String? name;
  factory ATMLinkAuthorName.fromJson(Map<String, dynamic> json) =>
      _$ATMLinkAuthorNameFromJson(json);

  Map<String, dynamic> toJson() => _$ATMLinkAuthorNameToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ATMLinkEntry {
  ATMLinkEntry(
    this.id,
    this.title,
    this.updated,
    this.category,
    this.link,
    this.content,
  );
  final String id;
  final String title;
  final String updated;
  final String? category;
  final String? link;
  final ATMLinkContentProperties content;

  factory ATMLinkEntry.fromJson(Map<String, dynamic> json) =>
      _$ATMLinkEntryFromJson(json);

  Map<String, dynamic> toJson() => _$ATMLinkEntryToJson(this);
}

@JsonSerializable()
class ATMLinkContentProperties {
  ATMLinkContentProperties(this.value);
  @JsonKey(name: "m:properties")
  final ATMLinkContentValue? value;

  factory ATMLinkContentProperties.fromJson(Map<String, dynamic> json) =>
      _$ATMLinkContentPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$ATMLinkContentPropertiesToJson(this);
}

@JsonSerializable()
class ATMLinkContentValue {
  ATMLinkContentValue(this.value);
  @JsonKey(name: "d:Value")
  final String? value;

  factory ATMLinkContentValue.fromJson(Map<String, dynamic> json) =>
      _$ATMLinkContentValueFromJson(json);

  Map<String, dynamic> toJson() => _$ATMLinkContentValueToJson(this);
}

@JsonSerializable()
class ATMContentProperties {
  ATMContentProperties(this.properties);
  @JsonKey(name: "m:properties")
  final ATMProperties properties;

  factory ATMContentProperties.fromJson(Map<String, dynamic> json) =>
      _$ATMContentPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$ATMContentPropertiesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ATMProperties {
  ATMProperties(
    this.id,
    this.name,
    this.type,
    this.latitude,
    this.longitude,
    this.distance,
    this.distanceUnit,
    this.address,
  );
  @JsonKey(name: "d:Id")
  final String id;
  @JsonKey(name: "d:Name")
  final String name;
  @JsonKey(name: "d:Type")
  final String type;
  @JsonKey(name: "d:Latitude")
  final String latitude;
  @JsonKey(name: "d:Longitude")
  final String longitude;
  @JsonKey(name: "d:Distance")
  final String? distance;
  @JsonKey(name: "d:DistanceUnit")
  final String distanceUnit;
  @JsonKey(name: "d:Address")
  final ATMAddress address;

  factory ATMProperties.fromJson(Map<String, dynamic> json) =>
      _$ATMPropertiesFromJson(json);

  Map<String, dynamic> toJson() => _$ATMPropertiesToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class ATMAddress {
  ATMAddress(
      this.street,
      this.street2,
      this.street3,
      this.city,
      this.state,
      this.streetCode,
      this.country,
      this.email,
      this.phone,
      this.phone2,
      this.zipcode,
      this.dataPhone,
      this.faxPhone,
      this.preferredContactMethod,
      this.preferredLanguage);
  @JsonKey(name: "d:Street")
  final String street;
  @JsonKey(name: "d:Street2")
  final String? street2;
  @JsonKey(name: "d:Street3")
  final String? street3;
  @JsonKey(name: "d:City")
  final String city;
  @JsonKey(name: "d:State")
  final String? state;
  @JsonKey(name: "d:StreetCode")
  final String? streetCode;
  @JsonKey(name: "d:Country")
  final String country;
  @JsonKey(name: "d:Email")
  final String? email;
  @JsonKey(name: "d:Phone")
  final String phone;
  @JsonKey(name: "d:Phone2")
  final String? phone2;
  @JsonKey(name: "d:ZipCode")
  final String? zipcode;
  @JsonKey(name: "d:DataPhone")
  final String? dataPhone;
  @JsonKey(name: "d:FaxPhone")
  final String faxPhone;
  @JsonKey(name: "d:PreferredContactMethod")
  final String? preferredContactMethod;
  @JsonKey(name: "d:preferredLanguage")
  final String? preferredLanguage;

  factory ATMAddress.fromJson(Map<String, dynamic> json) =>
      _$ATMAddressFromJson(json);

  Map<String, dynamic> toJson() => _$ATMAddressToJson(this);
}
