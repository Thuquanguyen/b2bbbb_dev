import 'package:b2b/scr/bloc/tax/tax_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/language/app_translate.dart';
import '../../../data/model/name_model.dart';
import '../../widgets/transaction_result.dart';

class ResultRegisterTaxScreen extends StatefulWidget {
  static const String routeName = '/ResultRegisterTaxScreen';

  const ResultRegisterTaxScreen({Key? key}) : super(key: key);

  @override
  _ResultRegisterTaxScreenState createState() =>
      _ResultRegisterTaxScreenState();
}

class _ResultRegisterTaxScreenState extends State<ResultRegisterTaxScreen> {
  late RegisterTaxBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<RegisterTaxBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    TaxState state = _bloc.state;
    return TransactionResult(
      showLogo: true,
      headerText: state.initTransferModel?.transcode,
      infoList: [
        TransactionResultItem(
          title: AppTranslate.i18n.taxIdStr.localized,
          value: state.taxOnline?.taxCode,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.taxDebitAccountStr.localized,
          value: state.rootAccount?.accountNumber,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.feeAccountStr.localized,
          value: state.feeAccount?.accountNumber,
        ),
        TransactionResultItem(
            title: AppTranslate.i18n.taxPayerNameStr.localized,
            value: state.taxOnline?.customerName),
        TransactionResultItem(
          title: AppTranslate.i18n.emailStr.localized,
          value: state.taxOnline?.customerEmail,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.phoneNumberStr.localized,
          value: state.taxOnline?.customerPhoneNumber,
        ),
        TransactionResultItem(
          title: 'Serial Number',
          value: state.taxOnline?.caSerialNumber,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.careerStr.localized,
          value: state.taxOnline?.career,
        ),
        TransactionResultItem(
          title: AppTranslate.i18n.addressStr.localized,
          value: state.taxOnline?.address,
        ),
      ],
      status: NameModel(
        key: 'OPEN_WAI',
        valueEn: AppTranslate.i18n.waitApproveStr.localized.toUpperCase(),
        valueVi: AppTranslate.i18n.waitApproveStr.localized.toUpperCase(),
      ),
    );
  }
}
