import 'package:json_annotation/json_annotation.dart';

part 'payroll_ben_model.g.dart';

// enum PayrollBenFilterType {
//   ForAmount,
//   ForName,
//   AccountNumber,
// }
//
// extension GetValue on PayrollBenFilterType {
//   int get value {
//     switch (this) {
//       case PayrollBenFilterType.ForAmount:
//         return 0;
//       case PayrollBenFilterType.ForName:
//         return 1;
//       case PayrollBenFilterType.AccountNumber:
//         return 2;
//     }
//   }
// }

class PayrollFilterOption {
  final String name;
  final int key;

  PayrollFilterOption({required this.name, required this.key});
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PayrollBenListFilterRequest {
  String? fileCode;
  PayrollBenListFilter? fillter;

  PayrollBenListFilterRequest({
    this.fileCode,
    this.fillter,
  });

  factory PayrollBenListFilterRequest.fromJson(Map<String, dynamic> json) =>
      _$PayrollBenListFilterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PayrollBenListFilterRequestToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PayrollBenListFilter {
  String? keywords;
  double? fromAmt;
  double? toAmt;
  int? options;

  PayrollBenListFilter({
    this.keywords,
    this.fromAmt,
    this.toAmt,
    this.options,
  });

  bool get isFilterActive {
    return keywords != null || fromAmt != null || toAmt != null;
  }

  factory PayrollBenListFilter.fromJson(Map<String, dynamic> json) =>
      _$PayrollBenListFilterFromJson(json);

  Map<String, dynamic> toJson() => _$PayrollBenListFilterToJson(this);
}

@JsonSerializable(fieldRename: FieldRename.snake)
class PayrollBenModel {
  String? transNo;
  String? benName;
  String? benAcc;
  String? benBank;
  String? benBranch;
  String? benAmt;
  String? benCcy;
  String? feeAmt;

  PayrollBenModel({
    this.transNo,
    this.benName,
    this.benAcc,
    this.benBank,
    this.benBranch,
    this.benAmt,
    this.benCcy,
    this.feeAmt,
  });

  factory PayrollBenModel.fromJson(Map<String, dynamic> json) =>
      _$PayrollBenModelFromJson(json);

  Map<String, dynamic> toJson() => _$PayrollBenModelToJson(this);
}
