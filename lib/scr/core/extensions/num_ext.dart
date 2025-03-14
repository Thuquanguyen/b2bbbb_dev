import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/utilities/logger.dart';

import 'string_ext.dart';

extension ExtendedNumber on num {
  double get toScreenSize {
    double designRatio = screenWidthInDesign / screenHeightInDesign;
    double deviceRatio = SizeConfig.screenWidth / SizeConfig.screenHeight;
    if (deviceRatio <= designRatio) {
      return (this / screenWidthInDesign) * SizeConfig.screenWidth;
    } else {
      return (this / screenHeightInDesign) * SizeConfig.screenHeight;
    }
    // return (this / screenWidthInDesign) * SizeConfig.screenWidth;
  }

  String get toMoneyString {
    String result = '';
    String value = toString();
    if(!value.contains('.')){
      return value.toMoneyFormat;
    }

    String first = value.substring(0, value.indexOf('.'));
    String last =
        value.contains('.') ? value.substring(value.indexOf('.')) : '';

    if(last == '.0' || last == '.00'){
      last = '';
    }

    result = first.toMoneyFormat + last;
    return result;
  }
}
