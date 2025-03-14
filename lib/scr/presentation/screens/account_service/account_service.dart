import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/account_service/statement_online/statement_online_bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/data/model/account_service/account_model.dart';
import 'package:b2b/scr/data/model/account_services_arguments.dart';
import 'package:b2b/scr/data/model/as_statement_online_model.dart';
import 'package:b2b/scr/data/model/as_statement_online_response_model.dart';
import 'package:b2b/scr/data/model/as_transaction_history_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/send_statements_screen.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/state_builder.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:configurable_expansion_tile_null_safety/configurable_expansion_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';

class AccountServicesScreen extends StatefulWidget {
  const AccountServicesScreen({Key? key}) : super(key: key);
  static const String routeName = 'account_history_list_screen';

  @override
  _AccountServicesScreenState createState() => _AccountServicesScreenState();
}

class _AccountServicesScreenState extends State<AccountServicesScreen> {
  late AccountServiceScreenType _accountServiceScreenType;
  late AccountServicesArguments args;
  late String _headerTitle = '';
  late String _headerDescription = '';

  late String _accountNumber = '';

  late String _surplus = '';
  late String _availableBalances = '';
  late String _cardIDNumber = '';
  late String _address = '';
  late String _accountType = '';
  late String _branch = '';
  late String _date = '';

  //type = savingAccountDetailArgument
  late String _azInitRate = '';
  late String _azTerm = '';
  late String _azOpenedDate = '';
  late String _azExpriedDate = '';

  AccountInfo? _accountModel;

  // final StateHandler _stateHandler = StateHandler(AccountServicesScreen.routeName);
  final List<AccountServiceStatementOnlineModel> statementOnlineList = [];

  DateFormat transactionDateFormat = DateFormat('dd/MM/yyyy');
  DateFormat transactionTitleFormat = DateFormat('d MMM - yyyy');
  DateFormat transactionTimeFormat = DateFormat('HH:mm');
  NumberFormat numberFormat = NumberFormat('#,###,000');

  final List<Widget> _listSavings = [];
  final List<Widget> _listDetails = [];

  late StatementOnlineBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<StatementOnlineBloc>(context);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  _setupScreen() {
    args = ModalRoute.of(context)!.settings.arguments as AccountServicesArguments;
    if (args.screenType == accountDetailArgument) {
      _accountServiceScreenType = AccountServiceScreenType.AccountDetail;
      _headerTitle = AppTranslate.i18n.profileTitleAccountInformationStr.localized.toUpperCase();
    } else if (args.screenType == savingAccountDetailArgument) {
      _accountServiceScreenType = AccountServiceScreenType.SavingAccountDetail;
      _headerTitle = AppTranslate.i18n.profileTitleAccountInformationStr.localized.toUpperCase();
    } else if (args.screenType == accountHistoryListArgument) {
      _accountServiceScreenType = AccountServiceScreenType.AccountHistoryList;
      _headerTitle = AppTranslate.i18n.transactionListStr.localized.toUpperCase();
      _headerDescription = 'Priority Business Account  (VND)';
    }
  }

