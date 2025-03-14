import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/notification/notification_bloc.dart';
import 'package:b2b/scr/bloc/notification/notification_event.dart';
import 'package:b2b/scr/bloc/notification/notification_state.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/data/model/notification/notification_tab_bar_data.dart';
import 'package:b2b/scr/data/repository/notification_repository.dart';
import 'package:b2b/scr/presentation/screens/auth/account_manager.dart';
import 'package:b2b/scr/presentation/screens/notification/notification_page_promote.dart';
import 'package:b2b/scr/presentation/screens/notification/tab_bar_widget.dart';
import 'package:b2b/scr/presentation/screens/settings/settings_screen.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import 'notification_enum.dart';
import 'notification_page_content.dart';

enum ModuleAlert { BALANCE, TRANSFER, MAKETTING }

class NotificationArgs {
  final bool? isMain;
  final bool? openPromotePage;

  NotificationArgs({this.isMain = true, this.openPromotePage});
}

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key, this.args}) : super(key: key);

  final NotificationArgs? args;

  static const String routeName = 'notification-screen';

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen>
    with AutomaticKeepAliveClientMixin<NotificationScreen> {
  List<TabBarData> tabBarList = [
    TabBarData(title: AppTranslate.i18n.balanceChangeStr.localized, isActive: true, numNews: 2),
    TabBarData(title: AppTranslate.i18n.transactionStr.localized.toTitleCase(), isActive: false, numNews: 3),
    TabBarData(title: 'Ưu đãi', isActive: false, numNews: 3),
  ];

  bool isFristReload = true;
  bool isLoaded = false;
  DateFormat notificationDateFormat = DateFormat('dd/MM/yyyy');
  PageController pageController = PageController();

  late NotificationBloc notificationBloc;
  String userName = '';
  String tokenIdentity = '';

  int currentPage = 0;

  @override
  void initState() {
    super.initState();

    notificationBloc = NotificationBloc(
      notificationRepository: NotificationRepositoryImpl(
        RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
        RepositoryProvider.of<ApiProviderRepositoryFireBaseImpl>(context),
      ),
    );

    if (widget.args?.openPromotePage == true) {
      currentPage = 2;
      pageController = PageController(initialPage: 2);
      notificationBloc.add(NotiChangeActiveTabEvent(2));
    }
  }

  @override
  void dispose() {
    MessageHandler().unregister(RELOAD_SESSION);
    MessageHandler().unregister(RELOAD_NOTIFICATION);
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: AppTranslate.i18n.notificationStr.localized,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: BlocProvider(
          create: (context) => notificationBloc,
          child: Column(
            children: [
              // const SizedBox(
              //   height: kDefaultPadding,
              // ),
              _buildListTitle(),
              BlocBuilder<NotificationBloc, NotificationState>(
                builder: (BuildContext context, state) {
                  if (state.currentPage == 1) {
                    return Column(
                      children: [
                        const SizedBox(
                          height: kDefaultPadding,
                        ),
                        Text(
                          AppTranslate.i18n.skipTransactionIfDoneStr.localized,
                          style: TextStyles.itemText.italic.copyWith(
                            color: const Color(0xff666667),
                          ),
                        )
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
              Expanded(
                child: _buildContent(),
              ),
            ],
          ),
        ),
      ),
      appBarType: (widget.args?.isMain ?? true) ? AppBarType.HOME : AppBarType.SMALL,
      actions: (widget.args?.isMain ?? true)
          ? [
              TextButton(
                onPressed: () {
                  pushNamed(
                    context,
                    SettingsScreen.routeName,
                    arguments: SettingScreenArgument(
                      sections: [SettingScreenSection.NOTIFICATION],
                    ),
                    // SettingNotificationScreen.routeName,
                  );
                },
                child: SvgPicture.asset(
                  AssetHelper.icSettingNoti,
                  width: 22,
                  height: 22,
                  fit: BoxFit.contain,
                ),
              )
            ]
          : [],
    );
  }

  _buildListTitle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          Logger.debug("BlocConsumer listener ${state.currentPage}");
          for (int i = 0; i < tabBarList.length; i++) {
            if (i == state.currentPage) {
              tabBarList[i].isActive = true;
            } else {
              tabBarList[i].isActive = false;
            }
          }
        },
        listenWhen: (previous, current) {
          return previous.currentPage != current.currentPage;
        },
        buildWhen: (previous, current) {
          return previous.currentPage != current.currentPage;
        },
        builder: (context, state) {
          return SizedBox(
            height: 42,
            width: double.infinity,
            child: ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                TabBarData data = tabBarList[index];
                return MyTabBarView(
                  tabBarData: data,
                  onTap: () {
                    // if (pageController.hasClients) {
                    pageController.jumpToPage(index);
                    // notificationBloc.add(NotiChangeActiveTabEvent(index));
                    // }
                  },
                );
              },
              itemCount: tabBarList.length,
              scrollDirection: Axis.horizontal,
            ),
          );
        },
      ),
    );
  }

  _buildContent() {
    return Container(
      margin: const EdgeInsets.only(top: 18),
      color: Colors.transparent,
      child: PageView(
        onPageChanged: (index) {
          notificationBloc.add(NotiChangeActiveTabEvent(index));
        },
        controller: pageController,
        scrollDirection: Axis.horizontal,
        children: _buildListPageContent(),
      ),
    );
  }

  _buildListPageContent() {
    List<Widget> pageContents = [
      NotificationPageContent(
        // listData: state.listNotificationBloc ?? [],
        pageType: NotificationPageType.BALANCE_CHANGE,
        userName: userName,
        tokenIdentity: tokenIdentity,
        indexTab: 1,
      ),
      NotificationPageContent(
        // listData: state.listNotificationPending ?? [],
        pageType: NotificationPageType.PENDING_TRANSACTION,
        // notificationBloc: notificationBloc,
        userName: userName,
        tokenIdentity: tokenIdentity,
        indexTab: 2,
      ),
      const NotificationPagePromote(),
    ];
    return pageContents;
  }

  @override
  bool get wantKeepAlive => true;
}
