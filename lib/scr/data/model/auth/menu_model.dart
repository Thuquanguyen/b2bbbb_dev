// ignore_for_file: avoid_print

import 'package:json_annotation/json_annotation.dart';

part 'menu_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class MenuModel {
  MenuModel({
    this.id,
    this.parentId,
    this.labelId,
    this.visible,
    this.lock,
  });

  factory MenuModel.fromJson(Map<String, dynamic> json) => _$MenuModelFromJson(json);

  int? id;
  int? parentId;
  String? labelId;
  bool? visible;
  bool? lock;

  Map<String, dynamic> toJson() => _$MenuModelToJson(this);

  // void saveToLocal() {
  //   try {
  //     String sessionData = jsonEncode(toJson());
  //     LocalStorageHelper.sharedPreferenceSetString(SESSION_DATA, sessionData);
  //   } catch (e) {
  //     print(e);
  //   }
  // }
  //
  // static Future<MenuModel?> getSessionData() async {
  //   try {
  //     String? sessionData = await LocalStorageHelper.sharedPreferenceGetString(SESSION_DATA);
  //     if (sessionData != null) {
  //       return MenuModel.fromJson(jsonDecode(sessionData));
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  //   return null;
  // }
}
