import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/presentation/screens/cards/card_detail/card_detail_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/card_history/card_history_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/card_statement/card_statement_screen.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';

class CardFunctionWidget extends StatelessWidget {
  const CardFunctionWidget({Key? key, required this.cardModel}) : super(key: key);

  final CardModel cardModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      width: double.infinity,
      child: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        decoration: kDecoration,
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  AppTranslate.i18n.ciCfTitleStr.localized,
                  style: TextStyles.normalText.semibold.copyWith(
                    color: AppColors.gPrimaryColor,
                  ),
                ),
              ],
            ),
            _buildItem(AssetHelper.icoCmInfo, AppTranslate.i18n.ciCfDetailStr.localized, () {
              pushNamed(context, CardDetailScreen.routeName,
                  async: true, arguments: CardDetailScreenArguments(cardModel: cardModel));
            }),
            _buildItem(AssetHelper.icoCmHistory, AppTranslate.i18n.ciCfHistoryStr.localized, () {
              Navigator.of(context).pushNamed(CardHistoryScreen.routeName,
                  arguments: CardHistoryScreenArguments(preSelected: cardModel));
            }),
            // _buildItem(AssetHelper.icoCmPinChange, AppTranslate.i18n.ciCfPinChangeStr.localized, () {}),
            // _buildItem(AssetHelper.icoCmOnlinePayment, AppTranslate.i18n.ciCfOnlinePaymentStr.localized, () {}),
            // _buildItem(AssetHelper.icoCmAutoDeduct, AppTranslate.i18n.ciCfAutoTrichnoStr.localized, () {}),
            if (cardModel.type == CardType.CREDIT)
              _buildItem(AssetHelper.icoCmStatement, AppTranslate.i18n.ciCfStatementStr.localized, () {
                Navigator.of(context).pushNamed(CardStatementScreen.routeName, arguments: cardModel);
              }),
            // _buildItem(AssetHelper.icoCmLock, AppTranslate.i18n.ciCfLockStr.localized, () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String icon, String title, Function onTap) {
    return TextButton(
      style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
      onPressed: () {
        onTap();
      },
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
