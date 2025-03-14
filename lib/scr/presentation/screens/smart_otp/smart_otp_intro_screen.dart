// Created by Cuonghd2 at 05/08/2021
// Email: cuonghd2@vpbank.com.vn
// Copyright (c) 2020. All rights reserved.

import 'dart:async';

import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/list_opt_intro.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/rounded_button_widget.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';

class SmartOTPIntroScreen extends StatefulWidget {
  const SmartOTPIntroScreen({Key? key}) : super(key: key);
  static String routeName = '/smartOtpIntroScreen';

  @override
  _SmartOTPIntroScreenState createState() => _SmartOTPIntroScreenState();
}

class _SmartOTPIntroScreenState extends State<SmartOTPIntroScreen> {
  final StreamController<int> _sliderStreamController = StreamController<int>.broadcast();

  final GlobalKey<ListOTPIntroState> _keyOtpIntro = GlobalKey<ListOTPIntroState>();

  Function? onNext;

  @override
  void initState() {
    super.initState();

    init();
  }

  void init() {
    bool isVi = AppTranslate().currentLanguage == SupportLanguages.Vi;
    listIntroObject = [
      OtpIntroModel(
        AppTranslate.i18n.otpIntroModel1Str.localized,
        AssetHelper.smartOtpIntro1,
        isVi ? AssetHelper.imgSmartOtpIntroDes1 : AssetHelper.imgSmartOtpIntroDes1En,
        const Color.fromRGBO(29, 66, 137, 1),
      ),
      OtpIntroModel(
        AppTranslate.i18n.otpIntroModel2Str.localized,
        AssetHelper.smartOtpIntro2,
        isVi ? AssetHelper.imgSmartOtpIntroDes2 : AssetHelper.imgSmartOtpIntroDes2En,
        const Color.fromRGBO(29, 88, 97, 1),
      ),
      OtpIntroModel(
        AppTranslate.i18n.otpIntroModel3Str.localized,
        AssetHelper.smartOtpIntro3,
        isVi ? AssetHelper.imgSmartOtpIntroDes3 : AssetHelper.imgSmartOtpIntroDes3En,
        const Color.fromRGBO(21, 127, 80, 1),
      ),
      OtpIntroModel(
        AppTranslate.i18n.otpIntroModel4Str.localized,
        AssetHelper.smartOtpIntro4,
        isVi ? AssetHelper.imgSmartOtpIntroDes4 : AssetHelper.imgSmartOtpIntroDes4En,
        const Color.fromRGBO(0, 183, 79, 1),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    onNext = getArgument<Function>(context, 'onNext');

    return AppBarContainer(
      title: 'Smart OTP',
      appBarType: AppBarType.MEDIUM,
      child: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(kDefaultPadding))),
              child: ListOTPIntro(
                key: _keyOtpIntro,
                callbackFromSlide: (index) {
                  _sliderStreamController.add(index);
                },
              ),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.symmetric(horizontal: kDefaultPadding * 2, vertical: kDefaultPadding + kTopPadding),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Wrap(
                      spacing: 8.toScreenSize,
                      children: List<int>.generate(4, (index) => index)
                          .map((e) => StreamBuilder<int>(
                                initialData: 0,
                                stream: _sliderStreamController.stream,
                                builder: (context, snapShotData) {
                                  return Container(
                                    height: 14.toScreenSize,
                                    width: 14.toScreenSize,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: e == snapShotData.data
                                              ? const Color.fromRGBO(6, 158, 78, 1)
                                              : Colors.transparent,
                                          width: 1),
                                      borderRadius: BorderRadius.all(Radius.circular(14.toScreenSize)),
                                    ),
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10.toScreenSize)),
                                        color: listIntroObject[e].colorDot,
                                      ),
                                    ),
                                  );
                                },
                              ))
                          .toList(),
                    ),
                    Touchable(
                      onTap: () {
                        // popScreen(context);
                        // SmartOTPManager().saveCheckReviewOTPIntro();
                        onNext?.call(context);
                      },
                      child: Row(
                        children: [
                          Text(
                            AppTranslate.i18n.dialogButtonSkipStr.localized.toUpperCase(),
                            style: TextStyles.normalText.slateGreyColor.copyWith(height: 1.5),
                          ),
                          ImageHelper.loadFromAsset(
                            AssetHelper.icoDoubleForward,
                            height: 24.toScreenSize,
                            width: 24.toScreenSize,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50.toScreenSize,
                ),
                StreamBuilder<int>(
                    stream: _sliderStreamController.stream,
                    builder: (_context, snapshot) {
                      return RoundedButtonWidget(
                        title: snapshot.data == 3
                            ? AppTranslate.i18n.smartOtpIntroTitleStartUseStr.localized
                            : AppTranslate.i18n.continueStr.localized.toUpperCase(),
                        onPress: () {
                          if (snapshot.data == 3) {
                            onNext?.call(context);
                          } else {
                            _keyOtpIntro.currentState?.jumpToNextPage();
                          }
                        },
                        height: 44,
                      );
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }
}
