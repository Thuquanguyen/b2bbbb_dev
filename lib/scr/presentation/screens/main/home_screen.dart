import 'package:b2b/app_manager.dart';
import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/main.dart';
import 'package:b2b/scr/bloc/auth/authen_bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/resource_service/resource_bloc.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/core/smart_otp/smart_otp_manager.dart';
import 'package:b2b/scr/data/model/auth/menu_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/account_list_screen.dart';
import 'package:b2b/scr/presentation/screens/auth/account_manager.dart';
import 'package:b2b/scr/presentation/screens/auth/re_login_screen.dart';
import 'package:b2b/scr/presentation/screens/main/banner_ads_widget.dart';
import 'package:b2b/scr/presentation/screens/main/home_action_manager.dart';
import 'package:b2b/scr/presentation/screens/main/list_second_home_screen.dart';
import 'package:b2b/scr/presentation/screens/profile/profile_screen.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/screens/settings/change_password_screen.dart';
import 'package:b2b/scr/presentation/screens/settings/settings_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_management_screen.dart';
import 'package:b2b/scr/presentation/screens/transfer/transfer_screen.dart';
import 'package:b2b/scr/presentation/screens/webview_screen.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/circle_avatar_letter.dart';
import 'package:b2b/scr/presentation/widgets/home_action_tile.dart';
import 'package:b2b/scr/presentation/widgets/home_first_action_tile.dart';
import 'package:b2b/scr/presentation/widgets/state_builder.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/fcm/fcm_helper.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:b2b/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static String routeName = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String customerName = AppTranslate.i18n.homeTitleCustomerStr.localized;
  String companyName = '...';
  bool isLoadSession = false;
  bool isAskSOTP = false;
  bool isFirst = true;
  bool isFirstHomeSecond = true;
  int countIcon = 0;
  List<MenuModel>? menuPermission = [];
  final List<Interval> _itemSlideIntervals = [];

  late AnimationController itemRowAnimCtl;
  late Animation<double> itemRowPositionAnim;
  static const _initialDelayTime = Duration(milliseconds: 50);
  static const _itemSlideTime = Duration(milliseconds: 250);
  static const _staggerTime = Duration(milliseconds: 50);
  final _animationDuration = _initialDelayTime + _itemSlideTime + (_staggerTime * 7);

  final StateHandler _stateHandler = StateHandler(HomeScreen.routeName);
  final HomeActionManager homeActionManager = HomeActionManager();

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    _createAnimationIntervals();
    itemRowAnimCtl = AnimationController(vsync: this, duration: _animationDuration);
    itemRowPositionAnim = CurvedAnimation(parent: itemRowAnimCtl, curve: Curves.ease);
    setTimeout(() {
      loadSession(context);
    }, 300);
  }

  void _createAnimationIntervals() {
    for (var i = 0; i <= 10; ++i) {
      final startTime = _staggerTime * i;
      final endTime = startTime + _itemSlideTime;
      _itemSlideIntervals.add(
        Interval(
          startTime.inMilliseconds / _animationDuration.inMilliseconds,
          endTime.inMilliseconds / _animationDuration.inMilliseconds,
        ),
      );
    }
  }

  @override
  void dispose() {
    itemRowAnimCtl.dispose();
    super.dispose();
  }

  Future<void> loadSession(BuildContext context) async {
    if (!isLoadSession) {
      isLoadSession = true;
      await SessionManager().load();
      homeActionManager.initActiveAction([]);
      if (SessionManager().isLoggedIn()) {
        setTimeout(() {
          context.read<AuthenBloc>().add(AuthenEventGetMenuUserPermission());
          context.read<AuthenBloc>().add(AuthenEventGetSession());
          context.read<ResourceBloc>().add(GetBannerAdsEvent());
        }, 300);
      }
    }
  }

  void processSessionData(AuthenState state) {
    hideLoading();
    if (state.sessionStatus == AuthenStatus.SUCCESS) {
      state.sessionModel?.saveToLocal();
      String username = state.sessionModel?.user?.username ?? '';
      customerName = state.sessionModel?.user?.fullName ?? '';
      companyName = state.sessionModel?.customer?.custName ?? '';
      bool enableSmartotp = state.sessionModel?.user?.enableSmartotp ?? false;
      FcmHelper().setFcmTopic(state.sessionModel?.topicKey);
      User _user = User(
        username: username,
        fullName: customerName,
        companyName: companyName,
        enableSmartotp: enableSmartotp,
        roleCode: state.sessionModel?.user?.roleCode,
      );
      AccountManager().setCurrentUser(_user);
      initHomeAction();
      if (!isAskSOTP) {
        isAskSOTP = true;
        SmartOTPManager().checkNeedActivationSOTP(
          context,
          AccountManager().currentUser,
        );
      }
    } else if (state.sessionStatus == AuthenStatus.CHANGE_PASSWORD) {
      pushNamed(context, ChangePasswordScreen.routeName, arguments: {'needLogout': true});
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthenBloc, AuthenState>(
      listenWhen: (previous, current) =>
          previous.menuState != current.menuState || previous.sessionState != current.sessionState,
      listener: (context, state) {
        if (state.sessionState == DataState.preload) {
          if (isFirst) {
            isFirst = false;
            // showLoading();
          }
        } else if (state.sessionState == DataState.data) {
          processSessionData(state);
        } else if (state.menuState == DataState.preload) {
          if (isFirstHomeSecond) {
            isFirstHomeSecond = false;
          }
        } else if (state.menuState == DataState.data) {
          menuPermission = state.menuModel;
          initHomeAction();
        }
      },
      builder: (context, state) {
        return AppBarContainer(
          child: buildScreen(context, state),
          appBarType: AppBarType.HOME,
          isHomePage: true,
        );
      },
    );
  }

  Future<void> _pullRefresh() async {
    // showLoading();
    // _refreshIndicatorKey.currentState?.show(atTop: true);
    setState(() {
      isLoadSession = false;
    });
    await Future.delayed(const Duration(seconds: 1));
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  Widget _buildItemShimmer() {
    return Column(
      children: [
        Container(
            width: getInScreenSize(56),
            height: getInScreenSize(56),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            )),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: 40,
          height: 10,
          decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2), borderRadius: const BorderRadius.all(Radius.circular(5))),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }

  List<Widget> renderHomeFirstAction() {
    if (!RolePermissionManager().hasInitPermission()) {
      return [
        Expanded(
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [_buildItemShimmer(), _buildItemShimmer(), _buildItemShimmer()],
            ),
          ),
        )
      ];
    }
    List<Widget> list = [
      if (RolePermissionManager().checkVisible(HomeAction.PAYROLL.id))
        _itemFirst(AppTranslate.i18n.homeTitlePayrollStr.localized, AssetHelper.icoTransferMoney, 0, () {
          Navigator.of(context).pushNamed(TransferScreen.routeName,
              arguments: TransferArgs(
                  title: AppTranslate.i18n.homeTitlePayrollStr.localized,
                  subTitle: AppTranslate.i18n.selectPayrollMethodStr.localized));
        }),
      if (RolePermissionManager().checkVisible(HomeAction.FUND_TRANSFER.id))
        _itemFirst(AppTranslate.i18n.homeTitleTransferMoneyStr.localized, AssetHelper.icoTransferMoney, 0, () {
          Navigator.of(context).pushNamed(TransferScreen.routeName,
              arguments: TransferArgs(title: AppTranslate.i18n.homeTitleTransferMoneyStr.localized));
        }),
      if (RolePermissionManager().checkVisible(HomeAction.ACCOUNT.id))
        _itemFirst(AppTranslate.i18n.homeTitleAccountStr.localized, AssetHelper.icoAccount, 0, () {
          Navigator.of(context).pushNamed(AccountListScreen.routeName);
        }),
      if (RolePermissionManager().checkVisible(HomeAction.TRANSACTION_MANAGER.id))
        _itemFirst(
          AppTranslate.i18n.homeTitleTransactionManagementStr.localized,
          AssetHelper.icoTransactionManage,
          0,
          () {
            pushNamed(context, TransactionManageScreen.routeName);
          },
        ),
      if (RolePermissionManager().checkVisible(HomeAction.APPROVE_MANAGER.id) ||
          RolePermissionManager().checkVisible(HomeAction.APPROVE_INDIVIDUAL_PAYROLL.id))
        _itemFirst(
          AppTranslate.i18n.homeTitleTransactionManagementStr.localized,
          AssetHelper.icoTransactionManage,
          0,
          () {
            pushNamed(context, TransactionManageScreen.routeName);
          },
        ),
    ];
    if (list.length == 1) {
      list.add(
        _itemFirst(AppTranslate.i18n.firstLoginTitleHelpStr.localized, AssetHelper.icoPhone, 0, () {
          // MessageHandler().notify(CHANGE_TAB_EVENT, data: 1);
          Navigator.of(context).pushNamed(WebViewScreen.routeName,
              arguments: WebViewArgs(
                  url: 'https://cskh.vpbank.com.vn/', title: AppTranslate.i18n.firstLoginTitleHelpStr.localized));
        }),
      );
    }
    if (list.length == 2) {
      list.insert(1, Container(height: 60, width: 0.5, color: Colors.grey.shade50));
    }
    return list;
  }

