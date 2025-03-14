// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/data/model/auth/session_customer_data_model.dart';
import 'package:b2b/scr/data/model/auth/session_user_data_model.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SessionModel {
  SessionModel({
    this.providerId,
    this.user,
    this.customer,
    this.topicKey,
    this.tokenIdentityNotification
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) => _$SessionModelFromJson(json);

  String? providerId;
  SessionUserDataModel? user;
  SessionCustomerDataModel? customer;
  List<String>? topicKey;
  String? tokenIdentityNotification;

  Map<String, dynamic> toJson() => _$SessionModelToJson(this);

  Future<void> saveToLocal() async {
    try {
      SessionManager().userData = this;
      String sessionData = jsonEncode(toJson());
      await LocalStorageHelper.setString(SESSION_DATA, sessionData);
    } catch (e) {
      Logger.debug(e.toString());
    }
  }

  static Future<SessionModel?> getSessionData() async {
    try {
      String? sessionData = await LocalStorageHelper.getString(SESSION_DATA);
      if (sessionData != null) {
        return SessionModel.fromJson(jsonDecode(sessionData));
      }
    } catch (e) {
      Logger.debug(e.toString());
    }
    return null;
  }
}
