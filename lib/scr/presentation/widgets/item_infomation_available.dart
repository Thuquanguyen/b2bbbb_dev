// Created by Cuonghd2 at 05/08/2021
// Email: cuonghd2@vpbank.com.vn
// Copyright (c) 2020. All rights reserved.

import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';

import '../../core/extensions/num_ext.dart';

class ItemInformationAvailable extends StatelessWidget {
  const ItemInformationAvailable({
    Key? key,
    required this.title,
    this.iconWidget,
    this.onPress,
    this.description,
    this.showIconForward = false,
    this.showBorder = true,
    this.enable = true,
    this.caption,
    this.forwardIcon = AssetHelper.icoForward,
    this.isShowLoading = false,
  }) : super(key: key);

  final String title;
  final Widget? iconWidget;
  final String? description;
  final String? caption;
  final void Function()? onPress;
  final bool showIconForward;
  final bool showBorder;
  final bool enable;
  final String? forwardIcon;
  final bool isShowLoading;

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: enable ? onPress : null,
      child: Container(
          decoration: BoxDecoration(
            border: showBorder
                ? const Border(
                    bottom: kBorderSide,
                  )
                : null,
          ),
          padding: caption != null
              ? const EdgeInsets.only(bottom: kMinPadding)
              : const EdgeInsets.symmetric(vertical: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (caption != null)
                Text(
                  caption!,
                  style: TextStyles.captionText.slateGreyColor,
                ),
              if (caption != null)
                const SizedBox(
                  height: kMinPadding,
                ),
              Opacity(
                  opacity: enable ? 1 : 0.5,
                  child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (iconWidget != null)
                    SizedBox(
                      height: (description == null) ? 18.toScreenSize : 32.toScreenSize,
                      width: (description == null) ? 18.toScreenSize : 32.toScreenSize,
                      child: iconWidget,
                    ),
                  if (iconWidget != null)
                    SizedBox(
                      width: showIconForward ? kDefaultPadding : kItemPadding,
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyles.normalText.semibold ,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (description != null)
                          Text(
                            description!,
                            style: TextStyles.smallText.slateGreyColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  if (isShowLoading)
                    const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 1.0),
                    ),
                  if (isShowLoading) const SizedBox(width: 10,),
                  if (showIconForward)
                    ImageHelper.loadFromAsset(
                      forwardIcon ?? AssetHelper.icoForward,
                      width: 18.toScreenSize,
                      height: 18.toScreenSize,
                    )
                ],
              )),
            ],
          ),
        ),
    );
  }
}
