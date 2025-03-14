import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/tax/tax_online.dart';
import 'package:b2b/scr/presentation/widgets/transaction_result.dart';
import 'package:flutter/cupertino.dart';

class TaxApproveResultScreen extends StatefulWidget {
  const TaxApproveResultScreen({Key? key}) : super(key: key);
  static const String routeName = 'TaxApproveResultScreen';

  @override
  State<StatefulWidget> createState() => TaxApproveResultScreenState();
}

class TaxApproveResultScreenState extends State<TaxApproveResultScreen> {
  @override
  Widget build(BuildContext context) {
    TaxOnline? taxOnline = getArgument<TaxOnline>(context, 'tax');
    if (taxOnline == null) {
      popScreen(context);
      return const SizedBox();
    }

    return TransactionResult(
      showLogo: true,
      headerText: taxOnline.transInfo?.transCode,
      infoList: [
        TransactionResultItem(
          title: AppTranslate.i18n.taxIdStr.localized,
          value: taxOnline.taxCode,
          valueStyle: TextStyles.semiBoldText.setColor(const Color.fromRGBO(52, 52, 52, 1)),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.taxDebitAccountStr.localized,
          value: taxOnline.transInfo?.account,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.feeAccountStr.localized,
          value: taxOnline.transInfo?.accountFee,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.taxPayerNameStr.localized,
          value: taxOnline.customerName,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.emailStr.localized,
          value: taxOnline.customerEmail,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.phoneNumberStr.localized,
          value: taxOnline.customerPhoneNumber,
        ),
        TransactionResultItem(
          title: 'Serial Number',
          value: taxOnline.caSerialNumber,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.careerStr.localized,
          value: taxOnline.career,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.addressStr.localized,
          value: taxOnline.address,
        ),
      ],
      status: NameModel(
        key: 'SUC',
        valueEn: AppTranslate.i18n.tsApproveConfirmStr.localized,
        valueVi: AppTranslate.i18n.tsApproveConfirmStr.localized,
      ),
    );
  }
}
