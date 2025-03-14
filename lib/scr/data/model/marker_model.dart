import 'package:json_annotation/json_annotation.dart';

part 'marker_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MarkerModel {
  MarkerModel(
      this.id,
      this.name,
      this.address,
      this.lat,
      this.lng,
      this.atmWorkingTime,
      this.cdmWorkingTime,
      this.branchWorkingTime,
      this.isAtm247,
      this.isCdm247,
      this.isBranch247,
      this.type,
      this.note);
  final String id;
  final bool? isCdm247;
  final bool? isAtm247;
  final bool? isBranch247;
  final double lat;
  final double lng;
  final String address;
  @JsonKey(name: "cdmWorkingTime")
  final String? cdmWorkingTime;
  @JsonKey(name: "atmWorkingTime")
  final String? atmWorkingTime;
  @JsonKey(name: "branchWorkingTime")
  final String? branchWorkingTime;
  final String name;
  final String? note;
  final List<String> type;

  factory MarkerModel.fromJson(Map<String, dynamic> json) =>
      _$MarkerModelFromJson(json);

  Map<String, dynamic> toJson() => _$MarkerModelToJson(this);
}
