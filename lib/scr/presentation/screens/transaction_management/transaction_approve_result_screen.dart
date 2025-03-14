import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/extensions.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/widgets/transaction_result.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';

class TransactionApproveResultScreen extends StatefulWidget {
  const TransactionApproveResultScreen({Key? key}) : super(key: key);
  static const String routeName = 'transaction-approve-result-screen';

  @override
  _TransactionApproveResultScreenState createState() => _TransactionApproveResultScreenState();
}

class _TransactionApproveResultScreenState extends State<TransactionApproveResultScreen> {
  @override
  Widget build(BuildContext context) {
    TransactionMainModel? transaction = getArguments<TransactionMainModel>(context);
    bool shouldShowRate = transaction?.debitAccountCcy?.toLowerCase() != transaction?.benCcy?.toLowerCase();

    if (transaction == null) {
      return Scaffold(
        body: Center(
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    Color.fromRGBO(237, 241, 246, 1),
                    Color.fromRGBO(237, 241, 246, 1),
                  ],
                )),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ImageHelper.loadFromAsset(AssetHelper.icoArtTransactionApprove),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        AppTranslate.i18n.transApproveSuccessfulStr.localized,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          height: 24 / 16,
                          color: kIncreaseMoneyColor,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(
                        height: 44,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          AppTranslate.i18n.transApproveMessageStr.localized,
                          style: kStyleTitleText.copyWith(
                            height: 17 / 13,
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 30,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: RoundedButtonWidget(
                    title: AppTranslate.i18n.transBackMainStr.localized.toUpperCase(),
                    height: 44,
                    radiusButton: 40,
                    onPress: () {
                      popScreen(context);
                    },
                    backgroundButton: const Color(0xff00B74F),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      String? headerText = transaction.transCode;
      if (headerText.isNotNullAndEmpty && transaction.bankId.isNotNullAndEmpty) {
        headerText = headerText! + '\n' + transaction.bankId!;
      }
      headerText ??= transaction.bankId;
      String? benValue =
          transaction.benBankName?.isNotEmpty == true ? transaction.benBankName : transaction.beneficiaryName;
      return TransactionResult(
        showLogo: true,
        headerText: headerText.isNotNullAndEmpty ? headerText : null,
        infoList: [
          TransactionResultItem(
            title: AppTranslate.i18n.tasTdDebitAccountStr.localized,
            value: transaction.debitAccountName,
            valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
            description: transaction.debitAccountNumber,
          ),
          TransactionResultItem(
            title: AppTranslate.i18n.tasTdBenInfoStr.localized,
            value: benValue,
            valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
            description:
                '${transaction.benBankName?.isNotEmpty == true ? ((transaction.beneficiaryName ?? '') + '\n') : ''}${transaction.isCardPayment == true ? transaction.benAccountName.maskedCardNumber : transaction.benAccountName}',
          ),
          TransactionResultItem(
            title: AppTranslate.i18n.tasTdAmountStr.localized,
            valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
            value: transaction.formattedAmount(withCurrency: true),
          ),
          TransactionResultItem(
            title: AppTranslate.i18n.tasTdAmountInWordsStr.localized,
            valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
            value: transaction.amountInWords?.localization().toTitleCase(),
          ),
          if (shouldShowRate)
            TransactionResultItem(
              title: AppTranslate.i18n.tasTdExchangeRateStr.localized,
              value: '1 ${transaction.debitAccountCcy ?? ''} = ${transaction.exchangeRateFormated} VND',
              description: transaction.bankId == null ? AppTranslate.i18n.tasTdExchangeRateNoticeStr.localized : '',
              descriptionStyle: kStyleTitleHeader.copyWith(
                color: AppColors.gRedTextColor,
                fontStyle: FontStyle.italic,
              ),
            ),
          if (shouldShowRate && transaction.currency?.toLowerCase() == 'vnd')
            TransactionResultItem(
              title: AppTranslate.i18n.tasTdDebitAmountStr.localized,
              value: TransactionManage().tryFormatCurrency(transaction.debitAmount, transaction.debitAccountCcy ?? '') +
                  ' ${transaction.debitAccountCcy ?? ''}',
            ),
          if (shouldShowRate && transaction.currency?.toLowerCase() != 'vnd')
            TransactionResultItem(
              title: AppTranslate.i18n.tasTdConvertedAmountStr.localized,
              value: TransactionManage()
                      .tryFormatCurrency((transaction.debitAmount ?? 0) * (transaction.exchangeRate ?? 0), 'VND') +
                  ' VND',
            ),
          TransactionResultItem(
            title: AppTranslate.i18n.tasTdChargeAmountStr.localized,
            value: transaction.isFreeCharge
                ? AppTranslate.i18n.freeAmountStr.localized
                : transaction.formattedFeeAmount(withCurrency: true),
            description: transaction.isFreeCharge
                ? null
                : '${transaction.charges?.localization(defaultValue: AppTranslate.i18n.tasTdChargeAmountStr.localized) ?? ''}${AppTranslate.i18n.titleVatIncludeStr.localized}',
          ),
          if (transaction.shouldShowChargeAccount == true &&
              transaction.chargesAccount.isNotNullAndEmpty &&
              !transaction.isFreeCharge)
            TransactionResultItem(
              title: AppTranslate.i18n.tasTdChargeAccountStr.localized,
              value: transaction.chargesAccount,
            ),
          TransactionResultItem(
            title: AppTranslate.i18n.tisMemoStr.localized,
            value: transaction.memo,
            valueStyle: TextStyles.itemText,
          ),
          TransactionResultItem(
            title: AppTranslate.i18n.tasTdApprTimeStr.localized,
            valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
            value: transaction.dateApprover?.convertServerTime?.toDateTime,
          ),
        ],
        status: NameModel(
          key: 'SUC',
          valueEn: transaction.bankId == null
              ? AppTranslate.i18n.tsApproveConfirmStr.localized
              : AppTranslate.i18n.tsApproveSuccessStr.localized,
          valueVi: transaction.bankId == null
              ? AppTranslate.i18n.tsApproveConfirmStr.localized
              : AppTranslate.i18n.tsApproveSuccessStr.localized,
        ),
      );
    }
  }
}
