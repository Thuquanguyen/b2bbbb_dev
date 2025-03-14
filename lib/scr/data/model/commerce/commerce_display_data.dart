import 'package:b2b/scr/presentation/screens/commerece/commerce_list_screen.dart';

class CommerceDisplayData {
  String? icon;
  String? amount;
  String? des;
  String? title1;
  String? title2;
  String? title3;
  String? value1;
  String? value2;
  String? value3;

  CommerceType? type;
  dynamic rootData;

  CommerceDisplayData(
      {this.icon,
      this.amount,
      this.des,
      this.title1,
      this.title2,
      this.title3,
      this.value1,
      this.value2,
      this.value3,
      this.type,
      this.rootData});
}
