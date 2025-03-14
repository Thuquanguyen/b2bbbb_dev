import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_state.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/extensions/extensions.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/saving_transaction_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/widgets/item_account_service/account_info_item.dart';
import 'package:b2b/scr/presentation/widgets/item_information/amount_item.dart';
import 'package:b2b/scr/presentation/widgets/render_input_item.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class SavingTransactionDetailWidget extends StatelessWidget {
  const SavingTransactionDetailWidget({
    Key? key,
    required this.savingTransaction,
    required this.debitAccountInfo,
    this.onAccountSelect,
    this.notice,
    this.nominatedAccount,
    this.isAccountListLoading = false,
    this.showDemandRate = false,
    this.forceShowMandustry = false,
    this.button1,
    this.button2,
  }) : super(key: key);

  final TransactionSavingModel? savingTransaction;
  final DebitAccountInfo? debitAccountInfo;
  final Function? onAccountSelect;
  final String? notice;
  final String? nominatedAccount;
  final bool isAccountListLoading;
  final bool showDemandRate;
  final bool forceShowMandustry;
  final Widget? button1;
  final Widget? button2;

  @override
  Widget build(BuildContext context) {
    String accountTitle = AppTranslate.i18n.tiDebitAccFullStr.localized;
    bool isCloseAz = false;

    if (savingTransaction?.getProductType == SavingProductType.CLOSEAZ) {
      accountTitle = AppTranslate.i18n.tiSavingAccFullStr.localized;
      isCloseAz = true;
    }

    return Container(
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
          Container(
            child: buildInfoItem(
              title: accountTitle,
              child: buildIconDescription(
                iconPath: AssetHelper.icoWallet1,
                description: isCloseAz
                    ? (savingTransaction?.bankId ?? ' ')
                    : '${TransactionManage().tryFormatCurrency(debitAccountInfo?.accountBalance, debitAccountInfo?.accountCcy)} <span>${debitAccountInfo?.accountCcy ?? ''}</span>',
                description2:
                    (isCloseAz || debitAccountInfo?.accountNumber == null)
                        ? null
                        : (AppTranslate.i18n.accountNumberStr.localized +
                            ': ' +
                            (debitAccountInfo?.accountNumber ?? ' ')),
              ),
            ),
          ).withShimmer(
              visible: debitAccountInfo?.accountDataState == DataState.preload),
          AmountItem(
            title: AppTranslate.i18n.cddsAmountStr.localized,
            subTitle: TransactionManage().tryFormatCurrency(
                savingTransaction?.amount, savingTransaction?.amountCcy),
            unit: savingTransaction?.amountCcy,
            amountStyle:
                kStyleTitleNumber.copyWith(color: AppColors.gPrimaryColor),
            unitStyle: kStyleTextUnit.copyWith(color: AppColors.gPrimaryColor),
          ),
          buildInfoItem(
            title: AppTranslate.i18n.cddsAmountInWordsStr.localized,
            description: savingTransaction?.amountSpell
                    ?.localization(defaultValue: ' ')
                    .toTitleCase() ??
                ' ',
          ),
          const SizedBox(
            height: 16,
          ),
          buildInfoItem(
            title: AppTranslate.i18n.cddsPeriodStr.localized,
            child: buildIconDescription(
              iconPath: AssetHelper.icoCalendar1,
              description: savingTransaction?.termDisplay
                      ?.localization(defaultValue: ' ') ??
                  ' ',
              highlighted: true,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              Expanded(
                child: buildInfoItem(
                  title: AppTranslate.i18n.cddsEffectiveDateStr.localized,
                  description: savingTransaction?.startDate ?? ' ',
                ),
              ),
              Expanded(
                child: buildInfoItem(
                  title: AppTranslate.i18n.cddsMaturityDateStr.localized,
                  description: savingTransaction?.endDate ?? ' ',
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          buildInfoItem(
            title: AppTranslate.i18n.cddsInterestRateStr.localized,
            description: AppTranslate.i18n.tiInterestRateValueStr.localized
                .interpolate({'i': savingTransaction?.rate}),
            visible: (savingTransaction?.rate ?? '').isNotNullAndEmpty,
            isGreen: true,
          ),
          if (showDemandRate)
            const SizedBox(
              height: 16,
            ),
          if (showDemandRate)
            buildInfoItem(
              title: AppTranslate.i18n.cddsInterestEarlyStr.localized,
              description: AppTranslate.i18n.tiInterestRateValueStr.localized
                  .interpolate({'i': savingTransaction?.demandRate}),
              isRed: true,
            ),
          if ((savingTransaction?.productName?.localization(defaultValue: '') ??
                  '')
              .isNotNullAndEmpty)
            const SizedBox(
              height: 16,
            ),
          buildInfoItem(
            title: AppTranslate.i18n.cddsInterestMethodStr.localized,
            description: savingTransaction?.productName
                    ?.localization(defaultValue: '') ??
                ' ',
            visible: (savingTransaction?.productName
                        ?.localization(defaultValue: '') ??
                    '')
                .isNotNullAndEmpty,
          ),
          if (forceShowMandustry || !isCloseAz)
            const SizedBox(
              height: 16,
            ),
          buildInfoItem(
            title: AppTranslate.i18n.cddsSettlementMethodStr.localized,
            description: savingTransaction?.mandustryDisplay
                    ?.localization(defaultValue: '') ??
                ' ',
            visible: forceShowMandustry || !isCloseAz,
          ),
          const SizedBox(
            height: 16,
          ),
          Container(
            child: buildInfoItem(
              title: AppTranslate.i18n.cddsSettlementAccountStr.localized,
              child: buildIconDescription(
                iconPath: AssetHelper.icoWallet1,
                description: nominatedAccount != null
                    ? nominatedAccount!
                    : (savingTransaction?.nominatedacc ?? ' '),
                onTap: onAccountSelect,
              ),
            ),
          ).withShimmer(visible: isAccountListLoading),
          if ((savingTransaction?.introducerCif ?? '').isNotNullAndEmpty)
            const SizedBox(
              height: 16,
            ),
          buildInfoItem(
              title: AppTranslate.i18n.cddsReferralCifStr.localized,
              description: savingTransaction?.introducerCif ?? ' ',
              visible:
                  (savingTransaction?.introducerCif ?? '').isNotNullAndEmpty),
          if ((savingTransaction?.contractNumber ?? '').isNotNullAndEmpty)
            const SizedBox(
              height: 16,
            ),
          buildInfoItem(
            title: AppTranslate.i18n.cddsNoteStr.localized,
            description: savingTransaction?.contractNumber ?? ' ',
            visible:
                (savingTransaction?.contractNumber ?? '').isNotNullAndEmpty,
          ),
          const SizedBox(
            height: 16,
          ),
          buildInfoItem(
            title: AppTranslate.i18n.cddsRejectReasonStr.localized,
            description: savingTransaction?.apprComment,
            visible: savingTransaction?.apprComment != null,
          ),
          if (notice != null)
            const SizedBox(
              height: 8,
            ),
          if (notice != null)
            Html(
              style: {
                'body': Style(
                  margin: EdgeInsets.zero,
                  padding: EdgeInsets.zero,
                  fontSize: const FontSize(13),
                  lineHeight: const LineHeight(1.4),
                ),
                'p': Style(
                  margin: EdgeInsets.zero,
                  fontWeight: FontWeight.w500,
                ),
                'span': Style(
                  fontWeight: FontWeight.w600,
                  color: AppColors.gPrimaryColor,
                ),
              },
              data: notice,
            ),
          if (button1 != null || button2 != null)
            const SizedBox(
              height: kDefaultPadding,
            ),
          if (button1 != null) button1!,
          if (button2 != null) button2!,
        ],
      ),
    );
  }

  Widget buildInfoItem({
    required String title,
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
        ).withShimmer(
          expectedCharacterCount: 10,
          randomizeRange: 5,
          visible: savingTransaction == null,
        ),
        if (description != null)
          const SizedBox(
            height: 4,
          ),
        if (description != null)
          Text(
            description,
            style: TextStyles.itemText.regular.copyWith(
              color: isGreen
                  ? AppColors.gPrimaryColor
                  : (isRed ? AppColors.gRedTextColor : AppColors.darkInk500),
            ),
          ).withShimmer(
            expectedCharacterCount: 15,
            randomizeRange: 5,
            visible: savingTransaction == null,
          ),
        if (description == null && child != null)
          const SizedBox(
            height: 8,
          ),
        if (description == null && child != null) child,
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
                  Html(
                    shrinkWrap: true,
                    style: {
                      'body': Style(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        fontSize:
                            FontSize(TextStyles.headerText.regular.fontSize),
                        lineHeight:
                            LineHeight(TextStyles.headerText.regular.height),
                        fontWeight: TextStyles.headerText.regular.fontWeight,
                        color: (highlighted || onTap != null)
                            ? AppColors.gPrimaryColor
                            : AppColors.darkInk500,
                      ),
                      'span': Style(
                        fontWeight: FontWeight.w600,
                        color: AppColors.gPrimaryColor,
                      ),
                    },
                    data: description,
                  ),
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
            if (onTap != null)
              ImageHelper.loadFromAsset(AssetHelper.icoChevronDown24),
          ],
        ),
      ),
    );
  }
}
