import 'package:b2b/scr/presentation/screens/commerece/commerce_list_screen.dart';

class CommerceFilterRequest {
  String? id;
  double? fromAmount;
  double? toAmount;
  String? fromDate;
  String? toDate;
  CommerceType? commerceType;

  CommerceFilterRequest(
      {this.id,
      this.fromAmount,
      this.toAmount,
      this.fromDate,
      this.toDate,
      this.commerceType});

  Map<String, dynamic> toJson() {
    var rq = <String, dynamic>{
      'from_amount': fromAmount,
      'to_amount': toAmount,
      'from_date': fromDate,
      'to_date': toDate
    };

    switch (commerceType) {
      case CommerceType.LC:
        rq['ref_no'] = id;
        break;
      case CommerceType.DISCOUNT:
      case CommerceType.BAO_LANH:
        rq['contract_no'] = id;
        break;
      default:
        break;
    }
    return rq;
  }
}
