//Ky han tien gui

import 'package:b2b/scr/core/language/app_translate.dart';

class RolloverTerm {
/*
{
  "term_code": "sample string 1",
  "vi": "sample string 2",
  "en": "sample string 3"
}
*/

  String? termCode;
  String? vi;
  String? en;

  RolloverTerm({
    this.termCode,
    this.vi,
    this.en,
  });

  RolloverTerm.fromJson(Map<String, dynamic> json) {
    termCode = json['term_code']?.toString();
    vi = json['vi']?.toString();
    en = json['en']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['term_code'] = termCode;
    data['vi'] = vi;
    data['en'] = en;
    return data;
  }

  String? getValue() {
    return (AppTranslate().currentLanguage == SupportLanguages.Vi) ? vi : en;
  }
}
