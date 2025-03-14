import 'package:b2b/scr/bloc/account_service/account_info/account_info_bloc.dart';
import 'package:b2b/scr/bloc/account_service/statement_online/statement_online_bloc.dart';
import 'package:b2b/scr/bloc/auth/change_password/change_password_bloc.dart';
import 'package:b2b/scr/bloc/bloc.dart';
import 'package:b2b/scr/bloc/deposits/open_online_deposits_bloc.dart';
import 'package:b2b/scr/bloc/loan/loan_list/loan_list_bloc.dart';
import 'package:b2b/scr/bloc/notification/notification_bloc.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/routes/argument/search_argument.dart';
import 'package:b2b/scr/core/routes/argument/transfer_screen_argument.dart';
import 'package:b2b/scr/core/routes/transparent_route.dart';
import 'package:b2b/scr/data/model/bill/bill_saved.dart';
import 'package:b2b/scr/data/repository/account_info_repository.dart';
import 'package:b2b/scr/data/repository/authen_repository.dart';
import 'package:b2b/scr/data/repository/exchange_rate_repository.dart';
import 'package:b2b/scr/data/repository/notification_repository.dart';
import 'package:b2b/scr/data/repository/notification_setting_repository.dart';
import 'package:b2b/scr/data/repository/rollover_term_saving_repository.dart';
import 'package:b2b/scr/data/repository/transfer_repository.dart';
import 'package:b2b/scr/example_presentation/first_page.dart';
import 'package:b2b/scr/example_presentation/intro/intro_screen.dart';
import 'package:b2b/scr/example_presentation/second_page.dart';
import 'package:b2b/scr/presentation/screens/account_service/account_list_screen.dart';
import 'package:b2b/scr/presentation/screens/account_service/account_service.dart';
import 'package:b2b/scr/presentation/screens/account_service/send_statements_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/account_manage_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/auth_otp_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/biometric_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/first_login_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/pin_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/re_login_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/verify_user_screen.dart';
import 'package:b2b/scr/presentation/screens/beneficiary/beneficiary_screen.dart';
import 'package:b2b/scr/presentation/screens/bill/bill_screen.dart';
import 'package:b2b/scr/presentation/screens/bill/electric/electric_confirm_payment_screen.dart';
import 'package:b2b/scr/presentation/screens/bill/electric/electric_payment_result_screen.dart';
import 'package:b2b/scr/presentation/screens/bill/electric/payment_electric_screen.dart';
import 'package:b2b/scr/presentation/screens/bill/electric/search_bill_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/card_detail/card_detail_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/card_history/card_history_result_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/card_history/card_history_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/card_info/card_info_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/card_list/card_list_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/card_list/card_menu_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/card_statement/card_statement_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/payment/payment_card_confirm_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/payment/payment_card_result_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/payment/payment_card_screen.dart';
import 'package:b2b/scr/presentation/screens/commerece/comerce_screen.dart';
import 'package:b2b/scr/presentation/screens/commerece/commerce_detail_screen.dart';
import 'package:b2b/scr/presentation/screens/commerece/commerce_documents_detail_screen.dart';
import 'package:b2b/scr/presentation/screens/commerece/commerce_list_screen.dart';
import 'package:b2b/scr/presentation/screens/confirm_infomation/confirm_information_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/confirm_open_deposits_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/current_deposits/current_deposit_detail_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/current_deposits/current_deposit_settlement_confirm_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/current_deposits/current_deposit_settlement_result_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/current_deposits/current_deposit_settlement_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/current_deposits/current_deposits_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/deposits_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/open_deposits_input_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/open_deposits_result_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/open_online_deposits_screen.dart';
import 'package:b2b/scr/presentation/screens/exchange_rate_screen.dart';
import 'package:b2b/scr/presentation/screens/find_atm_screen.dart';
import 'package:b2b/scr/presentation/screens/loan/loan_history/loan_history_screen.dart';
import 'package:b2b/scr/presentation/screens/loan/loan_info_screen.dart';
import 'package:b2b/scr/presentation/screens/loan/loan_list_screen.dart';
import 'package:b2b/scr/presentation/screens/log_screen.dart';
import 'package:b2b/scr/presentation/screens/main/list_second_home_screen.dart';
import 'package:b2b/scr/presentation/screens/main/main_screen.dart';
import 'package:b2b/scr/presentation/screens/normal_search_screen.dart';
import 'package:b2b/scr/presentation/screens/notification/notification_screen.dart';
import 'package:b2b/scr/presentation/screens/notification/setting/list_account_setting_screen.dart';
import 'package:b2b/scr/presentation/screens/notification/setting/setting_notification_screen.dart';
import 'package:b2b/scr/presentation/screens/profile/profile_screen.dart';
import 'package:b2b/scr/presentation/screens/qr_code_screen.dart';
import 'package:b2b/scr/presentation/screens/saving/saving_screen.dart';
import 'package:b2b/scr/presentation/screens/settings/change_otp_method_screen.dart';
import 'package:b2b/scr/presentation/screens/settings/change_password_screen.dart';
import 'package:b2b/scr/presentation/screens/settings/settings_screen.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/setup_otp_screen.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/smart_otp_active_screen.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/smart_otp_intro_screen.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/smart_otp_list_screen.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/smart_otp_screen.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:b2b/scr/presentation/screens/splash_screen.dart';
import 'package:b2b/scr/presentation/screens/tax/confirm_tax_screen.dart';
import 'package:b2b/scr/presentation/screens/tax/result_register_tax_screen.dart';
import 'package:b2b/scr/presentation/screens/tax/tax_list_screen.dart';
import 'package:b2b/scr/presentation/screens/term/term_screen.dart';
import 'package:b2b/scr/presentation/screens/test_page.dart';
import 'package:b2b/scr/presentation/screens/transaction/transaction_detail.dart';
import 'package:b2b/scr/presentation/screens/transaction/transaction_inquiry_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction/transaction_list_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/bill_approve/bill_approve_result_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/bill_approve/bill_approve_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/payroll_approve/payroll_approve_result_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/payroll_approve/payroll_approve_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/payroll_approve/payroll_approve_recipient_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/saving_approve/saving_transaction_approve_contract_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/saving_approve/saving_transaction_approve_result_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/saving_approve/saving_transaction_approve_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/tax_approve/tax_approve_contract_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/tax_approve/tax_approve_detail_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/tax_approve/tax_approve_result_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_approve/transaction_approve_detail_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_approve/transaction_approve_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_approve_result_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_management_screen.dart';
import 'package:b2b/scr/presentation/screens/transfer/confirm_transfer_screen.dart';
import 'package:b2b/scr/presentation/screens/transfer/list_account_transfer_saved_screen.dart';
import 'package:b2b/scr/presentation/screens/transfer/list_bank_available_screen.dart';
import 'package:b2b/scr/presentation/screens/transfer/transfer_input/transfer_input_screen.dart';
import 'package:b2b/scr/presentation/screens/transfer/transfer_result.dart';
import 'package:b2b/scr/presentation/screens/transfer/transfer_screen.dart';
import 'package:b2b/scr/presentation/screens/webview_screen.dart';
import 'package:b2b/utilities/animation_helper/animationhelper_scene.dart';
import 'package:b2b/utilities/candlestick/candlesstick_scene.dart';
import 'package:b2b/utilities/image_helper/imagehelper_scene.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper_scene.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../presentation/screens/bill/bill_provider_screen.dart';
import '../../presentation/screens/tax/create_tax_screen.dart';
import '../../presentation/screens/tax/tax_screen.dart';

