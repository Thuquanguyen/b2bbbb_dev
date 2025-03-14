import 'package:b2b/scr/bloc/bill/electric/payment_electric_bloc.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/presentation/widgets/transaction_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';

class ElectricPaymentResultScreen extends StatefulWidget {
  const ElectricPaymentResultScreen({Key? key}) : super(key: key);
  static const String routeName = '/ElectricPaymentResultScreen';

  @override
  State<StatefulWidget> createState() => ElectricPaymentResultScreenState();
}

class ElectricPaymentResultScreenState
    extends State<ElectricPaymentResultScreen> {
  late PaymentElectricBloc bloc;
  late PaymentElectricState state;
  String period = '';

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<PaymentElectricBloc>(context);
    state = bloc.state;
    for (var e in bloc.selectedBillList) {
      if (e != null) {
        period = '$period\n${e.billMonth}';
      }
    }
    period = period.replaceFirst('\n', '');
  }

  @override
  Widget build(BuildContext context) {
    DebitAccountModel? debitAccountModel = bloc.state.selectedDebitAccount;

    double totalAmt = 0;
    for (var element in bloc.selectedBillList) {
      totalAmt += (element?.billAmt ?? 0);
      element?.setSelected(true);
    }

    return TransactionResult(
      showLogo: true,
      headerText: state.initBillResponse?.transCode,
      infoList: [
        TransactionResultItem(
          title: AppTranslate
              .i18n.transferToAccountTitleSourceAccountStr.localized,
          value: debitAccountModel?.accountNumber,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.billProviderStr.localized,
          value: bloc.billProvider?.providerName,
        ),
        TransactionResultItem(
            title: AppTranslate.i18n.customerIdStr.localized,
            value: bloc.customerCode,
            valueStyle: TextStyles.itemText.semibold
                .copyWith(color: const Color(0xff22313F))),
        TransactionResultItem(
          title: AppTranslate.i18n.customerNameStr.localized,
          value: state.billInfo?.cusInfo?.cusName,
          valueStyle: TextStyles.itemText.semibold
              .copyWith(color: const Color(0xff22313F)),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.addressStr.localized,
          value: state.billInfo?.cusInfo?.cusAddr,
          valueStyle: TextStyles.itemText,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.totalAmountStr.localized,
          value: '${totalAmt.toMoneyString} VND',
          valueStyle: TextStyles.semiBoldText
              .setColor(const Color.fromRGBO(52, 52, 52, 1)),
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.paymentScheduleStr.localized,
          value: period,
          valueStyle: TextStyles.itemText,
        ),
        // TransactionResultItem(
        //   title: 'Nội dung',
        //   value: 'thanh toan hoa don tien dien 1263300028 so tien 911323 khach hang PD1100041982- luu the vinh ky thang 3/ 2022',
        //   valueStyle: TextStyles.itemText,
        // ),
      ],
      status: NameModel(
        key: 'OPEN_WAI',
        valueEn: AppTranslate.i18n.waitApproveStr.localized.toUpperCase(),
        valueVi: AppTranslate.i18n.waitApproveStr.localized.toUpperCase(),
      ),
    );
  }
}
