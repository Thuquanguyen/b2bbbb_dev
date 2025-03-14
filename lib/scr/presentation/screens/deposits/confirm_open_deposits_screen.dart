import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/deposits/open_online_deposits_bloc.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/data/model/open_saving/init_deposits_result.dart';
import 'package:b2b/scr/presentation/screens/deposits/open_deposits_result_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/open_online_deposits_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/render_deposits_input.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/buttons.dart';
import 'package:b2b/scr/presentation/widgets/item_account_service/account_info_item.dart';
import 'package:b2b/scr/presentation/widgets/item_information/amount_item.dart';
import 'package:b2b/scr/presentation/widgets/item_information/infomation_item.dart';
import 'package:b2b/scr/presentation/widgets/item_information/title_item.dart';
import 'package:b2b/scr/presentation/widgets/rounded_button_widget.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ConfirmDepositsScreen extends StatefulWidget {
  const ConfirmDepositsScreen({
    Key? key,
  }) : super(key: key);
  static const String routeName = 'ConfirmDepositsScreen';

  @override
  _ConfirmDepositsScreenState createState() => _ConfirmDepositsScreenState();
}

class _ConfirmDepositsScreenState extends State<ConfirmDepositsScreen> {
  late OpenOnlineDepositsBloc depositsBloc;

  @override
  void initState() {
    super.initState();
    Logger.debug('init state');
    depositsBloc = BlocProvider.of<OpenOnlineDepositsBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    depositsBloc.add(ClearDepositInitDataState());
  }

