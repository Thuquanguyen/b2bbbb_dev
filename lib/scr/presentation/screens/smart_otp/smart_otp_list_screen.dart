// Created by Cuonghd2 at 05/08/2021
// Email: cuonghd2@vpbank.com.vn
// Copyright (c) 2020. All rights reserved.

import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/presentation/screens/auth/account_manage_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/account_manager.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/setup_otp_screen.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/smart_otp_screen.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/state_builder.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/circle_avatar_letter.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const avatarBg = [
  Color.fromRGBO(252, 221, 236, 1.0),
  Color.fromRGBO(165, 166, 246, 1.0),
  Color.fromRGBO(33, 150, 83, 1.0),
  Color.fromRGBO(242, 153, 74, 1.0),
];

class SmartOTPListScreen extends StatefulWidget {
  const SmartOTPListScreen({Key? key}) : super(key: key);
  static String routeName = 'smart_otp_list_screen';

  @override
  _SmartOTPListScreenState createState() => _SmartOTPListScreenState();
}

class _SmartOTPListScreenState extends State<SmartOTPListScreen> {
  final StateHandler stateHandler = StateHandler(SmartOTPListScreen.routeName);
  final List<User> items = [];
  AccountManageArgument? args;

  Future<void> loadUsers() async {
    await AccountManager().loadUsers();
    items.clear();
    items.addAll(AccountManager().getUsersForSOTP());
    if (items.isEmpty) {
      showDialogCustom(
        context,
        AssetHelper.icoAuthError,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        AppTranslate.i18n.smartOtpNoSmartOtpStr.localized,
        button1: renderDialogTextButton(
          context: context,
          title: 'OK',
          onTap: () {
            popScreen(context);
          },
        ),
        barrierDismissible: false,
        onClose: () {
          popScreen(context);
        },
      );
      return;
    }
    stateHandler.refresh();
  }

  @override
  void initState() {
    loadUsers();
    super.initState();
  }

  void onLongPress(User user) {
    showDialogCustom(
      context,
      AssetHelper.icoAuthError,
      AppTranslate.i18n.dialogTitleNotificationStr.localized,
      AppTranslate.i18n.smartOtpCancelActiveStr.localized,
      button1: renderDialogTextButton(context: context, title: AppTranslate.i18n.cancelStr.localized),
      button2: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.titleConfirmStr.localized,
          onTap: () {
            SmartOTPManager().deleteUser(AccountManager().currentUsername);
            showToast(AppTranslate.i18n.sotpRemoveActivationStr.localized);
          }),
    );
  }

  Future<void> onSelectItem(User user) async {
    Logger.debug('selected OTP for user ${user.username}');
    if (user.username != null) {
      SmartOTPManager().showOtpForUser(context, user.username!, onResult: (isActivated, otpCode) {
        if (isActivated == false) {
          showDialogCustom(
            context,
            AssetHelper.icoAuthError,
            AppTranslate.i18n.dialogTitleNotificationStr.localized,
            AppTranslate.i18n.smartOtpActiveStr.localized,
            button1: renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonCancelStr.localized),
            button2: renderDialogTextButton(
                context: context,
                title: AppTranslate.i18n.accountManageTitleLoginStr.localized,
                onTap: () {
                  if (args != null) {
                    AccountManager().setCurrentUsername(user.username);
                    popScreen(context);
                    args!.doAction?.call(AccountManageActionType.CHANGE_ACCOUNT);
                  }
                }),
          );
        }
      });
    } else {
      //show error
      Logger.debug('Loi user ${user.username}');
    }
  }

  Widget renderItem(int index, User item) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Color.fromRGBO(0, 0, 0, 0.1), offset: Offset(0, 4), blurRadius: 8, spreadRadius: 0),
        ],
        borderRadius: BorderRadius.all(Radius.circular(getInScreenSize(16))),
      ),
      margin: const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
      alignment: Alignment.center,
      child: TextButton(
        onPressed: () {
          onSelectItem(item);
        },
        onLongPress: () {
          onLongPress(item);
        },
        child: Container(
          height: getInScreenSize(60),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              CircleAvatarLetter(
                name: item.fullName ?? '',
                size: 48,
                color: Colors.white,
                backgroundColor: avatarBg[index % 4],
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(left: 12),
                  height: getInScreenSize(40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text((item.fullName ?? '').toUpperCase(),
                          style: const TextStyle(
                              fontSize: 13, color: Color.fromRGBO(102, 102, 103, 1.0), fontWeight: FontWeight.w600)),
                      Text(
                        item.companyName ?? '',
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 12, color: Color.fromRGBO(102, 102, 103, 1.0), fontWeight: FontWeight.w400),
                      )
                    ],
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_right,
                size: 24,
                color: Colors.black54,
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    args = getArguments(context);

    return AppBarContainer(
      title: 'Smart OTP',
      appBarType: AppBarType.POPUP,
      actions: [
        Touchable(
            onTap: () {
              // popScreen(context);
              Navigator.of(context).pushNamed(SetupOtpScreen.routeName);
            },
            child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                alignment: Alignment.center,
                child: Text(
                  AppTranslate.i18n.listSecondTitleSetupStr.localized,
                  style: const TextStyle(color: Colors.white),
                )))
      ],
      onBack: () {
        // pushReplacementNamed(context, ReLoginScreen.routeName, animation: false, async: true);
        popScreen(context);
      },
      child: StateBuilder(
        builder: () {
          return ListView.builder(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var item = items[index];
              return renderItem(index, item);
            },
            itemCount: items.length,
          );
        },
        routeName: SmartOTPListScreen.routeName,
      ),
    );
  }
}