  _setData() {
    final args = ModalRoute.of(context)!.settings.arguments as AccountServicesArguments;
    if (args.accountInfo != null) {
      _accountModel = args.accountInfo;
      _headerDescription = SessionManager().userData?.customer?.custName ?? AppTranslate.i18n.updatingStr.localized;
      _accountNumber = _accountModel?.accountNumber ?? AppTranslate.i18n.updatingStr.localized;

      _azInitRate = _accountModel?.azInitRate == null
          ? AppTranslate.i18n.updatingStr.localized
          : AppTranslate.i18n.yearStr.localized.interpolate({'value': _accountModel?.azInitRate});
      String azTerm = _accountModel?.azTerm ?? AppTranslate.i18n.updatingStr.localized;
      _azTerm = azTerm.formatDateString;
      _azOpenedDate = (_accountModel?.openedDate?.length ?? 0) >= 8
          ? (_accountModel?.openedDate?.toDateString ?? AppTranslate.i18n.updatingStr.localized)
          : (_accountModel?.openedDate ?? AppTranslate.i18n.updatingStr.localized);
      _azExpriedDate = (_accountModel?.azExpriedDate?.length ?? 0) >= 8
          ? (_accountModel?.azExpriedDate?.toDateString ?? AppTranslate.i18n.updatingStr.localized)
          : (_accountModel?.azExpriedDate ?? AppTranslate.i18n.updatingStr.localized);

      String workingBalance = TransactionManage()
          .formatCurrency(_accountModel?.workingBalance ?? 0, _accountModel?.accountCurrency ?? 'VND');
      String availableBalance = TransactionManage()
          .formatCurrency(_accountModel?.availableBalance ?? 0, _accountModel?.accountCurrency ?? 'VND');
      _surplus = '$workingBalance ${_accountModel?.accountCurrency ?? AppTranslate.i18n.updatingStr.localized}';
      _availableBalances =
          '$availableBalance ${_accountModel?.accountCurrency ?? AppTranslate.i18n.updatingStr.localized}';
      _cardIDNumber = SessionManager().userData?.customer?.custLegalId ?? AppTranslate.i18n.updatingStr.localized;
      _address = SessionManager().userData?.customer?.custAddress ?? AppTranslate.i18n.updatingStr.localized;
      _accountType = args.accountType ?? AppTranslate.i18n.updatingStr.localized;
      _branch = _accountModel?.branchName ?? AppTranslate.i18n.updatingStr.localized;
      _date = (_accountModel?.openedDate?.length ?? 0) >= 8
          ? (_accountModel?.openedDate?.toDateString ?? AppTranslate.i18n.updatingStr.localized)
          : (_accountModel?.openedDate ?? AppTranslate.i18n.updatingStr.localized);
    }

    if (args.screenType == accountHistoryListArgument) {
      _bloc.add(StatementOnlineEventGetTransactionHistory(
          fromDate: args.dateFrom ?? "",
          toDate: args.dateTo ?? "",
          accountNumber: args.accountInfo?.accountNumber ?? "",
          fromAmount: args.amountFrom ?? 0,
          toAmount: args.amountTo ?? 0,
          memo: args.memo ?? ""));
    }
  }

