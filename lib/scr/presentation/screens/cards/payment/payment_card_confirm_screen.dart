import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/bloc.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/card/benefit_contract.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/data/model/transfer/init_transfer_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/screens/cards/card_list/item_card_view.dart';
import 'package:b2b/scr/presentation/screens/cards/card_list/item_contract_view.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/buttons.dart';
import 'package:b2b/scr/presentation/widgets/item_account_service/account_info_item.dart';
import 'package:b2b/scr/presentation/widgets/item_infomation_available.dart';
import 'package:b2b/scr/presentation/widgets/item_information/amount_item.dart';
import 'package:b2b/scr/presentation/widgets/item_information/infomation_item.dart';
import 'package:b2b/scr/presentation/widgets/item_information/title_item.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/utils.dart';
import 'package:flutter/material.dart';

class ConfirmPaymentArgument {
  final DebitAccountModel? debitAccount;
  final InitTransferModel? initTransferModel;
  final dynamic card;
  final Function() callBack;

  ConfirmPaymentArgument({this.debitAccount, this.initTransferModel, required this.callBack, this.card});
}

class PaymentCardConfirmScreen extends StatefulWidget {
  const PaymentCardConfirmScreen({Key? key}) : super(key: key);
  static const String routeName = '/PaymentCardConfirmScreen';

  @override
  _PaymentCardConfirmScreenState createState() => _PaymentCardConfirmScreenState();
}

class _PaymentCardConfirmScreenState extends State<PaymentCardConfirmScreen> {
  @override
  Widget build(BuildContext context) {
    Logger.debug('PaymentCardConfirmScreen');
    var args = getArguments(context) as ConfirmPaymentArgument;

    String vatFeeAmount = '';
    double feeAmountDouble = args.initTransferModel?.vatFeeAmount ?? 0;
    if (feeAmountDouble == 0) {
      vatFeeAmount = AppTranslate.i18n.freeAmountStr.localized;
    } else {
      vatFeeAmount = TransactionManage().formatCurrency(feeAmountDouble, args.debitAccount?.accountCurrency ?? 'VND');
    }

    return AppBarContainer(
      appBarType: AppBarType.SEMI_MEDIUM,
      title: AppTranslate.i18n.cardPaymentConfirmScreenTitleStr.localized,
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
                      title: AppTranslate.i18n.transferToAccountTitleSourceAccountStr.localized,
                    ),
                    AccountInfoItem(
                      workingBalance: args.debitAccount?.availableBalance?.toInt().toString().toMoneyFormat ?? '0',
                      accountCurrency: args.debitAccount?.accountCurrency,
                      accountNumber: args.debitAccount?.getSubtitle(),
                      isLastIndex: true,
                      prefixIcon: AssetHelper.icoWallet,
                      margin: const EdgeInsets.symmetric(vertical: kTopPadding),
                    ),
                    TitleItem(
                      title: AppTranslate.i18n.transferToAccountTitleBeneficiaryInformationStr.localized,
                    ),
                    const SizedBox(
                      height: kDefaultPadding,
                    ),
                    if (args.card is CardModel)
                      ItemCardView(
                        onPress: () {},
                        margin: EdgeInsets.zero,
                        cardCompanyName: args.card?.comMainName,
                        cardName: args.card?.clientName,
                        cardDes: '${args.card?.cardType} | ${args.card?.getLastCardNumber()}',
                        cardModel: args.card,
                      ),
                    if (args.card is BenefitContract)
                      ItemContractView(
                        benefitContract: args.card,
                        margin: EdgeInsets.zero,
                      ),
                    const SizedBox(
                      height: 10,
                    ),
                    AmountItem(
                      title: AppTranslate.i18n.dataHardCoreCountMoneyStr.localized,
                      subTitle: args.initTransferModel?.amount?.toInt().toString().toMoneyFormat ?? '',
                      unit: args.initTransferModel?.amountCcy,
                      amountStyle: TextStyles.itemText.copyWith(color: const Color(0xff00B74F), fontSize: 24),
                      unitStyle: TextStyles.itemText.copyWith(color: const Color(0xff00B74F), fontSize: 14),
                    ),
                    if (args.initTransferModel?.amountSpell != null)
                      InfomationItem(
                        title: AppTranslate.i18n.numberOfMoneyStr.localized,
                        subTitle: args.initTransferModel?.amountSpell?.localization().toTitleCase(),
                      ),
                    InfomationItem(
                      title: AppTranslate.i18n.descriptionTransferStr.localized,
                      subTitle: args.initTransferModel?.memo,
                    ),
                    InfomationItem(
                      title: AppTranslate.i18n.chargeAccountStr.localized,
                      subTitle: AppUtils.getFeeAccountDisplay(
                          args.debitAccount?.accountNumber, args.debitAccount?.accountCurrency),
                    ),
                    if (args.initTransferModel?.chargeAcc.isNotNullAndEmpty == true)
                      InfomationItem(title: AppTranslate.i18n.chargeAccountStr.localized),
                    if (vatFeeAmount.isNotNullAndEmpty)
                      AmountItem(
                        unitStyle: TextStyles.itemText.inputTextColor,
                        amountStyle: TextStyles.itemText.inputTextColor,
                        title: getFeeTypeString(
                            args.initTransferModel?.ourBenFee ?? 'OUR', AppTranslate.i18n.titleVatIncludeStr.localized),
                        subTitle: vatFeeAmount,
                        unit:
                            (args.initTransferModel?.vatFeeAmount != null && args.initTransferModel!.vatFeeAmount! > 0)
                                ? args.debitAccount?.accountCurrency
                                : '',
                      ),
                  ],
                ),
              ),
            ),
            DefaultButton(
              onPress: () {
                args.callBack.call();
              },
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
