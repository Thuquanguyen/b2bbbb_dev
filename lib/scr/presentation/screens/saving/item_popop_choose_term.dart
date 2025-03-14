// Created by Cuonghd2 at 05/08/2021
// Email: cuonghd2@vpbank.com.vn
// Copyright (c) 2020. All rights reserved.


import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';

import '../../../../constants.dart';

class ItemPopupChooseTerm extends StatelessWidget {
  const ItemPopupChooseTerm({Key? key, required this.title, required this.desc, required this.onShowModalPopup}) : super(key: key);
  final String title;
  final String desc;
  final Function()? onShowModalPopup;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: getInScreenSize(36,min: 36),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(desc),
            ],
          ),
          IconButton(
            onPressed: onShowModalPopup,
            icon: ImageHelper.loadFromAsset(
              AssetHelper.icoDropDown,
              width: getInScreenSize(20),
              height: getInScreenSize(24),
            ),
          )
        ],
      ),
    );
  }
}
