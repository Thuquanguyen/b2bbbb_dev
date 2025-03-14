import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/presentation/screens/main/home_action_manager.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';

class ItemSecondActionTitle extends StatelessWidget {
  const ItemSecondActionTitle({Key? key, required this.secondModel, required this.onSelect, this.isSetting = false})
      : super(key: key);
  final HomeActionItem? secondModel;
  final bool isSetting;
  final Function onSelect;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
        onPressed: () {
          onSelect(!(secondModel?.isSelected ?? false));
        },
        child: Container(
          height: 60.toScreenSize,
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 0.5,
                color: kColorDivider,
              ),
            ),
          ),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                  boxShadow: [kBoxShadowCommon],
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: ImageHelper.loadFromAsset(
                secondModel?.icon ?? '',
                width: getInScreenSize(24),
                height: getInScreenSize(24),
              ),
            ),
            const SizedBox(width: 15),
            Expanded(child: Text(secondModel?.title.localized ?? '')),
            Icon(isSetting
                ? ((secondModel?.isPreSelected ?? false) ? Icons.check_box : Icons.check_box_outline_blank)
                : Icons.navigate_next)
          ]),
        ));
  }
}
