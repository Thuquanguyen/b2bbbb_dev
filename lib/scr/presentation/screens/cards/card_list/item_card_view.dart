import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/presentation/screens/cards/card_info/card_info_screen.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';

class ItemCardView extends StatelessWidget {
  final bool? isExpand;
  final bool? isChildItem;
  final bool? canExpand;
  final bool? showDivider;
  final Function()? onArrowIconClick;
  final EdgeInsetsGeometry? margin;
  final String? cardName;
  final String? cardDes;
  final String? cardCompanyName;
  final CardModel? cardModel;
  final Function()? onPress;
  final String? rightIcon;
  final bool? isShimmer;
  final bool? isNull;

  const ItemCardView({
    Key? key,
    this.isExpand = false,
    this.isChildItem = false,
    this.canExpand = false,
    this.showDivider,
    this.onArrowIconClick,
    this.margin,
    this.cardName,
    this.cardDes,
    this.cardCompanyName,
    this.cardModel,
    this.onPress,
    this.rightIcon,
    this.isShimmer,
    this.isNull,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isShimmer == true) {
      return _buildShimmer();
    }
    if(isNull == true){
      return const SizedBox();
    }
    return TouchableRipple(
      onPressed: onPress,
      child: Container(
        width: double.infinity,
        margin: margin ??
            const EdgeInsets.only(
                left: kDefaultPadding,
                right: kDefaultPadding,
                top: 8,
                bottom: 8),
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 37.toScreenSize,
                  height: 24.toScreenSize,
                  alignment: Alignment.centerRight,
                  child: (isChildItem == true)
                      ? ImageHelper.loadFromAsset(AssetHelper.cardChild,
                          width: 24.toScreenSize, height: 24.toScreenSize)
                      : ImageHelper.loadFromAsset(
                          cardModel?.visual.front ?? '',
                        ),
                ),
                const SizedBox(
                  width: kDefaultPadding,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cardName ?? '',
                        style: TextStyles.itemText.medium.blackColor,
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      if (cardCompanyName.isNotNullAndEmpty)
                        Text(
                          cardCompanyName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.itemText,
                        ),
                      if (cardCompanyName.isNotNullAndEmpty)
                        const SizedBox(
                          height: 2,
                        ),
                      if (cardDes.isNotNullAndEmpty)
                        Text(
                          cardDes ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.itemText.slateGreyColor,
                        ),
                    ],
                  ),
                ),
                if (canExpand == true && isChildItem == false)
                  Touchable(
                      onTap: onArrowIconClick,
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        child: isExpand == true
                            ? ImageHelper.loadFromAsset(
                                AssetHelper.icArrowUp,
                                width: 18.toScreenSize,
                                height: 18.toScreenSize,
                              )
                            : ImageHelper.loadFromAsset(
                                AssetHelper.icArrowDown,
                                width: 18.toScreenSize,
                                height: 18.toScreenSize,
                              ),
                      )),
                if (rightIcon.isNotNullAndEmpty)
                  ImageHelper.loadFromAsset(
                    rightIcon!,
                    width: 18.toScreenSize,
                    height: 18.toScreenSize,
                  )
              ],
            ),
            if (showDivider == true) const Divider(),
          ],
        ),
      ),
    );
  }

  _buildShimmer() {
    return AppShimmer(
      Row(
        children: [
          Container(
            width: 37.toScreenSize,
            height: 24.toScreenSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.shimmerItemColor,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 150,
                height: 9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.shimmerItemColor,
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Container(
                width: 200,
                height: 9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.shimmerItemColor,
                ),
              ),
              const SizedBox(
                height: 7,
              ),
              Container(
                width: 230,
                height: 9,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.shimmerItemColor,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