  @override
  Widget build(BuildContext context) {
    OpenOnlineDepositsState state = depositsBloc.state;
    InitDepositsResult? depositsResult = state.intDepositsResult;
    if (depositsResult == null) {
      popScreen(context);
    }
    return AppBarContainer(
      appBarType: AppBarType.SEMI_MEDIUM,
      title: AppTranslate.i18n.otpConfirmInformationStr.localized,
      onTap: () {},
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
              child:
                  BlocListener<OpenOnlineDepositsBloc, OpenOnlineDepositsState>(
                listenWhen: (previous, current) {
                  return previous.confirmDepositsDataState !=
                      current.confirmDepositsDataState;
                },
                listener: (context, state) {
                  if (state.confirmDepositsDataState == DataState.preload) {
                    showLoading();
                    return;
                  } else if (state.confirmDepositsDataState ==
                      DataState.error) {
                    hideLoading();
                    showDialogErrorForceGoBack(
                      context,
                      (state.errorMessage ?? ''),
                      () {
                        popScreen(context);
                      },
                    );
                    return;
                  } else if (state.confirmDepositsDataState == DataState.data) {
                    hideLoading();
                    _navigatorToOTPScreen();
                  }
                },
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
                        workingBalance: state.rootAccountDebit?.availableBalance
                                ?.toInt()
                                .toString()
                                .toMoneyFormat ??
                            '0',
                        accountCurrency:
                            state.rootAccountDebit?.accountCurrency,
                        accountNumber: state.rootAccountDebit?.getSubtitle(),
                        isLastIndex: true,
                        prefixIcon: AssetHelper.icoWallet,
                        margin:
                            const EdgeInsets.symmetric(vertical: kTopPadding),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      AmountItem(
                        title: AppTranslate.i18n.depositsStr.localized,
                        subTitle: depositsResult?.amount
                            ?.toInt()
                            .toString()
                            .toMoneyFormat,
                        unit: depositsResult?.amountCcy,
                      ),
                      // if (args.textAmount != null)
                      InfomationItem(
                        title: AppTranslate.i18n.numberOfMoneyStr.localized,
                        subTitle:
                            (depositsResult?.amountSpell?.localization() ?? '')
                                .toTitleCase(),
                        subTitleStyle:
                            TextStyles.itemText.medium.tabSelctedColor,
                      ),
                      periodWidget(state,
                          hidePadding: true, isShowDropdown: false),
                      const SizedBox(
                        height: 10,
                      ),
                      InfomationItem(
                        title:
                            AppTranslate.i18n.listedInterestRateStr.localized,
                        subTitle: depositsResult?.getRate(),
                        subTitleStyle: TextStyles.itemText.medium
                            .copyWith(color: blueTextColor),
                        note: (depositsResult?.isShowNoticeCellingRate() ==
                                    true &&
                                (depositsResult?.voucherRate ?? '')
                                    .isNullOrEmpty)
                            ? AppTranslate.i18n.maxInterestRateStr.localized
                                .interpolate(
                                {'rate': depositsResult?.ceilingRate},
                              )
                            : '',
                        noteStyle: TextStyles.smallText.copyWith(
                          color: const Color(0xffFF6763),
                        ),
                      ),
                      if (depositsResult?.voucherRate != null &&
                          depositsResult!.getVoucherRate().isNotNullAndEmpty)
                        InfomationItem(
                          title:
                              AppTranslate.i18n.profitInterestRateStr.localized,
                          subTitle: depositsResult.getVoucherRate(),
                          subTitleStyle: TextStyles.itemText.medium
                              .copyWith(color: blueTextColor),
                          note: depositsResult.isShowNoticeCellingRate() ==
                                  false
                              ? ''
                              : AppTranslate.i18n.maxInterestRateStr.localized
                                  .interpolate({
                                  'rate': depositsResult.ceilingRate ?? ''
                                }),
                          noteStyle: TextStyles.smallText.copyWith(
                            color: const Color(0xffFF6763),
                          ),
                        ),
                      InfomationItem(
                        title: AppTranslate
                            .i18n.receiveInterestMethodStr.localized,
                        subTitle:
                            state.savingReceiveMethod?.interrestPreiod ?? '',
                        subTitleStyle:
                            TextStyles.itemText.medium.tabSelctedColor,
                      ),
                      InfomationItem(
                          title: AppTranslate
                              .i18n.dueProcessingMethodStr.localized,
                          subTitle: state.depositsInputState?.selectedSettelment
                                  ?.name ??
                              '',
                          subTitleStyle:
                              TextStyles.itemText.medium.tabSelctedColor),
                      const SizedBox(
                        height: 10,
                      ),
                      accountWidget(state,
                          hideDropDownIcon: true,
                          title: AppTranslate
                              .i18n.accountReceiveProfitStr.localized),
                      const SizedBox(
                        height: 10,
                      ),
                      if (depositsResult!.introducerCif.isNotNullAndEmpty)
                        InfomationItem(
                          title: AppTranslate.i18n.cifReferStr.localized,
                          subTitle: depositsResult.introducerCif,
                        ),
                      if (depositsResult.contractNumber.isNotNullAndEmpty)
                        InfomationItem(
                          title: AppTranslate.i18n.noteStr.localized,
                          subTitle: depositsResult.contractNumber,
                        ),
                      Text.rich(
                        TextSpan(
                          children: <TextSpan>[
                            TextSpan(
                              text: AppTranslate.i18n.noteStr.localized,
                              style: TextStyles.buttonText.medium.copyWith(
                                color: const Color(0xff00B74F),
                              ),
                            ),
                            TextSpan(
                              text:
                                  '${AppTranslate.i18n.noteConfirmDepositsStr.localized} ',
                              style: TextStyles.buttonText.regular
                                  .copyWith(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 5,
                ),
                RoundedButtonWidget(
                  onPress: () {
                    if (depositsBloc.state.intDepositsResult != null) {
                      depositsBloc.add(
                        ConfirmOpenDepositsEvent(
                            depositsBloc.state.intDepositsResult!),
                      );
                    }
                  },
                  title: AppTranslate.i18n.continueStr.localized.toUpperCase(),
                  textStyle:
                      TextStyles.headerText.copyWith(color: Colors.white),
                ),
                const SizedBox(
                  height: 24,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _navigatorToOTPScreen() {
    OpenOnlineDepositsState state = depositsBloc.state;
    final args = VerifyOtpOpenSavingArgs(
      transCode: state.intDepositsResult?.transCode ?? '',
      secureTrans: state.intDepositsResult?.sercureTrans ?? '',
      verifyOtpDisplayType: state.confirmResponse?.verifyOtpDisplayType ?? -1,
      message: state.confirmResponse?.message,
      transferTypeCode: 4,
    );
    SmartOTPManager().verifyOTP(
      context,
      args,
      onResult: (isSuccess, data) {
        if (isSuccess == true) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            OpenDepositsResultScreen.routeName,
            (route) =>
                route.settings.name == OpenOnlineDepositsScreen.routeName,
            arguments: context,
          );
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }
}
