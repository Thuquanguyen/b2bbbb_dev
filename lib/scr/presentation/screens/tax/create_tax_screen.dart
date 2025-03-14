import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/tax/tax_online.dart';
import 'package:b2b/scr/presentation/screens/main/main_screen.dart';
import 'package:b2b/scr/presentation/screens/tax/confirm_tax_screen.dart';
import 'package:b2b/scr/presentation/screens/tax/result_register_tax_screen.dart';
import 'package:b2b/scr/presentation/screens/tax/tax_screen.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../commons.dart';
import '../../../../config.dart';
import '../../../../utilities/image_helper/asset_helper.dart';
import '../../../../utilities/logger.dart';
import '../../../bloc/tax/tax_bloc.dart';
import '../../../core/environment/app_enviroment_manager.dart';
import '../../../core/extensions/palette.dart';
import '../../../core/extensions/textstyles.dart';
import '../../../core/smart_otp/smart_otp_manager.dart';
import '../../../data/model/transfer/init_transfer_model.dart';
import '../../widgets/debit_account_widget.dart';
import '../../widgets/dialog_widget.dart';
import '../../widgets/item_vertical_title_value.dart';
import '../../widgets/rounded_button_widget.dart';
import '../smart_otp/verify_otp_screen.dart';
import '../term/term_screen.dart';

class CreateTaxArgs {
  BuildContext context;
  TaxOnline? taxOnline;
  RegisterTaxBloc taxBloc;

  CreateTaxArgs(this.context, {this.taxOnline, required this.taxBloc});
}

class CreateTaxScreen extends StatefulWidget {
  static const String routeName = '/CreateTaxScreen';

  const CreateTaxScreen({Key? key}) : super(key: key);

  @override
  _CreateTaxScreenState createState() => _CreateTaxScreenState();
}

