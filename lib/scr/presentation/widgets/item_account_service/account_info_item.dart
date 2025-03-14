import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/text_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';

class AccountInfoItem extends StatelessWidget {
  AccountInfoItem({
    Key? key,
    required this.isLastIndex,
    this.icon,
    this.workingBalance,
    this.accountCurrency,
    this.accountNumber,
    this.accountName,
    this.prefixIcon,
    this.onPress,
    this.showShimmer = false,
    this.margin = const EdgeInsets.all(kDefaultPadding),
    this.hideBalance = false,
  }) : super(key: key);

  final bool isLastIndex;
  final String? workingBalance;
  final String? accountCurrency;
  final String? accountNumber;
  final String? accountName;
  final String? icon;
  final String? prefixIcon;
  final Function()? onPress;
  final EdgeInsets? margin;
  final bool? showShimmer;
  final bool? hideBalance;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
      child: Container(
        margin: margin,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (prefixIcon != null)
              Container(
                padding: EdgeInsets.only(right: kDefaultPadding.toScreenSize),
                child: ImageHelper.loadFromAsset(
                  prefixIcon!,
                  width: 26.toScreenSize,
                  height: 26.toScreenSize,
                  // tintColor: const Color.fromRGBO(102, 102, 103, 0.5),
                ),
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  showShimmer == true
                      ? Text(
                          (accountNumber ?? '* * * * * * * * *') +
                              ((accountName == null) ? '' : ' - $accountName'),
                          style: TextStyles.smallText.slateGreyColor,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ).withShimmer(
                          visible: showShimmer ?? false,
                          expectedCharacterCount: 30)
                      : hideBalance != true
                          ? RichText(
                              text: TextSpan(
                                text: (workingBalance ?? '* * * * * * * * *'),
                                style: TextStyles.semiBoldText.inputTextColor,
                                children: <TextSpan>[
                                  TextSpan(
                                    text: ' ' + (accountCurrency ?? ''),
                                    style: TextStyles.semiBoldText.unitColor,
                                  )
                                ],
                              ),
                            )
                          : const SizedBox(),
                  SizedBox(height: 4.toScreenSize),
                  Text(
                    (accountNumber ?? '* * * * * * * * *') +
                        ((accountName == null) ? '' : ' - $accountName'),
                    style: TextStyles.smallText.slateGreyColor,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ).withShimmer(
                      visible: showShimmer ?? false, expectedCharacterCount: 20)
                ],
              ),
            ),
            if (icon != null)
              ImageHelper.loadFromAsset(
                icon!,
                width: 18.toScreenSize,
                height: 18.toScreenSize,
              )
          ],
        ),
      ),
      onPressed: onPress,
    );
  }
}
