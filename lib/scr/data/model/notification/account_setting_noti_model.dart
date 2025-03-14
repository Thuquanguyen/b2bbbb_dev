import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

part 'account_setting_noti_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class AccountSettingNotiModel {
  @JsonKey(name: 'aggregate_Id')
  final String?
      aggregateId; // Mã ID tồn tại nếu đã đăng ký account này trên hệ thống
  final bool?
      enable; // true: đã đăng ký nhận biến động số dư, ngượi lại là false
  final String? secureTrans; // Chuỗi bảo mật của tài khoản
  final String? accountNumber; // Số tài khoản CA/AZ
  final String? accountCurrency; // Loại tiền của tài khoản
  final double? availableBalance; // Số dư tài khoản
  AccountSettingNotiModel(
      {this.aggregateId,
      this.enable,
      this.secureTrans,
      this.accountNumber,
      this.accountCurrency,
      this.availableBalance});

  factory AccountSettingNotiModel.fromJson(Map<String, dynamic> json) =>
      _$AccountSettingNotiModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountSettingNotiModelToJson(this);

  AccountSettingNotiModel copyWith({bool? enable,String? aggregateId,String? secureTrans}) {
    return AccountSettingNotiModel(
        enable: enable ?? this.enable,
        aggregateId: aggregateId ?? this.aggregateId,
        secureTrans: secureTrans ?? this.secureTrans,
        accountNumber: accountNumber,
        accountCurrency: accountCurrency,
        availableBalance: availableBalance);
  }
}