  void _initScreenType() {
    if (_accountServiceScreenType == AccountServiceScreenType.SavingAccountDetail && _listSavings.isEmpty) {
      _listSavings.addAll([
        _accountInfo(AssetHelper.icoSurplus, AppTranslate.i18n.titleDepositsStr.localized, _availableBalances),
        _accountInfo(
            AssetHelper.icoArrowUpdown, AppTranslate.i18n.firstLoginTitleInterestRateStr.localized, _azInitRate),
        _accountInfo(AssetHelper.icoOpenDate, AppTranslate.i18n.savingTitlePeriodStr.localized, _azTerm),
        _accountInfo(AssetHelper.icoOpenDate, AppTranslate.i18n.titleOpenExpriedDateStr.localized, _azOpenedDate),
        _accountInfo(AssetHelper.icoOpenDate, AppTranslate.i18n.titleExpriedDateStr.localized, _azExpriedDate),
        _accountInfo(AssetHelper.icoOpenBranch, AppTranslate.i18n.titleTypeDepositsStr.localized, _accountType),
        _accountInfo(AssetHelper.icoAddress, AppTranslate.i18n.titleDepositsBranchStr.localized, _branch),
        _accountInfo(AssetHelper.icoAddress, AppTranslate.i18n.titleAddressStr.localized, _address),
      ]);
    } else if (_listDetails.isEmpty) {
      _listDetails.addAll([
        _accountInfo(AssetHelper.icoSurplus, AppTranslate.i18n.asSurplusStr.localized, _surplus),
        _accountInfo(
            AssetHelper.icoArrowUpdown, AppTranslate.i18n.asAvailableBalancesStr.localized, _availableBalances),
        _accountInfo(AssetHelper.icoAccountType, AppTranslate.i18n.titleAccountTypeStr.localized, _accountType),
        // _accountInfo(AssetHelper.icoRegistedId, AppTranslate.i18n.asIdNumberStr.localized, _cardIDNumber),
        _accountInfo(AssetHelper.icoOpenDate, AppTranslate.i18n.titleOpenDateStr.localized, _date),
        _accountInfo(AssetHelper.icoOpenBranch, AppTranslate.i18n.titleOpenBranchStr.localized, _branch),
        _accountInfo(AssetHelper.icoAddress, AppTranslate.i18n.titleAddressStr.localized, _address),
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    _setupScreen();
    _setData();
    _initScreenType();
    return AppBarContainer(
      title: _headerTitle,
      appBarType: AppBarType.MEDIUM,
      child: BlocConsumer<StatementOnlineBloc, StatementOnlineState>(
        listenWhen: (previous, current) => previous.statementState != current.statementState,
        listener: (context, state) {
          if (state.statementState == DataState.preload) {
            showLoading();
          } else if (state.statementState == DataState.data) {
            hideLoading();
            if (_bloc.state.statementOnlineResponse?.result.code == '998') {
              showDialogCustom(
                context,
                AssetHelper.icoStatementComplate,
                AppTranslate.i18n.dialogTitleNotificationStr.localized,
                _bloc.state.statementOnlineResponse?.result.getMessage() ?? '',
                button1: renderDialogTextButton(
                  context: context,
                  title: AppTranslate.i18n.asSendStatementEmailStr.localized,
                  dismiss: true,
                  textStyle: TextStyles.normalText.copyWith(color: AppColors.gPrimaryColor),
                  onTap: () {
                    args.callBack?.call(type: TransactionType.OFFLINE);
                    popScreen(context);
                  },
                ),
                onClose: () {
                  popScreen(context);
                },
                barrierDismissible: false,
              );
            }
          } else {
            hideLoading();
            if (state.isRequestTimeOut ?? false) {
              showDialogCustom(
                context,
                AssetHelper.icoStatementComplate,
                AppTranslate.i18n.dialogTitleNotificationStr.localized,
                AppTranslate.i18n.titleOutOfRequestTransactionStr.localized,
                button1:
                    renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonCancelStr.localized),
                button2: renderDialogTextButton(
                  context: context,
                  title: AppTranslate.i18n.containerItemContinueStr.localized,
                  dismiss: true,
                  onTap: () {
                    args.callBack?.call();
                    Navigator.of(context).pop();
                  },
                ),
              );
            }
          }
        },
        builder: (context, state) {
          return Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: kDefaultPadding * 2, right: kDefaultPadding * 2, top: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 10),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text(
                            _accountNumber,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                height: 1.4,
                                letterSpacing: getInScreenSize(4),
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            child: Text(
                              _headerDescription,
                              style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                              textAlign: TextAlign.center,
                            ),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                        ]),
                      ),
                    ),
                    Touchable(
                      onTap: () {
                        showToast('Copied account $_accountNumber');
                        Clipboard.setData(ClipboardData(text: _accountNumber));
                      },
                      child: Icon(
                        Icons.copy,
                        color: Colors.white,
                        size: getInScreenSize(20),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: (_accountServiceScreenType == AccountServiceScreenType.AccountDetail) ? 12 : 24,
              ),
              _accountServiceScreenType == AccountServiceScreenType.AccountDetail
                  ? Container(
                      margin: const EdgeInsets.only(bottom: 25, left: kDefaultPadding, right: kDefaultPadding),
                      padding: const EdgeInsets.only(
                          top: 20, bottom: kMediumPadding, left: kDefaultPadding, right: kDefaultPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(4, 8), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Text(
                            AppTranslate.i18n.accountToolsStr.localized,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: getInScreenSize(12),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Touchable(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(TransactionListScreen.routeName,
                                          arguments: TransactionListArgument(
                                              accountInfo: _accountModel, transactionType: TransactionType.ONLINE));
                                    },
                                    child: Container(
                                      width: getInScreenSize(43),
                                      height: getInScreenSize(43),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black.withOpacity(0.25)),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          AssetHelper.icoAsTransactionList,
                                          width: getInScreenSize(20),
                                          height: getInScreenSize(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getInScreenSize(10),
                                  ),
                                  Text(
                                    AppTranslate.i18n.onlineStatementStr.localized,
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.65),
                                      fontSize: 13,
                                    ),
                                  )
                                ],
                              ),
                              Container(
                                width: getInScreenSize(
                                  1,
                                ),
                                height: getInScreenSize(42),
                                color: const Color(0xffc7cedf),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Touchable(
                                    onTap: () {
                                      Navigator.of(context).pushNamed(TransactionListScreen.routeName,
                                          arguments: TransactionListArgument(
                                              accountInfo: _accountModel, transactionType: TransactionType.OFFLINE));
                                    },
                                    child: Container(
                                      width: getInScreenSize(43),
                                      height: getInScreenSize(43),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black.withOpacity(0.25)),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Image.asset(
                                          AssetHelper.icoAsSendToMail,
                                          width: getInScreenSize(20),
                                          height: getInScreenSize(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: getInScreenSize(10),
                                  ),
                                  Text(
                                    AppTranslate.i18n.sendEmailOfflineStatementStr.localized,
                                    style: TextStyle(
                                      color: Colors.black.withOpacity(0.65),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(bottom: kDefaultPadding, left: kDefaultPadding, right: kDefaultPadding),
                  height: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(4, 8), // changes position of shadow
                      ),
                    ],
                  ),
                  child: _accountServiceScreenType == AccountServiceScreenType.AccountHistoryList
                      ? _transactionHistoryList()
                      : Padding(
                          padding: EdgeInsets.all(getInScreenSize(8)),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(
                                getInScreenSize(12),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(bottom: getInScreenSize(8)),
                                    child: Text(
                                      AppTranslate.i18n.profileTitleAccountInformationStr.localized,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Column(
                                      children:
                                          _accountServiceScreenType == AccountServiceScreenType.SavingAccountDetail
                                              ? _listSavings
                                              : _listDetails),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  _convertStmtDataToTransactionHistory(List<StmtData> stmtData) {
    statementOnlineList.clear();
    for (StmtData data in stmtData) {
      DateTime? tempDate;
      String title = '';
      String time = '';
      try {
        tempDate = DateFormat("dd/MM/yyyy hh:mm").parse(data.commitTime ?? '');
        title = transactionTitleFormat.format(tempDate);
        time = transactionTimeFormat.format(tempDate);
      } catch (_) {}
      if (statementOnlineList.isNotEmpty && statementOnlineList.last.date == title) {
        statementOnlineList.last.transactionHistoryList.add(
          AccountServiceTransactionHistoryModel(
              code: data.stmtId ?? '',
              transactionTime: time,
              destinationAccountName: '',
              destinationAccountNumber: data.txnAcctId ?? '',
              amount: TransactionManage().tryFormatCurrency(
                data.txnCcy == 'VND' ? data.txnAmtLcy : data.txnAmtFcy,
                data.txnCcy,
              ),
              currentBalance: TransactionManage().tryFormatCurrency(
                data.currBalance,
                data.txnCcy,
              ),
              currency: data.txnCcy ?? '',
              transactionnote: data.txnNarrative),
        );
      } else {
        AccountServiceStatementOnlineModel accountServiceStatementOnlineModel = AccountServiceStatementOnlineModel(
          title,
          <AccountServiceTransactionHistoryModel>[
            AccountServiceTransactionHistoryModel(
                code: data.stmtId ?? '',
                transactionTime: time,
                destinationAccountName: '',
                destinationAccountNumber: data.txnAcctId ?? '',
                currentBalance: TransactionManage().tryFormatCurrency(
                  data.currBalance,
                  data.txnCcy,
                ),
                amount: TransactionManage().tryFormatCurrency(
                  data.txnCcy == 'VND' ? data.txnAmtLcy : data.txnAmtFcy,
                  data.txnCcy,
                ),
                currency: data.txnCcy ?? '',
                transactionnote: data.txnNarrative),
          ],
        );
        statementOnlineList.add(accountServiceStatementOnlineModel);
      }
    }
  }

  Widget _transactionHistoryList() {
    if (_bloc.state.statementOnlineResponse != null) {
      Logger.debug(
        'code: ${_bloc.state.statementOnlineResponse!.result.code}, state: ${_bloc.state.statementState}',
      );
    }

    // lớn hơn 1000 giao dịch thì hiện dialog gửi sao kê về qua Email
    if (_bloc.state.statementOnlineResponse?.result.code == '998') {
      return const SizedBox();
    }
    late Widget widget = const SizedBox();
    if (_bloc.state.statementState == DataState.preload) {
      widget = const SizedBox();
    } else if (_bloc.state.statementState == DataState.data) {
      if (_bloc.state.statementOnlineResponse!.result.code == '200') {
        StatementOnlineResponse response = _bloc.state.statementOnlineResponse!;
        var stmtData = response.data.stmtData ?? [];
        if (stmtData.isNotEmpty) {
          _convertStmtDataToTransactionHistory(stmtData);
          widget = Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: getInScreenSize(16), vertical: getInScreenSize(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppTranslate.i18n.titleBalanceFluctuationsContentStr.localized,
                      textAlign: TextAlign.start,
                      style: const TextStyle(color: Color(0xff666667), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      AppTranslate.i18n.titleBalanceAfterTransactionsStr.localized,
                      textAlign: TextAlign.end,
                      style: const TextStyle(color: Color(0xff666667), fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(top: 0),
                  itemBuilder: (BuildContext context, int index) =>
                      _transactionExpansionTile(statementOnlineList[index]),
                  itemCount: statementOnlineList.length,
                ),
              ),
            ],
          );
        } else {
          widget = Center(
            child: Padding(
              padding: EdgeInsets.all(getInScreenSize(24)),
              child: Text(
                AppTranslate.i18n.titleErrorNoDataStr.localized,
                textAlign: TextAlign.center,
                style: kStyleTitleText,
              ),
            ),
          );
        }
      } else if (_bloc.state.statementOnlineResponse!.result.code == '0') {
        widget = Center(
          child: Padding(
            padding: EdgeInsets.all(getInScreenSize(24)),
            child: Html(
              data: context.read<StatementOnlineBloc>().state.statementOnlineResponse!.result.getMessage(),
            ),
          ),
        );
      }
    } else if (_bloc.state.statementState == DataState.error) {
      Logger.debug('Error ${_bloc.state.statementState}');
      widget = const SizedBox();
    } else {
      widget = const SizedBox();
    }
    return widget;
  }

  Widget _transactionExpansionTile(AccountServiceStatementOnlineModel statementOnlineModel) {
    return StateBuilder(
        builder: () => ConfigurableExpansionTile(
              animatedWidgetFollowingHeader: Padding(
                padding: EdgeInsets.symmetric(horizontal: getInScreenSize(8)),
                child: const Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: Color(0xff666667),
                ),
              ),
              headerBackgroundColorStart: const Color.fromRGBO(230, 246, 237, 1.0),
              headerBackgroundColorEnd: const Color.fromRGBO(230, 246, 237, 1.0),
              header: Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          _transactionDate(statementOnlineModel.date),
                          style: const TextStyle(
                            color: Color(0xff343434),
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  height: getInScreenSize(24),
                  color: const Color.fromRGBO(230, 246, 237, 1.0),
                ),
              ),
              initiallyExpanded: true,
              children: _transactionTile(statementOnlineModel),
            ),
        routeName: AccountServicesScreen.routeName);
  }

  List<Widget> _transactionTile(AccountServiceStatementOnlineModel model) {
    List<AccountServiceTransactionHistoryModel> transactionList = model.transactionHistoryList;
    List<IntrinsicHeight> containerList = <IntrinsicHeight>[];
    for (var item in transactionList) {
      bool isLastIndex = transactionList.indexOf(item) == (transactionList.length - 1);
      IntrinsicHeight transactionContainer = IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: getInScreenSize(16)),
          child: Row(
            children: [
              Container(
                width: getInScreenSize(40),
                height: getInScreenSize(40),
                decoration: const BoxDecoration(color: Color(0xfff5f7fa), shape: BoxShape.circle),
                alignment: Alignment.center,
                child: Text(
                  item.transactionTime,
                  style: const TextStyle(color: Color(0xff666667), fontSize: 12, fontWeight: FontWeight.normal),
                ),
              ),
              SizedBox(
                width: getInScreenSize(16),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: getInScreenSize(16)),
                  decoration: isLastIndex
                      ? const BoxDecoration()
                      : const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 0.5, color: kColorDivider),
                          ),
                        ),
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: _transactionAmount(
                              item.amount,
                              item.currency,
                            ),
                          ),
                          const Expanded(child: SizedBox()),
                          Expanded(
                            flex: 5,
                            child: Text(
                              '${item.currentBalance} ${item.currency}',
                              textAlign: TextAlign.end,
                              maxLines: 1,
                              style: const TextStyle(
                                  color: Color(0xff666667), fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: getInScreenSize(8),
                      ),
                      Flexible(
                        child: Text(
                          // transactionMessage,
                          '${item.transactionnote}',
                          textAlign: TextAlign.left,
                          style: const TextStyle(color: Color(0xff666667), fontSize: 12, fontWeight: FontWeight.normal),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      containerList.add(transactionContainer);
    }
    return containerList;
  }

  String transactionMessage =
      'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et';

  String _transactionDate(String date) {
    try {
      DateTime tempDate = DateFormat("dd MMM - yyyy").parse(date);
      String dateFormatted = transactionDateFormat.format(tempDate);
      return dateFormatted;
    } catch (e) {
      return date;
    }
  }

  Text _transactionAmount(String amount, String currency) {
    Color textColor;
    String amountText;
    if (amount.startsWith('-')) {
      textColor = const Color(0xffff6763);
      amountText = '$amount $currency';
    } else {
      textColor = const Color(0xff00b74f);
      amountText = '+$amount $currency';
    }
    return Text(
      amountText,
      textAlign: TextAlign.start,
      // maxLines: 1,
      style: TextStyle(color: textColor, fontSize: 13, fontWeight: FontWeight.normal),
    );
  }

  Widget _accountInfo(String icon, String title, String data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                icon,
                width: 16.0,
                height: 16.0,
              ),
              const SizedBox(
                width: 14.0,
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyles.itemText.slateGreyColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6.0),
          Row(
            children: [
              const SizedBox(
                width: 30.0,
              ),
              Expanded(
                child: Text(
                  data,
                  style: TextStyles.itemText.semibold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

enum AccountServiceScreenType { AccountDetail, SavingAccountDetail, AccountHistoryList }
