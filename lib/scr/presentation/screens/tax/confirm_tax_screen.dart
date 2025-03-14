import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/tax/tax_online.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../bloc/tax/tax_bloc.dart';
import '../../../core/extensions/palette.dart';
import '../../../core/extensions/textstyles.dart';
import '../../../core/routes/routes.dart';
import '../../widgets/debit_account_widget.dart';
import '../../widgets/item_vertical_title_value.dart';
import '../../widgets/rounded_button_widget.dart';

class ConfirmTaxArg {
  bool? isCreateNew;

  Function()? callBack;

  ConfirmTaxArg({this.isCreateNew = true, this.callBack});
}

class ConfirmTaxScreen extends StatefulWidget {
  static const String routeName = '/ConfirmTaxScreen';

  const ConfirmTaxScreen({Key? key}) : super(key: key);

  @override
  _ConfirmTaxScreenState createState() => _ConfirmTaxScreenState();
}

class _ConfirmTaxScreenState extends State<ConfirmTaxScreen> {
  late RegisterTaxBloc _bloc;
  TaxOnline? taxOnline;
  ConfirmTaxArg? args;
  bool? isCreateNew;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<RegisterTaxBloc>(context);

    taxOnline = _bloc.state.taxOnline;

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      args = getArguments(context) as ConfirmTaxArg?;
      isCreateNew = args?.isCreateNew ?? true;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: AppTranslate.i18n.otpConfirmInformationStr.localized.toUpperCase(),
      isShowKeyboardDoneButton: true,
      appBarType: AppBarType.SEMI_MEDIUM,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      onBack: () {
        popScreen(context);
      },
      child: Container(
        decoration: kDecoration,
        width: double.infinity,
        height: double.infinity,
        margin: const EdgeInsets.all(kDefaultPadding),
        padding: const EdgeInsets.all(kDefaultPadding),
        child: _buildContent(),
      ),
    );
  }

  _buildContent() {
    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterTaxBloc, TaxState>(
          listenWhen: (previous, current) {
            return false;
          },
          listener: (context, state) {},
        ),
      ],
      child: BlocBuilder<RegisterTaxBloc, TaxState>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        AppTranslate.i18n.customerInfoStr.localized,
                        style: TextStyles.headerText
                            .copyWith(color: AppColors.greenText),
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      itemVerticalLabelValueText(
                          AppTranslate.i18n.taxIdStr.localized,
                          taxOnline?.taxCode,
                          margin: EdgeInsets.zero),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: debitAccountWidget(
                              onTap: () {},
                              hideDropDownIcon: true,
                              value: isCreateNew == true
                                  ? _bloc.state.rootAccount?.accountNumber ?? ''
                                  : taxOnline?.transInfo?.account ?? '',
                              title: AppTranslate
                                  .i18n.taxDebitAccountStr.localized,
                            ),
                          ),
                          Expanded(
                            child: debitAccountWidget(
                                onTap: () {},
                                hideDropDownIcon: true,
                                value: isCreateNew == true
                                    ? _bloc.state.feeAccount?.accountNumber ??
                                        ''
                                    : taxOnline?.transInfo?.accountFee ?? '',
                                title: AppTranslate
                                    .i18n.feePaymentAccountStr.localized),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        AppTranslate.i18n.generalTaxInfoStr.localized,
                        style: TextStyles.headerText
                            .copyWith(color: AppColors.greenText),
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      itemVerticalLabelValueText(
                          AppTranslate.i18n.taxPayerNameStr.localized,
                          taxOnline?.customerName),
                      itemVerticalLabelValueText(
                          AppTranslate.i18n.emailStr.localized,
                          taxOnline?.customerEmail),
                      itemVerticalLabelValueText(
                          AppTranslate.i18n.phoneNumberStr.localized,
                          taxOnline?.customerPhoneNumber),
                      if ((taxOnline?.career ?? '').isNotNullAndEmpty)
                        itemVerticalLabelValueText(
                            AppTranslate.i18n.careerStr.localized,
                            taxOnline?.career),
                      itemVerticalLabelValueText(
                          AppTranslate.i18n.addressStr.localized,
                          taxOnline?.address),
                      itemVerticalLabelValueText(
                          'Serial Number', taxOnline?.caSerialNumber),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: kDefaultPadding),
                child: RoundedButtonWidget(
                  backgroundButton: isCreateNew == true
                      ? const Color(0xff00B74F)
                      : const Color(0xffFF6763),
                  onPress: () {
                    if (isCreateNew == true) {
                      args?.callBack?.call();
                    } else {
                      cancelTax();
                    }
                  },
                  title: isCreateNew == true
                      ? AppTranslate.i18n.continueStr.localized.toUpperCase()
                      : AppTranslate.i18n.cancelTransactionStr.localized
                          .toUpperCase(),
                  textStyle:
                      TextStyles.headerText.copyWith(color: Colors.white),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  void cancelTax() {
    //TODO cancel TAX
  }
}
