// ignore_for_file: constant_identifier_names

import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/auth/authen_bloc.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/presentation/screens/auth/account_manager.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/circle_avatar_letter.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/state_builder.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/fcm/fcm_helper.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

const avatarBg = [
  Color.fromRGBO(252, 221, 236, 1.0),
  Color.fromRGBO(165, 166, 246, 1.0),
  Color.fromRGBO(33, 150, 83, 1.0),
  Color.fromRGBO(242, 153, 74, 1.0),
];

enum AccountManageActionType { ADD_NEW_ACCOUNT, CHANGE_ACCOUNT, DONE }

class AccountManageArgument {
  AccountManageArgument(this.doAction);

  Function(AccountManageActionType type)? doAction;
}

class AccountManageScreen extends StatefulWidget {
  const AccountManageScreen({Key? key}) : super(key: key);
  static String routeName = 'account_manage_screen';

  @override
  _AccountManageScreenState createState() => _AccountManageScreenState();
}

class _AccountManageScreenState extends State<AccountManageScreen> {
  late final SlidableController slidableController;
  final StateHandler stateHandler = StateHandler(AccountManageScreen.routeName);
  final List<User> items = [];

  Future<void> loadUsers() async {
    await AccountManager().loadUsers();
    items.clear();
    items.addAll(List.from(AccountManager().getUsers().reversed));
    stateHandler.refresh();
  }

