//Phương thức lãi
class Settelment {
  String? settleCode;
  String? name;

  Settelment({this.settleCode, this.name});

  Settelment.fromJson(Map<String, dynamic> json) {
    settleCode = json['settle_code']?.toString();
    name = json['name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['settle_code'] = settleCode;
    data['name'] = name;
    return data;
  }
}
