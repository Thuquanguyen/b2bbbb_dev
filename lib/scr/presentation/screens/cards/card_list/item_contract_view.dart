import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/data/model/card/benefit_contract.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';

class ItemContractView extends StatelessWidget {
  final BenefitContract? benefitContract;
  final Function()? onPress;
  final EdgeInsets? margin;
  final String? rightIcon;

  const ItemContractView(
      {Key? key,
      this.benefitContract,
      this.onPress,
      this.margin,
      this.rightIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (benefitContract == null) {
      return const SizedBox();
    }
    return TouchableRipple(
      onPressed: onPress,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        margin: margin ??
            const EdgeInsets.only(
                left: kDefaultPadding,
                right: kDefaultPadding,
                top: 8,
                bottom: 8),
        child: Row(
          children: [
            Container(
              width: 37.toScreenSize,
              height: 24.toScreenSize,
              alignment: Alignment.centerRight,
              child: ImageHelper.loadFromAsset(AssetHelper.contract,
                  width: 24.toScreenSize, height: 24.toScreenSize),
            ),
            const SizedBox(
              width: kDefaultPadding,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    benefitContract?.contractName ?? '',
                    style: TextStyles.itemText.medium.blackColor,
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    benefitContract?.mainContract ?? '',
                    style: TextStyles.itemText.medium.blackColor,
                  ),
                ],
              ),
            ),
            if (rightIcon.isNotNullAndEmpty)
              ImageHelper.loadFromAsset(
                rightIcon!,
                width: 18.toScreenSize,
                height: 18.toScreenSize,
              )
          ],
        ),
      ),
    );
  }
}
