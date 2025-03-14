import 'package:b2b/scr/core/extensions/extensions.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/utils.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class NotificationModel {
  final String? username;
  late final String? time;
  final String? account;
  final String? balance;
  final String? ccy;
  final String? desc;
  DateTime? timeInDateTime;
  String? id;
  bool? hasRead;

  DateTime? dateTime;

  String? transCode;

  NotificationModel(
      {this.username,
      this.time,
      this.account,
      this.balance,
      this.ccy,
      this.desc,
      this.id,
      this.hasRead,
      this.dateTime,
      this.transCode});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationModel copyWith({bool? hasRead}) {
    return NotificationModel(
        hasRead: hasRead ?? this.hasRead,
        username: username,
        time: time,
        account: account,
        balance: balance,
        ccy: ccy,
        desc: desc,
        id: id,
        dateTime: dateTime,
        transCode: transCode);
  }

  String timeInFormat() {
    try {
      if (time.isNotNullAndEmpty) {
        timeInDateTime ??= DateFormat("dd/MM/yyyy HH:mm").parse(time ?? '');
        return AppUtils.getDateTimeTitle(timeInDateTime!);
      }
    } catch (e) {
      Logger.debug(e.toString());
    }
    return '';
  }

  String hoursInFormat() {
    try {
      if (time.isNotNullAndEmpty) {
        timeInDateTime ??= DateFormat("dd/MM/yyyy HH:mm").parse(time ?? '');
        return AppUtils.getDateTimeInFormat(timeInDateTime!, 'HH:mm');
      }
    } catch (e) {
      Logger.debug(e.toString());
    }
    return '';
  }

  String getBalance() {
    return ((balance?.startsWith('-') ?? false) ? balance : '+$balance') ?? '';
  }
}
