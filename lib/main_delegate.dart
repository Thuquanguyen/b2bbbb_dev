import 'dart:async';
import 'dart:io';

import 'package:b2b/app_manager.dart';
import 'package:b2b/commons.dart';
import 'package:b2b/config.dart';
import 'package:b2b/scr/bloc/auth/authen_bloc.dart';
import 'package:b2b/scr/bloc/beneficiary/beneficiary_bloc.dart';
import 'package:b2b/scr/bloc/bill/bill_bloc.dart';
import 'package:b2b/scr/bloc/bill/electric/payment_electric_bloc.dart';
import 'package:b2b/scr/bloc/bloc.dart';
import 'package:b2b/scr/bloc/bloc_logging_obsever.dart';
import 'package:b2b/scr/bloc/card/card_history/card_history_bloc.dart';
import 'package:b2b/scr/bloc/card/card_list/card_list_bloc.dart';
import 'package:b2b/scr/bloc/commerece/lc/commerce_bloc.dart';

import 'package:b2b/scr/bloc/notification/notification_bloc.dart';
import 'package:b2b/scr/bloc/otp/otp_bloc.dart';
import 'package:b2b/scr/bloc/payroll/payroll_bloc.dart';
import 'package:b2b/scr/bloc/resource_service/resource_bloc.dart';
import 'package:b2b/scr/bloc/tax/tax_bloc.dart';
import 'package:b2b/scr/bloc/tax/tax_manage/tax_manage_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_bloc.dart';
import 'package:b2b/scr/bloc/transfer/rate/transfer_rate_bloc.dart';
import 'package:b2b/scr/core/environment/app_enviroment_manager.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/language/locales.dart';
import 'package:b2b/scr/core/routes/navigator_observer.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/cubit/connect_internet_cubit/connect_internet_cubit.dart';
import 'package:b2b/scr/data/repository/authen_repository.dart';
import 'package:b2b/scr/data/repository/beneficiary_repository.dart';
import 'package:b2b/scr/data/repository/bill_repository.dart';
import 'package:b2b/scr/data/repository/card_repository.dart';
import 'package:b2b/scr/data/repository/commerce_repository.dart';
import 'package:b2b/scr/data/repository/bill_repository.dart';
import 'package:b2b/scr/data/repository/exchange_rate_repository.dart';

// import 'package:b2b/scr/data/repository/id_active_repository.dart';
import 'package:b2b/scr/data/repository/notification_repository.dart';
import 'package:b2b/scr/data/repository/notification_setting_repository.dart';
import 'package:b2b/scr/data/repository/otp_repository.dart';
import 'package:b2b/scr/data/repository/payroll_repository.dart';
import 'package:b2b/scr/data/repository/resource_repository.dart';
import 'package:b2b/scr/data/repository/saving_repository.dart';
import 'package:b2b/scr/data/repository/tax_repository.dart';
import 'package:b2b/scr/data/repository/transaction_manager_repository.dart';
import 'package:b2b/scr/data/repository/transaction_repository.dart';
import 'package:b2b/scr/data/repository/transfer_repository.dart';
import 'package:b2b/scr/presentation/screens/auth/account_manager.dart';
import 'package:b2b/scr/presentation/screens/bill/bill_screen.dart';
import 'package:b2b/scr/presentation/screens/splash_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/bill_approve/bill_approve_result_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/bill_approve/bill_approve_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_management_screen.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/theme/theme_manager.dart';
import 'package:b2b/utilities/fcm/fcm_helper.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:bloc/bloc.dart';

//FCM
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'constants.dart';
import 'scr/core/api_service/api_provider.dart';
import 'scr/core/routes/routes.dart';
import 'scr/presentation/screens/account_service/transaction_manage.dart';
import 'scr/presentation/screens/auth/re_login_screen.dart';
import 'scr/presentation/screens/notification/notification_screen.dart';
import 'theme/theme_templates.dart';
import 'utilities/fcm/fcm_data.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';

// let's implements handle message when user tapping on the noti
// Future<void> _firebaseMessagingTappingHandler(RemoteMessage message) async {
//   Logger.debug('Handling message ${message.notification?.body}');
//   // example
//   await Navigator.of(globalKeyFistPageState.currentContext!).pushNamed(
//     SecondPage.routeName,
//     arguments: {'title': message.notification?.body},
//   );
// }

