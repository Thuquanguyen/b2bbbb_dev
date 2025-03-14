export 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/cupertino.dart';
import 'lang_vi.dart';
import 'lang_en.dart';

part 'i18n.g.dart';

enum SupportLanguages {
  En,
  Vi,
}

extension SupportLanguagesExtension on SupportLanguages {
  String get locale {
    return this == SupportLanguages.En ? 'en_US' : 'vi_VN';
  }

  String get value {
    return this == SupportLanguages.En ? 'en' : 'vi';
  }

  String get title {
    return this == SupportLanguages.En ? 'Vie' : 'Eng';
  }

  String get icon {
    return this == SupportLanguages.En
        ? AssetHelper.icoFlagVi
        : AssetHelper.icoFlagEng;
  }
}

const EVENT_CHANGE_LANGUAGE = 'EVENT_CHANGE_LANGUAGE';

class AppTranslate {
  factory AppTranslate() => _instance;

  AppTranslate._();

  static final _instance = AppTranslate._();

  SupportLanguages currentLanguage = SupportLanguages.Vi;

  static I18n i18n = I18n();

  late Map<String, String> dataLang;

  Future<void> loadLanguage({Function? onSynced}) async {
    String? language = await LocalStorageHelper.getLanguage();
    AppTranslate().setLanguage(
        language == 'en' ? SupportLanguages.En : SupportLanguages.Vi);
    onSynced?.call();
  }

  String translate(String keyword) {
    try {
      return dataLang[keyword]!;
    } catch (e) {
      return keyword;
    }
  }

  void setLanguage(SupportLanguages currentLang) {
    Logger.debug('currentLang ${currentLang.toString()}');
    currentLanguage = currentLang;
    if (currentLang == SupportLanguages.Vi) {
      dataLang = vi_VN;
    } else {
      dataLang = en_US;
    }
  }

  String getTitleLanguage() {
    return currentLanguage.title;
  }

  String getIcoLanguage() {
    return currentLanguage.icon;
  }

  Future<void> toggleLanguage(BuildContext context, Function reloadPage) async {
    currentLanguage = currentLanguage == SupportLanguages.Vi
        ? SupportLanguages.En
        : SupportLanguages.Vi;
    Logger.debug('change language to ${currentLanguage.toString()}');
    await LocalStorageHelper.setLanguage(
      currentLanguage.value,
    );
    setLanguage(currentLanguage);
    reloadPage();
    MessageHandler().notify(EVENT_CHANGE_LANGUAGE);
  }

  int getCurrentLanguageApiCode() {
    return currentLanguage == SupportLanguages.Vi ? 1 : 0;
  }
}
