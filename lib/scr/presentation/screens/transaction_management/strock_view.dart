import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';


class StrockView extends StatelessWidget {
  String? value;
  String? icon;
  double? iconSize;

  StrockView({Key? key, this.value, this.icon = "", this.iconSize = 18.0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              AssetHelper.bgDotRectangle,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
            child: Row(
              children: [
                if (icon != null)
                  SvgPicture.asset(
                    icon!,
                    width: iconSize!,
                    height: iconSize!,
                    fit: BoxFit.contain,
                  ),
                if (value != null)
                  const SizedBox(
                    width: 10,
                  ),
                if (value != null && value!.isNotEmpty)
                  Text(
                    value!,
                    style: TextStyles.itemText.copyWith(
                      color: const Color(0xFF666667),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