class _CreateTaxScreenState extends State<CreateTaxScreen> {
  late RegisterTaxBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = BlocProvider.of<RegisterTaxBloc>(context)..add(TaxEventGetListDebitAccount());
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: AppTranslate.i18n.registerTaxStr.localized.toUpperCase(),
      isShowKeyboardDoneButton: true,
      appBarType: AppBarType.SEMI_MEDIUM,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      onBack: () {
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: kDecoration,
        margin: const EdgeInsets.all(kDefaultPadding),
        padding: const EdgeInsets.all(kDefaultPadding),
        child: _buildContent(),
      ),
    );
  }

  _buildContent() {
    Logger.debug('_buildContent create tax');

    return MultiBlocListener(
      listeners: [
        BlocListener<RegisterTaxBloc, TaxState>(
          listenWhen: (previous, current) {
            return previous.getListDebitDataState != current.getListDebitDataState;
          },
          listener: (context, state) {
            if (state.getListDebitDataState == DataState.error) {
              showDialogErrorForceGoBack(context, (state.errMsg ?? ''), () {
                popScreen(context);
              });
            }
          },
        ),
        BlocListener<RegisterTaxBloc, TaxState>(
          listenWhen: (previous, current) {
            return previous.initTaxDataState != current.initTaxDataState;
          },
          listener: (context, state) {
            try {
              if (DataState.preload == state.initTaxDataState) {
                showLoading();
                return;
              } else if (state.initTaxDataState == DataState.error) {
                hideLoading();
                showDialogErrorForceGoBack(context, (state.errMsg ?? ''), () {});
                return;
              } else if (state.initTaxDataState == DataState.data) {
                hideLoading();
                Navigator.of(context).pushNamed(
                  ConfirmTaxScreen.routeName,
                  arguments: ConfirmTaxArg(
                    isCreateNew: true,
                    callBack: () {
                      _bloc.add(ConfirmTaxEvent());
                    },
                  ),
                );
              }
            } catch (e) {
              Logger.error('Exception $e');
            }
          },
        ),
        BlocListener<RegisterTaxBloc, TaxState>(
          listenWhen: (previous, current) => previous.confirmTaxDataState != current.confirmTaxDataState,
          listener: (context, state) {
            try {
              if (state.confirmTaxDataState == DataState.preload) {
                showLoading();
                return;
              } else if (state.confirmTaxDataState == DataState.error) {
                showDialogErrorForceGoBack(context, (state.errMsg ?? ''), () {});
                hideLoading();
                return;
              } else if (state.confirmTaxDataState == DataState.data) {
                hideLoading();
                _navigatorToOTPScreen();
              }
            } catch (e) {
              Logger.debug('object');
            }
          },
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
                        style: TextStyles.headerText.copyWith(color: AppColors.greenText),
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      itemVerticalLabelValueText(AppTranslate.i18n.taxIdStr.localized, state.taxOnline?.taxCode,
                          margin: EdgeInsets.zero),
                      debitAccountWidget(
                        onTap: () {
                          showDebitModelBottom(
                            context: context,
                            dataList: state.listDebitAccount,
                            currSelected: state.rootAccount,
                            callBack: (debit) {
                              _bloc.add(TaxEventChangeRootAccount(debit));
                            },
                          );
                        },
                        isLoading: state.getListDebitDataState != DataState.data,
                        value: state.rootAccount?.accountNumber ?? '',
                        title: AppTranslate.i18n.taxDebitAccountStr.localized,
                        margin: const EdgeInsets.only(top: kDefaultPadding),
                      ),
                      debitAccountWidget(
                          onTap: () {
                            showDebitModelBottom(
                                context: context,
                                dataList: state.listDebitAccount,
                                currSelected: state.feeAccount,
                                callBack: (debit) {
                                  _bloc.add(TaxEventChangeFeeAccount(debit));
                                });
                          },
                          isLoading: state.getListDebitDataState != DataState.data,
                          value: state.feeAccount?.accountNumber ?? '',
                          title: AppTranslate.i18n.feePaymentAccountStr.localized),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        AppTranslate.i18n.generalTaxInfoStr.localized,
                        style: TextStyles.headerText.copyWith(color: AppColors.greenText),
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      itemVerticalLabelValueText(
                          AppTranslate.i18n.taxPayerNameStr.localized, state.taxOnline?.customerName),
                      itemVerticalLabelValueText(AppTranslate.i18n.emailStr.localized, state.taxOnline?.customerEmail),
                      itemVerticalLabelValueText(
                          AppTranslate.i18n.phoneNumberStr.localized, state.taxOnline?.customerPhoneNumber),
                      if (state.taxOnline?.career?.isNotNullAndEmpty ?? false)
                        itemVerticalLabelValueText(AppTranslate.i18n.careerStr.localized, state.taxOnline?.career),
                      itemVerticalLabelValueText(AppTranslate.i18n.addressStr.localized, state.taxOnline?.address),
                      itemVerticalLabelValueText('Serial Number', state.taxOnline?.caSerialNumber),
                      noteWidget(openTermAndCondition),
                    ],
                    crossAxisAlignment: CrossAxisAlignment.start,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: kDefaultPadding),
                child: RoundedButtonWidget(
                  onPress: () {
                    registerTax();
                  },
                  title: AppTranslate.i18n.continueStr.localized.toUpperCase().toUpperCase(),
                  textStyle: TextStyles.headerText.copyWith(color: Colors.white),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  openTermAndCondition() {
    String url = AppEnvironmentManager.apiUrl;
    url = url.replaceAll('/api', '');
    url = '$url/tax_register_online_t&c.html';
    if (AppEnvironmentManager.environment == AppEnvironment.Pro) {
      url = 'https://api-b2b.vpbank.com.vn/mapi/tax_register_online_t&c.html';
    }
    Navigator.of(context).pushNamed(
      TermScreen.routeName,
      arguments: TermModel(
        AppTranslate.i18n.homeTitleTermHeaderStr.localized,
        url,
        () {},
      ),
    );
  }

  noteWidget(Function() onTap) {
    return Text.rich(
      TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: AppTranslate.i18n.noteStr.localized,
            style: TextStyles.buttonText.regular.copyWith(
              color: const Color(0xff00B74F),
            ),
          ),
          TextSpan(
            text: '${AppTranslate.i18n.depositsTerm1Str.localized} ',
            style: TextStyles.buttonText.regular,
          ),
          TextSpan(
            text: AppTranslate.i18n.taxConditionStr.localized,
            style: TextStyles.buttonText.bold.copyWith(color: const Color(0xff00B74F)),
            recognizer: TapGestureRecognizer()..onTap = onTap,
          ),
          TextSpan(
            text: ' ${AppTranslate.i18n.depositsTerm2Str.localized}',
            style: TextStyles.buttonText.regular,
          ),
        ],
      ),
    );
  }

  void registerTax() {
    Logger.debug('registerTax');
    _bloc.add(InitTaxEvent());
  }

  void _navigatorToOTPScreen() {
    final state = _bloc.state;
    final args = VerifyMadeFundOTPArgs(
      transCode: state.initTransferModel?.transcode ?? '',
      secureTrans: state.initTransferModel?.sercureTrans ?? '',
      verifyOtpDisplayType: state.confirmPaymentModel?.verifyOtpDisplayType ?? -1,
      transferTypeCode: TransferType.TAX.getTransferTypeCode,
      message: state.confirmPaymentModel?.message,
    );
    SmartOTPManager().verifyOTP(
      context,
      args,
      onResult: (isSuccess, data) {
        if (isSuccess == true) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            ResultRegisterTaxScreen.routeName,
            (route) => route.settings.name == TaxScreen.routeName,
            arguments: _bloc,
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
}