  @override
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    loadUsers();
    super.initState();
  }

  Animation<double>? _rotationAnimation;
  Color _fabColor = Colors.blue.shade100;

  void handleSlideAnimationChanged(Animation<double>? slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool? isOpen) {
    setState(() {
      _fabColor = isOpen! ? Colors.green : Colors.blue;
    });
  }

  void removeUser(User user) {
    showDialogCustom(
      context,
      AssetHelper.icoAuthError,
      AppTranslate.i18n.dialogTitleDeleteStr.localized,
      AppTranslate.i18n.dialogMessageDeleteStr.localized,
      button1: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.dialogButtonSkipStr.localized),
      button2: renderDialogTextButton(
        context: context,
        title: AppTranslate.i18n.dialogButtonDeleteStr.localized,
        onTap: () async {
          showLoading();
          FcmHelper().unsubscribeUser(user.username ?? '');
          context
              .read<AuthenBloc>()
              .add(AuthenEventCleanUserDevice(username: user.username ?? ""));
          setTimeout(() {
            hideLoading();
            AccountManager().removeUser(user);
            loadUsers();
          }, 1200);
        },
      ),
    );
  }

  void changeUser(User user) {
    AccountManager().setCurrentUsername(user.username);
  }

  Widget renderItem(int index, User item) {
    Color? roleColor;
    if (RolePermissionManager().getRoleName(item.roleCode) ==
        UserRole.CHECKER.getValue()) {
      roleColor = const Color(0xff00B74F);
    } else if (RolePermissionManager().getRoleName(item.roleCode) ==
        UserRole.MAKER.getValue()) {
      roleColor = const Color(0xff9B7DCC);
    } else if (RolePermissionManager().getRoleName(item.roleCode) ==
        UserRole.VIEWER.getValue()) {
      roleColor = const Color(0xffF1AA1C);
    }
    return Slidable(
      key: Key(item.username ?? ''),
      direction: Axis.horizontal,
      actionPane: const SlidableBehindActionPane(),
      secondaryActions: [
        Container(
          width: 80,
          height: getInScreenSize(80),
          margin: const EdgeInsets.only(right: 30),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            color: Color.fromRGBO(237, 241, 246, 0.5),
            // border: Border.all(width: 1, color: const Color.fromRGBO(237, 241, 246, 1))
            // boxShadow: const [
            //   BoxShadow(
            //       color: Color.fromRGBO(0, 0, 0, 0.05), offset: Offset(0, 4), blurRadius: 8, spreadRadius: 0),
            // ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Touchable(
                onTap: () {
                  removeUser(item);
                },
                child: Container(
                  width: getInScreenSize(36),
                  height: getInScreenSize(36),
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 103, 99, 1),
                      borderRadius: BorderRadius.all(
                          Radius.circular(getInScreenSize(18)))),
                  child: const Icon(Icons.delete_outline,
                      color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                AppTranslate.i18n.dialogButtonDeleteStr.localized,
                style: const TextStyle(
                    color: Color.fromRGBO(255, 103, 99, 1),
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
        )
      ],
      child: Stack(children: [
        Container(
          height: getInScreenSize(136),
          padding: const EdgeInsets.only(left: 8, right: 8),
          margin:
              const EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 16),
          alignment: Alignment.center,
          decoration: kDecoration,
          child: Column(
            children: [
              Container(
                height: getInScreenSize(84),
                padding: const EdgeInsets.symmetric(horizontal: 12),
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
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    (item.fullName ?? '').toUpperCase(),
                                    style: const TextStyle(
                                        fontSize: 13,
                                        color:
                                            Color.fromRGBO(102, 102, 103, 1.0),
                                        fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (RolePermissionManager()
                                    .getRoleName(item.roleCode)
                                    .isNotNullAndEmpty)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: roleColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.only(
                                        left: 10, right: 10, top: 2, bottom: 2),
                                    child: Text(
                                      RolePermissionManager()
                                              .getRoleName(item.roleCode) ??
                                          '',
                                      style: TextStyles.itemText
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            Text(
                              item.companyName ?? '',
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: Color.fromRGBO(102, 102, 103, 1.0),
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 1,
                color: const Color.fromRGBO(237, 241, 246, 1.0),
              ),
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Touchable(
                    onTap: () {
                      // popScreen(context);
                      // pushReplacementNamed(context, ReLoginScreen.routeName);
                      popScreen(context);
                      changeUser(item);
                      setTimeout(() {
                        setTimeout(() {
                          if (args != null) {
                            args!.doAction
                                ?.call(AccountManageActionType.CHANGE_ACCOUNT);
                          }
                        }, 400);
                      }, 400);
                    },
                    child: Container(
                      // color: Colors.green,
                      alignment: Alignment.center,
                      width: 120,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        AppTranslate.i18n.accountManageTitleLoginStr.localized,
                        style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                            fontSize: 15),
                      ),
                    ),
                  ),
                  if (item.enableSmartotp == true)
                    Container(
                      width: 1,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      color: const Color.fromRGBO(237, 241, 246, 1.0),
                    ),
                  if (item.enableSmartotp == true)
                    Touchable(
                      onTap: () async {
                        // pushNamed(context, SmartOTPScreen.routeName);
                        if (item.enableSmartotp == true) {
                          if (item.username != null) {
                            SmartOTPManager().showOtpForUser(
                              context,
                              item.username!,
                              onResult: (isActivated, isSuccess) {
                                showDialogCustom(
                                  context,
                                  AssetHelper.icoAuthError,
                                  AppTranslate.i18n.dialogTitleNotificationStr
                                      .localized,
                                  AppTranslate.i18n
                                      .accountManageTitleActiveOtpStr.localized,
                                  button1: renderDialogTextButton(
                                      context: context,
                                      title: AppTranslate
                                          .i18n.dialogButtonSkipStr.localized),
                                  button2: renderDialogTextButton(
                                      context: context,
                                      title: AppTranslate.i18n
                                          .accountManageTitleLoginStr.localized,
                                      onTap: () {
                                        if (args != null) {
                                          AccountManager().setCurrentUsername(
                                              item.username ?? '');
                                          popScreen(context);
                                          args!.doAction?.call(
                                              AccountManageActionType
                                                  .CHANGE_ACCOUNT);
                                        }
                                      }),
                                );
                              },
                            );
                          } else {
                            //show error
                            Logger.debug('Loi user ${item.username}');
                          }
                        } else {
                          showDialogCustom(
                              context,
                              AssetHelper.icoAuthError,
                              AppTranslate
                                  .i18n.dialogTitleNotificationStr.localized,
                              AppTranslate
                                  .i18n
                                  .accountMangeTitleOptNotAvailableStr
                                  .localized,
                              button1: renderDialogTextButton(
                                  context: context,
                                  title: AppTranslate
                                      .i18n.dialogButtonCloseStr.localized));
                        }
                      },
                      child: Container(
                        width: 120,
                        // color: Colors.red,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ImageHelper.loadFromAsset(AssetHelper.icoSmartOtp,
                                width: 24, height: 24),
                            const SizedBox(
                              width: 5,
                            ),
                            const Text(
                              'Smart OTP',
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        ),
                      ),
                    )
                ],
              ))
            ],
          ),
        ),
        Positioned(
            top: 10,
            right: 26,
            child: Touchable(
              onTap: () {
                removeUser(item);
              },
              child: const Icon(
                Icons.close,
                size: 22,
                color: Colors.black54,
              ),
            )),
      ]),
    );
  }

  AccountManageArgument? args;

  @override
  Widget build(BuildContext context) {
    args = getArguments(context);
    return AppBarContainer(
      title: AppTranslate.i18n.accountManageTitleHeaderStr.localized,
      appBarType: AppBarType.POPUP,
      hideBackButton: true,
      actions: [
        Touchable(
          onTap: () {
            popScreen(context);
            if (args != null) {
              args!.doAction?.call(AccountManageActionType.DONE);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Text(
              AppTranslate.i18n.accountManageTitleDoneStr.localized,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
      onBack: () {
        // pushReplacementNamed(context, ReLoginScreen.routeName, animation: false, async: true);
        popScreen(context);
      },
      child: StateBuilder(
        builder: () {
          return ListView.builder(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              if (index == items.length) {
                return Padding(
                  padding: EdgeInsets.only(top: items.isEmpty ? 80 : 0),
                  child: Touchable(
                    onTap: () {
                      popScreen(context);
                      setTimeout(() {
                        if (args != null) {
                          args!.doAction
                              ?.call(AccountManageActionType.ADD_NEW_ACCOUNT);
                        }
                      }, 400);
                    },
                    child: Container(
                      height: getInScreenSize(66),
                      margin: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 20),
                      decoration: BoxDecoration(
                          // color: Colors.white30,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(16)),
                          border:
                              Border.all(width: 1.5, color: Colors.white70)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person_add,
                            color: Color.fromRGBO(102, 102, 103, 1.0),
                            size: 24,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            AppTranslate
                                .i18n
                                .accountManageTitleLoginAccountOtherStr
                                .localized,
                            style: const TextStyle(
                                height: 1.5,
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                                fontSize: 15),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                var item = items[index];
                return renderItem(index, item);
              }
            },
            itemCount: items.length + 1,
          );
        },
        routeName: AccountManageScreen.routeName,
      ),
    );
  }
}
