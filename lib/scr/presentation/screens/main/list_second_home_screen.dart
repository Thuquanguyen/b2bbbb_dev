import 'dart:math';

import 'package:b2b/commons.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/auth/menu_model.dart';
import 'package:b2b/scr/presentation/screens/main/home_action_manager.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/item_second_action_tile.dart';
import 'package:b2b/scr/presentation/widgets/state_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';

class HomeActionArg {
  HomeActionArg({this.onResult});

  Function? onResult;
}

class ListSecondHomeScreen extends StatefulWidget {
  const ListSecondHomeScreen({Key? key}) : super(key: key);
  static const String routeName = 'list-second-home';

  @override
  _ListSecondHomeScreenState createState() => _ListSecondHomeScreenState();
}

class _ListSecondHomeScreenState extends State<ListSecondHomeScreen> {
  String titleAction = AppTranslate.i18n.listSecondTitleSetupStr.localized;
  bool isShowSelect = false;
  bool isFirst = true;
  bool isFirstListAction = true;

  HomeActionArg? homeActionArg = HomeActionArg();
  StateHandler stateHandler = StateHandler(ListSecondHomeScreen.routeName);
  HomeActionManager homeActionManager = HomeActionManager();

  void showSelectItem() {
    isShowSelect = !isShowSelect;
    if (isShowSelect) {
      titleAction = AppTranslate.i18n.listSecondTitleSaveStr.localized;
    } else {
      titleAction = AppTranslate.i18n.listSecondTitleSetupStr.localized;
    }
    stateHandler.refresh();
  }

  void initListAction(List<MenuModel>? ids) {
    homeActionManager.initActiveAction(ids);
    stateHandler.refresh(holder: 'list-active');
  }

  Future<void> saveListSelected(HomeActionArg args) async {
    if (isShowSelect) {
      if (homeActionManager.checkPreSelectedLength()) {
        bool isSave = await homeActionManager.saveSelectedItem();
        if (isSave) {
          args.onResult?.call();
          showSuccess(AppTranslate.i18n.listSecondMessageSaveSuccessStr.localized);
        } else {
          showSelectItem();
          showSuccess(AppTranslate.i18n.canNotSaveStr.localized);
        }
      } else {
        showSelectItem();
        showError(AppTranslate.i18n.listSecondMessageSelected7Str.localized
            .interpolate({'number': min(7, HomeActionManager().getAllActions().length)}));
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    homeActionManager.getSelectedItem();
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    var args = getArguments(context) as HomeActionArg;

    return AppBarContainer(
      title: AppTranslate.i18n.listSecondTitleUtilitiesListStr.localized,
      onBack: () {
        Navigator.of(context).pop();
      },
      actions: [
        TextButton(
            onPressed: () {
              saveListSelected(args);
              showSelectItem();
            },
            child: StateBuilder(
              routeName: ListSecondHomeScreen.routeName,
              builder: () => Text(
                titleAction,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 16),
              ),
            ))
      ],
      child: StateBuilder(
        builder: () => Container(
          height: SizeConfig.screenHeight,
          color: Colors.white,
          padding: EdgeInsets.only(bottom: SizeConfig.bottomSafeAreaPadding),
          child: _listItemWidget(),
        ),
        routeName: ListSecondHomeScreen.routeName,
        holder: 'list-active',
      ),
      hideBackButton: false,
      appBarType: AppBarType.NORMAL,
    );
  }

  Widget _listItemWidget() {
    final List<HomeActionItem> _listHomeActive = homeActionManager.getAllActions();

    return ListView.builder(
        padding: const EdgeInsets.only(top: 10),
        itemBuilder: (context, index) {
          final HomeActionItem itemAction = _listHomeActive[index];
          return StateBuilder(
              holder: itemAction.icon,
              builder: () {
                return ItemSecondActionTitle(
                    secondModel: itemAction,
                    onSelect: (value) {
                      if (isShowSelect) {
                        if (!itemAction.isPreSelected) {
                          if (homeActionManager.checkPreSelectedLength()) {
                            showError(AppTranslate.i18n.homeActionMessageHaveSelected7Str.localized
                                .interpolate({'number': min(7, HomeActionManager().getAllActions().length)}));
                          } else {
                            itemAction.isPreSelected = true;
                          }
                        } else {
                          itemAction.isPreSelected = false;
                        }
                        stateHandler.refresh(holder: itemAction.icon);
                      } else {
                        itemAction.onTap?.call(context);
                      }
                    },
                    isSetting: isShowSelect);
              },
              routeName: ListSecondHomeScreen.routeName);
        },
        itemCount: _listHomeActive.length);
  }
}
