// ignore_for_file: constant_identifier_names
import 'dart:math';

import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/data/model/auth/menu_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/account_list_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/account_manager.dart';
import 'package:b2b/scr/presentation/screens/bill/bill_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/card_list/card_list_screen.dart';
import 'package:b2b/scr/presentation/screens/commerece/comerce_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/current_deposits/current_deposits_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/deposits_screen.dart';
import 'package:b2b/scr/presentation/screens/exchange_rate_screen.dart';
import 'package:b2b/scr/presentation/screens/find_atm_screen.dart';
import 'package:b2b/scr/presentation/screens/loan/loan_list_screen.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/screens/saving/saving_screen.dart';
import 'package:b2b/scr/presentation/screens/tax/tax_list_screen.dart';
import 'package:b2b/scr/presentation/screens/webview_screen.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/widgets.dart';

import '../bill/bill_provider_screen.dart';
import '../tax/tax_screen.dart';

enum HomeAction {
  PAYROLL,
  PAYROLL_INHOUSE,
  PAYROLL_INTERBANK,
  FUND_TRANSFER,
  TRANSFER_INHOUSE,
  TRANSFER_INTERBANK,
  TRANSFER_INTERBANK_24H,
  ACCOUNT,
  TRANSACTION_MANAGER, //maker
  APPROVE_MANAGER, //checker
  APPROVE_INDIVIDUAL_PAYROLL,
  TAB_QUERY_HISTORY_TRANS,
  TIEN_GUI,
  THE,
  TIEN_VAY,
  BAO_LANH,
  NHO_THU,
  CHIET_KHAU,
  COMMERCE, // TÀi trợ thương mại
  TAX,
  BILL,
  DICH_VU,
  ATM,
  TY_GIA,
  LAI_SUAT,
  SMART_OTP,
  HO_TRO,
}

Map<HomeAction, String> homeActionId = {
  HomeAction.APPROVE_INDIVIDUAL_PAYROLL: 'lblApproveIndividualPayroll',
  HomeAction.PAYROLL: 'lblPayroll',
  HomeAction.PAYROLL_INHOUSE: 'lblPayrollInhoues',
  HomeAction.PAYROLL_INTERBANK: 'lblPayrollInter',
  HomeAction.TRANSFER_INHOUSE: 'lblInhouseTransfer',
  HomeAction.TRANSFER_INTERBANK: 'lblInterbankTranfer',
  HomeAction.TRANSFER_INTERBANK_24H: 'lblInterbankTranfer24h',
  HomeAction.FUND_TRANSFER: 'lblFundTransfer',
  HomeAction.ACCOUNT: 'lblAccount',
  HomeAction.TRANSACTION_MANAGER: 'lblTransactionManager',
  HomeAction.APPROVE_MANAGER: 'lblApproveTransfer',
  HomeAction.TAB_QUERY_HISTORY_TRANS: 'lblQueryHistoryTrans',
  HomeAction.TIEN_GUI: 'lblSavingOnline',
  HomeAction.THE: 'lblCardService',
  HomeAction.TIEN_VAY: 'TIEN_VAY',
  HomeAction.COMMERCE: 'lblTradeFinanceReport',
  HomeAction.TAX: 'Tax_lblTaxPayment',
  HomeAction.BILL: 'lblBillPay',
  HomeAction.BAO_LANH: '4',
  HomeAction.NHO_THU: 'NHOTHU',
  HomeAction.CHIET_KHAU: '6',
  HomeAction.DICH_VU: '7',
  HomeAction.ATM: 'LOCAL_ATM',
  HomeAction.TY_GIA: 'LOCAL_TY_GIA',
  HomeAction.LAI_SUAT: 'LOCAL_LAI_SUAT',
  HomeAction.SMART_OTP: 'LOCAL_SMART_OTP',
  HomeAction.HO_TRO: 'LOCAL_HO_TRO',
};

extension HomeActionExtension on HomeAction {
  String get id {
    return homeActionId[this] ?? '';
  }
}

class HomeActionItem {
  HomeActionItem({
    required this.id,
    required this.title,
    required this.icon,
    required this.index,
    required this.isSelected,
    required this.isActive,
    required this.onTap,
    required this.isPreSelected,
  });

  String id;
  String title;
  String icon;
  int index;
  bool isSelected = false;
  bool isPreSelected = false;
  bool isActive = false;
  Function? onTap;

