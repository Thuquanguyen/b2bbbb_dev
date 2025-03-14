import 'package:b2b/scr/data/model/name_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_customer_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SessionCustomerDataModel {
  SessionCustomerDataModel(
      {this.custName,
      this.custCif,
      this.vipType,
      this.segment,
      this.custAddress,
      this.custType,
      this.sectorCode,
      this.custLegalId,
      this.custGroup,
      this.levelCodeDisplay,
      this.servicePackageDisplay});

  factory SessionCustomerDataModel.fromJson(Map<String, dynamic> json) => _$SessionCustomerDataModelFromJson(json);

  String? custName;
  String? custCif;
  String? vipType;
  String? segment;
  String? custAddress;
  String? custType;
  String? sectorCode;
  String? custLegalId;
  List<String>? custGroup;
  NameModel? levelCodeDisplay;
  NameModel? servicePackageDisplay;

  String get maskedLegalId {
    return '${custLegalId?.substring(0, 3) ?? ''}•••••${custLegalId?.substring((custLegalId?.length ?? 3) - 3) ?? ''}';
  }

  Map<String, dynamic> toJson() => _$SessionCustomerDataModelToJson(this);
}
