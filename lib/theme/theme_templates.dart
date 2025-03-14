import 'package:flutter/material.dart';
import 'package:b2b/theme/theme_colors.dart';
import 'package:flutter/services.dart';

ThemeData lightTheme(BuildContext context) {
  return ThemeData.light().copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    primaryColor: ThemeColors.primaryColor.lightColor,
    scaffoldBackgroundColor: ThemeColors.backgroundColor1.lightColor,
    accentColor: ThemeColors.primaryColor.lightColor,
    shadowColor: ThemeColors.subTextColor.lightColor,
    bottomAppBarColor: ThemeColors.backgroundColor2.lightColor,
    cardColor: ThemeColors.backgroundColor1.lightColor,
    dividerColor: ThemeColors.divider1.lightColor,
    focusColor: ThemeColors.primaryColor.lightColor,
    hoverColor: ThemeColors.secondaryColor.lightColor,
    highlightColor: ThemeColors.primaryColor.lightColor,
    splashColor: ThemeColors.primaryColor.lightColor,
    selectedRowColor: ThemeColors.secondaryColor.lightColor,
    unselectedWidgetColor: ThemeColors.subTextColor.lightColor,
    disabledColor: ThemeColors.subTextColor.lightColor,
    buttonColor: ThemeColors.primaryColor.lightColor,
    secondaryHeaderColor: ThemeColors.backgroundColor2.lightColor,
    appBarTheme: appBarTheme,
    canvasColor: Colors.transparent,
    iconTheme: IconThemeData(color: ThemeColors.mainTextColor.lightColor),
    textTheme: Theme.of(context).textTheme.apply(
          bodyColor: ThemeColors.mainTextColor.lightColor,
          fontFamily: 'SVN-Gilroy'
        ),
    primaryTextTheme: Theme.of(context).textTheme.apply(
          bodyColor: ThemeColors.mainTextColor.lightColor,
          fontFamily: 'SVN-Gilroy',
        ),
    accentTextTheme: Theme.of(context).textTheme.apply(
          bodyColor: ThemeColors.mainTextColor.lightColor,
          fontFamily: 'SVN-Gilroy',
        ),
    colorScheme: ColorScheme.light(
      primary: ThemeColors.primaryColor.lightColor,
      secondary: ThemeColors.secondaryColor.lightColor,
      error: ThemeColors.error.lightColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ThemeColors.backgroundColor1.lightColor,
      selectedItemColor: ThemeColors.primaryColor.lightColor.withOpacity(0.7),
      unselectedItemColor:
          ThemeColors.subTextColor.lightColor.withOpacity(0.32),
      selectedIconTheme:
          IconThemeData(color: ThemeColors.primaryColor.lightColor),
      showUnselectedLabels: true,
    ),
  );
}

ThemeData darkTheme(BuildContext context) {
  return ThemeData.dark().copyWith(
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: CupertinoPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    primaryColor: ThemeColors.primaryColor.darkColor,
    scaffoldBackgroundColor: ThemeColors.backgroundColor1.darkColor,
    accentColor: ThemeColors.primaryColor.darkColor,
    shadowColor: ThemeColors.subTextColor.darkColor,
    bottomAppBarColor: ThemeColors.backgroundColor2.darkColor,
    cardColor: ThemeColors.backgroundColor1.darkColor,
    dividerColor: ThemeColors.divider1.darkColor,
    focusColor: ThemeColors.primaryColor.darkColor,
    hoverColor: ThemeColors.secondaryColor.darkColor,
    highlightColor: ThemeColors.primaryColor.darkColor,
    splashColor: ThemeColors.primaryColor.darkColor,
    selectedRowColor: ThemeColors.secondaryColor.darkColor,
    unselectedWidgetColor: ThemeColors.subTextColor.darkColor,
    disabledColor: ThemeColors.subTextColor.darkColor,
    buttonColor: ThemeColors.primaryColor.darkColor,
    secondaryHeaderColor: ThemeColors.backgroundColor2.darkColor,
    appBarTheme: appBarTheme,
    iconTheme: IconThemeData(color: ThemeColors.mainTextColor.darkColor),
    textTheme: Theme.of(context).textTheme.apply(
          bodyColor: ThemeColors.mainTextColor.darkColor,
          fontFamily: 'SVN-Gilroy',
        ),
    primaryTextTheme: Theme.of(context).textTheme.apply(
          bodyColor: ThemeColors.mainTextColor.darkColor,
          fontFamily: 'SVN-Gilroy',
        ),
    accentTextTheme: Theme.of(context).textTheme.apply(
          bodyColor: ThemeColors.mainTextColor.darkColor,
          fontFamily: 'SVN-Gilroy',
        ),
    colorScheme: ColorScheme.dark(
      primary: ThemeColors.primaryColor.darkColor,
      secondary: ThemeColors.secondaryColor.darkColor,
      error: ThemeColors.error.darkColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: ThemeColors.backgroundColor1.darkColor,
      selectedItemColor: ThemeColors.primaryColor.darkColor.withOpacity(0.7),
      unselectedItemColor: ThemeColors.subTextColor.darkColor.withOpacity(0.32),
      selectedIconTheme:
          IconThemeData(color: ThemeColors.primaryColor.darkColor),
      showUnselectedLabels: true,
    ),
  );
}

const AppBarTheme appBarTheme = AppBarTheme(
  centerTitle: false,
  elevation: 0,
  systemOverlayStyle: SystemUiOverlayStyle(statusBarBrightness: Brightness.dark, statusBarColor: Colors.transparent),
  // brightness: Brightness.light,
  // systemOverlayStyle: SystemUiOverlayStyle.dark, // 2
);