final Map<String, WidgetBuilder> routes = {
  FirstPage.routeName: (context) => const FirstPage(),
  TestPage.routeName: (context) => const TestPage(),
  ImageHelperScene.routeName: (context) => const ImageHelperScene(),
  LocalStorageHelperScene.routeName: (context) =>
      const LocalStorageHelperScene(),
  MainScreen.routeName: (context) => const MainScreen(),
  LogScreen.routeName: (context) => const LogScreen(),
  AnimationHelperScene.routeName: (context) => const AnimationHelperScene(),
  CandlesStickScene.ruoteName: (context) => const CandlesStickScene(),
  IntroScreen.routeName: (context) => const IntroScreen(),
  SplashScreen.routeName: (context) => const SplashScreen(),
  FirstLoginScreen.routeName: (context) => const FirstLoginScreen(),
  ReLoginScreen.routeName: (context) => const ReLoginScreen(),
  AuthOTPScreen.routeName: (context) => const AuthOTPScreen(),
  SmartOTPScreen.routeName: (context) => const SmartOTPScreen(),
  SmartOTPIntroScreen.routeName: (context) => const SmartOTPIntroScreen(),
  SmartOTPListScreen.routeName: (context) => const SmartOTPListScreen(),
  SmartOTPActiveScreen.routeName: (context) => const SmartOTPActiveScreen(),
  PINScreen.routeName: (context) => const PINScreen(),
  BiometricScreen.routeName: (context) => const BiometricScreen(),
  QRCodeScreen.routeName: (context) => const QRCodeScreen(),
  VerifyOTPScreen.routeName: (context) => const VerifyOTPScreen(),
  FindATMScreen.routeName: (context) => const FindATMScreen(),
  ReLoginUserScreen.routeName: (context) => const ReLoginUserScreen(),
  ListAccountSettingScreen.routeName: (context) =>
      const ListAccountSettingScreen(),
  SettingNotificationScreen.routeName: (context) =>
      RepositoryProvider<NotificationSettingImpl>(
        create: (context) => NotificationSettingImpl(
          apiProvider:
              RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
        ),
        child: BlocProvider<NotificationBloc>(
          create: (context) => NotificationBloc(
            notificationSettingRepository: context.read(),
          ),
          child: const SettingNotificationScreen(),
        ),
      ),
  // SettingNotificationScreen.routeName: (context) => const SettingNotificationScreen(),
  TransferScreen.routeName: (context) =>
      RepositoryProvider<TransferRepositoryImpl>(
        create: (context) => TransferRepositoryImpl(
          apiProvider:
              RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
        ),
        child: BlocProvider<TransferBloc>(
          create: (context) => TransferBloc(
            transferRepositoryImpl: context.read(),
          ),
          child: const TransferScreen(),
        ),
      ),
  ConfirmInformationScreen.routeName: (context) =>
      const ConfirmInformationScreen(),
  ProfileScreen.routeName: (context) => const ProfileScreen(),
  WebViewScreen.routeName: (context) => const WebViewScreen(),
  TermScreen.routeName: (context) => const TermScreen(),
  SetupOtpScreen.routeName: (context) => const SetupOtpScreen(),
  BeneficiaryScreen.routeName: (context) => const BeneficiaryScreen(),
  TransactionListScreen.routeName: (context) =>
      RepositoryProvider<AccountInfoRepositoryImpl>(
        create: (context) => AccountInfoRepositoryImpl(
            apiProvider:
                RepositoryProvider.of<ApiProviderRepositoryImpl>(context)),
        lazy: false,
        child: BlocProvider<AccountInfoBloc>(
          create: (c) => AccountInfoBloc(accountInfoRepository: c.read()),
          child: const TransactionListScreen(),
          lazy: false,
        ),
      ),
  AccountListScreen.routeName: (context) =>
      RepositoryProvider<AccountInfoRepositoryImpl>(
        create: (context) => AccountInfoRepositoryImpl(
          apiProvider:
              RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
        ),
        lazy: false,
        child: BlocProvider<AccountInfoBloc>(
          create: (c) => AccountInfoBloc(accountInfoRepository: c.read())
            ..add(AccountInfoEventGetAccountList()),
          child: const AccountListScreen(),
          lazy: false,
        ),
      ),
  RolloverTermSavingScreen.routeName: (context) =>
      RepositoryProvider<RolloverTermSavingRepositoryImpl>(
        create: (context) => RolloverTermSavingRepositoryImpl(
          apiProvider:
              RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
        ),
        lazy: false,
        child: BlocProvider<RolloverTermSavingBloc>(
          create: (c) =>
              RolloverTermSavingBloc(savingPeriodRepositoryImpl: c.read())
                ..add(GetSavingPeriodEvent()),
          child: const RolloverTermSavingScreen(),
          lazy: false,
        ),
      ),
  AccountManageScreen.routeName: (context) => const AccountManageScreen(),
  ListSecondHomeScreen.routeName: (context) => const ListSecondHomeScreen(),
  ListAccountTransferSaved.routeName: (context) => ListAccountTransferSaved(),
  ListBankAvailable.routeName: (context) => const ListBankAvailable(),
  AccountServicesScreen.routeName: (context) =>
      RepositoryProvider<AccountInfoRepositoryImpl>(
        create: (context) => AccountInfoRepositoryImpl(
            apiProvider:
                RepositoryProvider.of<ApiProviderRepositoryImpl>(context)),
        lazy: false,
        child: BlocProvider<StatementOnlineBloc>(
          create: (c) => StatementOnlineBloc(accountInfoRepository: c.read()),
          child: const AccountServicesScreen(),
          lazy: false,
        ),
      ),
  // AccountHistoryDetailScreen.routeName: (context) => const AccountHistoryDetailScreen(),
  ExchangeRateScreen.routeName: (context) =>
      RepositoryProvider<ExchangeRateRepositoryImpl>(
        create: (context) => ExchangeRateRepositoryImpl(
          apiProvider:
              RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
        ),
        child: BlocProvider<ExchangeRateBloc>(
          create: (context) => ExchangeRateBloc(
            exchangeRateRepositoryImpl: context.read(),
          ),
          child: const ExchangeRateScreen(),
        ),
      ),
  ChangeOTPMethodScreen.routeName: (context) => const ChangeOTPMethodScreen(),
  ChangePasswordScreen.routeName: (context) =>
      RepositoryProvider<AuthenRepositoryImpl>(
        create: (context) => AuthenRepositoryImpl(
          apiProvider:
              RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
        ),
        child: BlocProvider<ChangePasswordBloc>(
          create: (context) => ChangePasswordBloc(
            authenRepository: context.read(),
          ),
          child: const ChangePasswordScreen(),
        ),
      ),
  TransactionInquiryScreen.routeName: (context) =>
      const TransactionInquiryScreen(),
  TransactionInquiryListScreen.routeName: (context) =>
      const TransactionInquiryListScreen(),
  TransactionInquiryDetailScreen.routeName: (context) =>
      const TransactionInquiryDetailScreen(),
  SettingsScreen.routeName: (context) => const SettingsScreen(),
  TransactionApproveDetailScreen.routeName: (context) =>
      const TransactionApproveDetailScreen(),
  TransactionApproveScreen.routeName: (context) =>
      const TransactionApproveScreen(),
  TransactionApproveResultScreen.routeName: (context) =>
      const TransactionApproveResultScreen(),
  DepositsScreen.routeName: (context) => const DepositsScreen(),
  OpenOnlineDepositsScreen.routeName: (context) =>
      const OpenOnlineDepositsScreen(),
  CurrentDepositsScreen.routeName: (context) => const CurrentDepositsScreen(),
  CurrentDepositSettlementScreen.routeName: (context) =>
      const CurrentDepositSettlementScreen(),
  CurrentDepositSettlementConfirmScreen.routeName: (context) =>
      const CurrentDepositSettlementConfirmScreen(),
  CurrentDepositSettlementResultScreen.routeName: (context) =>
      const CurrentDepositSettlementResultScreen(),
  CurrentDepositDetailScreen.routeName: (context) =>
      const CurrentDepositDetailScreen(),
  TransactionManageScreen.routeName: (context) =>
      const TransactionManageScreen(),
  SavingTransactionApproveScreen.routeName: (context) =>
      const SavingTransactionApproveScreen(),
  SavingTransactionApproveContractScreen.routeName: (context) =>
      const SavingTransactionApproveContractScreen(),
  SavingTransactionApproveResultScreen.routeName: (context) =>
      const SavingTransactionApproveResultScreen(),
  PayrollApproveScreen.routeName: (context) => const PayrollApproveScreen(),
  PayrollApproveRecipientListScreen.routeName: (context) =>
      const PayrollApproveRecipientListScreen(),
  PayrollApproveResultScreen.routeName: (context) =>
      const PayrollApproveResultScreen(),
  CardInfoScreen.routeName: (context) => const CardInfoScreen(),
  CardListScreen.routeName: (context) => const CardListScreen(),
  CardDetailScreen.routeName: (context) => const CardDetailScreen(),
  PaymentCardScreen.routeName: (context) => const PaymentCardScreen(),
  PaymentCardConfirmScreen.routeName: (context) =>
      const PaymentCardConfirmScreen(),
  PaymentCardResultScreen.routeName: (context) =>
      const PaymentCardResultScreen(),
  CardStatementScreen.routeName: (context) => const CardStatementScreen(),
  CardHistoryScreen.routeName: (context) => const CardHistoryScreen(),
  CardHistoryResultScreen.routeName: (context) =>
      const CardHistoryResultScreen(),
  LoanListScreen.routeName: (context) => const LoanListScreen(),
  CardMenuScreen.routeName: (context) => const CardMenuScreen(),
  LoanHistoryScreen.routeName: (context) => const LoanHistoryScreen(),
  CommerceScreen.routeName: (context) => const CommerceScreen(),
  CommerceListScreen.routeName: (context) => const CommerceListScreen(),
  CommerceDetailScreen.routeName: (context) => const CommerceDetailScreen(),
  CommerceDocumentDetailScreen.routeName: (context) =>
      const CommerceDocumentDetailScreen(),
  TaxScreen.routeName: (context) => const TaxScreen(),
  CreateTaxScreen.routeName: (context) => const CreateTaxScreen(),
  ConfirmTaxScreen.routeName: (context) => const ConfirmTaxScreen(),
  TaxDetailScreen.routeName: (context) => const TaxDetailScreen(),
  TaxListScreen.routeName: (context) => const TaxListScreen(),
  ResultRegisterTaxScreen.routeName: (context) =>
      const ResultRegisterTaxScreen(),
  TaxApproveContractScreen.routeName: (context) =>
      const TaxApproveContractScreen(),
  TaxApproveResultScreen.routeName: (context) => const TaxApproveResultScreen(),
  BillScreen.routeName: (context) => const BillScreen(),
  BillProviderScreen.routeName: (context) => const BillProviderScreen(),
  PaymentElectricScreen.routeName: (context) => const PaymentElectricScreen(),
  ElectricConfirmPaymentScreen.routeName: (context) =>
      ElectricConfirmPaymentScreen(),
  ElectricPaymentResultScreen.routeName: (context) =>
      const ElectricPaymentResultScreen(),
  BillApproveScreen.routeName: (context) => const BillApproveScreen(),
  BillApproveResultScreen.routeName: (context) =>
      const BillApproveResultScreen(),
};

