import 'package:b2b/constants.dart';
import 'package:b2b/scr/data/model/transfer/benefician_account_model.dart';
import 'package:b2b/scr/presentation/widgets/circle_avatar_letter.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';

// ignore: must_be_immutable
class BeneficiaryItem extends StatelessWidget {
  BeneficiaryItem({Key? key, required this.acountBeneficianModel, required this.isLastItem}) : super(key: key);

  final BeneficianAccountModel acountBeneficianModel;
  bool isLastItem;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 63.toScreenSize,
        decoration:
            BoxDecoration(border: Border(bottom: BorderSide(width: isLastItem ? 0 : 0.5, color: kColorDivider))),
        child: TextButton(
          onPressed: () {},
          child: Column(children: [
            Expanded(
              child: Row(children: [
                Container(
                    margin: const EdgeInsets.all(5),
                    child: CircleAvatarLetter(
                      name: acountBeneficianModel.benName ?? "",
                      size: 32.toScreenSize,
                      color: Colors.white,
                      backgroundColor: const Color.fromRGBO(21, 99, 121, 1.0),
                    )),
                const SizedBox(width: 15),
                Expanded(
                    child: Column(
                  children: [
                    Text(
                      acountBeneficianModel.benName ?? "",
                      style: kStyleTextUnit,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${acountBeneficianModel.benName} - ${acountBeneficianModel.benName}",
                      style: kStyleTextSubtitle,
                    )
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                )),
                Image.asset(
                  AssetHelper.imgForward,
                  height: 18.toScreenSize,
                  width: 18.toScreenSize,
                  fit: BoxFit.fitWidth,
                )
              ]),
            )
          ]),
        ));
  }
}
