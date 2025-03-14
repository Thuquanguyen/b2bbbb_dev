import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:json_annotation/json_annotation.dart';

part 'debit_account_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class DebitAccountModel {
  DebitAccountModel({
    this.accountNumber,
    this.accountCurrency,
    this.availableBalance,
  });

  final String? accountNumber;
  final String? accountCurrency;
  final double? availableBalance;

  factory DebitAccountModel.fromJson(Map<String, dynamic> json) => _$DebitAccountModelFromJson(json);

  Map<String, dynamic> toJSON() => _$DebitAccountModelToJson(this);

  Map<String, dynamic> toJSONPARAM() => {
        'account_number': this.accountNumber,
        'currency': this.accountCurrency,
      };

  String getSubtitle({String? value}) {
    if (value != null) {
      return value;
    }
    return AppTranslate.i18n.accountNumberStr.localized + ' $accountNumber';
  }
}

@JsonSerializable(fieldRename: FieldRename.snake)
class DebitAccountResponseModel {
  DebitAccountResponseModel({
    this.debbitAccountList,
    this.accountDefault,
  });

  final List<DebitAccountModel>? debbitAccountList;
  final String? accountDefault;

  factory DebitAccountResponseModel.fromJson(Map<String, dynamic> json) => _$DebitAccountResponseModelFromJson(json);

  Map<String, dynamic> toJSON() => _$DebitAccountResponseModelToJson(this);
}
