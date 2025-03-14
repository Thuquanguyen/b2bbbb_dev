import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/bill/bill_info.dart';
import 'package:b2b/scr/presentation/screens/bill/bill_screen.dart';
import 'package:b2b/scr/presentation/screens/bill/electric/electric_payment_result_screen.dart';
import 'package:b2b/scr/presentation/screens/main/main_screen.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/item_horizontal_title_value.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import '../../../../../commons.dart';
import '../../../../../constants.dart';
import '../../../../../utilities/image_helper/asset_helper.dart';
import '../../../../bloc/bill/electric/payment_electric_bloc.dart';
import '../../../../bloc/otp/otp_bloc.dart';
import '../../../../core/extensions/textstyles.dart';
import '../../../../core/language/app_translate.dart';
import '../../../../core/smart_otp/smart_otp_manager.dart';
import '../../../widgets/appbar_container.dart';
import '../../../widgets/buttons.dart';
import '../../../widgets/item_account_service/account_info_item.dart';
import '../../../widgets/item_information/amount_item.dart';
import '../../../widgets/item_information/infomation_item.dart';
import '../../../widgets/item_information/title_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';

class ElectricConfirmPaymentScreen extends StatefulWidget {
  static String routeName = 'ElectricConfirmPaymentScreen';

  ElectricConfirmPaymentScreen({Key? key}) : super(key: key);

  @override
  _ElectricConfirmPaymentScreenState createState() =>
      _ElectricConfirmPaymentScreenState();
}