  @override
  String toString() {
    return 'HomeActionItem(title: $title, isActive: $isActive)';
  }
}

class HomeArgs {
  Function? onResult;
}

class HomeActionManager {
  factory HomeActionManager() => _instance;

  HomeActionManager._() {
    init();
    MessageHandler().addListener(EVENT_CHANGE_LANGUAGE, init);
  }

  static final _instance = HomeActionManager._();

  final List<HomeActionItem> homeActions = [];

  void init() {
    homeActions.clear();
    homeActions.addAll([
      HomeActionItem(
          id: HomeAction.SMART_OTP.id,
          title: 'Smart OTP',
          icon: AssetHelper.icoSmartOtp,
          isSelected: true,
          isPreSelected: true,
          isActive: true,
          onTap: (context) {
            Logger.debug('Home Action Smart OTP');
            SmartOTPManager().showOtpForUser(
              context,
              AccountManager().currentUsername,
              onResult: (isActivated, isSuccess) {
                if (isActivated == false) {
                  SmartOTPManager().checkNeedActivationSOTP(
                    context,
                    AccountManager().currentUser,
                  );
                }
              },
            );
          },
          index: 10),
      HomeActionItem(
          id: HomeAction.TIEN_GUI.id,
          title: AppTranslate.i18n.beneficiaryTitleFindBankStr,
          icon: AssetHelper.icoHomeDeposits,
          isSelected: false,
          isPreSelected: false,
          isActive: true,
          onTap: (context) {
            if (RolePermissionManager().isRoleViewerSaving()) {
              Navigator.of(context).pushNamed(CurrentDepositsScreen.routeName);
            } else {
              pushNamed(context, DepositsScreen.routeName);
            }
          },
          index: 0),
      HomeActionItem(
          id: HomeAction.THE.id,
          title: AppTranslate.i18n.dataHardCoreCardStr,
          icon: AssetHelper.icoHomeCard,
          isSelected: false,
          isPreSelected: false,
          isActive: true,
          onTap: (context) {
            Navigator.of(context).pushNamed(
              CardListScreen.routeName,
            );
          },
          index: 1),
      HomeActionItem(
          id: HomeAction.TIEN_VAY.id,
          title: AppTranslate.i18n.dataHardCoreLoanStr,
          icon: AssetHelper.icoHomeLoan,
          isSelected: false,
          isPreSelected: false,
          isActive: true,
          onTap: (context) {
            pushNamed(context, LoanListScreen.routeName);
          },
          index: 2),
      HomeActionItem(
          id: HomeAction.COMMERCE.id,
          title: AppTranslate.i18n.dataHardCoreCommerceStr,
          icon: AssetHelper.icHomeCommerce,
          isSelected: false,
          isPreSelected: false,
          isActive: true,
          onTap: (context) {
            pushNamed(context, CommerceScreen.routeName);
          },
          index: 3),
      HomeActionItem(
          id: HomeAction.TAX.id,
          title: AppTranslate.i18n.registerTaxStr,
          icon: AssetHelper.icHomeTax,
          isSelected: false,
          isPreSelected: false,
          isActive: true,
          onTap: (context) {
            RolePermissionManager().userRole == UserRole.MAKER
                ? pushNamed(context, TaxScreen.routeName)
                : pushNamed(context, TaxListScreen.routeName);
          },
          index: 4),
      HomeActionItem(
          id: HomeAction.BILL.id,
          title: AppTranslate.i18n.billStr.localized,
          icon: AssetHelper.icIdea,
          isSelected: false,
          isPreSelected: false,
          isActive: true,
          onTap: (context) {
            pushNamed(context, BillScreen.routeName);
          },
          index: 4),
      HomeActionItem(
          id: HomeAction.BAO_LANH.id,
          title: AppTranslate.i18n.dataHardCoreGuaranteeStr,
          icon: AssetHelper.icoHomeGuarantee,
          isSelected: false,
          isPreSelected: false,
          isActive: true,
          onTap: (context) {
            // Navigator.of(context).pushNamed(WebViewScreen.routeName,
            //     arguments: WebViewArgs(
            //         url: 'https://cskh.vpbank.com.vn/',
            //         title: AppTranslate.i18n.firstLoginTitleHelpStr.localized));
          },
          index: 3),
      HomeActionItem(
          id: HomeAction.NHO_THU.id,
          title: AppTranslate.i18n.dataHardCoreLdStr,
          icon: AssetHelper.icoHomeRecall,
          isSelected: false,
          isPreSelected: false,
          isActive: true,
          onTap: (context) {},
          index: 4),
      HomeActionItem(
          id: HomeAction.CHIET_KHAU.id,
          title: AppTranslate.i18n.dataHardCoreDiscountStr,
          icon: AssetHelper.icoHomeDiscount,
          isSelected: false,
          isPreSelected: false,
          isActive: false,
          onTap: (context) {
            Navigator.of(context).pushNamed(WebViewScreen.routeName,
                arguments: WebViewArgs(
                    url: 'https://cskh.vpbank.com.vn/',
                    title: AppTranslate.i18n.firstLoginTitleHelpStr.localized));
          },
          index: 5),
      HomeActionItem(
          id: HomeAction.DICH_VU.id,
          title: AppTranslate.i18n.reLoginServiceAccountStr,
          icon: AssetHelper.icoAccountService,
          isSelected: false,
          isPreSelected: false,
          isActive: false,
          onTap: (context) {
            Navigator.of(context).pushNamed(AccountListScreen.routeName);
          },
          index: 6),
      HomeActionItem(
          id: HomeAction.ATM.id,
          title: 'ATM/CDM',
          icon: AssetHelper.icoAtm,
          isSelected: false,
          isPreSelected: false,
          isActive: true,
          onTap: (context) {
            pushNamed(context, FindATMScreen.routeName, async: true);
          },
          index: 7),
      HomeActionItem(
          id: HomeAction.TY_GIA.id,
          title: AppTranslate.i18n.firstLoginTitleExchangeRateStr,
          icon: AssetHelper.icoBarChart,
          isSelected: false,
          isPreSelected: false,
          isActive: true,
          onTap: (context) {
            pushNamed(context, ExchangeRateScreen.routeName);
          },
          index: 8),
      HomeActionItem(
          id: HomeAction.LAI_SUAT.id,
          title: AppTranslate.i18n.firstLoginTitleInterestRateStr,
          icon: AssetHelper.icoLineChart,
          isSelected: false,
          isPreSelected: false,
          isActive: true,
          onTap: (context) {
            pushNamed(context, RolloverTermSavingScreen.routeName);
          },
          index: 9),

      HomeActionItem(
          id: HomeAction.HO_TRO.id,
          title: AppTranslate.i18n.firstLoginTitleHelpStr,
          icon: AssetHelper.icoPhone,
          isSelected: false,
          isPreSelected: false,
          isActive: true,
          onTap: (context) {
            Navigator.of(context).pushNamed(WebViewScreen.routeName,
                arguments: WebViewArgs(
                    url: 'https://cskh.vpbank.com.vn/',
                    title: AppTranslate.i18n.firstLoginTitleHelpStr.localized));
          },
          index: 11),
      HomeActionItem(
          id: 'LOCAL_FEEDBACK',
          title: AppTranslate.i18n.homeTitleFeedbackStr,
          icon: AssetHelper.icoAlert,
          isSelected: false,
          isPreSelected: false,
          isActive: true,
          onTap: (context) {
            pushNamed(context, WebViewScreen.routeName,
                arguments: WebViewArgs(
                    url: 'https://www.surveymonkey.com/r/8HSLSFL',
                    title: AppTranslate.i18n.homeTitleFeedbackStr.localized));
          },
          index: 12),
      // HomeActionItem(
      //     id: 'LOCAL_LOGS',
      //     title: 'Logs',
      //     icon: AssetHelper.icoCheck,
      //     isSelected: false,
      //     isPreSelected: false,
      //     isActive: true,
      //     onTap: (context) {
      //       pushNamed(context, LogScreen.routeName);
      //     },
      //     index: 12),
      // HomeActionItem(
      //     id: 'LOCAL_CALENDAR',
      //     title: 'Calendar',
      //     icon: AssetHelper.icoCalendar,
      //     isSelected: false,
      //     isPreSelected: false,
      //     isActive: true,
      //     onTap: (context) {
      //       MyCalendar().showDatePicker(context, onSelected: (date){
      //         Logger.debug(date);
      //       });
      //     },
      //     index: 13),
    ]);
  }

