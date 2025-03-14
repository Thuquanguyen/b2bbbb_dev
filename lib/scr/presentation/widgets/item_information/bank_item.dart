import 'package:flutter/material.dart';

class BankItem extends StatelessWidget {
  const BankItem({Key? key, this.icon, this.title}) : super(key: key);

  final icon;
  final title;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          // ImageHelper.loadFromAsset(
          //   AssetHelper.icoVpbankOnly,
          //   height: (des == null) ? 18.toScreenSize : 26.toScreenSize,
          //   width: (des == null) ? 18.toScreenSize : 32.toScreenSize,
          // ),
          // SizedBox(width: 8),
          // Text(
          //   title,
          //   style: TextStyle(
          //     color: Color.fromRGBO(52, 52, 52, 1.0),
          //     fontSize: 13,
          //     fontWeight: FontWeight.bold,
          //   ),
          // )
        ],
      ),
    );
  }
}
