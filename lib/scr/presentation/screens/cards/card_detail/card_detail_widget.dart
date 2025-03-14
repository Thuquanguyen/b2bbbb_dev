import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/data/model/card/card_visual.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/double_ext.dart';

class CardDetailWidget extends StatefulWidget {
  const CardDetailWidget({
    Key? key,
    required this.cardModel,
  }) : super(key: key);

  final CardModel cardModel;

  @override
  State<StatefulWidget> createState() => CardDetailWidgetState();
}

class CardDetailWidgetState extends State<CardDetailWidget> {
  String helperText = AppTranslate.i18n.cdRevealBackHintStr.localized;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      width: double.infinity,
      child: Container(
        decoration: kDecoration,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 24,
                  left: 24,
                  right: 24,
                  bottom: kDefaultPadding,
                ),
                color: AppColors.lightBlueBg,
                child: Column(
                  children: [
                    FlipCard(
                      front: Container(
                        decoration: kDecoration.copyWith(color: Colors.transparent),
                        child: Stack(
                          children: [
                            ImageHelper.loadFromAsset(
                              widget.cardModel.visual.front,
                            ),
                            if (widget.cardModel.visual.dataInBack == true)
                              const SizedBox()
                            else
                              _buildCardInfo(widget.cardModel),
                          ],
                        ),
                      ),
                      back: Container(
                        decoration: kDecoration.copyWith(color: Colors.transparent),
                        child: Stack(
                          children: [
                            ImageHelper.loadFromAsset(
                              widget.cardModel.visual.back,
                            ),
                            if (widget.cardModel.visual.dataInBack == true) _buildCardInfo(widget.cardModel),
                          ],
                        ),
                      ),
                      onFlipDone: (isFront) {
                        if (isFront) {
                          helperText = AppTranslate.i18n.cdRevealFrontHintStr.localized;
                        } else {
                          helperText = AppTranslate.i18n.cdRevealBackHintStr.localized;
                        }
                        setState(() {});
                      },
                    ),
                    const SizedBox(
                      height: kDefaultPadding,
                    ),
                    Text(
                      helperText,
                      style: TextStyles.itemText.copyWith(
                        color: AppColors.gPrimaryColor,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(
                  kDefaultPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 6),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: AppColors.whiteGreyBorder)),
                      ),
                      child: Row(
                        children: [
                          ImageHelper.loadFromAsset(AssetHelper.icoInfoCircleGreen, height: 24, width: 24),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            AppTranslate.i18n.cdCardInfoTitleStr.localized,
                            style: TextStyles.normalText.medium.copyWith(
                              color: AppColors.darkInk500,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: kDefaultPadding,
                    ),
                    _buildInfoItem(
                      AppTranslate.i18n.cdCardTypeStr.localized,
                      widget.cardModel.cardType,
                    ),
                    _buildInfoItem(
                      AppTranslate.i18n.cdCardNumberStr.localized,
                      widget.cardModel.maskedNumber,
                    ),
                    _buildInfoItem(
                      AppTranslate.i18n.cdCardHolderNameStr.localized,
                      widget.cardModel.clientName,
                    ),
                    _buildInfoItem(
                      AppTranslate.i18n.cdCardHolderIdStr.localized,
                      SessionManager().userData?.customer?.maskedLegalId,
                    ),
                    _buildInfoItem(
                      AppTranslate.i18n.cdCardStatusStr.localized,
                      widget.cardModel.name,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            AppTranslate.i18n.cdCardOpenDateStr.localized,
                            widget.cardModel.dateOpenDisplay,
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            AppTranslate.i18n.cdCardExpiryDateStr.localized,
                            widget.cardModel.dateExpireDisplay,
                          ),
                        ),
                      ],
                    ),
                    if (widget.cardModel.type == CardType.CREDIT)
                      _buildInfoItem(
                        AppTranslate.i18n.cdCardLimitStr.localized,
                        widget.cardModel.cardLimit.getFormattedWithCurrency(
                          widget.cardModel.cardCurrency,
                          showCurrency: true,
                        ),
                      ),
                    _buildInfoItem(
                      AppTranslate.i18n.cdCardAvailBalanceStr.localized,
                      widget.cardModel.cardAvail.getFormattedWithCurrency(
                        widget.cardModel.cardCurrency,
                        showCurrency: true,
                      ),
                    ),
                    if (widget.cardModel.type == CardType.CREDIT)
                      _buildInfoItem(
                        AppTranslate.i18n.cdCardBlockedStr.localized,
                        widget.cardModel.cardBlocked.getFormattedWithCurrency(
                          widget.cardModel.cardCurrency,
                          showCurrency: true,
                        ),
                      ),
                    _buildInfoItem(
                      AppTranslate.i18n.cdCardOnlinePaymentStatusStr.localized,
                      widget.cardModel.statusEcomDisplay?.localization(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String title, String? value, {double? padding}) {
    if (value == null) return const SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.captionText.copyWith(
            color: AppColors.darkInk300,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          value,
          style: TextStyles.itemText.copyWith(
            color: AppColors.darkInk500,
          ),
        ),
        SizedBox(
          height: padding ?? kDefaultPadding,
        ),
      ],
    );
  }

  Widget _buildCardInfo(CardModel cardModel) {
    CardVisual visual = cardModel.visual;

    return Positioned.fill(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              if (visual.numberYOffset != 0 && visual.numberXOffset != 0)
                Padding(
                  padding: EdgeInsets.only(
                    top: constraints.biggest.height * visual.numberYOffset,
                    left: constraints.biggest.width * visual.numberXOffset,
                  ),
                  child: Text(
                    cardModel.maskedNumber,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'VPBank',
                      color: cardModel.visual.dataColor,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      fontSize: constraints.biggest.width * 0.05,
                    ),
                  ),
                ),
              if (visual.openDateYOffset != 0 && visual.openDateXOffset != 0)
                Padding(
                  padding: EdgeInsets.only(
                    top: constraints.biggest.height * visual.openDateYOffset,
                    left: constraints.biggest.width * visual.openDateXOffset,
                  ),
                  child: Text(
                    cardModel.dateOpenDisplay,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'VPBank',
                      color: cardModel.visual.dataColor,
                      fontSize: constraints.biggest.width * 0.04,
                    ),
                  ),
                ),
              if (visual.expiryDateYOffset != 0 && visual.expiryDateXOffset != 0)
                Padding(
                  padding: EdgeInsets.only(
                    top: constraints.biggest.height * visual.expiryDateYOffset,
                    left: constraints.biggest.width * visual.expiryDateXOffset,
                  ),
                  child: Text(
                    cardModel.dateExpireDisplay,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'VPBank',
                      color: cardModel.visual.dataColor,
                      fontSize: constraints.biggest.width * 0.04,
                    ),
                  ),
                ),
              if (visual.nameYOffset != 0 && visual.nameXOffset != 0)
                Padding(
                  padding: EdgeInsets.only(
                    top: constraints.biggest.height * visual.nameYOffset,
                    left: constraints.biggest.width * visual.nameXOffset,
                  ),
                  child: Text(
                    cardModel.clientName ?? '',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'VPBank',
                      color: cardModel.visual.dataColor,
                      fontSize: constraints.biggest.width * 0.04,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              if (visual.companyYOffset != 0 && visual.companyXOffset != 0)
                Padding(
                  padding: EdgeInsets.only(
                    top: constraints.biggest.height * visual.companyYOffset,
                    left: constraints.biggest.width * visual.companyXOffset,
                  ),
                  child: Text(
                    cardModel.comMainName ?? '',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontFamily: 'VPBank',
                      color: cardModel.visual.dataColor,
                      fontSize: constraints.biggest.width * 0.04,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