//SizeConfig.screenHeight - kBottomNavigationBarHeight,
  Widget buildScreen(BuildContext context, AuthenState state) {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      backgroundColor: Colors.white,
      onRefresh: _pullRefresh,
      child: Column(
        children: [
          SizedBox(
            height: SizeConfig.screenPaddingTop.toScreenSize,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getInScreenSize(16)),
            child: Row(
              // alignment: Alignment.topLeft,
              children: [
                ImageHelper.loadFromAsset(AssetHelper.icoVpbankGreen,
                    width: getInScreenSize(132), height: getInScreenSize(34)),
                const Spacer(),
                Touchable(
                    onTap: () {
                      SessionManager().logout(showAskDialog: true);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppTranslate.i18n.profileTitleLogoutStr.localized,
                            style: TextStyles.smallText.regular.blackColor,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          ImageHelper.loadFromAsset(AssetHelper.icoLogout, height: 24, width: 24)
                        ],
                      ),
                    ))
              ],
            ),
          ),
          SizedBox(
            height: getInScreenSize(10),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getInScreenSize(16)),
            child: Row(
              children: [
                StateBuilder(
                  builder: () {
                    return CircleAvatarLetter(
                      onTap: () async {
                        // SmartOTPManager().setCurrentUser(AccountManager().currentUsername);
                        // bool isPIN = await SmartOTPManager().checkActivatedPIN();
                        // print('SmartOTPManager().checkActivatedPIN() $isPIN');
                        Navigator.pushNamed(context, ProfileScreen.routeName);
                        // Navigator.pushNamed(context, ReLoginUserScreen.routeName,arguments: ReLoginUserArgs(title: 'Xác thực giao dịch'));
                        // Navigator.pushNamed(context, TestPage.routeName);
                        // MyCalendar().showDatePicker(
                        //   context,
                        //   maxDate: DateTime.now(),
                        //   minDate: DateTime.utc(2021, 7,15),
                        //   selectedDate: DateTime.utc(2021, 8,15),
                        //   onSelected: (date) {
                        //     Logger.debug(date);
                        //   },
                        // );
                      },
                      size: getInScreenSize(48),
                      name: customerName,
                    );
                  },
                  routeName: HomeScreen.routeName,
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(left: getInScreenSize(12)),
                    height: getInScreenSize(40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Text(AppTranslate.i18n.homeTitleWellComeStr.localized,
                                style: TextStyle(
                                    fontSize: 13, color: Theme.of(context).textTheme.bodyText1?.color ?? Colors.black)),
                            StateBuilder(
                              builder: () {
                                return Text(customerName,
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.green, fontWeight: FontWeight.w600));
                              },
                              routeName: HomeScreen.routeName,
                            ),
                          ],
                        ),
                        StateBuilder(
                          builder: () {
                            return Text(
                              companyName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Theme.of(context).textTheme.bodyText1?.color ?? Colors.black,
                                  fontWeight: FontWeight.w600),
                            );
                          },
                          routeName: HomeScreen.routeName,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: getInScreenSize(12),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: getInScreenSize(16)),
            child: Container(
              height: getInScreenSize(120),
              padding: EdgeInsets.only(
                  top: getInScreenSize(12), left: getInScreenSize(12), right: getInScreenSize(12), bottom: 6),
              decoration: const BoxDecoration(
                  gradient: kGradientBackgroundH,
                  color: Colors.red,
                  boxShadow: [
                    BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.1), offset: Offset(0, 0.2), blurRadius: 2, spreadRadius: 2),
                  ],
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: StateBuilder(
                  builder: () {
                    return Row(children: renderHomeFirstAction());
                  },
                  routeName: HomeScreen.routeName,
                  holder: 'list-second'),
            ),
          ),
          SizedBox(
            height: getInScreenSize(5),
          ),
          Expanded(
            child: renderScrollView(context),
          ),
        ],
      ),
    );
  }

  void initHomeAction() {
    if (menuPermission != null && menuPermission!.isNotEmpty) {
      RolePermissionManager().initPermission(menuPermission);
      homeActionManager.initActiveAction(menuPermission);
      MessageHandler().notify(SettingsScreen.SETTING_UPDATED_EVENT);
      MessageHandler().notify(RolePermissionManager.ROLE_PERMISSION_UPDATED);
      AuthManager().doActionQueue(context);
      setTimeout(() {
        _stateHandler.refresh();
      }, 100);
    }
  }

  Widget renderScrollView(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          begin: Alignment.center,
          end: Alignment.topCenter,
          stops: [0, 1],
          colors: <Color>[
            Color.fromRGBO(255, 255, 255, 1),
            Color.fromRGBO(255, 255, 255, 0),
          ],
        ).createShader(Rect.fromLTWH(bounds.left, bounds.top, bounds.width, 20));
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: getInScreenSize(16),
            ),
            StateBuilder(
              builder: () => Container(
                width: double.infinity,
                // padding: EdgeInsets.symmetric(horizontal: getInScreenSize(16)),
                alignment: Alignment.topLeft,
                child: _listItem(context, true),
              ),
              routeName: HomeScreen.routeName,
              holder: 'list-second',
            ),
            const SizedBox(
              height: 5,
            ),
            Flexible(
              child: BlocConsumer<ResourceBloc, ResourceState>(
                buildWhen: (o, c) => o.bannerAdsState?.dataState != c.bannerAdsState?.dataState,
                listener: (_, __) {},
                builder: (ctx, rState) {
                  return BannerAdsWidget(
                    ads: rState.bannerAdsState?.bannerAds ?? [],
                  );
                },
              ),
            ),
            SizedBox(
              height: getInScreenSize(16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemFirst(String title, String icon, int badge, Function onTap) {
    return Expanded(child: HomeFirstActionTile(onPressed: onTap, icon: icon, title: title, badgeNumber: badge));
  }

  HomeActionTile actionToButton(HomeActionItem item, BuildContext context) {
    return HomeActionTile(
        icon: item.icon, onPressed: () => item.onTap!(context)?.call(), badgeNumber: 0, title: item.title.localized);
  }

  Widget _listItem(BuildContext context, bool isFirstLine) {
    List<HomeActionTile> items = [];
    //get item selected
    List<HomeActionItem> actions = homeActionManager.getSelectedItem();
    if (actions.isNotEmpty) {
      setTimeout(() {
        itemRowAnimCtl.forward();
      }, 200);
    }

    if (actions.length >8 ) {
      actions = actions.sublist(0,7);
      HomeActionItem otherAction = HomeActionItem(
          id: 'KHAC',
          title: AppTranslate.i18n.homeTitleItemOtherStr,
          icon: AssetHelper.icoHomeOther,
          isSelected: true,
          isPreSelected: true,
          isActive: true,
          onTap: (context) {
            Navigator.of(context).pushNamed(ListSecondHomeScreen.routeName, arguments: HomeActionArg(onResult: () {
              _stateHandler.refresh();
            }));
          },
          index: 1000);
      actions.add(otherAction);
    }

    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        // crossAxisSpacing: 4,
        // mainAxisSpacing: 8,
        // childAspectRatio: (2 / 1),
      ),
      itemBuilder: (BuildContext context, int index) {
        return AnimatedBuilder(
          animation: itemRowAnimCtl,
          builder: (context, child) {
            final animationPercent = Curves.easeInOutCirc.transform(
              _itemSlideIntervals[index].transform(itemRowAnimCtl.value),
            );
            final opacity = animationPercent;
            final slideDistance = (1.0 - animationPercent) * 10;

            return Opacity(
              opacity: opacity,
              child: Transform.translate(
                offset: Offset(0, slideDistance),
                child: child,
              ),
            );
          },
          child: actionToButton(actions[index], context),
        );
      },
      itemCount: actions.length,
    );
  }
}