  // Function get All item active
  List<HomeActionItem> getAllActions() {
    List<HomeActionItem> activeItems = [];
    for (int i = 0; i < homeActions.length; i++) {
      if (homeActions[i].isActive) {
        activeItems.add(homeActions[i]);
      }
    }
    return activeItems;
  }

  // Function get all item is selected
  List<HomeActionItem> getSelectedItem() {
    List<HomeActionItem> selectedItems = [];
    for (int i = 0; i < homeActions.length; i++) {
      if (homeActions[i].isSelected && homeActions[i].isActive) {
        homeActions[i].isPreSelected = true;
        selectedItems.add(homeActions[i]);
      } else {
        homeActions[i].isPreSelected = false;
      }
    }
    return selectedItems;
  }

  List<HomeActionItem> getPreSelectedItem() {
    List<HomeActionItem> selectedItems = [];
    for (int i = 0; i < homeActions.length; i++) {
      if (homeActions[i].isPreSelected && homeActions[i].isActive) {
        selectedItems.add(homeActions[i]);
      }
    }
    return selectedItems;
  }

  Future<bool> saveSelectedItem() async {
    List<String> idsSelected = [];
    for (int i = 0; i < homeActions.length; i++) {
      if (homeActions[i].isPreSelected) {
        homeActions[i].isSelected = true;
        if (homeActions[i].id.isNotEmpty) {
          idsSelected.add(homeActions[i].id);
        }
      } else {
        homeActions[i].isSelected = false;
      }
    }
    try {
      return await LocalStorageHelper.setStringList(
          LIST_SECOND_HOME, idsSelected);
    } catch (e) {
      Logger.debug(e);
    }
    return false;
  }

