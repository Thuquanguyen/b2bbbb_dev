import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/presentation/screens/cards/card_history/card_history_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/card_statement/card_statement_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/payment/payment_card_screen.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardMenuScreen extends StatefulWidget {
  const CardMenuScreen({Key? key}) : super(key: key);
  static const String routeName = 'CardMenuScreen';

  @override
  State<StatefulWidget> createState() => CardMenuScreenState();
}

class CardMenuScreenState extends State<CardMenuScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: AppTranslate.i18n.cardMenuStr.localized,
      appBarType: AppBarType.NORMAL,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(kDefaultPadding),
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              decoration: kDecoration,
              child: Column(
                children: [
                  _buildItem(AssetHelper.icCardHistory, AppTranslate.i18n.ciCfHistoryStr.localized, () {
                    pushNamed(context, CardHistoryScreen.routeName);
                  }),
                  _buildItem(AssetHelper.icoCmStatement, AppTranslate.i18n.ciCfStatementStr.localized, () {
                    pushNamed(context, CardStatementScreen.routeName);
                  }),
                  if (RolePermissionManager().userRole == UserRole.MAKER)
                    _buildItem(AssetHelper.icoPaymentCard, AppTranslate.i18n.cardPaymentStr.localized, () {
                      pushNamed(context, PaymentCardScreen.routeName);
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String icon, String title, Function() onTap) {
    return TouchableRipple(
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.whiteGreyBorder,
            ),
          ),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: kDefaultPadding,
        ),
        child: Row(
          children: [
            ImageHelper.loadFromAsset(
              icon,
              width: 24,
              height: 24,
            ),
            const SizedBox(
              width: kDefaultPadding,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyles.itemText.copyWith(
                  color: AppColors.darkInk500,
                ),
              ),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: ImageHelper.loadFromAsset(
                AssetHelper.icoChevronDown,
                width: 24,
                height: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