// Future<void> setFcmTopic(List<String>? topics) async {
//   if (topics != null && topics.isNotEmpty) {
//     Logger.debug('FCM TOPICS: ' + topics.toString());
//     List<String>? oldTopics = await LocalStorageHelper.getStringList("fcm_topics");
//     Map<String, bool> mark = {};
//     if (oldTopics != null && oldTopics.isNotEmpty) {
//       for (var element in oldTopics) {
//         mark[element] = false;
//       }
//     }
//     for (var element in topics) {
//       mark[element] = true;
//     }
//     LocalStorageHelper.setStringList("fcm_topics", topics);
//     for (var element in mark.keys) {
//       if (mark[element] == true) {
//         FirebaseMessaging.instance.subscribeToTopic(element);
//       } else {
//         FirebaseMessaging.instance.unsubscribeFromTopic(element);
//       }
//     }
//   }
// }

Future<void> waitActionForContext(FcmData data) async {
  int dem = 0;
  while (true) {
    if (SessionManager().getContext != null) {
      processNotification(data);
      break;
    }
    if (dem >= 30) {
      break;
    }
    dem++;
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

void processNotificationAction(String module, dynamic extraData) {
  if (SessionManager().getContext == null) return;
  final context = SessionManager().getContext!;

  String routeName = '';
  dynamic arg;

  if (module == FcmActionType.BalanceAlert.getValue()) {
    routeName = NotificationScreen.routeName;
    arg = NotificationArgs(isMain: false);
  } else if (module == FcmActionType.TransferAlert.getValue()) {
    routeName = TransactionManageScreen.routeName;
  } else if (module == FcmActionType.SAVING.getValue()) {
    routeName = TransactionManageScreen.routeName;
    arg = TransactionManageScreenArguments(
      selectedCategory: TransactionManage.savingCat,
    );
  } else if (module == FcmActionType.PAY_ROLL.getValue()) {
    routeName = TransactionManageScreen.routeName;
    arg = TransactionManageScreenArguments(
      selectedCategory: TransactionManage.payrollCat,
    );
  } else if (module == FcmActionType.PROMOTE.getValue()) {
    routeName = NotificationScreen.routeName;
    arg = NotificationArgs(isMain: false, openPromotePage: true);
  } else if (module == FcmActionType.bill.getValue()) {
    routeName = TransactionManageScreen.routeName;
    arg = TransactionManageScreenArguments(
      selectedCategory: TransactionManage.billCat,
    );
  }

  Logger.debug('NOTIFICATION PUSH TO ROUTE NAME $routeName');

  Navigator.of(context).pushNamed(
    routeName,
    arguments: arg,
  );
}

void processAskLogin(FcmData fcmData, {bool forceAskLogin = false}) {
  final context = SessionManager().getContext!;
  String userReceive = fcmData.metaData?.userReceive ?? '';
  String message = fcmData.body ?? '';
  String module = fcmData.metaData?.module ?? '';

  if (fcmData.metaData?.userReceive == AccountManager().currentUsername) {
    LocalStorageHelper.getBool(CHANGE_VIEW_BALANCE).then(
      (value) async {
        final isNotiBalance = value ?? false;
        if (module == FcmActionType.BalanceAlert.getValue() && isNotiBalance) {
          // await SessionManager().load();
          Logger.debug('push to notifcation screen');
          pushNamed(context, NotificationScreen.routeName, arguments: NotificationArgs(isMain: false));
        } else {
          showDialogRequireLogin(context: context, userReceive: userReceive, message: message, module: module);
        }
      },
    );
  } else {
    showDialogRequireLogin(context: context, userReceive: userReceive, message: message, module: module);
  }
}

void showDialogRequireLogin({
  required BuildContext context,
  required String message,
  required String userReceive,
  required String module,
}) {
  Logger.debug('showDialogRequireLogin');

  showDialogCustom(
    context,
    AssetHelper.icoAuthError,
    AppTranslate.i18n.notificationStr.localized,
    AppTranslate.i18n.loginToSeeNotifyStr.localized.interpolate({'message': message, 'account': userReceive}),
    button1:
        renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonSkipStr.localized.toUpperCase()),
    button2: renderDialogTextButton(
      context: context,
      title: AppTranslate.i18n.accountManageTitleLoginStr.localized.toUpperCase(),
      onTap: () {
        MessageHandler().notify('NOTIFICATION_CHANGE_USER', data: userReceive);
        AuthManager().notifyAction(
          (_context) {
            processNotificationAction(module, null);
          },
        );
      },
    ),
  );
}

void processNotification(FcmData fcmData, {bool isBackground = true}) async {
  Logger.debug('processNotification ${AccountManager().currentUsername}');
  try {
    if (SessionManager().getContext == null) {
      Logger.debug('SessionManager().getContext == null');
      return;
    }

    final context = SessionManager().getContext!;
    String userReceive = fcmData.metaData?.userReceive ?? '';
    String message = fcmData.body ?? '';
    String module = fcmData.metaData?.module ?? '';
    String topic = fcmData.metaData?.topic ?? '';

    bool hasUser = AccountManager().hasUser(userReceive);
    bool hasTopic = await FcmHelper().checkTopic(topic, AccountManager().currentUsername);
    if (!hasUser && !hasTopic) {
      Logger.debug('hasUser =  false && hasTopic = false');
      return;
    }
    if (SessionManager().isLoggedIn()) {
      Logger.debug('SessionManager().isLoggedIn() = true');
      if (AccountManager().currentUsername == userReceive || hasTopic) {
        if (module != FcmActionType.PROMOTE.getValue()) {
          MessageHandler().notify(TransactionManageScreen.TRANSACTION_NEED_RELOAD);
          MessageHandler().notify(RELOAD_NOTIFICATION);
        }

        showNotificationSnackBar(
          context,
          message,
          actionText: AppTranslate.i18n.seeStr.localized,
          onPress: () {
            processNotificationAction(module, null);
          },
        );
      }
    } else {
      Logger.debug('SessionManager().isLoggedIn() = false');
      if (isBackground) {
        processAskLogin(fcmData);
      } else {
        showNotificationSnackBar(
          context,
          message,
          actionText: AppTranslate.i18n.seeStr.localized,
          onPress: () {
            processAskLogin(fcmData, forceAskLogin: true);
          },
        );
      }
    }
  } catch (e) {
    Logger.debug('Error $e');
  }
}

Future<void> initIAWebView() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Permission.camera.request();
  // await Permission.microphone.request();
  // await Permission.storage.request();

  if (Platform.isAndroid) {
    await AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);

    var swAvailable = await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_BASIC_USAGE);
    var swInterceptAvailable =
        await AndroidWebViewFeature.isFeatureSupported(AndroidWebViewFeature.SERVICE_WORKER_SHOULD_INTERCEPT_REQUEST);

    if (swAvailable && swInterceptAvailable) {
      AndroidServiceWorkerController serviceWorkerController = AndroidServiceWorkerController.instance();

      serviceWorkerController.serviceWorkerClient = AndroidServiceWorkerClient(
        shouldInterceptRequest: (request) async {
          Logger.debug(request.toString());
          return null;
        },
      );
    }
  }
}

