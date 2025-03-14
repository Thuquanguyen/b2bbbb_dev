import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_state.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/widgets/transaction_shimmer.dart';
import 'package:b2b/utilities/utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b2b/scr/core/extensions/extensions.dart';

class TransactionApproveDetail extends StatelessWidget {
  const TransactionApproveDetail({
    Key? key,
    this.transaction,
  }) : super(key: key);

  final TransactionMainModel? transaction;

  @override
  Widget build(BuildContext context) {
    bool shouldShowRate = transaction?.debitAccountCcy?.toLowerCase() != transaction?.benCcy?.toLowerCase();
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
          bottom: kDefaultPadding,
        ),
        width: double.infinity,
        child: transaction == null
            ? const TransactionApproveDetailShimmer()
            : Container(
                padding: const EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [kBoxShadowCommon],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      AppTranslate.i18n.tasTdDebitAccountStr.localized,
                      style: kStyleTextHeaderSemiBold,
                    ).withShimmer(
                      visible: transaction == null,
                      expectedCharacterCount: 13,
                    ),
                    const SizedBox(
                      height: 11,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.white,
                          ),
                          child: ImageHelper.loadFromAsset(AssetHelper.icoWallet1),
                        ).withShimmer(visible: transaction == null),
                        const SizedBox(
                          width: 22,
                        ),
                        Expanded(
                          child: BlocConsumer<TransactionManagerBloc, TransactionManagerState>(
                            buildWhen: (old, current) {
                              return old.additionalInfoState?.accountInfo?.accountDataState !=
                                  current.additionalInfoState?.accountInfo?.accountDataState;
                            },
                            listener: (context, state) {},
                            builder: (context, state) {
                              return _buildBankInfo(
                                state.additionalInfoState?.accountInfo?.accountNumber ?? ' ',
                                state.additionalInfoState?.accountInfo?.balanceFormatted ?? ' ',
                                isLoading: state.additionalInfoState?.accountInfo?.accountDataState != DataState.data,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Text(
                      AppTranslate.i18n.tasTdBenInfoStr.localized,
                      style: kStyleTextHeaderSemiBold,
                    ).withShimmer(
                      visible: transaction == null,
                      expectedCharacterCount: 15,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildDetailInfoItem(
                            isLoading: transaction == null,
                            visible: transaction?.transactionType?.transactionType != TransactionType.NAPAS_CARD,
                            title: AppTranslate.i18n.tasTdBenBankStr.localized,
                            descriptionWidget: Row(
                              children: [
                                transaction?.benBankCode.isNotNullAndEmpty == true
                                    ? Container(
                                        padding: EdgeInsets.zero,
                                        margin: const EdgeInsets.only(right: 4),
                                        child: ImageHelper.loadFromAsset(
                                          'assets/icons/bank_logo/ic_bank_${transaction?.benBankCode}.png',
                                          width: 18,
                                          height: 18,
                                        ),
                                      )
                                    : Container(),
                                transaction?.benBankName?.toLowerCase() == 'vpbank'
                                    ? Container(
                                        padding: EdgeInsets.zero,
                                        margin: const EdgeInsets.only(right: 4),
                                        child: ImageHelper.loadFromAsset(
                                          AssetHelper.icoLogoVpbank,
                                          width: 18,
                                          height: 18,
                                        ),
                                      )
                                    : Container(),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.only(right: kDefaultPadding),
                                    child: Text(
                                      transaction?.benBankName ?? ' ',
                                      style: TextStyles.itemText.slateGreyColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            bottomSpacing: 20,
                          ),
                        ),
                        Expanded(
                          child: BlocConsumer<TransactionManagerBloc, TransactionManagerState>(
                            buildWhen: (old, current) {
                              return old.additionalInfoState?.cityInfo?.cityDataState !=
                                  current.additionalInfoState?.cityInfo?.cityDataState;
                            },
                            listener: (context, state) {},
                            builder: (context, state) {
                              String? cityName = state.additionalInfoState?.cityInfo?.cityName;
                              return _buildDetailInfoItem(
                                isLoading: transaction == null,
                                visible: transaction?.shouldShowBranchCity == true && cityName.isNotNullAndEmpty,
                                title: AppTranslate.i18n.tasTdBenCityStr.localized,
                                description: cityName,
                              );
                            },
                          ),
                        ),
                        Expanded(
                          child: _buildDetailInfoItem(
                            isLoading: transaction == null,
                            rightAligned: true,
                            visible: transaction?.shouldShowBranchCity == true &&
                                transaction?.benBranchName.isNotNullAndEmpty == true,
                            title: AppTranslate.i18n.tasTdBenBranchStr.localized,
                            description: transaction?.benBranchName,
                          ),
                        ),
                      ],
                    ),
                    _buildBankInfo(
                      transaction?.beneficiaryName ?? ' ',
                      (transaction?.isCardPayment == true
                              ? transaction?.benAccountName.maskedCardNumber
                              : transaction?.benAccountName) ??
                          ' ',
                      isLoading: transaction == null,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    _buildDetailInfoItem(
                      isLoading: transaction == null,
                      title: AppTranslate.i18n.tasTdAmountStr.localized,
                      descriptionWidget: Row(
                        children: [
                          Expanded(
                            child: Text(
                              transaction?.formattedAmount() ?? '',
                              style: kStyleTitleNumber,
                            ),
                          ),
                          Text(
                            transaction?.currency ?? '',
                            style: kStyleTextSubtitle.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildDetailInfoItem(
                      isLoading: transaction == null,
                      title: AppTranslate.i18n.tasTdAmountInWordsStr.localized,
                      visible: transaction?.amountInWords?.localization().isNotNullAndEmpty == true,
                      description: transaction?.amountInWords?.localization().toTitleCase(),
                    ),
                    _buildDetailInfoItem(
                      title: AppTranslate.i18n.tasTdExchangeRateStr.localized,
                      isLoading: transaction == null,
                      visible: shouldShowRate,
                      description:
                          '1 ${transaction?.debitAccountCcy ?? ''} = ${transaction?.exchangeRateFormated} VND',
                    ),
                    if (shouldShowRate && transaction != null)
                      Text(
                        AppTranslate.i18n.tasTdExchangeRateNoticeStr.localized,
                        style: kStyleTitleHeader.copyWith(
                          color: AppColors.gRedTextColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    if (shouldShowRate && transaction != null)
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                    if (shouldShowRate && transaction?.currency == 'VND')
                      _buildDetailInfoItem(
                        title: AppTranslate.i18n.tasTdDebitAmountStr.localized,
                        description: TransactionManage()
                                .tryFormatCurrency(transaction?.debitAmount, transaction?.debitAccountCcy ?? '') +
                            ' ${transaction?.debitAccountCcy ?? ''}',
                      ),
                    if (shouldShowRate && transaction?.currency != 'VND')
                      _buildDetailInfoItem(
                        title: AppTranslate.i18n.tasTdConvertedAmountStr.localized,
                        description: TransactionManage().tryFormatCurrency(
                                (transaction?.debitAmount ?? 0) * (transaction?.exchangeRate ?? 0), 'VND') +
                            ' VND',
                      ),
                    _buildDetailInfoItem(
                      isLoading: transaction == null,
                      title: AppTranslate.i18n.tasTdChargeAccountStr.localized,
                      visible: transaction?.shouldShowChargeAccount == true &&
                          transaction?.chargesAccount.isNotNullAndEmpty == true,
                      description: AppUtils.getFeeAccountDisplay(
                        transaction?.chargesAccount,
                        transaction?.feeAmountCcy,
                      ),
                    ),
                    _buildDetailInfoItem(
                      isLoading: transaction == null,
                      title:
                          '${(transaction?.charges?.localization(defaultValue: AppTranslate.i18n.tasTdChargeAmountStr.localized) ?? AppTranslate.i18n.tasTdChargeAmountStr.localized)} ${AppTranslate.i18n.titleVatIncludeStr.localized}',
                      descriptionWidget: Row(
                        children: [
                          Expanded(
                            child: Text(
                              transaction?.isFreeCharge == true
                                  ? AppTranslate.i18n.freeAmountStr.localized
                                  : transaction?.formattedFeeAmount() ?? '',
                              style: kStyleTitleText,
                            ),
                          ),
                          Text(
                            transaction?.isFreeCharge == true ? '' : transaction?.feeAmountCcy ?? '',
                            style: kStyleTitleText,
                          ),
                        ],
                      ),
                    ),
                    _buildDetailInfoItem(
                      title: AppTranslate.i18n.tasTdMemoStr.localized,
                      isLoading: transaction == null,
                      visible: transaction?.memo.isNotNullAndEmpty == true,
                      description: transaction?.memo,
                    ),
                    _buildDetailInfoItem(
                      title: AppTranslate.i18n.tasTdRejectCauseStr.localized,
                      isLoading: transaction == null,
                      visible: transaction?.rejectCause.isNotNullAndEmpty == true,
                      description: transaction?.rejectCause,
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildBankInfo(String title, String description, {bool isLoading = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.semiBoldText.inputTextColor,
        ).withShimmer(visible: isLoading, expectedCharacterCount: 10),
        const SizedBox(
          height: 2,
        ),
        Text(
          description,
          style: TextStyles.smallText.slateGreyColor,
        ).withShimmer(visible: isLoading, expectedCharacterCount: 15),
      ],
    );
  }

  Widget _buildDetailInfoItem({
    required String title,
    bool visible = true,
    bool isLoading = false,
    String? description,
    Widget? descriptionWidget,
    double? bottomSpacing = 16,
    bool rightAligned = false,
  }) {
    if (!visible && !isLoading) return Container();
    return Column(
      crossAxisAlignment: rightAligned ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: kStyleTitleHeader,
        ).withShimmer(
          visible: isLoading,
          expectedCharacterCount: 15,
          randomizeRange: 5,
        ),
        const SizedBox(
          height: 4,
        ),
        description != null
            ? Text(
                description,
                style: TextStyles.itemText.slateGreyColor,
                textAlign: rightAligned ? TextAlign.right : TextAlign.left,
              ).withShimmer(
                visible: isLoading,
                expectedCharacterCount: 20,
                randomizeRange: 2,
              )
            : descriptionWidget ??
                const SizedBox(
                  height: 13,
                ),
        SizedBox(
          height: bottomSpacing ?? 0,
        ),
      ],
    );
  }

  Widget transactionDetailShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBaseColor,
      highlightColor: AppColors.shimmerHighlightColor,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(left: kDefaultPadding, right: kDefaultPadding, top: 8, bottom: 8),
            decoration: BoxDecoration(
              color: AppColors.shimmerBackGroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  height: 40.toScreenSize,
                  width: 40.toScreenSize,
                  decoration: BoxDecoration(
                    color: AppColors.shimmerItemColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 100,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.shimmerItemColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Container(
                      width: 80,
                      height: 10,
                      decoration: BoxDecoration(
                        color: AppColors.shimmerItemColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
