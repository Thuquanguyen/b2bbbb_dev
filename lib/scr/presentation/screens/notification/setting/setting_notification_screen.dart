import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/presentation/screens/notification/setting/list_account_setting_screen.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SettingNotificationScreen extends StatefulWidget {
  const SettingNotificationScreen({Key? key}) : super(key: key);

  static const String routeName = 'setting-notification-screen';

  @override
  _SettingNotificationScreenState createState() =>
      _SettingNotificationScreenState();
}

class _SettingNotificationScreenState extends State<SettingNotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
        appBarType: AppBarType.NORMAL,
        title: AppTranslate.i18n.titleSettingNotificationStr.localized,
        child: _buildNotificationSettings());
  }

  Widget _buildMenuItem({
    String? svgIcon,
    required String title,
    String? description,
    bool isSwitch = false,
    bool value = false,
    Function(bool)? onChanged,
    Function? onTap,
    double? overridePadding,
  }) {
    return Touchable(
      onTap: () {
        if (onTap != null && !isSwitch) onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: overridePadding ?? 25),
        child: Row(
          children: [
            svgIcon != null ? SvgPicture.asset(svgIcon) : Container(),
            const SizedBox(
              width: 22,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: kStyleTextUnit,
                  ),
                  description != null
                      ? const SizedBox(
                          height: 5,
                        )
                      : Container(),
                  description != null
                      ? Text(
                          description,
                          style: kStyleTextSubtitle,
                        )
                      : Container(),
                ],
              ),
            ),
            isSwitch
                ? _buildSwitch(value: value, onChanged: onChanged)
                : SvgPicture.asset(AssetHelper.icoForward1),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch({
    required bool value,
    required Function(bool)? onChanged,
  }) {
    return Touchable(
        child: Transform.scale(
      scale: 0.7,
      child: CupertinoSwitch(
        value: value,
        onChanged: (value) {
          if (onChanged != null) onChanged(!value);
        },
        activeColor: Colors.green,
      ),
    ));
  }

  Widget _buildSeparator() {
    return Container(
      height: 1,
      color: const Color.fromRGBO(237, 241, 246, 1.0),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
          top: 5,
          bottom: kDefaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [kBoxShadowContainer],
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  _buildMenuItem(
                    svgIcon: AssetHelper.icoBell,
                    title: AppTranslate
                        .i18n.stsNotificationBalancePreviewStr.localized,
                    isSwitch: true,
                    overridePadding: 17,
                  ),
                  Text(
                    AppTranslate
                        .i18n.stsNotificationBalancePreviewDescStr.localized,
                    style: kStyleTextSubtitle,
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  _buildSeparator(),
                  _buildMenuItem(
                      svgIcon: AssetHelper.icoChart,
                      title: AppTranslate
                          .i18n.stsNotificationTransactionStr.localized,
                      onTap: () {
                        pushNamed(context, ListAccountSettingScreen.routeName);
                      }),
                  _buildMenuItem(
                    title: AppTranslate
                        .i18n.stsNotificationTransactionPendingStr.localized,
                    isSwitch: true,
                  ),
                  _buildMenuItem(
                    title: AppTranslate
                        .i18n.stsNotificationTransactionStep1Str.localized,
                    isSwitch: true,
                  ),
                  _buildMenuItem(
                    title: AppTranslate
                        .i18n.stsNotificationTransactionWaitingStr.localized,
                    isSwitch: true,
                  ),
                  _buildMenuItem(
                    title: AppTranslate
                        .i18n.stsNotificationTransactionErrorStr.localized,
                    isSwitch: true,
                  ),
                  _buildSeparator(),
                  _buildMenuItem(
                    svgIcon: AssetHelper.icoGift,
                    title: AppTranslate.i18n.stsNotificationOtherStr.localized,
                    description:
                        AppTranslate.i18n.stsNotificationOtherDescStr.localized,
                    isSwitch: true,
                  ),
                  _buildSeparator(),
                ],
                mainAxisSize: MainAxisSize.min,
              ))
        ],
      ),
    );
  }
}
