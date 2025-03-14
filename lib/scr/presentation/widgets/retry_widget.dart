import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:flutter/material.dart';

import '../../core/extensions/palette.dart';
import '../../core/extensions/textstyles.dart';
import '../../core/language/app_translate.dart';

class RetryWidget extends StatelessWidget {
  final Function()? callBack;
  final String? message;

  const RetryWidget({Key? key, this.callBack, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (message.isNotNullAndEmpty)
            Text(
              message ?? '',
              style: TextStyles.headerText.slateGreyColor,
            ),
          if (message.isNotNullAndEmpty)
            const SizedBox(
              height: 30,
            ),
          Touchable(
            onTap: callBack,
            child: Column(
              children: [
                Icon(Icons.refresh, color: AppColors.gPrimaryColor, size: 30),
                Text(
                  AppTranslate.i18n.retryStr.localized,
                  style:
                      TextStyles.buttonText.setColor(AppColors.gPrimaryColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