// to pass argument to another page, let's define them is here
Route<MaterialPageRoute>? generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case LoanInfoScreen.routeName:
      LoanInfoArg argument = settings.arguments as LoanInfoArg;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<LoanListBloc>(argument.context),
          child: LoanInfoScreen(
            loanListModel: argument.loanListModel,
          ),
        ),
      );
    case SecondPage.routeName:
      return CupertinoPageRoute(
        settings: settings,
        builder: (context) => SecondPage(
          title: (settings.arguments as Map<String, dynamic>)['title'],
        ),
      );
    case TransferInputScreen.routeName:
      TransferScreenArgument argument =
          settings.arguments as TransferScreenArgument;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<TransferBloc>(argument.context),
          child: TransferInputScreen(
            transferType: argument.transferType,
          ),
        ),
      );
    case NormalSearchScreen.routeName:
      SearchArgument? argument = settings.arguments as SearchArgument?;
      if (argument == null) {
        Logger.debug("SearchArgument is require for search screen");
        break;
      }
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => NormalSearchScreen(
          searchArgument: argument,
        ),
      );
    case SearchBillScreen.routeName:
      Function(BillSaved?)? callBack =
          settings.arguments as Function(BillSaved?)?;
      if (callBack == null) {
        break;
      }
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => SearchBillScreen(
          callBack: callBack,
        ),
      );
    case TransactionManageScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => const TransactionManageScreen(),
      );
    case ConfirmTransferScreen.routeName:
      ConfirmTransferArgument? argument =
          settings.arguments as ConfirmTransferArgument?;
      if (argument == null) {
        Logger.debug("SearchArgument is require for search screen");
        break;
      }
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => ConfirmTransferScreen(
          argument: argument,
        ),
      );
    case TransferResultScreen.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => BlocProvider.value(
          value: (settings.arguments as TransferBloc),
          child: const TransferResultScreen(),
        ),
      );
    case OpenDepositsInputScreen.routeName:
      BuildContext mContext = settings.arguments as BuildContext;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<OpenOnlineDepositsBloc>(mContext),
          child: const OpenDepositsInputScreen(),
        ),
      );
    case ConfirmDepositsScreen.routeName:
      BuildContext mContext = settings.arguments as BuildContext;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<OpenOnlineDepositsBloc>(mContext),
          child: const ConfirmDepositsScreen(),
        ),
      );
    case OpenDepositsResultScreen.routeName:
      BuildContext mContext = settings.arguments as BuildContext;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => BlocProvider.value(
          value: BlocProvider.of<OpenOnlineDepositsBloc>(mContext),
          child: const OpenDepositsResultScreen(),
        ),
      );

    case NotificationScreen.routeName:
      NotificationArgs? argument = settings.arguments as NotificationArgs?;
      return MaterialPageRoute(
        settings: settings,
        builder: (context) => NotificationScreen(
          args: argument,
        ),
      );
    default:
      return null;
  }
}

