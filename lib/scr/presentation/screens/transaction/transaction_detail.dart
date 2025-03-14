import 'package:b2b/scr/bloc/bloc.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/extensions/extensions.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/presentation/widgets/transaction_result.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionInquiryDetailScreen extends StatefulWidget {
  const TransactionInquiryDetailScreen({Key? key}) : super(key: key);
  static const String routeName = 'transaction-inquiry-detail-screen';

  @override
  _TransactionInquiryDetailScreenState createState() => _TransactionInquiryDetailScreenState();
}

class _TransactionInquiryDetailScreenState extends State<TransactionInquiryDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _contentBuilder(BuildContext context, TransactionInquiryState state) {
    TransactionInquiryDetailState? detail = state.detailState;
    if (detail != null) {
      bool isPayroll = detail.data?.transactionType?.transactionType == TransactionType.SALARY_FILE;
      String? headerText = detail.data?.transCode;
      if (headerText.isNotNullAndEmpty && (detail.data?.bankId.isNotNullAndEmpty == true)) {
        headerText = headerText! + '\n' + detail.data!.bankId!;
      }
      headerText ??= detail.data!.bankId;
      return TransactionResult(
        screenTitle: isPayroll ? AppTranslate.i18n.tisPayrollDetailScreenTitleStr.localized : null,
        showLogo: true,
        headerText: headerText.isNotNullAndEmpty ? headerText : null,
        infoList: [
          TransactionResultItem(
            title: AppTranslate.i18n.tisDebitAccountStr.localized,
            valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
            value: detail.data?.debitAccountName,
            description: detail.data?.debitAccountNumber,
          ),
          if (!isPayroll)
            TransactionResultItem(
              title: AppTranslate.i18n.tisBenInfoStr.localized,
              value: '${detail.data?.benBankName}\n${detail.data?.beneficiaryName}',
              valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
              description: detail.data?.isCardPayment == true
                  ? detail.data?.benAccountName.maskedCardNumber
                  : detail.data?.benAccountName,
            ),
          TransactionResultItem(
            title: AppTranslate.i18n.tisAmountStr.localized,
            valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
            value: detail.data?.formattedAmount(withCurrency: true),
          ),
          TransactionResultItem(
            title: AppTranslate.i18n.tisAmountInWordsStr.localized,
            valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
            value: detail.data?.amountInWords?.localization(),
          ),
          TransactionResultItem(
            title: AppTranslate.i18n.tisMemoStr.localized,
            value: detail.data?.memo,
            valueStyle: TextStyles.itemText,
          ),
          if (isPayroll)
            TransactionResultItem(
              title: AppTranslate.i18n.prTotalItemsStr.localized,
              value: '${(detail.data?.totalInhouse ?? 0) + (detail.data?.totalOther ?? 0)}',
              valueStyle: TextStyles.itemText,
            ),
          TransactionResultItem(
            title: detail.data?.charges?.localization() ?? AppTranslate.i18n.tisChargeStr.localized,
            value: detail.data?.isFreeCharge == true
                ? AppTranslate.i18n.freeAmountStr.localized
                : detail.data?.formattedFeeAmount(withCurrency: true),
            description: detail.data?.isFreeCharge == true ? '' : AppTranslate.i18n.titleVatIncludeStr.localized,
          ),
          TransactionResultItem(
            title: AppTranslate.i18n.tisChargeAccountStr.localized,
            value: detail.data?.chargesAccount,
            valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
          ),
          TransactionResultItem(
            title: AppTranslate.i18n.tisTimestampStr.localized,
            value: detail.data?.createdDate?.convertServerTime?.toDateTime ?? '',
          ),
        ],
        status: detail.data?.status,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TransactionInquiryBloc, TransactionInquiryState>(
      listenWhen: (previous, current) => previous.detailState?.dataState != current.detailState?.dataState,
      listener: (_, __) {},
      builder: _contentBuilder,
    );
  }
}