class _ElectricConfirmPaymentScreenState
    extends State<ElectricConfirmPaymentScreen> {
  late PaymentElectricBloc _bloc;
  late PaymentElectricState _state;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<PaymentElectricBloc>(context);
    _state = _bloc.state;
  }

  void _navigatorToOTPScreen(PaymentElectricState state) {
    final args = VerifyOtpBillArgs(
      transCode: state.initBillResponse?.transCode ?? '',
      secureTrans: state.initBillResponse?.sercureTrans ?? '',
      verifyOtpDisplayType:
          state.confirmBillResponse?.verifyOtpDisplayType ?? -1,
      message: state.confirmBillResponse?.message,
    );
    SmartOTPManager().verifyOTP(
      context,
      args,
      onResult: (isSuccess, data) {
        if (isSuccess == true) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            ElectricPaymentResultScreen.routeName,
            (route) => route.settings.name == MainScreen.routeName,
          );
        } else {
          if (data is OtpVerifyMadeFundState) {
            if (data.status == OtpStatus.VERIFY_ERROR_00) {
              showDialogCustom(
                context,
                AssetHelper.icoAuthError,
                AppTranslate.i18n.dialogTitleNotificationStr.localized,
                data.message ?? AppTranslate.i18n.errorNoReasonStr.localized,
                barrierDismissible: false,
                showCloseButton: false,
                button1: renderDialogTextButton(
                  context: context,
                  title: AppTranslate.i18n.dmcdsBackStr.localized,
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                ),
              );
            } else {
              Navigator.of(context).pop();
            }
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double totalAmt = 0;
    _bloc.selectedBillList.forEach((element) {
      totalAmt += (element?.billAmt ?? 0);
      element?.setSelected(true);
    });

    return AppBarContainer(
      appBarType: AppBarType.SEMI_MEDIUM,
      title: AppTranslate.i18n.otpConfirmInformationStr.localized.toUpperCase(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<PaymentElectricBloc, PaymentElectricState>(
            listenWhen: (pre, cur) {
              return pre.confirmBillDataState != cur.confirmBillDataState;
            },
            listener: (c, s) {
              if (s.confirmBillDataState == DataState.preload) {
                showLoading();
              } else {
                hideLoading();
                if (s.confirmBillDataState == DataState.error) {
                  showDialogErrorForceGoBack(
                      context, s.confirmBillErrMsg ?? '', () {});
                } else if (s.confirmBillDataState == DataState.data) {
                  _navigatorToOTPScreen(s);
                }
              }
            },
          )
        ],
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
                        workingBalance: _state.selectedDebitAccount
                            ?.availableBalance?.toMoneyString,
                        accountCurrency:
                            _state.selectedDebitAccount?.accountCurrency ??
                                'VND',
                        accountNumber:
                            _state.selectedDebitAccount?.getSubtitle(),
                        isLastIndex: true,
                        prefixIcon: AssetHelper.icoWallet,
                        margin:
                            const EdgeInsets.symmetric(vertical: kTopPadding),
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      _paymentInfo(),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      InfomationItem(
                        title: AppTranslate.i18n.customerNameStr.localized,
                        subTitle: _state.billInfo?.cusInfo?.cusName,
                      ),
                      InfomationItem(
                        title: AppTranslate.i18n.addressStr.localized,
                        subTitle: _state.billInfo?.cusInfo?.cusAddr,
                      ),

                      AmountItem(
                        title: AppTranslate.i18n.totalAmountStr.localized,
                        subTitle: totalAmt.toMoneyString,
                        amountStyle: TextStyles.headerText
                            .copyWith(color: AppColors.greenText),
                        unit: _state.selectedDebitAccount?.accountCurrency ??
                            'VND',
                        unitStyle: TextStyles.captionText.copyWith(
                          fontSize: 14,
                          color: AppColors.greenText,
                        ),
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      _buildListPeriod(),
                      // InfomationItem(
                      //   title: 'Nội dung',
                      //   subTitle: _state.initBillResponse?.memo,
                      // ),
                    ],
                  ),
                ),
              ),
              DefaultButton(
                onPress: () {
                  _bloc.add(ConfirmBillEvent());
                },
                text: AppTranslate.i18n.continueStr.localized,
                height: 45,
                radius: 32,
                margin: const EdgeInsets.symmetric(vertical: kDefaultPadding),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildListPeriod() {
    List<BillInfoBillList?> dataList = _bloc.selectedBillList;
    return ListView.separated(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (c, i) {
          return _itemPeriod(dataList[i]);
        },
        separatorBuilder: (c, s) {
          return const SizedBox(
            height: kDefaultPadding,
          );
        },
        itemCount: dataList.length);
  }

  _itemPeriod(BillInfoBillList? data) {
    if (data == null) {
      return const SizedBox();
    }
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xffF9F9F9),
      ),
      child: Column(
        children: [
          itemTextHorizontalTitleValue(
              title: AppTranslate.i18n.paymentScheduleStr.localized,
              value: data.billMonth,
              valueStyle: TextStyles.itemText.medium
                  .copyWith(color: AppColors.blackTextColor)),
          itemTextHorizontalTitleValue(
              title: AppTranslate.i18n.transferAmountStr.localized,
              value: '${data.billAmt?.toMoneyString} VND',
              valueStyle: TextStyles.itemText.bold
                  .copyWith(color: AppColors.blackTextColor)),
          itemTextHorizontalTitleValue(
              title: AppTranslate.i18n.billTypeStr.localized, value: data.type),
          itemTextHorizontalTitleValue(
              title: AppTranslate.i18n.billIdStr.localized, value: data.billId),
        ],
      ),
    );
  }

  Widget _paymentInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppTranslate.i18n.paymentInfoStr.localized,
          style: TextStyles.headerText.copyWith(fontSize: 16),
        ),
        const SizedBox(
          height: kDefaultPadding,
        ),
        Row(
          children: [
            ImageHelper.loadFromAsset(AssetHelper.electricHcm,
                width: 16, height: 16),
            const SizedBox(
              width: kDefaultPadding,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _bloc.billProvider?.providerName ?? '',
                  style: TextStyles.itemText.semibold,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  _bloc.customerCode,
                  style: TextStyles.itemText.semibold,
                ),
              ],
            )
          ],
        )
      ],
    );
  }
}