String _currentScreen = '';

void setCurrentScreen(String screen) {
  _currentScreen = screen;
}

String getCurrentScreen() {
  return _currentScreen;
}

T? getArguments<T>(BuildContext context) {
  if (ModalRoute.of(context)!.settings.arguments != null &&
      ModalRoute.of(context)!.settings.arguments is T) {
    final args = ModalRoute.of(context)!.settings.arguments as T;
    return args;
  }
  return null;
}

T? getArgument<T>(BuildContext context, dynamic key) {
  if ((ModalRoute.of(context)!.settings.arguments is Map<String, dynamic>?) &&
      (key is String)) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    return args?[key];
  }
  if (ModalRoute.of(context)!.settings.arguments is Map<dynamic, dynamic>?) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>?;
    return args?[key];
  }
  return null;
}

Future<Widget> buildPageAsync(Function? builder, BuildContext context) async {
  return Future.microtask(() {
    return builder?.call(context);
  });
}

Future<void> pushReplacementNamed(BuildContext context, String name,
    {Object? arguments,
    bool animation = true,
    bool async = false,
    bool isTransparentRoute = false}) async {
  if (isTransparentRoute) {
    Navigator.of(context).pushReplacement(TransparentRoute(
        builder: (BuildContext context) {
          Function? builder = routes[name];
          return builder?.call(context);
        },
        settings: RouteSettings(arguments: arguments, name: name)));
    return;
  }
  if (async) {
    Function? builder = routes[name];
    var page = await buildPageAsync(builder, context);
    if (animation) {
      var route = MaterialPageRoute(
          builder: (_) => page,
          settings: RouteSettings(arguments: arguments, name: name));
      Navigator.pushReplacement(context, route);
    } else {
      var route = PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) {
          return page;
        },
        // transitionsBuilder: (context, animation, secondaryAnimation, child) {
        //   var begin = Offset(0.0, 1.0);
        //   var end = Offset.zero;
        //   var tween = Tween(begin: begin, end: end);
        //   var offsetAnimation = animation.drive(tween);
        //
        //   return SlideTransition(
        //     position: offsetAnimation,
        //     child: child,
        //   );
        // },
        transitionDuration: const Duration(milliseconds: 0),
        settings: RouteSettings(
          arguments: arguments,
          name: name,
        ),
      );
      Navigator.pushReplacement(context, route);
    }
  } else {
    if (animation) {
      Navigator.of(context).pushReplacementNamed(name, arguments: arguments);
    } else {
      var route = PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) {
            Function? builder = routes[name];
            return builder?.call(context);
          },
          transitionDuration: const Duration(seconds: 0),
          settings: RouteSettings(arguments: arguments, name: name));
      Navigator.pushReplacement(context, route);
    }
  }
}

