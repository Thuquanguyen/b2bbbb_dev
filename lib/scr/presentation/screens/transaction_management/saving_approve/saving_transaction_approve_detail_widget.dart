import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_state.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/saving_transaction_model.dart';
import 'package:b2b/scr/presentation/screens/deposits/widgets/saving_transaction_detail.dart';
import 'package:b2b/scr/presentation/widgets/transaction_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SavingTransactionApproveDetail extends StatelessWidget {
  const SavingTransactionApproveDetail({
    Key? key,
    this.transaction,
    this.debitAccountInfo,
  }) : super(key: key);

  final TransactionSavingModel? transaction;
  final DebitAccountInfo? debitAccountInfo;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionManagerBloc, TransactionManagerState>(
      listener: (_, __) {},
      buildWhen: (TransactionManagerState p, TransactionManagerState c) {
        return p.additionalInfoState?.accountInfo?.accountDataState !=
            c.additionalInfoState?.accountInfo?.accountDataState;
      },
      builder: (BuildContext context, TransactionManagerState state) {
        String? notice;

        if (transaction?.getProductType == SavingProductType.AZ) {
          notice = AppTranslate.i18n.cddsSavingNoticeStr.localized;
        } else if (transaction?.getProductType == SavingProductType.CLOSEAZ) {
          notice = AppTranslate.i18n.cddsOnlineNoticeStr.localized;
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                  bottom: kDefaultPadding / 2,
                ),
                child: Text(
                  AppTranslate.i18n.tiInfoTitleStr.localized.interpolate({
                    'type': transaction?.getProductType?.localizedName ?? '',
                  }).toSentence(),
                  style: TextStyles.headerText.whiteColor,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                  left: kDefaultPadding,
                  right: kDefaultPadding,
                  bottom: kDefaultPadding,
                ),
                width: double.infinity,
                child: transaction == null
                    ? const TransactionApproveDetailShimmer(
                        transType: TransactionSavingModel,
                      )
                    : SavingTransactionDetailWidget(
                        savingTransaction: transaction,
                        showDemandRate: transaction?.getProductType == SavingProductType.CLOSEAZ,
                        debitAccountInfo: state.additionalInfoState?.accountInfo,
                        notice: notice,
                      ),
              ),
            ],
          ),
        );
      },
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
}
