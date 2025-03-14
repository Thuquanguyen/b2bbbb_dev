/**
 * DepositsType -> loại tiền gửi
 * SavingReceiveMethod -> phương thức nhận lãi
 */

//tien gui thuong, tien gui VPS
class SavingDepositsProductResponse {
  String? mainGroupId;
  String? name;
  List<SavingDes?>? desc;

  // Loai tiền gửi
  List<DepositsType?>? groupArray;

  SavingDepositsProductResponse({
    this.mainGroupId,
    this.name,
    this.desc,
    this.groupArray,
  });

  SavingDepositsProductResponse.fromJson(Map<String, dynamic> json) {
    mainGroupId = json['main_group_id']?.toString();
    name = json['name']?.toString();
    if (json['desc'] != null) {
      final v = json['desc'];
      final arr0 = <SavingDes>[];
      v.forEach((v) {
        arr0.add(SavingDes.fromJson(v));
      });
      desc = arr0;
    }
    if (json['group_array'] != null) {
      final v = json['group_array'];
      final arr0 = <DepositsType>[];
      v.forEach((v) {
        arr0.add(DepositsType.fromJson(v));
      });
      groupArray = arr0;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['main_group_id'] = mainGroupId;
    data['name'] = name;
    if (desc != null) {
      final v = desc;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['desc'] = arr0;
    }
    if (groupArray != null) {
      final v = groupArray;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['group_array'] = arr0;
    }
    return data;
  }
}

//Loại tiền gưir
class DepositsType {
  String? groupId;

  //Phương thức nhận lãi
  List<SavingReceiveMethod?>? productArray;
  String? name;

  DepositsType({
    this.groupId,
    this.productArray,
    this.name,
  });

  DepositsType.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id']?.toString();
    if (json['product_array'] != null) {
      final v = json['product_array'];
      final arr0 = <SavingReceiveMethod>[];
      v.forEach((v) {
        arr0.add(SavingReceiveMethod.fromJson(v));
      });
      productArray = arr0;
    }
    name = json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['group_id'] = groupId;
    if (productArray != null) {
      final v = productArray;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data['product_array'] = arr0;
    }
    data['name'] = name;
    return data;
  }
}

class SavingDes {
  String? text;
  String? type;

  SavingDes({
    this.text,
    this.type,
  });

  SavingDes.fromJson(Map<String, dynamic> json) {
    text = json['text']?.toString();
    type = json['type']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['text'] = text;
    data['type'] = type;
    return data;
  }
}

class SavingReceiveMethod {
  String? productId;
  String? secureId;
  String? groupId;
  String? allInOneProduct;
  String? categoryCode;
  String? ctsp;
  double? minAmt;
  double? maxAmt;
  bool? allowFcy;
  String? interrestPreiod;
  bool? isShowName;
  String? periodCode;
  String? pdGroupCode;

  SavingReceiveMethod({
    this.productId,
    this.secureId,
    this.groupId,
    this.allInOneProduct,
    this.categoryCode,
    this.ctsp,
    this.minAmt,
    this.maxAmt,
    this.allowFcy,
    this.interrestPreiod,
    this.isShowName,
    this.periodCode,
    this.pdGroupCode,
  });

  SavingReceiveMethod.fromJson(Map<String, dynamic> json) {
    productId = json['product_id']?.toString();
    secureId = json['secure_id']?.toString();
    groupId = json['group_id']?.toString();
    allInOneProduct = json['all_in_one_product']?.toString();
    categoryCode = json['category_code']?.toString();
    ctsp = json['ctsp']?.toString();
    minAmt = json['min_amt']?.toDouble();
    maxAmt = json['max_amt']?.toDouble();
    allowFcy = json['allow_fcy'];
    interrestPreiod = json['interrest_preiod']?.toString();
    isShowName = json['is_show_name'];
    periodCode = json['period_code']?.toString();
    pdGroupCode = json['pd_group_code']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['product_id'] = productId;
    data['secure_id'] = secureId;
    data['group_id'] = groupId;
    data['all_in_one_product'] = allInOneProduct;
    data['category_code'] = categoryCode;
    data['ctsp'] = ctsp;
    data['min_amt'] = minAmt;
    data['max_amt'] = maxAmt;
    data['allow_fcy'] = allowFcy;
    data['interrest_preiod'] = interrestPreiod;
    data['is_show_name'] = isShowName;
    data['period_code'] = periodCode;
    data['pd_group_code'] = pdGroupCode;
    return data;
  }
}
