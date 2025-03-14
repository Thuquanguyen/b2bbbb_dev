import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_state.dart';
import 'package:b2b/scr/core/extensions/extensions.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionConfirm extends StatelessWidget {
  const TransactionConfirm({
    Key? key,
    required this.infoList,
  }) : super(key: key);

  final List<Widget> infoList;

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
                children: infoList,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionConfirmItem extends StatelessWidget {
  const TransactionConfirmItem({
    Key? key,
    this.title,
    this.titleStyle,
    this.value,
    this.valueStyle,
    this.bottomSpacing,
  }) : super(key: key);

  final String? title;
  final TextStyle? titleStyle;
  final String? value;
  final TextStyle? valueStyle;
  final double? bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          style: titleStyle ??
              TextStyles.captionText.copyWith(
                color: AppColors.darkInk400,
              ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 4,
        ),
        Text(
          value ?? '',
          style: valueStyle ??
              TextStyles.itemText.medium.copyWith(
                color: AppColors.darkInk500,
              ),
          textAlign: TextAlign.left,
        ),
        SizedBox(
          height: bottomSpacing ?? kDefaultPadding,
        ),
      ],
    );
  }
}

class TransactionConfirmItemMoney extends StatelessWidget {
  const TransactionConfirmItemMoney({
    Key? key,
    this.title,
    this.titleStyle,
    this.amount,
    this.amountStyle,
    this.isGreen = false,
    this.currency,
    this.currencyStyle,
    this.bottomSpacing,
  }) : super(key: key);

  final String? title;
  final TextStyle? titleStyle;
  final String? amount;
  final TextStyle? amountStyle;
  final bool isGreen;
  final String? currency;
  final TextStyle? currencyStyle;
  final double? bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          style: titleStyle ??
              TextStyles.captionText.copyWith(
                color: AppColors.darkInk400,
              ),
          textAlign: TextAlign.left,
        ),
        const SizedBox(
          height: 4,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Text(
                amount ?? '',
                style: amountStyle ??
                    TextStyles.normalText.copyWith(
                      fontSize: 24,
                      color: isGreen ? AppColors.gPrimaryColor : AppColors.darkInk500,
                    ),
                textAlign: TextAlign.left,
              ),
            ),
            Text(
              currency ?? '',
              style: currencyStyle ??
                  TextStyles.itemText.copyWith(
                    color: isGreen ? AppColors.gPrimaryColor : AppColors.darkInk500,
                  ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        SizedBox(
          height: bottomSpacing ?? kDefaultPadding,
        ),
      ],
    );
  }
}

class TransactionConfirmItemHeader extends StatelessWidget {
  const TransactionConfirmItemHeader({
    Key? key,
    this.title,
    this.titleStyle,
    this.bottomSpacing,
  }) : super(key: key);

  final String? title;
  final TextStyle? titleStyle;
  final double? bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing ?? kDefaultPadding),
      child: Text(
        title ?? '',
        style: titleStyle ?? TextStyles.headerText.darkInk500,
      ),
    );
  }
}

class TransactionConfirmItemBen extends StatelessWidget {
  const TransactionConfirmItemBen({
    Key? key,
    this.benName,
    this.benNameStyle,
    this.benAccount,
    this.benAccountStyle,
    this.imagePath,
    this.bottomSpacing,
  }) : super(key: key);

  final String? benName;
  final TextStyle? benNameStyle;
  final String? benAccount;
  final TextStyle? benAccountStyle;
  final String? imagePath;
  final double? bottomSpacing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomSpacing ?? kDefaultPadding,
      ),
      child: Row(
        children: [
          if (imagePath != null)
            ImageHelper.loadFromAsset(
              imagePath!,
              width: 24,
              height: 24,
            ),
          if (imagePath != null)
            const SizedBox(
              width: kDefaultPadding,
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  benName ?? '',
                  style: benNameStyle ?? TextStyles.itemText.semibold.darkInk500,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  benAccount ?? '',
                  style: benAccountStyle ?? TextStyles.itemText.medium.darkInk500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TransactionConfirmItemDebit extends StatelessWidget {
  const TransactionConfirmItemDebit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionManagerBloc, TransactionManagerState>(
        listener: (_, __) {},
        buildWhen: (TransactionManagerState p, TransactionManagerState c) {
          return p.additionalInfoState?.accountInfo?.accountDataState !=
              c.additionalInfoState?.accountInfo?.accountDataState;
        },
        builder: (BuildContext context, TransactionManagerState state) {
          DebitAccountInfo? debitAccountInfo = state.additionalInfoState?.accountInfo;
          if (debitAccountInfo?.accountDataState == DataState.error) return Container();
          return Container(
            padding: EdgeInsets.only(
              bottom: kDefaultPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTranslate.i18n.accountPaymentStr.localized,
                  style: TextStyles.captionText.copyWith(
                    color: AppColors.darkInk400,
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    ImageHelper.loadFromAsset(AssetHelper.icoWallet, width: 24, height: 24),
                    const SizedBox(
                      width: kDefaultPadding,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            TransactionManage().tryFormatCurrency(
                              debitAccountInfo?.accountBalance,
                              debitAccountInfo?.accountCcy,
                              showCurrency: true,
                            ),
                            style: TextStyles.itemText.medium.copyWith(
                              color: AppColors.darkInk500,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(
                            height: 2,
                          ),
                          Text(
                            AppTranslate.i18n.accountNumberStr.localized +
                                ': ' +
                                (debitAccountInfo?.accountNumber ?? ''),
                            style: TextStyles.captionText.copyWith(
                              color: AppColors.darkInk400,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ).withShimmer(visible: debitAccountInfo?.accountDataState == DataState.preload);
        });
  }
}
