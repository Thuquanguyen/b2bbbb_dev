import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/account_service/account_info/account_info_bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/account_service/account_model.dart';
import 'package:b2b/scr/data/model/account_services_arguments.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/account_list_screen.dart';
import 'package:b2b/scr/presentation/screens/account_service/account_service.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/widgets/inputs/vp_amount_input.dart';
import 'package:b2b/scr/presentation/widgets/inputs/vp_text_input.dart';
import 'package:b2b/scr/presentation/widgets/keyboard_aware_scroll_view.dart';
import 'package:b2b/scr/presentation/widgets/vp_date_selector.dart';
import 'package:b2b/scr/presentation/widgets/vp_dropdown.dart';
import 'package:b2b/scr/presentation/widgets/vp_icon_header.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';

enum TransactionType { ONLINE, OFFLINE }

class TransactionListArgument {
  TransactionListArgument({this.accountInfo, this.transactionType = TransactionType.ONLINE});

  final AccountInfo? accountInfo;
  TransactionType transactionType;
}

class TransactionListScreen extends StatefulWidget {
  const TransactionListScreen({Key? key}) : super(key: key);
  static const String routeName = 'send-statements-screen';

  @override
  _TransactionListScreenState createState() => _TransactionListScreenState();
}

class _TransactionListScreenState extends State<TransactionListScreen> {
  DateTime? _dateFrom;
  DateTime? _dateTo;
  final TextEditingController _amountFromController = TextEditingController();
  final TextEditingController _amountToController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  String? _fileName = "";
  int _selectedFileName = 0;

  final List<NameModel<int>> _listOptions = [
    NameModel(
      valueVi: AppTranslate.i18n.oneWeekStr.localized,
      valueEn: AppTranslate.i18n.oneWeekStr.localized,
      data: 7,
    ),
    NameModel(
      valueVi: AppTranslate.i18n.twoWeekStr.localized,
      valueEn: AppTranslate.i18n.twoWeekStr.localized,
      data: 14,
    ),
    NameModel(
      valueVi: AppTranslate.i18n.oneMouthStr.localized,
      valueEn: AppTranslate.i18n.oneMouthStr.localized,
      data: 30,
    ),
    NameModel(
      valueVi: AppTranslate.i18n.electiveStr.localized,
      valueEn: AppTranslate.i18n.electiveStr.localized,
      data: 0,
    )
  ];

  final List<NameModel<String>> _listFile = [
    NameModel(
      valueVi: "CSV",
      valueEn: "CSV",
      data: "csv",
    ),
    NameModel(
      valueVi: "XLS",
      valueEn: "XLS",
      data: "xls",
    ),
  ];

  int _valueOption = 0;
  TransactionType? transactionType;