  // Function get list selected from localstorge
  void loadSelectedItem() async {
    List<String> _listIdHomeAction = [];
    try {
      _listIdHomeAction =
          await LocalStorageHelper.getStringList(LIST_SECOND_HOME) ?? [];
    } catch (e) {
      Logger.debug("cache : ${e}");
    }

    final List<HomeActionItem> actives = getAllActions();

    //default value
    if (_listIdHomeAction.isEmpty) {
      final n = min(actives.length, 8);
      for (int i = 0; i < n; i++) {
        final item = actives[i];
        item.isSelected = true;
      }
    } else {
      // add list selected
      for (HomeActionItem item in actives) {
        if (_listIdHomeAction.contains(item.id)) {
          item.isSelected = true;
        }
      }
    }
  }

  void clearActiveAction() {
    for (HomeActionItem actionItem in homeActions) {
      if (!actionItem.id.startsWith('LOCAL_') ||
          actionItem.id == HomeAction.SMART_OTP.id) {
        actionItem.isActive = false;
      }
    }
  }

  // Function fetch data list HomeActionItem active
  void initActiveAction(List<MenuModel>? menuPermission) {
    if (menuPermission != null) {
      // for (int i = 0; i < menuPermission.length; i++) {
      //   final item = menuPermission[i];
      //   for (HomeActionItem actionItem in homeActions) {
      //     if (!actionItem.id.startsWith('LOCAL_')) {
      //       actionItem.isActive = false;
      //     }
      //     if (actionItem.id == HomeAction.SMART_OTP.id) {
      //       actionItem.isActive =
      //           (AccountManager().currentUser.enableSmartotp != false);
      //     }
      //     if (item.labelId == actionItem.id && item.visible == true) {
      //       actionItem.isActive = true;
      //     }
      //
      //     Logger.debug(
      //         'initActiveAction labelID ${item.labelId} ACtionID ${actionItem.id}   VISIBLE ${item.visible}');
      //   }
      // }

      for (HomeActionItem actionItem in homeActions) {
        if (actionItem.id.startsWith('LOCAL_')) {
          if (actionItem.id == HomeAction.SMART_OTP.id) {
            try {
              actionItem.isActive =
                  AccountManager().currentUser.enableSmartotp ?? false;
            } catch (e) {}
          } else {
            continue;
          }
        }

        for (MenuModel menuModel in menuPermission) {
          if (menuModel.labelId != actionItem.id) {
            continue;
          }
          actionItem.isActive = menuModel.visible ?? false;
        }
      }

      loadSelectedItem();
    }
  }

  // Function check length list selected in list active
  bool checkPreSelectedLength() {
    return getPreSelectedItem().length == min(7, getAllActions().length);
  }
}
