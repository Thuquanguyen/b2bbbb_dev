// ignore_for_file: constant_identifier_names

import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/size/size_config.dart';

// * PADDING, HEIGHT, SIZE, RADIUS CONSTANTS
const kDefaultPadding = 16.0;
const kMediumPadding = 24.0;
const kMinPadding = 5.0;
const kTopPadding = 8.0;
const kItemPadding = 10.0;
const kPickerSheetHeight = 262.0;

const kButtonHeight = 44.0;
const kButtonCornerRadius = 40.0;

const kCornerRadius = 8.0;

const kLeadingIconSize = 32.0;

const kMaxLengthAmountContent = 210;
const kMaxLengthBeneficiary = 70;
const kMaxLengthReminiscent = 500;
const kMaxLengthAmount = 17;

// * BORDER
const kBorderSide = BorderSide(
  color: Color.fromRGBO(186, 205, 223, 1),
  width: 0.5,
);
const kBorderSide1px = BorderSide(
  color: Color.fromRGBO(186, 205, 223, 1),
  width: 1,
);
const kBorderSide1pxGrey = BorderSide(
  color: Color.fromRGBO(233, 234, 236, 1),
  width: 1,
);
const kButtonBorder = BorderSide(
  color: Color.fromRGBO(226, 232, 240, 1),
  width: 1,
);

const regexRuleTransferContent =
    '[-a-zA-Z0-9 .+,()ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂưăạảấầẩẫậắằẳẵặẹẻẽềềểỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳýỵỷỹ]';

// const regexRuleTransferContent = '[-a-zA-Z0-9\u0020-\u007E-\u0024-\u00A9 .+()]';
// * COLOR TEXTFROMFIELD
const kTextHeight = 60.0;
const kTextNumberHeight = 66.0;

const kStyleTitleHeader =
    TextStyle(color: Color.fromRGBO(102, 102, 103, 1.0), fontSize: 10, fontWeight: FontWeight.normal);
const kStyleTitleText = TextStyle(color: Color.fromRGBO(52, 52, 52, 1.0), fontSize: 13, fontWeight: FontWeight.normal);
const kStyleTitleNumber = TextStyle(color: Color.fromRGBO(52, 52, 52, 1.0), fontSize: 24, fontWeight: FontWeight.w500);
const kStyleASTitle = TextStyle(color: Color.fromRGBO(102, 102, 103, 1.0), fontSize: 12, fontWeight: FontWeight.normal);

const kStyleASSemiBoldText =
    TextStyle(color: Color.fromRGBO(52, 52, 52, 1.0), fontSize: 12, fontWeight: FontWeight.w500);

const kStyleTextHeaderSemiBold = TextStyle(
  color: Color.fromRGBO(102, 102, 103, 1),
  fontSize: 16,
  height: 24 / 16,
  fontWeight: FontWeight.w600,
);

const kDialogButtonBoldText = TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 16,
  height: 1.8,
  color: Color.fromRGBO(255, 103, 99, 1),
);

// * COLOR TEXT
const kStyleTextUnit =
    TextStyle(color: Color.fromRGBO(52, 52, 52, 1.0), fontSize: 14, fontWeight: FontWeight.w600, height: 1.4);
const kStyleTextSubtitle = TextStyle(color: Color.fromRGBO(102, 102, 103, 1.0), fontSize: 13, height: 1.4);
// * BoxShadow
const kBoxShadowContainer =
    BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), offset: Offset(0, 4), blurRadius: 8, spreadRadius: 0);

const kBoxShadowCenterContainer =
    BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), offset: Offset(0, 0), blurRadius: 8, spreadRadius: 0);

// * DIVIDER
const kColorDivider = Color(0xffEDF1F6);
const kColorTabIndicator = Color.fromRGBO(0, 183, 79, 1);
const blueTextColor = Color(0xff00B74F);

// * GRADIENT
const LinearGradient kGradientBackground = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  // ignore: always_specify_types
  colors: [
    Color.fromRGBO(0, 183, 79, 1.0),
    Color.fromRGBO(29, 66, 137, 1.0),
  ],
);

const LinearGradient kGradientBackgroundH = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.topRight,
  // ignore: always_specify_types
  colors: [
    Color.fromRGBO(29, 66, 137, 1.0),
    Color.fromRGBO(0, 183, 79, 1.0),
  ],
);

const LinearGradient snackBarBackground = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.topRight,
  // ignore: always_specify_types
  colors: [
    Color.fromRGBO(29, 66, 137, 1.0),
    Color.fromRGBO(61, 39, 95, 1.0),
  ],
);

