import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/notification/account_setting_noti_model.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingAccountItem extends StatelessWidget {
  SettingAccountItem(
      {Key? key,
      this.accountSettingNotiModel,
      this.callBack,
      this.isOn = false})
      : super(key: key);

  final AccountSettingNotiModel? accountSettingNotiModel;
  final Function? callBack;
  bool? isOn;

  @override
  Widget build(BuildContext context) {
    isOn = accountSettingNotiModel?.enable ?? false;
    return Container(
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppTranslate.i18n.titleAccountStr.localized,
                style: TextStyles.itemText.slateGreyColor,
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Text(
                    '${accountSettingNotiModel?.accountCurrency ?? ''} - ${accountSettingNotiModel?.accountNumber ?? ''}',
                    style: TextStyles.semiBoldText.tabSelctedColor,
                  )
                ],
              ),
            ],
          )),
          StatefulBuilder(
              builder: (context, setState) => Transform.scale(
                    scale: 0.7,
                    child: CupertinoSwitch(
                      value: isOn ?? false,
                      onChanged: (value) {
                        Logger.debug('value value ============ > $value');
                        setState(() => isOn = value);
                        setTimeout(() {
                          callBack?.call(value);
                        }, 500);
                      },
                      activeColor: Colors.green,
                    ),
                  ))
        ],
      ),
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
                  color: Color.fromRGBO(244, 249, 253, 1), width: 1))),
      padding: const EdgeInsets.only(top: 18, bottom: 18),
      margin: const EdgeInsets.only(
        left: kDefaultPadding,
        right: 24,
      ),
    );
  }
}