Future<void> mainDelegate() async {
  await initIAWebView();
  //ssl ignore
  // HttpOverrides.global = IgnoreCertificateErrorOverrides();
  if (AppConfig.env == AppEnvironment.Dev) {
    initHttpSslIgnore();
  }

  await Firebase.initializeApp();
  await FcmHelper().initializeFirebaseMessage();

  // init bloc obsever for control bloc
  Bloc.observer = AppBlocLoggingObserver();

  // init WidgetsFlutterBinding to listen method call from app native
  WidgetsFlutterBinding.ensureInitialized();

  // init your environment
  AppEnvironmentManager.initialize();
  AppManager().initialize();
  AppTranslate().loadLanguage();

  // read themes in local storage
  ThemeManager().readJson(completion: () {
    runZonedGuarded(() async {
      // if (!kDebugMode) {
      //   //TODO: FCM
      //   // await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      // }
      runApp(const MyApp(
          // dioRepository: dioRepository,
          ));
      Future.delayed(const Duration(milliseconds: 1), () {
        initLoadingStyle(globalKey.currentContext);
      });
      // await initializeFirebaseMessage();
    }, (error, stackTrace) async {
      await FirebaseCrashlytics.instance.recordError(error, stackTrace);
    });
  });
}

final GlobalKey<SplashScreenState> globalKeyFistPageState = GlobalKey();
final GlobalKey<NavigatorState> globalKey = GlobalKey();

