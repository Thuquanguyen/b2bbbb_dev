// Created by Cuonghd2 at 05/08/2021
// Email: cuonghd2@vpbank.com.vn
// Copyright (c) 2020. All rights reserved.

import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';

class OtpIntroModel {
  OtpIntroModel(this.des, this.image, this.imageDes, this.colorDot);

  final String des;
  final String image;
  final String imageDes;
  final Color colorDot;
}

List<OtpIntroModel> listIntroObject = [
  OtpIntroModel(
    AppTranslate.i18n.otpIntroModel1Str.localized,
    AssetHelper.smartOtpIntro1,
    AssetHelper.imgSmartOtpIntroDes1,
    const Color.fromRGBO(29, 66, 137, 1),
  ),
  OtpIntroModel(
    AppTranslate.i18n.otpIntroModel2Str.localized,
    AssetHelper.smartOtpIntro2,
    AssetHelper.imgSmartOtpIntroDes2,
    const Color.fromRGBO(29, 88, 97, 1),
  ),
  OtpIntroModel(
    AppTranslate.i18n.otpIntroModel3Str.localized,
    AssetHelper.smartOtpIntro3,
    AssetHelper.imgSmartOtpIntroDes3,
    const Color.fromRGBO(21, 127, 80, 1),
  ),
  OtpIntroModel(
    AppTranslate.i18n.otpIntroModel4Str.localized,
    AssetHelper.smartOtpIntro4,
    AssetHelper.imgSmartOtpIntroDes4,
    const Color.fromRGBO(0, 183, 79, 1),
  ),
];

class ListOTPIntro extends StatefulWidget {
  const ListOTPIntro({Key? key, required this.callbackFromSlide})
      : super(key: key);

  final Function(int) callbackFromSlide;

  @override
  ListOTPIntroState createState() => ListOTPIntroState();
}

class ListOTPIntroState extends State<ListOTPIntro>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: listIntroObject.length, vsync: this);
    tabController.addListener(() {
      widget.callbackFromSlide(tabController.index);
    });
  }

  void jumpToNextPage() {
    if (tabController.index == listIntroObject.length - 1) {
      return;
    }
    tabController.animateTo(tabController.index + 1);
  }

  Widget _buildOtpIntroWidget(String image, String des, String imageDes) {
    final happyRatio = SizeConfig.isIphoneX() ? 1 : 0.75;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: kMediumPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(),
          Container(
            alignment: Alignment.center,
            child: ImageHelper.loadFromAsset(
              image,
              width: 200.toScreenSize * happyRatio,
              height: 180.toScreenSize * happyRatio,
              fit: BoxFit.contain,
            ),
          ),
          const Spacer(),
          ImageHelper.loadFromAsset(
            imageDes,
            height: 50.toScreenSize * happyRatio,
            fit: BoxFit.contain,
          ),
          SizedBox(
            height: kDefaultPadding.toScreenSize,
          ),
          Container(
            constraints: BoxConstraints(
              maxWidth: 242.toScreenSize * happyRatio,
            ),
            child: Text(des,
                style:
                    const TextStyle(color: Color.fromRGBO(102, 102, 103, 1))),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: listIntroObject.length,
      child: TabBarView(
        controller: tabController,
        children: listIntroObject
            .map((e) => _buildOtpIntroWidget(e.image, e.des, e.imageDes))
            .toList(),
      ),
    );
  }
}
