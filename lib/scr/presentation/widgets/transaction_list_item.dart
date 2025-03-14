import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manage_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manage_state.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/bill_payment_model.dart';
import 'package:b2b/scr/data/model/saving_transaction_model.dart';
import 'package:b2b/scr/data/model/transaction_base_model.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/data/model/transaction_payroll_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/text_formatter.dart';
import 'package:b2b/utilities/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum TransactionListItemType {
  NORMAL,
  SAVING,
}

class TransactionListItem<T extends TransactionBaseModel> extends StatefulWidget {
  const TransactionListItem({
    Key? key,
    this.transaction,
    this.bloc,
    this.groupIndex,
    this.transIndex,
    this.onPress,
    this.onLongPress,
    this.type = TransactionListItemType.NORMAL,
  }) : super(key: key);

  final T? transaction;
  final TransuctionManageBloc? bloc;
  final int? groupIndex;
  final int? transIndex;
  final Function? onPress;
  final Function? onLongPress;
  final TransactionListItemType type;

  @override
  State<StatefulWidget> createState() => TransactionListItemState<T>();
}

class TransactionListItemState<T extends TransactionBaseModel> extends State<TransactionListItem>
    with TickerProviderStateMixin {
  late AnimationController checkmarkAnimController;
  late Animation<double> checkmarkAnim;
  bool _isSelected = false;
  bool _isInSelectMode = false;

  @override
  void initState() {
    super.initState();
    checkmarkAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    checkmarkAnim = CurvedAnimation(
      parent: checkmarkAnimController,
      curve: Curves.easeInOutCirc,
    );
    checkmarkAnimController.value = 1;
  }

  @override
  void dispose() {
    checkmarkAnimController.dispose();
    super.dispose();
  }

  void switchSelectState(bool inSelectMode, bool selected) {
    checkmarkAnimController.animateTo(0.5).then((_) {
      setState(() {
        _isInSelectMode = inSelectMode;
        _isSelected = selected;
      });
      checkmarkAnimController.animateTo(1);
    });
  }

  Widget buildInfoEntry(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.smallText.setColor(AppColors.gTextColor),
        ),
        const SizedBox(
          width: kDefaultPadding,
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyles.itemText.medium.setColor(AppColors.gTextColor),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    T? transaction;

    if (widget.transaction != null) {
      transaction = widget.transaction as T;
    } else if (widget.groupIndex != null && widget.transIndex != null) {
      transaction =
          AppUtils.tryCast<T>(widget.bloc?.state.listState?.transactions?[widget.groupIndex!].list[widget.transIndex!]);
    }

    if (transaction == null) {
      return Container();
    }

    _isSelected = widget.bloc?.state.listState?.selected.contains(transaction.transCode) ?? false;
    _isInSelectMode = widget.bloc?.state.isSelecting ?? false;

    List<Widget> transactionInfos = [];
    Type transType = transaction.runtimeType;
    String accountTitle = AppTranslate.i18n.tiDebitAccStr.localized;

    String statusText = '';
    Color statusColor = AppColors.darkInk500;

    if (transType == TransactionMainModel) {
      TransactionMainModel tran = transaction as TransactionMainModel;
      transactionInfos.add(
        const SizedBox(
          height: 4,
        ),
      );
      transactionInfos.add(
        buildInfoEntry(
          AppTranslate.i18n.transferAmountStr.localized,
          "${CurrencyInputFormatter.formatCcyString(tran.amount.toString(), ccy: tran.currency, removeDecimal: true)} ${tran.currency}",
        ),
      );
      transactionInfos.add(
        const SizedBox(
          height: 4,
        ),
      );
      transactionInfos.add(
        buildInfoEntry(
          AppTranslate.i18n.pickBeneficiaryStr.localized,
          '',
        ),
      );
      transactionInfos.add(
        const SizedBox(
          height: 4,
        ),
      );
      transactionInfos.add(
        Text(
          '${(transaction.isCardPayment == true ? transaction.benAccountName.maskedCardNumber : transaction.benAccountName)} - ${tran.beneficiaryName?.toUpperCase()}',
          style: TextStyles.itemText.medium.setColor(AppColors.gTextColor),
          textAlign: TextAlign.left,
        ),
      );

      statusText = tran.status?.localization().toUpperCase() ?? '';
      statusColor = tran.status?.statusDetail?.color ?? AppColors.darkInk500;
    } else if (transType == TransactionSavingModel) {
      TransactionSavingModel tran = transaction as TransactionSavingModel;
      if (tran.getProductType == SavingProductType.CLOSEAZ) {
        accountTitle = AppTranslate.i18n.tiSavingAccStr.localized;
      }

      transactionInfos.add(
        const SizedBox(
          height: 8,
        ),
      );
      transactionInfos.add(
        buildInfoEntry(
          AppTranslate.i18n.cddsAmountStr.localized,
          "${TransactionManage().formatCurrency(tran.amount ?? 0, tran.amountCcy ?? '')} ${tran.amountCcy}",
        ),
      );
      transactionInfos.add(
        const SizedBox(
          height: 8,
        ),
      );
      transactionInfos.add(
        buildInfoEntry(
          AppTranslate.i18n.savProdTypeStr.localized,
          tran.getProductType?.localizedName ?? '',
        ),
      );
      transactionInfos.add(
        const SizedBox(
          height: 8,
        ),
      );
      transactionInfos.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppTranslate.i18n.savInterestStr.localized.interpolate({'i': tran.rate}),
              style: TextStyles.smallText.setColor(AppColors.gTextColor),
            ),
            Text(
              AppTranslate.i18n.savTermStr.localized
                  .interpolate({'t': tran.termDisplay?.localization(defaultValue: '')}),
              style: TextStyles.smallText.setColor(AppColors.gTextColor),
            ),
          ],
        ),
      );

      statusText = tran.status?.localization().toUpperCase() ?? '';
      statusColor = tran.status?.statusDetail?.color ?? AppColors.darkInk500;
    } else if (transType == TransactionPayrollModel) {
      TransactionPayrollModel tran = transaction as TransactionPayrollModel;

      transactionInfos.add(
        const SizedBox(
          height: 8,
        ),
      );
      transactionInfos.add(
        buildInfoEntry(
          AppTranslate.i18n.transferAmountStr.localized,
          "${TransactionManage().tryFormatCurrency(tran.amount, tran.currency)} ${tran.currency ?? ''}",
        ),
      );
      transactionInfos.add(
        const SizedBox(
          height: 8,
        ),
      );
      transactionInfos.add(
        buildInfoEntry(
          AppTranslate.i18n.prTotalItemsStr.localized,
          AppTranslate.i18n.prCountStr.localized.interpolate({'c': tran.totalItem.toString()}),
        ),
      );

      statusText = tran.status?.localization().toUpperCase() ?? '';
      statusColor = tran.status?.statusDetail?.color ?? AppColors.darkInk500;
    } else if (transType == BillPaymentModel) {
      BillPaymentModel tran = transaction as BillPaymentModel;

      transactionInfos.add(
        const SizedBox(
          height: 8,
        ),
      );
      transactionInfos.add(
        buildInfoEntry(
          AppTranslate.i18n.bcElecPeriodTypeStr.localized,
          tran.beneficiaryName ?? '',
        ),
      );
      transactionInfos.add(
        const SizedBox(
          height: 8,
        ),
      );
      transactionInfos.add(
        buildInfoEntry(
          AppTranslate.i18n.transferAmountStr.localized,
          "${TransactionManage().tryFormatCurrency(tran.amount, tran.currency)} ${tran.currency ?? ''}",
        ),
      );
      transactionInfos.add(
        const SizedBox(
          height: 8,
        ),
      );
      transactionInfos.add(
        buildInfoEntry(
          AppTranslate.i18n.bcElecCustomerCodeStr.localized,
          tran.billInfo?.cusInfo?.cusCode ?? '',
        ),
      );

      statusText = tran.status?.localization().toUpperCase() ?? '';
      statusColor = tran.status?.statusDetail?.color ?? AppColors.darkInk500;
    }

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: kDecoration,
      child: TextButton(
        onPressed: () {
          if (widget.onPress != null) widget.onPress!();
        },
        onLongPress: () {
          if (widget.onLongPress != null) widget.onLongPress!();
        },
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: Container(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Row(
            children: [
              ScaleTransition(
                scale: checkmarkAnim,
                child: Container(
                  height: 44,
                  width: 44,
                  decoration: BoxDecoration(
                    color: _isSelected == true
                        ? AppColors.gPrimaryColor
                        : _isInSelectMode == true
                            ? AppColors.itemTimeUnselectBg
                            : AppColors.itemTimeBg,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Center(
                    child: _isSelected == true
                        ? ImageHelper.loadFromAsset(AssetHelper.icWhiteCheck)
                        : _isInSelectMode == true
                            ? ImageHelper.loadFromAsset(AssetHelper.icWhiteCheck)
                            : Text(
                                transaction.createdDate.convertServerTime.to24H ?? '',
                                style: TextStyles.normalText,
                              ),
                  ),
                ),
              ),
              const SizedBox(
                width: kDefaultPadding,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.bloc != null)
                      BlocListener<TransuctionManageBloc, TransuctionManageState>(
                        bloc: widget.bloc,
                        listener: (context, state) {
                          bool isSelected = state.listState?.selected.contains(transaction?.transCode) ?? false;
                          bool isSelecting = state.isSelecting;
                          if (_isSelected != isSelected || _isInSelectMode != isSelecting) {
                            switchSelectState(isSelecting, isSelected);
                          }
                        },
                        child: Container(),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          accountTitle + ': ' + (transaction.debitAccountNumber ?? ''),
                          style: TextStyles.headerItemText.regular.setColor(AppColors.darkInk500),
                        ),
                        Text(
                          statusText,
                          style: TextStyles.headerItemText.regular.setColor(statusColor),
                        ),
                      ],
                    ),
                    ...transactionInfos,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
