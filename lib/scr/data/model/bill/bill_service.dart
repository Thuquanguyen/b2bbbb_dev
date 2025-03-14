import 'package:b2b/scr/bloc/bill/bill_bloc.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
class BillService {
  String? serviceCode;
  String? serviceName;
  NameModel? serviceNameDisplay;

  BillService({
    this.serviceCode,
    this.serviceName,
    this.serviceNameDisplay,
  });

  BillService.fromJson(Map<String, dynamic> json) {
    serviceCode = json['service_code']?.toString();
    serviceName = json['service_name']?.toString();
    serviceNameDisplay = (json['service_name_display'] != null)
        ? NameModel.fromJson(json['service_name_display'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['service_code'] = serviceCode;
    data['service_name'] = serviceName;
    if (serviceNameDisplay != null) {
      data['service_name_display'] = serviceNameDisplay!.toJson();
    }
    return data;
  }
  String getIcon(){
    if(serviceCode == BillType.DIEN.getServiceCode()){
      return AssetHelper.icIdea;
    }else{
      return AssetHelper.icoVpbankSvg;
    }
  }
}
