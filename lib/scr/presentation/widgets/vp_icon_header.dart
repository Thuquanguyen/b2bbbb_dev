import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/cupertino.dart';

class VPIconHeader extends StatelessWidget {
  const VPIconHeader({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  final String title;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 8,
        bottom: 10,
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
