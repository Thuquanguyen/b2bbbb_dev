import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'session_user_data_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SessionUserDataModel {
  SessionUserDataModel({
    this.username,
    this.otpMethod,
    this.otpPhone,
    this.otpEmail,
    this.certId,
    this.fullName,
    this.roleCode,
    this.roleName,
    this.otpMethodName,
    this.lastLogin,
    this.enableSmartotp = false,
  });

  factory SessionUserDataModel.fromJson(Map<String, dynamic> json) => _$SessionUserDataModelFromJson(json);

  String? username;
  String? otpMethod;
  String? otpPhone;
  String? otpEmail;
  String? fullName;
  String? certId;
  String? roleCode;
  NameModel? roleName;
  NameModel? otpMethodName;
  String? lastLogin;
  bool enableSmartotp;

  String? getLastLoginText() {
    try {
      Logger.debug('--------- last login ${lastLogin}');
      DateTime date = DateFormat('M/dd/yyyy').add_jms().parse(lastLogin ?? ''); // think this will work better for you
      return DateFormat('dd/MM/yyyy ').add_Hms().format(date);
    } catch (e) {
      return null;
    }
  }

  Map<String, dynamic> toJson() => _$SessionUserDataModelToJson(this);
}
