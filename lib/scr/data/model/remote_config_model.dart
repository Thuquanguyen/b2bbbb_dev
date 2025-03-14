import 'package:b2b/scr/core/language/app_translate.dart';

class RemoteConfigModel {
  bool? forceUpdate;
  int? iosVersion;
  int? androidVersion;
  String? updateMessageVi;
  String? updateMessageEn;
  bool? maintain;
  String? maintainMessageVn;
  String? maintainMessageEn;
  String? maintainLink;
  String? linkIos;
  String? linkAndroid;
  bool? allowFeedback;
  String? surveyUrl;

  RemoteConfigModel(
      {this.forceUpdate,
      this.iosVersion,
      this.androidVersion,
      this.updateMessageVi,
      this.updateMessageEn,
      this.maintain,
      this.maintainMessageVn,
      this.maintainMessageEn,
      this.maintainLink,
      this.linkIos,
      this.linkAndroid,
      this.allowFeedback,
      this.surveyUrl = 'https://www.surveymonkey.com/r/8HSLSFL'});

  String getMaintainMessage() {
    if (AppTranslate().currentLanguage == SupportLanguages.Vi) {
      return maintainMessageVn ?? '';
    } else {
      return maintainMessageEn ?? '';
    }
  }

  String getUpdateMessage() {
    if (AppTranslate().currentLanguage == SupportLanguages.Vi) {
      return updateMessageVi ?? '';
    } else {
      return updateMessageEn ?? '';
    }
  }

  @override
  String toString() {
    return super.toString();
  }
}
