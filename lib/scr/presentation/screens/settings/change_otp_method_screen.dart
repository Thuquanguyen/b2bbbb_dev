import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChangeOTPMethodScreen extends StatefulWidget {
  const ChangeOTPMethodScreen({Key? key}) : super(key: key);
  static const String routeName = 'change-otp-method-screen';

  @override
  _ChangeOTPMethodScreenState createState() => _ChangeOTPMethodScreenState();
}

class _ChangeOTPMethodScreenState extends State<ChangeOTPMethodScreen> {
  @override
  void initState() {
    super.initState();
  }

  Widget _buildSeparator() {
    return Container(
      height: 1,
      color: const Color.fromRGBO(237, 241, 246, 1.0),
    );
  }

  Widget _buildItem({
    required String icon,
    required String title,
    String? desc,
    required isSelected,
    required Function onTap,
  }) {
    return SizedBox(
      height: 64,
      child: Row(
        children: [
          SizedBox(
            width: 24,
            child: SvgPicture.asset(icon),
          ),
          const SizedBox(
            width: 22,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: kStyleTextUnit,
                ),
                desc != null
                    ? Text(
                        desc,
                        style: kStyleTextSubtitle,
                      )
                    : Container(),
              ],
            ),
          ),
          SvgPicture.asset(
            isSelected
                ? AssetHelper.icoRadioBtnSelected
                : AssetHelper.icoRadioBtn,
          ),
        ],
      ),
    );
  }

  Widget _contentBuilder(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: kDefaultPadding,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [kBoxShadowContainer],
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                _buildItem(
                  icon: AssetHelper.icoPhone1,
                  title: AppTranslate.i18n.cotpsSmsStr.localized,
                  desc: AppTranslate.i18n.cotpsSmsDescStr.localized,
                  isSelected: true,
                  onTap: () {},
                ),
                _buildSeparator(),
                _buildItem(
                  icon: AssetHelper.icoEmail,
                  title: AppTranslate.i18n.cotpsEmailStr.localized,
                  desc: AppTranslate.i18n.cotpsEmailDescStr.localized,
                  isSelected: true,
                  onTap: () {},
                ),
                _buildSeparator(),
                _buildItem(
                  icon: AssetHelper.icoSmartotp,
                  title: AppTranslate.i18n.cotpsSotpStr.localized,
                  isSelected: true,
                  onTap: () {},
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      appBarType: AppBarType.MEDIUM,
      title: AppTranslate.i18n.cotpsScreenTitleStr.localized,
      child: _contentBuilder(context),
    );
  }
}
