import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/auth/session_model.dart';
import 'package:b2b/scr/data/model/information_title_model.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/state_builder.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  static const String routeName = 'profile-screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  SessionModel? sessionModel;
  final StateHandler _stateHandler = StateHandler(ProfileScreen.routeName);

  @override
  void initState() {
    super.initState();
    initSession();
  }

  Future<void> initSession() async {
    sessionModel = await SessionManager().load();
    _stateHandler.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
        appBarType: AppBarType.MEDIUM,
        title: AppTranslate.i18n.profileTitleHeaderStr.localized,
        // actions: [
        //   GestureDetector(
        //       onTap: () {
        //         SessionManager().logout(showAskDialog: true);
        //       },
        //       child: Padding(
        //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //         child: ImageHelper.loadFromAsset(AssetHelper.icoLogout, height: 24, width: 24, tintColor: Colors.white),
        //       ))
        // ],
        child: StateBuilder(
            builder: () {
              return Container(
                margin: const EdgeInsets.only(left: 16, right: 16),
                width: SizeConfig.screenWidth,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _itemInformation(AppTranslate.i18n.profileTitleBusinessInformationStr.localized, [
                        TitleModel(
                            title: AppTranslate.i18n.profileTitleCustomerNameStr.localized,
                            content: sessionModel?.customer?.custName ?? ""),
                        TitleModel(
                            title: AppTranslate.i18n.profileTitleCustomerAddressStr.localized,
                            content: sessionModel?.customer?.custAddress ?? ""),
                        TitleModel(
                            title: AppTranslate.i18n.profileTitleCustomerServicePackageStr.localized,
                            content: sessionModel?.customer?.servicePackageDisplay?.localization() ?? ""),
                        TitleModel(
                            title: AppTranslate.i18n.profileTitleCustomerCreditLimitStr.localized,
                            content: sessionModel?.customer?.levelCodeDisplay?.localization() ?? "")
                      ]),
                      _itemInformation(AppTranslate.i18n.profileTitleInformationStr.localized, [
                        TitleModel(
                            title: AppTranslate.i18n.profileTitleFullNameStr.localized,
                            content: sessionModel?.user?.fullName ?? ""),
                        TitleModel(
                            title: AppTranslate.i18n.profileTitleIDPassportNumberStr.localized,
                            content: sessionModel?.user?.certId ?? "")
                      ]),
                      _itemInformation(AppTranslate.i18n.profileTitleAccountInformationStr.localized, [
                        // TitleModel(
                        //     title: AppTranslate.i18n.firstLoginTitleUsernameStr.localized,
                        //     content: sessionModel?.user?.username ?? ""),
                        TitleModel(
                            title: AppTranslate.i18n.profileTitleOtpMethodReceivingStr.localized,
                            content: sessionModel?.user?.otpMethodName?.localization() ?? ""),
                        TitleModel(
                            title: AppTranslate.i18n.profileTitleOtpPhoneNumberReceivingStr.localized,
                            content: sessionModel?.user?.otpPhone ?? ""),
                        TitleModel(
                            title: AppTranslate.i18n.profileTitleOtpEmailReceivingStr.localized,
                            content: sessionModel?.user?.otpEmail ?? ""),
                        TitleModel(
                            title: AppTranslate.i18n.profileTitleRoleStr.localized,
                            content: sessionModel?.user?.roleName?.localization() ?? ""),
                        TitleModel(
                          title: AppTranslate.i18n.profileTitleLastLoginStr.localized,
                          content: (sessionModel?.user?.getLastLoginText() ?? ""),
                        )
                      ]),
                      // Container(
                      //   margin: EdgeInsets.only(
                      //       left: 16,
                      //       right: 16,
                      //       top: 30,
                      //       bottom: SizeConfig.bottomSafeAreaPadding + 16),
                      //   child: RoundedButtonWidget(
                      //     title: AppTranslate.i18n.profileTitleLogoutStr.localized,
                      //     onPress: () {
                      //       SessionManager().logout(showAskDialog: true);
                      //     },
                      //     height: kButtonHeight,
                      //   ),
                      // )
                    ],
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                ),
              );
            },
            routeName: ProfileScreen.routeName));
  }

  Widget _itemInformation(String _title, List<TitleModel> _listContent) {
    return Container(
      padding: const EdgeInsets.only(left: 14, right: 14, bottom: 20, top: 22),
      margin: const EdgeInsets.only(top: 10, bottom: 10),
      decoration: kDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _title,
            style: const TextStyle(
                color: Color.fromRGBO(52, 52, 52, 1.0), fontSize: 16, height: 1.4, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),
          Column(children: _listContent.map((model) => _itemTitle(model.title, model.content)).toList())
        ],
      ),
    );
  }

  Widget _itemTitle(String title, String content) => Container(
        margin: const EdgeInsets.only(top: 3, bottom: 3),
        child: Row(
          children: [
            Expanded(
                child: Text(
              title,
              style: const TextStyle(
                  color: Color.fromRGBO(52, 52, 52, 1.0), fontSize: 13, fontWeight: FontWeight.normal, height: 1.4),
              textAlign: TextAlign.right,
            )),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                content,
                style: const TextStyle(
                    color: Color.fromRGBO(52, 52, 52, 1.0), fontSize: 13, fontWeight: FontWeight.w600, height: 1.4),
                textAlign: TextAlign.left,
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      );
}
