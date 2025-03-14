import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/iterable_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/cubit/connect_internet_cubit/connect_internet_cubit.dart';
import 'package:b2b/scr/presentation/screens/main/bottom_navigation.dart';
import 'package:b2b/scr/presentation/screens/main/home_screen.dart';
import 'package:b2b/scr/presentation/screens/notification/notification_screen.dart';
import 'package:b2b/scr/presentation/screens/settings/settings_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction/transaction_inquiry_screen.dart';
import 'package:b2b/scr/presentation/widgets/lazy_widget.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum TabScreenPosition {
  LEFT,
  MIDDLE,
  RIGHT,
}

class TabScreen {
  Widget screen;
  TabScreenPosition position;
  bool isVisible;

  TabScreen({
    required this.screen,
    required this.position,
    required this.isVisible,
  });
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);
  static const String routeName = 'main_screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  int selectedIndex = 0;
  bool _visible = false;
  List<TabScreen> screensList = [
    TabScreen(
      screen: const HomeScreen(),
      position: TabScreenPosition.MIDDLE,
      isVisible: true,
    ),
    TabScreen(
      screen: const TransactionInquiryScreen(),
      position: TabScreenPosition.LEFT,
      isVisible: false,
    ),
    TabScreen(
      screen: const NotificationScreen(),
      position: TabScreenPosition.LEFT,
      isVisible: false,
    ),
    TabScreen(
      screen: const SettingsScreen(),
      position: TabScreenPosition.LEFT,
      isVisible: false,
    ),
  ];

  void _selectPage(int index) {
    if (index == 3) {
      MessageHandler().notify(SettingsScreen.SETTING_UPDATED_EVENT);
    }

    for (int i = 0; i <= screensList.length - 1; i++) {
      screensList[i].isVisible = true;
      if (i < index) {
        screensList[i].position = TabScreenPosition.RIGHT;
      } else if (i > index) {
        screensList[i].position = TabScreenPosition.LEFT;
      }
    }

    screensList[index].position = TabScreenPosition.MIDDLE;
    selectedIndex = index;
    setState(() {});
    Future.delayed(const Duration(milliseconds: 181), setPageVisibility);
  }

  void setPageVisibility() {
    for (int i = 0; i <= screensList.length - 1; i++) {
      if (screensList[i].position != TabScreenPosition.MIDDLE) {
        screensList[i].isVisible = false;
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    // TODO: implement dispose
    MessageHandler().removeListener(CHANGE_TAB_EVENT, _selectPage);
    SessionManager().clear();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Logger.debug('MainScreen initState');
    // SessionManager().clear();
    MessageHandler().addListener(CHANGE_TAB_EVENT, _selectPage);
    SessionManager().start(context);
    setTimeout(() {
      setState(() {
        _visible = true;
      });
    }, 300);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectInternetCubit, bool>(
      listener: (context, state) async {
        ScaffoldMessenger.of(SessionManager().getContext!)
            .hideCurrentSnackBar();
        if (!state) {
          try {
            final snackBar = SnackBar(
              padding: const EdgeInsets.symmetric(
                  horizontal: kDefaultPadding, vertical: kItemPadding),
              backgroundColor: Colors.red,
              margin: const EdgeInsets.all(kTopPadding),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(kDefaultPadding),
                  side: BorderSide.none),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppTranslate.i18n.errorTitleNoInternetStr.localized,
                    style: TextStyles.normalText.semibold.whiteColor,
                  ),
                  Touchable(
                    onTap: () {
                      SessionManager().logout();
                    },
                    child: Text(AppTranslate.i18n.titleCancelStr.localized,
                        style: TextStyles.normalText.semibold.whiteColor),
                  ),
                ],
              ),
              duration: const Duration(minutes: 10),
            );
            ScaffoldMessenger.of(SessionManager().getContext!)
                .showSnackBar(snackBar);
          } catch (e) {
            Logger.debug('error $e');
          }
        }
      },
      child: Container(
        color: Colors.black,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 400),
          opacity: _visible ? 1.0 : 0.7,
          child: Scaffold(
            body: Stack(
              children: screensList.mapIndexed((s, i) {
                Offset sos = const Offset(0, 0);
                if (s.position == TabScreenPosition.LEFT) {
                  sos = const Offset(0.12, 0);
                } else if (s.position == TabScreenPosition.RIGHT) {
                  sos = const Offset(-0.12, 0);
                } else if (s.position == TabScreenPosition.MIDDLE) {
                  sos = const Offset(0, 0);
                }
                return AnimatedSlide(
                  curve: Curves.easeOutQuad,
                  offset: sos,
                  child: AnimatedOpacity(
                    curve: Curves.easeOutQuad,
                    duration: const Duration(milliseconds: 180),
                    opacity: s.position == TabScreenPosition.MIDDLE ? 1 : 0,
                    child: SizedBox(
                      width: s.isVisible ? double.infinity : 0,
                      child: s.screen,
                    ),
                  ),
                  duration: const Duration(milliseconds: 180),
                );
              }).toList(),
            ),
            bottomNavigationBar: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                textTheme: Theme.of(context).textTheme.apply(
                      fontFamily: 'SVN-Gilroy',
                    ),
              ),
              child: BottomNavigation(
                selectedIndex: selectedIndex,
                onSelectPage: _selectPage,
              ),
            ),
          ),
        ),
      ),
    );
  }

  final List<Widget> screens = [
    const HomeScreen(),
    const LazyWidget(
      child: TransactionInquiryScreen(),
      delay: 200,
    ),
    const LazyWidget(
      child: NotificationScreen(),
      delay: 250,
    ),
    const LazyWidget(
      child: SettingsScreen(),
      delay: 300,
    ),
  ];
}
