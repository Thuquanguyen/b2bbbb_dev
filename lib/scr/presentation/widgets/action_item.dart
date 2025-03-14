import 'package:b2b/constants.dart';
import 'package:b2b/scr/data/model/base_item_model.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ActionItem extends StatelessWidget {
  const ActionItem({Key? key, required this.itemModel, required this.isLastIndex, this.callback}) : super(key: key);

  final BaseItemModel itemModel;
  final bool isLastIndex;
  final void Function()? callback;

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: () {
        if (callback != null) {
          callback!();
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        height: 57.toScreenSize,
        child: Row(
          children: [
            SvgPicture.asset(
              itemModel.icon ?? AssetHelper.icoVpbankSvg,
              width: 22,
              height: 22,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: kDefaultPadding),
            Expanded(
              child: Text(
                itemModel.title,
                style: const TextStyle(
                  color: Color.fromRGBO(52, 52, 52, 1.0),
                  fontSize: 13,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.navigate_next,
              size: getInScreenSize(24),
              color: Colors.black,
            )
          ],
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: isLastIndex ? 0 : 0.5,
              color: kColorDivider,
            ),
          ),
        ),
      ),
    );
  }
}
