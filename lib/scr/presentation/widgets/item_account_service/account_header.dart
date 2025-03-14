import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';

class AccountHeader extends StatelessWidget {
  const AccountHeader({Key? key, required this.title, required this.icon})
      : super(key: key);

  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.screenBg,
      ),
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 10,
        left: kDefaultPadding,
        right: kDefaultPadding,
      ),
      child: Row(
        children: [
          ImageHelper.loadFromAsset(icon, width: 22, height: 22),
          const SizedBox(width: 16),
          Text(title, style: TextStyles.headerText.normalColor)
        ],
      ),
    );
  }
}
