import 'package:flutter/material.dart';
import 'palette.dart';

extension ExtendedTextStyle on TextStyle {
  TextStyle get light {
    return this.copyWith(fontWeight: FontWeight.w300);
  }

  TextStyle get w400 {
    return this.copyWith(fontWeight: FontWeight.w400);
  }

  TextStyle get regular {
    return this.copyWith(fontWeight: FontWeight.w500);
  }

  TextStyle get italic {
    return this
        .copyWith(fontWeight: FontWeight.normal, fontStyle: FontStyle.italic);
  }

  TextStyle get medium {
    return this.copyWith(fontWeight: FontWeight.w600);
  }

  TextStyle get semibold {
    return this.copyWith(fontWeight: FontWeight.w700);
  }

  TextStyle get semiboldDisable {
    return this.copyWith(fontWeight: FontWeight.w600, color: Colors.black38);
  }

  TextStyle get bold {
    return this.copyWith(fontWeight: FontWeight.w800);
  }

  TextStyle get whiteColor {
    return this.copyWith(color: AppColors.gLightTextColor);
  }

  TextStyle get blackColor {
    return this.copyWith(color: AppColors.gDarkTextColor);
  }

  TextStyle get tabSelctedColor {
    return this.copyWith(color: AppColors.gTextInputColor);
  }

  TextStyle get inputTextColor {
    return this.copyWith(color: AppColors.gTextInputColor);
  }

  TextStyle get tabUnSelctedColor {
    return this.copyWith(color: AppColors.gUnSelectedTextColor);
  }

  TextStyle get normalColor {
    return this.copyWith(color: AppColors.slateGrey);
  }

  TextStyle get slateGreyColor {
    return this.copyWith(color: AppColors.gTextColor);
  }

  TextStyle get greenColor {
    return this.copyWith(color: AppColors.gPrimaryColor);
  }

  TextStyle get redColor {
    return this.copyWith(color: AppColors.gRedTextColor);
  }

  TextStyle get unitColor {
    return this.copyWith(color: AppColors.gPrimaryColor);
  }

  TextStyle get hintTextColor {
    return this.copyWith(color: AppColors.gUnSelectedTextColor);
  }

  TextStyle get darkInk400 {
    return this.copyWith(color: AppColors.darkInk400);
  }

  TextStyle get darkInk500 {
    return this.copyWith(color: AppColors.darkInk500);
  }

  TextStyle setColor(Color color) {
    return copyWith(color: color);
  }

  TextStyle setFontWeight(FontWeight fontWeight) {
    return copyWith(fontWeight: fontWeight);
  }

  TextStyle setTextSize(double size) {
    return copyWith(fontSize: size);
  }
}

class TextStyles {
  static const double _height = 1.4;

  static const TextStyle _defaultStyle = TextStyle(
    fontSize: 14,
    color: Color.fromRGBO(102, 102, 103, 1.0),
    height: _height,
  );

  /// Text use for normal OTP number
  ///
  /// Default: size: 24, weight: medium
  static TextStyle otpText1 = _defaultStyle.copyWith(fontSize: 24).medium;

  /// Text use for Smart OTP number
  ///
  /// Default: size: 35, weight: medium
  static TextStyle otpText2 = _defaultStyle.copyWith(fontSize: 35).medium;

  /// Text use for coundown timer at normal OTP view
  ///
  /// Default: size: 30, weight: regular
  static TextStyle countdownText1 =
      _defaultStyle.copyWith(fontSize: 30).regular;

  /// Text use for coundown timer at smart OTP view
  ///
  /// Default: size: 22, weight: regular
  static TextStyle countdownText2 =
      _defaultStyle.copyWith(fontSize: 22).regular;

  /// Text use for heading text
  ///
  /// Default: size: 20, weight: bold
  static TextStyle headingText = _defaultStyle.copyWith(fontSize: 20).bold;

  /// Text use for big button, button in card, navbar title, header of list, loading text, ...
  ///
  /// Default: size: 16, weight: semibold
  static TextStyle headerText = _defaultStyle.copyWith(fontSize: 16).semibold;

  /// Text use for big button, button in card, navbar title, header of list, loading text, ...
  ///
  /// Default: size: 13, weight: semibold
  static TextStyle semiBoldText = _defaultStyle.copyWith(fontSize: 13).semibold;

  /// Text use for regular button
  ///
  /// Default: size: 15, weight: regular
  static TextStyle buttonText = _defaultStyle.copyWith(fontSize: 15).regular;

  /// Text use for normal text in project
  ///
  /// Default: size: 14, weight: regular
  static TextStyle normalText = _defaultStyle.regular;

  /// Text use for item's title text like: bottom bar, header items, ...
  ///
  /// Default: size: 13, weight: regular
  static TextStyle itemText = _defaultStyle.copyWith(fontSize: 13).regular;

  /// Text use for item's title text like: bottom bar, header items, ...
  ///
  /// Default: size: 13, weight: regular
  static TextStyle headerItemText = _defaultStyle.copyWith(fontSize: 14).bold;

  /// Text use for small text like: note, guideline text, ...
  ///
  /// Default: size: 12, weight: regular
  static TextStyle smallText = _defaultStyle.copyWith(fontSize: 12).regular;

  /// Text use for caption of TextField
  ///
  /// Default: size: 10, weight: regular
  static TextStyle captionText = _defaultStyle.copyWith(fontSize: 10).regular;

  /// Text use for caption of TextField
  ///
  /// Default: size: 10, weight: regular
  static TextStyle captionBoldText = _defaultStyle.copyWith(fontSize: 10).bold;

  static TextStyle gNavBarText = headerText.whiteColor;
  static TextStyle gDescriptionText = itemText.slateGreyColor;
  static TextStyle gHeader = headerText.slateGreyColor;
  static TextStyle gSection = headerText.normalColor;
  static TextStyle gButton = headerText.whiteColor;
  static TextStyle gLink = normalText.greenColor;
  static TextStyle gUnselectedTabbar = smallText.whiteColor;
  static TextStyle gSelectedTabbar = smallText.greenColor;
}
// How to use?
// Text('test text', style: TextStyles.normalText.semibold.whiteColor);
// Text('test text', style: TextStyles.itemText.whiteColor.bold);