// let's change the name app
class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
    // required this.dioRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // declare all neccessary global reposity/instance to widgets

    // final Dio dioRepository = HttpClient.getRepository();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ApiProviderRepositoryImpl>(
          create: (context) => ApiProviderRepositoryImpl(),
          lazy: false,
        ),
        RepositoryProvider<ApiProviderRepositoryFireBaseImpl>(
          create: (context) => ApiProviderRepositoryFireBaseImpl(),
          lazy: false,
        ),
      ],
      // declare all neccessary global Bloc providers here
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthenBloc>(
            create: (context) => AuthenBloc(
              authenRepository: AuthenRepositoryImpl(
                apiProvider: RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
            )..add(AuthenEventStartApp()),
            lazy: false,
          ),
          BlocProvider<OtpBloc>(
            create: (context) => OtpBloc(
                otpRepository: OtpRepositoryImpl(
              apiProvider: RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
            )),
            lazy: false,
          ),
          BlocProvider<BeneficiaryBloc>(
            create: (context) => BeneficiaryBloc(
                beneficiaryRepository: BeneficiaryRepositoryImpl(
              apiProvider: RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
            )),
          ),
          BlocProvider<TransactionInquiryBloc>(
            create: (context) => TransactionInquiryBloc(
              transactionRepository: TransactionRepositoryImpl(
                apiProvider: RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
            ),
            lazy: false,
          ),
          BlocProvider<TransactionManagerBloc>(
            create: (context) => TransactionManagerBloc(
              transManangerRepository: TransactionManagerRepository(
                RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
              savingRepo: SavingRepository(
                RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
              payrollRepo: PayrollRepository(
                RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
              billRepo: BillRepository(
                RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
            ),
            lazy: false,
          ),
          BlocProvider<ResourceBloc>(
            create: (context) => ResourceBloc(
              resourceRepository: ResourceRepositoryImpl(
                apiProvider: RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
            ),
            lazy: false,
          ),
          BlocProvider<PayrollBloc>(
            create: (context) => PayrollBloc(
              PayrollRepository(
                RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
            ),
            lazy: false,
          ),
          BlocProvider<NotificationBloc>(
            create: (context) => NotificationBloc(
              notificationSettingRepository: NotificationSettingImpl(
                apiProvider: RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
            ),
            lazy: false,
          ),
          BlocProvider<ConnectInternetCubit>(
            create: (context) => ConnectInternetCubit(),
            lazy: false,
          ),
          BlocProvider<CurrentDepositsBloc>(
            create: (context) => CurrentDepositsBloc(
              SavingRepository(
                RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
              TransactionManagerRepository(
                RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
            ),
            lazy: false,
          ),
          BlocProvider<CardHistoryBloc>(
            create: (context) => CardHistoryBloc(
              CardRepository(
                RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
            ),
            lazy: false,
          ),
          BlocProvider<CardHistoryBloc>(
            create: (context) => CardHistoryBloc(
              CardRepository(
                RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
            ),
            lazy: false,
          ),
          BlocProvider<CardListBloc>(
            create: (context) => CardListBloc(
              CardRepository(
                RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
            ),
            lazy: false,
          ),
          BlocProvider<TaxManageBloc>(
            create: (context) => TaxManageBloc(
              TaxRepository(
                RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
            ),
            lazy: false,
          ),
          BlocProvider<RegisterTaxBloc>(
            create: (context) => RegisterTaxBloc(
              TaxRepository(
                RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
            ),
            lazy: false,
          ),
          BlocProvider<CommerceBloc>(
            create: (context) => CommerceBloc(
              CommerceRepository(
                RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
            ),
            lazy: false,
          ),
          BlocProvider<TransferRateBloc>(
            create: (context) => TransferRateBloc(
              TransferRepositoryImpl(
                apiProvider: RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
            ),
            lazy: false,
          ),
          BlocProvider<PaymentElectricBloc>(
            create: (context) => PaymentElectricBloc(
              BillRepository(
                RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
            ),
            lazy: false,
          ),
          BlocProvider<BillBloc>(
            create: (context) => BillBloc(
              BillRepository(
                RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
              ),
            ),
            lazy: false,
          ),
        ],
        child: MaterialApp(
          themeMode: ThemeMode.light,
          routes: routes,
          navigatorKey: globalKey,
          home: SplashScreen(
            key: globalKeyFistPageState,
          ),
          onGenerateRoute: generateRoutes,
          supportedLocales: LocaleManager.validateLocales(),
          locale: LocaleManager.defaultLocale(),
          theme: lightTheme(context),
          // darkTheme: darkTheme(context),
          debugShowCheckedModeBanner: false,
          navigatorObservers: [
            AppLoggingRoutesObserver(),
          ],
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          // builder: (BuildContext context, Widget? child) {
          //   return MediaQuery(
          //     data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          //     child: child ?? const SizedBox(),
          //   );
          // },
          builder: EasyLoading.init(builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Stack(
                children: [
                  child ?? const SizedBox(),
                  AppConfig.env != AppEnvironment.Pro
                      ? IgnorePointer(
                          child: Container(
                            margin: const EdgeInsets.only(left: 15, top: 5),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 224, 70, 231),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            );
          }),
          scrollBehavior: const CupertinoScrollBehavior(),
        ),
      ),
    );
  }
}
