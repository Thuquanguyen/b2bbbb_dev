import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_state.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/text_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/presentation/widgets/transaction_shimmer.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/payroll_approve/payroll_approve_recipient_screen.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PayrollTransactionApproveDetail extends StatelessWidget {
  const PayrollTransactionApproveDetail({
    Key? key,
    this.payroll,
    this.totalInhouse,
    this.totalOther,
  }) : super(key: key);

  final TransactionMainModel? payroll;
  final int? totalInhouse;
  final int? totalOther;

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
            child: payroll == null
                ? const TransactionApproveDetailShimmer()
                : Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(
                      kDefaultPadding,
                    ),
                    decoration: BoxDecoration(
                      boxShadow: const [kBoxShadowContainer],
                      borderRadius: BorderRadius.circular(14),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocConsumer<TransactionManagerBloc, TransactionManagerState>(
                            listener: (_, __) {},
                            buildWhen: (TransactionManagerState p, TransactionManagerState c) {
                              return p.additionalInfoState?.accountInfo?.accountDataState !=
                                  c.additionalInfoState?.accountInfo?.accountDataState;
                            },
                            builder: (BuildContext context, TransactionManagerState state) {
                              DebitAccountInfo? debitAccountInfo = state.additionalInfoState?.accountInfo;
                              return Container(
                                child: buildInfoItem(
                                  title: AppTranslate.i18n.prDetailAccountStr.localized,
                                  child: buildIconDescription(
                                    iconPath: AssetHelper.icoWallet1,
                                    description:
                                        '${TransactionManage().tryFormatCurrency(debitAccountInfo?.accountBalance, debitAccountInfo?.accountCcy)} <span>${debitAccountInfo?.accountCcy ?? ''}</span>',
                                    description2: (AppTranslate.i18n.accountNumberStr.localized +
                                        ': ' +
                                        (debitAccountInfo?.accountNumber ?? ' ')),
                                  ),
                                ),
                              ).withShimmer(visible: debitAccountInfo?.accountDataState == DataState.preload);
                            }),
                        buildInfoItem(
                          title: AppTranslate.i18n.prDetailAmountStr.localized,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                TransactionManage().tryFormatCurrency(payroll?.amount, payroll?.currency),
                                style: TextStyles.otpText1.regular.copyWith(color: AppColors.darkInk500),
                              ),
                              Text(
                                payroll?.currency ?? '',
                                style: TextStyles.headerText.regular.copyWith(color: AppColors.darkInk500),
                              )
                            ],
                          ),
                          // description:
                          //     "${TransactionManage().tryFormatCurrency(payroll?.amount, payroll?.currency)} ${payroll?.currency ?? ''}",
                        ),
                        const SizedBox(
                          height: kDefaultPadding,
                        ),
                        buildInfoItem(
                          title: AppTranslate.i18n.prDetailAmountInWordsStr.localized,
                          description: payroll?.amountInWords?.localization().toTitleCase(),
                        ),
                        const SizedBox(
                          height: kDefaultPadding,
                        ),
                        buildInfoItem(
                          title: AppTranslate.i18n.prDetailMemoStr.localized,
                          description: payroll?.memo,
                        ),
                        const SizedBox(
                          height: kDefaultPadding,
                        ),
                        buildInfoItem(
                          title: AppTranslate.i18n.prDetailReciCountStr.localized,
                          child: Row(
                            children: [
                              Text(
                                '${(totalInhouse ?? 0) + (totalOther ?? 0)}',
                                style: TextStyles.itemText.regular.copyWith(
                                  color: AppColors.darkInk500,
                                ),
                              ).withShimmer(
                                expectedCharacterCount: 2,
                                randomizeRange: 1,
                                visible: payroll == null,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                AppTranslate.i18n.prDetailReciCountDetailStr.localized.interpolate({
                                  'v': totalInhouse,
                                  'k': totalOther,
                                }),
                                style: TextStyles.itemText.regular.copyWith(
                                  color: const Color.fromRGBO(102, 102, 103, 1.0),
                                ),
                              ).withShimmer(
                                expectedCharacterCount: 15,
                                randomizeRange: 5,
                                visible: payroll == null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: kDefaultPadding,
                        ),
                        buildInfoItem(
                          title: AppTranslate.i18n.prDetailFeeStr.localized,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                payroll?.formattedFeeAmount() ?? '',
                                style: TextStyles.itemText.regular.copyWith(
                                  color: AppColors.darkInk500,
                                ),
                              ),
                              Text(
                                payroll?.feeAmountCcy ?? '',
                                style: TextStyles.itemText.regular.copyWith(
                                  color: AppColors.darkInk500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: kDefaultPadding,
                        ),
                        buildInfoItem(
                          title: AppTranslate.i18n.prDetailFeePayerStr.localized,
                          description: payroll?.charges?.localization(),
                        ),
                        const SizedBox(
                          height: kDefaultPadding,
                        ),
                        buildInfoItem(
                          title: AppTranslate.i18n.prDetailFeeAccountStr.localized,
                          description: payroll?.chargesAccount ?? '',
                        ),
                        const SizedBox(
                          height: kDefaultPadding,
                        ),
                        buildInfoItem(
                          title: AppTranslate.i18n.prDetailRejectReasonStr.localized,
                          description: payroll?.rejectCause,
                          visible: payroll?.rejectCause.isNotNullAndEmpty == true,
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              top: BorderSide(width: 1.5, color: kColorDivider),
                            ),
                          ),
                          child: buildReciListBtn(context),
                        )
                      ],
                    ),
                  ),
          ),
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
          visible: payroll == null,
        ),
        if (description != null)
          const SizedBox(
            height: 4,
          ),
        if (description != null)
          Text(
            description,
            style: TextStyles.itemText.regular.copyWith(
              color: isGreen ? AppColors.gPrimaryColor : (isRed ? AppColors.gRedTextColor : AppColors.darkInk500),
            ),
          ).withShimmer(
            expectedCharacterCount: 15,
            randomizeRange: 5,
            visible: payroll == null,
          ),
        if (description == null && child != null)
          const SizedBox(
            height: 4,
          ),
        if (description == null && child != null) child,
      ],
    );
  }

  Widget buildReciListBtn(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
      ),
      onPressed: () {
        Navigator.of(context).pushNamed(PayrollApproveRecipientListScreen.routeName, arguments: {
          'fileCode': payroll?.transCode,
        });
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageHelper.loadFromAsset(
            AssetHelper.icoPeople,
            width: 24,
            height: 24,
          ),
          const SizedBox(
            width: kDefaultPadding,
          ),
          Expanded(
            child: Text(
              AppTranslate.i18n.prDetailReciListStr.localized,
              style: TextStyles.normalText.medium.copyWith(color: AppColors.gPrimaryColor),
            ),
          ),
          ImageHelper.loadFromAsset(AssetHelper.icoChevronForward),
        ],
      ),
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
                        fontSize: FontSize(TextStyles.itemText.regular.fontSize),
                        lineHeight: LineHeight(TextStyles.itemText.regular.height),
                        fontWeight: TextStyles.itemText.regular.fontWeight,
                        color: (highlighted || onTap != null) ? AppColors.gPrimaryColor : AppColors.darkInk500,
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
                      style: TextStyles.captionText.regular.copyWith(
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
