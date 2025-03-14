/**
 * Hóa đơn đã lưu
 */
class BillSaved {
  String? id;
  String? serviceCode;
  String? serviceName;
  String? customerCode;
  String? providerCode;
  String? providerName;

  BillSaved({
    this.id,
    this.serviceCode,
    this.serviceName,
    this.customerCode,
    this.providerCode,
    this.providerName,
  });

  BillSaved.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    serviceCode = json['service_code']?.toString();
    serviceName = json['service_name']?.toString();
    customerCode = json['customer_code']?.toString();
    providerCode = json['provider_code']?.toString();
    providerName = json['provider_name']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['service_code'] = serviceCode;
    data['service_name'] = serviceName;
    data['bill_code'] = customerCode;
    data['provider_code'] = providerCode;
    data['provider_name'] = providerName;
    return data;
  }
}