  void updateDateRange(int index) {
    _dateTo = DateTime.now();
    _dateFrom = _dateTo?.subtract(Duration(days: _listOptions[index].data ?? 0));
    setState(() {});
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      updateDateRange(0);
      _fileName = _listFile[_selectedFileName].data;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    TransactionListArgument args = getArguments(context) as TransactionListArgument;
    transactionType ??= args.transactionType;

    return AppBarContainer(
      onTap: () {
        hideKeyboard(context);
      },
      appBarType: AppBarType.SEMI_MEDIUM,
      isShowKeyboardDoneButton: true,
      title: transactionType == TransactionType.ONLINE
          ? AppTranslate.i18n.onlineStatementStr.localized
          : AppTranslate.i18n.asSendStatementEmailStr.localized,
      child: BlocConsumer<AccountInfoBloc, AccountInfoState>(
        listenWhen: (previous, current) => previous.statementState != current.statementState,
        listener: (context, state) {
          if (state.statementState == DataState.preload) {
            showLoading();
          } else if (state.statementState == DataState.data) {
            if (state.baseResultModel?.code == "200") {
              String message = state.baseResultModel?.getMessage() ?? '';
              showDialogCustom(
                context,
                AssetHelper.icoStatementComplate,
                AppTranslate.i18n.asRequsetSendStatementSuccessStr.localized,
                replaceTextToStyle(message, ['Vpbank']),
                button1: renderDialogTextButton(
                  context: context,
                  textStyle: TextStyles.headerText.unitColor,
                  title: AppTranslate.i18n.asBackToListAccountStr.localized.toUpperCase(),
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.settings.name == AccountListScreen.routeName);
                  },
                ),
              );
            } else {
              showDialogCustom(context, AssetHelper.icoAuthError,
                  AppTranslate.i18n.dialogTitleNotificationStr.localized, state.baseResultModel?.getMessage() ?? "",
                  button1: renderDialogTextButton(
                      context: context, title: AppTranslate.i18n.dialogButtonCloseStr.localized));
            }
            hideLoading();
          } else {
            hideLoading();
          }
        },
        builder: (context, current) {
          double paddingKeyboard = MediaQuery.of(context).viewInsets.bottom - 90 - SizeConfig.bottomSafeAreaPadding;
          if (paddingKeyboard < 0) paddingKeyboard = 0;
          return Container(
            child: Column(
              children: [
                Expanded(
                    child: KeyboardAwareScrollView(
                  child: StateBuilder(
                      builder: () => Column(
                            children: [
                              VPIconHeader(
                                  title: AppTranslate.i18n.asPeriodStr.localized, icon: AssetHelper.icoFindCalendar),
                              VPDropDown(
                                options: _listOptions,
                                onSelect: (c, o, i) {
                                  _valueOption = i;
                                  updateDateRange(i);
                                },
                                selectedIndex: _valueOption,
                                title: AppTranslate.i18n.asPeriodStr.localized,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: VPDateInput(
                                      title: AppTranslate.i18n.tqsFromDateStr.localized,
                                      currentDate: _dateFrom,
                                      minDate: Jiffy().subtract(months: 6).dateTime,
                                      maxDate: _dateTo,
                                      onSelect: (d) {
                                        _dateFrom = d;
                                        _valueOption = _listOptions.length - 1;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(
                                    child: VPDateInput(
                                      title: AppTranslate.i18n.tqsToDateStr.localized,
                                      currentDate: _dateTo,
                                      minDate: _dateFrom,
                                      maxDate: DateTime.now(),
                                      onSelect: (d) {
                                        _dateTo = d;
                                        _valueOption = _listOptions.length - 1;
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              VPIconHeader(
                                title: AppTranslate.i18n.asForAmountStr.localized,
                                icon: AssetHelper.icoPayment,
                              ),
                              Row(
                                children: [
                                  Flexible(
                                    child: VPAmountInput(
                                      controller: _amountFromController,
                                      title: AppTranslate.i18n.tqsFromAmountStr.localized,
                                      hint: AppTranslate.i18n.titleInputAmountMinStr.localized,
                                    ),
                                    flex: 3,
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Flexible(
                                    child: VPAmountInput(
                                      enabled: false,
                                      controller: TextEditingController(text: args.accountInfo?.accountCurrency ?? ''),
                                      title: AppTranslate.i18n.titleTypeAmountStr.localized,
                                      hint: AppTranslate.i18n.titleInputAmountMinStr.localized,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              VPAmountInput(
                                controller: _amountToController,
                                title: AppTranslate.i18n.tqsToAmountStr.localized,
                                hint: AppTranslate.i18n.titleInputAmountMaxStr.localized,
                              ),
                              const SizedBox(
                                height: 16,
                              ),
                              VPIconHeader(
                                title: AppTranslate.i18n.asForContentTransactionStr.localized,
                                icon: AssetHelper.icoReceipt,
                              ),
                              VPTextInput(
                                controller: _contentController,
                                title: AppTranslate.i18n.tqsInputMemoStr.localized,
                                // hint: AppTranslate.i18n.asInputContentTransactionStr.localized,
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Visibility(
                                child: VPDropDown<String>(
                                  options: _listFile,
                                  onSelect: (c, o, i) {
                                    _selectedFileName = i;
                                    _fileName = o.data;
                                    setState(() {});
                                  },
                                  selectedIndex: _selectedFileName,
                                  title: AppTranslate.i18n.asFileFormatStr.localized,
                                ),
                                visible: transactionType == TransactionType.OFFLINE,
                              ),
                              // if (args.transactionType ==
                              //     TransactionType.OFFLINE)
                              //   ItemNoteTransaction(
                              //     contentNote: AppTranslate.i18n
                              //         .asChooseTimeTransactionStr.localized,
                              //   )
                            ],
                          ),
                      routeName: TransactionListScreen.routeName),
                )),
                Visibility(
                  child: RoundedButtonWidget(
                    title: transactionType == TransactionType.ONLINE
                        ? AppTranslate.i18n.asListResultStr.localized.toUpperCase()
                        : AppTranslate.i18n.asSendStatementStr.localized.toUpperCase(),
                    onPress: () => _sendStatement(args),
                    height: 44.toScreenSize,
                  ),
                  visible: !isKeyboardShowing(context),
                )
              ],
            ),
            decoration: kDecoration,
            padding: EdgeInsets.only(
              top: 20,
              left: kDefaultPadding,
              right: kDefaultPadding,
              bottom: isKeyboardShowing(context) ? 0 : 14,
            ),
            margin: EdgeInsets.only(
                left: kDefaultPadding,
                right: kDefaultPadding,
                bottom: isKeyboardShowing(context) ? 0 : SizeConfig.bottomSafeAreaPadding + 12,
                top: 5),
          );
        },
      ),
    );
  }

  void _sendStatement(TransactionListArgument args) {
    DateFormat dateFormat = DateFormat("dd/MM/yyyy");

    if (_dateFrom == null || _dateTo == null) {
      showDialogCustom(context, AssetHelper.icoAuthError, AppTranslate.i18n.dialogTitleNotificationStr.localized,
          AppTranslate.i18n.asFillFullTimeSearchStr.localized,
          button1: renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonCloseStr.localized));
    } else if (TransactionManage().validTime(dateFormat.format(_dateFrom!), dateFormat.format(_dateTo!)) < 0) {
      showDialogCustom(context, AssetHelper.icoAuthError, AppTranslate.i18n.dialogTitleNotificationStr.localized,
          AppTranslate.i18n.asFindTimeInvalidNewStr.localized,
          button1: renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonCloseStr.localized));
      // } else if (TransactionManage().validTime(dateFormat.format(_dateFrom!), dateFormat.format(_dateTo!)) >
      //     (args.transactionType == TransactionType.ONLINE ? 92 : 31)) {
      //   showDialogCustom(
      //       context,
      //       AssetHelper.icoAuthError,
      //       AppTranslate.i18n.dialogTitleNotificationStr.localized,
      //       AppTranslate.i18n.asFindTimeOutOfDateStr.localized
      //           .interpolate({'mouth': args.transactionType == TransactionType.ONLINE ? '3' : '1'}),
      //       button1: renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonCloseStr.localized));
    } else {
      if (transactionType == TransactionType.ONLINE) {
        Navigator.of(context).pushNamed(
          AccountServicesScreen.routeName,
          arguments: AccountServicesArguments(
            accountHistoryListArgument,
            dateFrom: dateFormat.format(_dateFrom!),
            dateTo: dateFormat.format(_dateTo!),
            amountFrom: _amountFromController.text.replaceAll(' ', '').isEmpty
                ? 0
                : double.parse(_amountFromController.text.replaceAll(' ', '')),
            amountTo: _amountToController.text.replaceAll(' ', '').isEmpty
                ? 0
                : double.parse(_amountToController.text.replaceAll(' ', '')),
            memo: _contentController.text,
            accountInfo: args.accountInfo,
            callBack: ({TransactionType? type}) {
              _contentController.text = '';
              _amountFromController.text = '';
              _amountToController.text = '';
              _dateFrom = null;
              _dateTo = null;
              _valueOption = 0;
              updateDateRange(0);
              _fileName = _listFile[_selectedFileName].data;
              transactionType = type ?? TransactionType.OFFLINE;
              setState(() {});
            },
          ),
        );
      } else {
        context.read<AccountInfoBloc>().add(AccountInfoEventSendStatement(
              fileType: _fileName ?? '',
              fromDate: dateFormat.format(_dateFrom!),
              toDate: dateFormat.format(_dateTo!),
              accountNumber: args.accountInfo?.accountNumber ?? "",
              fromAmount: double.parse(_amountFromController.text.replaceAll(' ', '').isEmpty
                  ? "0"
                  : _amountFromController.text.replaceAll(' ', '')),
              toAmount: double.parse(_amountToController.text.replaceAll(' ', '').isEmpty
                  ? "0"
                  : _amountToController.text.replaceAll(' ', '')),
              memo: _contentController.text,
            ));
      }
    }
  }
}
