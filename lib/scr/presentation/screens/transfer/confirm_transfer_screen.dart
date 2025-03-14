import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/bloc.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/screens/transfer/transfer_input/extrange_rate_widget.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/buttons.dart';
import 'package:b2b/scr/presentation/widgets/item_account_service/account_info_item.dart';
import 'package:b2b/scr/presentation/widgets/item_infomation_available.dart';
import 'package:b2b/scr/presentation/widgets/item_information/amount_item.dart';
import 'package:b2b/scr/presentation/widgets/item_information/infomation_item.dart';
import 'package:b2b/scr/presentation/widgets/item_information/title_item.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/data_state.dart';
import '../../../bloc/transfer/rate/transfer_rate_bloc.dart';

class ConfirmTransferArgument {
  final DebitAccountModel? debitAccount;
  final DebitAccountModel? chargeAccount;
  final String? vatFeeAmount;
  final String? chargeCcy;
  final String title;
  final String? benAccount;
  final String? benCcy;
  final String? benBankName;
  final String? benBankIcon;
  final String amount;
  final String? amountCcy;
  final String? benName;
  final String? textAmount;
  final String memo;
  final String? ourBenFee;
  final String? cityName;
  final String? branchName;
  final TransferType? transferType;
  final Function() callBack;

  ConfirmTransferArgument({
    required this.title,
    this.debitAccount,
    required this.amount,
    required this.memo,
    required this.benName,
    required this.callBack,
    required this.benAccount,
    this.benCcy,
    this.transferType,
    this.chargeAccount,
    this.vatFeeAmount,
    this.benBankName,
    this.benBankIcon,
    this.amountCcy,
    this.chargeCcy,
    this.ourBenFee = 'OUT',
    this.cityName,
    this.branchName,
    this.textAmount,
  });
}

class ConfirmTransferScreen extends StatefulWidget {
  const ConfirmTransferScreen({Key? key, required this.argument})
      : super(key: key);
  static const String routeName = 'confirm-transfer-screen';

  final ConfirmTransferArgument argument;

  @override
  _ConfirmTransferScreenState createState() => _ConfirmTransferScreenState();
}

class _ConfirmTransferScreenState extends State<ConfirmTransferScreen> {
  late TransferRateBloc _rateBloc;

  @override
  void initState() {
    super.initState();
    _rateBloc = BlocProvider.of<TransferRateBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    var args = widget.argument;

    return AppBarContainer(
      appBarType: AppBarType.SEMI_MEDIUM,
      title: args.title,
      child: Container(
        margin: const EdgeInsets.fromLTRB(
          kDefaultPadding,
          kDefaultPadding,
          kDefaultPadding,
          kMediumPadding,
        ),
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kDefaultPadding),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: kDefaultPadding,
                    ),
                    TitleItem(
                      title: AppTranslate.i18n
                          .transferToAccountTitleSourceAccountStr.localized,
                    ),
                    AccountInfoItem(
                      workingBalance: args.debitAccount?.availableBalance
                              ?.toInt()
                              .toString()
                              .toMoneyFormat ??
                          '0',
                      accountCurrency: args.debitAccount?.accountCurrency,
                      accountNumber: args.debitAccount?.getSubtitle(),
                      isLastIndex: true,
                      prefixIcon: AssetHelper.icoWallet,
                      margin: const EdgeInsets.symmetric(vertical: kTopPadding),
                    ),
                    TitleItem(
                      title: AppTranslate
                          .i18n
                          .transferToAccountTitleBeneficiaryInformationStr
                          .localized,
                    ),
                    const SizedBox(
                      height: kDefaultPadding,
                    ),
                    if (args.transferType != TransferType.TRANS247_CARD)
                      ItemInformationAvailable(
                        title: args.benBankName ?? '',
                        iconWidget: ImageHelper.loadFromAsset(
                          args.benBankIcon!,
                        ),
                        onPress: () {},
                        caption:
                            AppTranslate.i18n.dataHardCoreBankStr.localized,
                        showBorder: false,
                      ),
                    if (args.cityName != null &&
                        args.transferType == TransferType.TRANSINTERBANK)
                      InfomationItem(
                          title: AppTranslate.i18n.pickBankPlaceStr.localized,
                          subTitle: args.cityName),
                    if (args.branchName != null &&
                        (args.branchName?.isNotEmpty ?? false) &&
                        args.transferType == TransferType.TRANSINTERBANK)
                      InfomationItem(
                          title:
                              AppTranslate.i18n.findAtmTitleBranchStr.localized,
                          subTitle: args.branchName),
                    if (args.transferType != TransferType.TRANS247_CARD &&
                        args.transferType != TransferType.TRANSINTERBANK)
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                    Text((args.benName ?? '').toUpperCase(),
                        style: kStyleTextUnit),
                    const SizedBox(height: 4),
                    Text(args.benAccount ?? '', style: kStyleTextSubtitle),
                    const SizedBox(
                      height: kDefaultPadding,
                    ),
                    AmountItem(
                      title:
                          AppTranslate.i18n.dataHardCoreCountMoneyStr.localized,
                      subTitle: args.amount,
                      unit: args.amountCcy,
                    ),
                    if (args.textAmount != null)
                      InfomationItem(
                          title: AppTranslate.i18n.numberOfMoneyStr.localized,
                          subTitle: args.textAmount?.toTitleCase()),
                    if (_rateBloc.state.getRateDataState == DataState.data &&
                        args.debitAccount?.accountCurrency != 'VND' &&
                        args.benCcy == 'VND')
                      ExchangeRateWidget(
                        rateState: _rateBloc.state.getRateDataState,
                        rate: _rateBloc.state.transferRate,
                        amount: args.amount,
                        selectedAmountCcy: 'VND',
                      ),
                    if (_rateBloc.state.getRateDataState == DataState.data &&
                        args.debitAccount?.accountCurrency != 'VND' &&
                        args.benCcy == 'VND')
                      const SizedBox(
                        height: 10,
                      ),
                    if (args.chargeAccount != null && args.ourBenFee != 'BEN')
                      InfomationItem(
                          title: AppTranslate.i18n.chargeAccountStr.localized,
                          subTitle: args.ourBenFee == 'OUR'
                              ? AppUtils.getFeeAccountDisplay(
                                  args.chargeAccount?.accountNumber,
                                  args.chargeAccount?.accountCurrency)
                              : AppUtils.getFeeAccountDisplay(
                                  args.benAccount, args.benCcy)
                          // : "${args.benAccount} (${args.benCcy})",
                          ),
                    if (args.vatFeeAmount != null)
                      AmountItem(
                        unitStyle: TextStyles.itemText.inputTextColor,
                        amountStyle: TextStyles.itemText.inputTextColor,
                        title: getFeeTypeString(args.ourBenFee ?? 'OUR',
                            AppTranslate.i18n.titleVatIncludeStr.localized),
                        subTitle: args.vatFeeAmount,
                        unit: (args.vatFeeAmount != null &&
                                args.vatFeeAmount!.isNotEmpty)
                            ? args.chargeCcy
                            : '',
                      ),
                    InfomationItem(
                      title: AppTranslate.i18n.descriptionTransferStr.localized,
                      subTitle: args.memo,
                    ),
                  ],
                ),
              ),
            ),
            DefaultButton(
              onPress: args.callBack,
              text: AppTranslate.i18n.continueStr.localized,
              height: 45,
              radius: 32,
              margin: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            ),
          ],
        ),
      ),
    );
  }
}