Future<void> pushNamed(BuildContext context, String name,
    {Object? arguments,
    bool animation = true,
    bool async = false,
    bool isTransparentRoute = false}) async {
  Logger.debug('pushNamed');
  if (isTransparentRoute) {
    Navigator.of(context).push(TransparentRoute(
        builder: (BuildContext context) {
          Function? builder = routes[name];
          return builder?.call(context);
        },
        settings: RouteSettings(arguments: arguments, name: name)));
    return;
  }
  if (async) {
    Function? builder = routes[name];
    var page = await buildPageAsync(builder, context);
    if (animation) {
      var route = MaterialPageRoute(
          builder: (_) => page,
          settings: RouteSettings(arguments: arguments, name: name));
      await Navigator.push(context, route);
    } else {
      var route = PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) {
            return page;
          },
          transitionDuration: const Duration(seconds: 0),
          settings: RouteSettings(arguments: arguments, name: name));

      await Navigator.push(context, route);
    }
  } else {
    if (animation) {
      Navigator.of(context).pushNamed(name, arguments: arguments);
    } else {
      var route = PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) {
            Function? builder = routes[name];
            return builder?.call(context);
          },
          transitionDuration: const Duration(seconds: 0),
          settings: RouteSettings(arguments: arguments, name: name));
      Navigator.push(context, route);
    }
  }
}

Future<void> popAndPushNamed(BuildContext context, String name,
    {Object? arguments, bool animation = true, bool async = false}) async {
  Navigator.of(context).popAndPushNamed(name, arguments: arguments);
}

void popScreen(BuildContext context,
    {String? routeName, bool animation = true, Object? arguments}) {
  if (routeName == null) {
    Navigator.pop(context);
  } else {
    if (animation) {
      Navigator.pushNamedAndRemoveUntil(context, routeName, (route) => false);
    } else {
      var route = PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) {
            Function? builder = routes[routeName];
            return builder?.call(context);
          },
          transitionDuration: const Duration(seconds: 0),
          settings: RouteSettings(arguments: arguments, name: routeName));
      Navigator.pushAndRemoveUntil(context, route, (route) => false);
    }
  }
}
