import '../../../core/language/app_translate.dart';

class BillProvider {
  int? sysId;
  int? isCorpActive;
  int? isRetailActive;
  String? serviceCode;
  String? merchantServiceCode;
  String? merchantCode;
  String? providerCode;
  String? providerName;
  String? providerNameEn;

  BillProvider({
    this.sysId,
    this.isCorpActive,
    this.isRetailActive,
    this.serviceCode,
    this.merchantServiceCode,
    this.merchantCode,
    this.providerCode,
    this.providerName,
    this.providerNameEn,
  });

  BillProvider.fromJson(Map<String, dynamic> json) {
    sysId = json['sys_id']?.toInt();
    isCorpActive = json['is_corp_active']?.toInt();
    isRetailActive = json['is_retail_active']?.toInt();
    serviceCode = json['service_code']?.toString();
    merchantServiceCode = json['merchant_service_code']?.toString();
    merchantCode = json['merchant_code']?.toString();
    providerCode = json['provider_code']?.toString();
    providerName = json['provider_name']?.toString();
    providerNameEn = json['provider_name_en']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['sys_id'] = sysId;
    data['is_corp_active'] = isCorpActive;
    data['is_retail_active'] = isRetailActive;
    data['service_code'] = serviceCode;
    data['merchant_service_code'] = merchantServiceCode;
    data['merchant_code'] = merchantCode;
    data['provider_code'] = providerCode;
    data['provider_name'] = providerName;
    data['provider_name_en'] = providerNameEn;
    return data;
  }

  String? getProviderName() {
    var locale = AppTranslate().currentLanguage;
    if (locale == SupportLanguages.En) {
      return providerNameEn;
    }
    return providerName;
  }

  bool searchProvider(String value) {
    return (providerCode ?? '').toLowerCase().contains(value.toLowerCase()) ||
        (getProviderName() ?? '').toLowerCase().contains(value.toLowerCase());
  }
}
