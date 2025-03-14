import 'package:b2b/constants.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingItem extends StatelessWidget {
  String? svgIcon;
  String title;
  String? description;
  bool isSwitch;
  bool value;
  bool isPaddingBottom;
  Function(bool)? onChanged;
  Function? onTap;
  double? overridePadding;

  SettingItem(this.title,
      {Key? key,
      this.svgIcon,
      this.description,
      this.isSwitch = false,
      this.value = false,
      this.isPaddingBottom = true,
      this.overridePadding,
      this.onChanged,
      this.onTap})
      : super(key: key);

  bool isOn = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: !isPaddingBottom
          ? null
          : const BoxDecoration(
              border: Border(
                  bottom: BorderSide(
                      color: Color.fromRGBO(237, 241, 246, 1), width: 1))),
      child: Container(
        padding: isPaddingBottom
            ? EdgeInsets.symmetric(vertical: overridePadding ?? 25)
            : const EdgeInsets.only(top: 25),
        child: Row(
          children: [
            svgIcon != null
                ? SvgPicture.asset(
              svgIcon ?? '',
              width: 20,
              height: 20,
            )
                : Container(),
            SizedBox(
              width: svgIcon != null ? 22 : 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: kStyleTextUnit,
                  ),
                  description != null
                      ? const SizedBox(
                    height: 5,
                  )
                      : Container(),
                  description != null
                      ? Text(
                    description ?? '',
                    style: kStyleTextSubtitle,
                  )
                      : Container(),
                ],
              ),
            ),
            const SizedBox(width: 5,),
            onTap != null ? StatefulBuilder(
                builder: (context, setState) => Transform.scale(
                  scale: 0.7,
                  child: CupertinoSwitch(
                    value: isOn,
                    onChanged: (value) {
                      if (onTap != null) onTap!();
                    },
                    activeColor: Colors.green,
                  ),
                )) : Container(),
          ],
        ),
      ),
    );
  }
}