const LinearGradient kGradientBackgroundAppBar = LinearGradient(
  begin: Alignment.topRight,
  end: Alignment.bottomLeft,
  // ignore: always_specify_types
  colors: [
    Color.fromRGBO(0, 183, 79, 1.0),
    Color.fromRGBO(20, 112, 114, 1.0),
  ],
);

const LinearGradient bottomBarBg = LinearGradient(
  begin: Alignment.centerRight,
  end: Alignment.centerLeft,
  // ignore: always_specify_types
  colors: [
    Color.fromRGBO(0, 183, 79, 1.0),
    Color.fromRGBO(12, 139, 101, 1.0),
    Color.fromRGBO(22, 99, 121, 1.0),
  ],
);

List<Color> benIconLeftColor = [
  const Color.fromRGBO(21, 99, 121, 1),
  const Color.fromRGBO(7, 159, 92, 1),
  const Color.fromRGBO(15, 124, 109, 1),
  const Color.fromRGBO(9, 150, 96, 1)
];

Color? getColor(int index) {
  Color? bgColor;
  for (int i = benIconLeftColor.length; i > 0; i--) {
    if ((index % i == 0)) {
      bgColor = benIconLeftColor[i - 1];
      return bgColor;
    }
  }
}

// Get the proportionate height as per screen size
double getInScreenSize(double inputWidth, {double? max, double? min, bool fitHeight = false}) {
  double newSize = (inputWidth / screenWidthInDesign) * SizeConfig.screenWidth;
  if (max != null && newSize > max) {
    return max;
  }
  if (min != null && newSize < min) {
    return min;
  }
  if (fitHeight) {
    double designRatio = screenWidthInDesign / screenHeightInDesign;
    double deviceRatio = SizeConfig.screenWidth / SizeConfig.screenHeight;
    if (deviceRatio <= designRatio) {
      return newSize;
    } else {
      return (inputWidth / screenHeightInDesign) * SizeConfig.screenHeight;
    }
  }
  return newSize;
}

const double screenWidthInDesign = 375.0;
const double screenHeightInDesign = 812.0;

// * DURATIONS
const Duration kAnimationDuration = Duration(milliseconds: 200);

const apiAccessToken = 'RXNiU3lzdGVtOjIx';
// const SESSION_ID = 'SESSION_ID';
const SESSION_DATA = 'SESSION_DATA';
const RELOAD_SESSION = 'RELOAD_SESSION';
const RELOAD_NOTIFICATION = 'RELOAD_NOTIFICATION';
const LIST_SECOND_HOME = 'LIST_SECOND_HOME';
const CHECK_REVIEW_OTP_INTRO = 'CHECK_REVIEW_OTP_INTRO';
const gcpApiKey = 'AIzaSyBz33Ex77rw_rjmwXkF5ts9EuQac-ExGvM';
const SECURE_PASSWORD = 'data2021@vpbCorp';

const kBoxShadow =
    BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), offset: Offset(0, 0.2), blurRadius: 1, spreadRadius: 1);
const kDecoration = BoxDecoration(
    color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(14)), boxShadow: [kBoxShadowCommon]);

final kDecorationShimmer =
    BoxDecoration(color: AppColors.shimmerItemColor, borderRadius: BorderRadius.all(const Radius.circular(8)));

const kBoxShadowCommon =
    BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), offset: Offset(0, 4), blurRadius: 8, spreadRadius: 0);

const EXPIRED_TIME = 180000; //milliseconds
const SESSION_TIMEOUT = 'SESSION_TIMEOUT';
const SESSION_MESSAGE = 'SESSION_MESSAGE';

const LOGOUT_EVENT = 'LOGOUT_EVENT';
const LOGOUT_EVENT_MESSAGE = 'LOGOUT_EVENT_MESSAGE';
const LOGOUT_EVENT_ACTION = 'LOGOUT_EVENT_ACTION';

const CHANGE_TAB_EVENT = 'CHANGE_TAB_EVENT';
const CHANGE_VIEW_BALANCE = 'CHANGE_VIEW_BALANCE';

const accountDetailArgument = 'accountDetailArgument';
const savingAccountDetailArgument = 'savingAccountDetailArgument';
const accountHistoryListArgument = 'accountHistoryListArgument';

const colorSlateGrey = Color.fromRGBO(102, 102, 103, 1);

const kIncreaseMoneyColor = Color.fromRGBO(0, 183, 79, 1);
const kDecreaseMoneyColor = Color.fromRGBO(255, 103, 99, 1);

const snackBarBgColor = Color.fromRGBO(0, 183, 79, 1);
