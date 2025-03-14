import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/data/model/base_item_model.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';

class ItemCheckList extends StatelessWidget {
  const ItemCheckList({Key? key, required this.item, required this.callBack, required this.isLast}) : super(key: key);

  final BaseItemModel item;
  final bool isLast;
  final Function callBack;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        padding: const EdgeInsets.only(left: 8),
        decoration: isLast
            ? const BoxDecoration()
            : const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    width: 0.5,
                    color: kColorDivider,
                  ),
                ),
              ),
        height: 62.toScreenSize,
        child: Row(
          children: [
            Opacity(
              opacity: item.isCheck ? 1 : 0,
              child: ImageHelper.loadFromAsset(AssetHelper.icoCheck, width: 24, height: 24),
            ),
            const SizedBox(width: kDefaultPadding),
            Text(item.title, style: TextStyles.normalText.normalColor)
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      ),
      onPressed: () {
        callBack();
      },
    );
  }
}
