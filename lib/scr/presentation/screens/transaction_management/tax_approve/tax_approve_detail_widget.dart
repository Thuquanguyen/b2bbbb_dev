import 'package:b2b/config.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/environment/app_enviroment_manager.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/tax/tax_online.dart';
import 'package:b2b/scr/presentation/screens/term/term_screen.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/vp_html_text.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';

class TaxApproveDetailWidget extends StatelessWidget {
  const TaxApproveDetailWidget({
    Key? key,
    this.tax,
  }) : super(key: key);

  final TaxOnline? tax;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              bottom: kDefaultPadding,
            ),
            width: double.infinity,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
                vertical: kDefaultPadding,
              ),
              decoration: BoxDecoration(
                boxShadow: const [kBoxShadowContainer],
                borderRadius: BorderRadius.circular(14),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTranslate.i18n.customerInfoStr.localized,
                    style: TextStyles.headerItemText.copyWith(
                      color: AppColors.gPrimaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  buildInfoItem(
                    title: AppTranslate.i18n.taxIdStr.localized,
                    description: tax?.taxCode,
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: buildInfoItem(
                          title: AppTranslate.i18n.taxAccountStr.localized,
                          description: tax?.transInfo?.account,
                          iconPath: AssetHelper.icoWallet1,
                        ),
                      ),
                      Expanded(
                        child: buildInfoItem(
                          title: AppTranslate.i18n.taxFeeAccountStr.localized,
                          description: tax?.transInfo?.accountFee,
                          iconPath: AssetHelper.icoWallet1,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  Text(
                    AppTranslate.i18n.generalTaxInfoStr.localized,
                    style: TextStyles.headerItemText.copyWith(
                      color: AppColors.gPrimaryColor,
                    ),
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  buildInfoItem(
                    title: AppTranslate.i18n.taxPayerNameStr.localized,
                    description: tax?.customerName,
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  buildInfoItem(
                    title: AppTranslate.i18n.emailStr.localized,
                    description: tax?.customerEmail,
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  buildInfoItem(
                    title: AppTranslate.i18n.phoneNumberStr.localized,
                    description: tax?.customerPhoneNumber,
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  buildInfoItem(
                    title: AppTranslate.i18n.addressStr.localized,
                    description: tax?.address,
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  buildInfoItem(
                    title: 'Serial Number',
                    description: tax?.caSerialNumber,
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  if (tax?.shouldShowRejectReason == true)
                    buildInfoItem(
                      title: AppTranslate.i18n.tasTdRejectCauseStr.localized,
                      description: tax?.transInfo?.reason,
                    ),
                  if (tax?.shouldShowRejectReason == true)
                    const SizedBox(
                      height: kDefaultPadding,
                    ),
                  Touchable(
                    onTap: () {
                      openTermAndCondition(context);
                    },
                    child: VPHTMLText(
                      content: AppTranslate.i18n.taxTcNoticeStr.localized,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openTermAndCondition(BuildContext context) {
    String url = AppEnvironmentManager.apiUrl;
    url = url.replaceAll('/api', '');
    url = '$url/tax_register_online_t&c.html';
    if (AppEnvironmentManager.environment == AppEnvironment.Pro) {
      url = 'https://api-b2b.vpbank.com.vn/mapi/tax_register_online_t&c.html';
    }
    Navigator.of(context).pushNamed(
      TermScreen.routeName,
      arguments: TermModel(
        AppTranslate.i18n.homeTitleTermHeaderStr.localized,
        url,
        () {},
      ),
    );
  }

  Widget buildInfoItem({
    required String title,
    String? iconPath,
    String? description,
    Widget? child,
    bool isGreen = false,
    bool isRed = false,
    bool visible = true,
  }) {
    if (visible == false) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.captionText,
        ),
        SizedBox(
          height: (iconPath != null || child != null) ? 8 : 4,
        ),
        Row(
          children: [
            if (iconPath != null) ImageHelper.loadFromAsset(iconPath),
            if (iconPath != null)
              const SizedBox(
                width: kDefaultPadding,
              ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (description != null)
                    Text(
                      description,
                      style: TextStyles.itemText.regular.copyWith(
                        color: isGreen
                            ? AppColors.gPrimaryColor
                            : (isRed ? AppColors.gRedTextColor : AppColors.darkInk500),
                      ),
                    ),
                  if (description == null && child != null) child,
                ],
              ),
            )
          ],
        )
      ],
    );
  }

  Widget buildIconDescription({
    required String iconPath,
    required String description,
    String? description2,
    bool highlighted = false,
    Function? onTap,
  }) {
    return Touchable(
      onTap: onTap != null
          ? () {
              onTap();
            }
          : null,
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: onTap != null
            ? const BoxDecoration(
                border: Border(
                  bottom: kBorderSide,
                ),
              )
            : null,
        child: Row(
          children: [
            ImageHelper.loadFromAsset(iconPath),
            const SizedBox(
              width: 18,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Html(
                  //   shrinkWrap: true,
                  //   style: {
                  //     'body': Style(
                  //       margin: EdgeInsets.zero,
                  //       padding: EdgeInsets.zero,
                  //       fontSize:
                  //       FontSize(TextStyles.headerText.regular.fontSize),
                  //       lineHeight:
                  //       LineHeight(TextStyles.headerText.regular.height),
                  //       fontWeight: TextStyles.headerText.regular.fontWeight,
                  //       color: (highlighted || onTap != null)
                  //           ? AppColors.gPrimaryColor
                  //           : AppColors.darkInk500,
                  //     ),
                  //     'span': Style(
                  //       fontWeight: FontWeight.w600,
                  //       color: AppColors.gPrimaryColor,
                  //     ),
                  //   },
                  //   data: description,
                  // ),
                  if (description2 != null)
                    const SizedBox(
                      height: 2,
                    ),
                  if (description2 != null)
                    Text(
                      description2,
                      style: TextStyles.itemText.regular.copyWith(
                        color: AppColors.darkInk400,
                      ),
                    ),
                ],
              ),
            ),
            if (onTap != null) ImageHelper.loadFromAsset(AssetHelper.icoChevronDown24),
          ],
        ),
      ),
    );
  }
}
