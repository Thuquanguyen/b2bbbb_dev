import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/notification/notification_bloc.dart';
import 'package:b2b/scr/bloc/notification/notification_event.dart';
import 'package:b2b/scr/bloc/notification/notification_state.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/notification/account_setting_noti_model.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/setting_account_item.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';

class ListAccountSettingScreen extends StatefulWidget {
  const ListAccountSettingScreen({Key? key}) : super(key: key);

  static const String routeName = 'list-account-setting-screen';

  @override
  _ListAccountSettingScreenState createState() =>
      _ListAccountSettingScreenState();
}

class _ListAccountSettingScreenState extends State<ListAccountSettingScreen> {
  bool reload = false;
  bool isLoaded = true;
  final StateHandler _stateHandler =
      StateHandler(ListAccountSettingScreen.routeName);
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool isFirstReload = true;

  Future<void> _pullRefresh() async {
    context.read<NotificationBloc>().add(GetListAccountSettingNotiEvent());
    await Future.delayed(const Duration(milliseconds: 500));
    int dem = 0;
    while (true) {
      if (isLoaded || dem >= 30) {
        break;
      }
      dem++;
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    context.read<NotificationBloc>().add(GetListAccountSettingNotiEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
      listenWhen: (previous, current) =>
          (previous.listAccountSettingState !=
              current.listAccountSettingState) ||
          (previous.registerAccountNotificationState !=
              current.registerAccountNotificationState) ||
          (previous.dereRegisterAccountNotificationState !=
              current.dereRegisterAccountNotificationState),
      listener: (context, state) {
        DataState? registerAccountState =
            state.registerAccountNotificationState;
        DataState? dereRegisterAccountState =
            state.dereRegisterAccountNotificationState;
        print(
            '12121212121212121212 = ${state.registerAccountNotificationState}');
        if ([DataState.preload].contains(registerAccountState) ||
            [DataState.preload].contains(dereRegisterAccountState)) {
          reload = true;
          _stateHandler.refresh();
        } else if (state.listAccountSettingState == DataState.preload) {
          isLoaded = false;
        } else if (state.listAccountSettingState == DataState.data) {
          isLoaded = true;
        }
        if (isFirstReload && state.listAccountSettingState == DataState.data) {
          isFirstReload = false;
        }

        if ((state.registerAccountNotificationState == DataState.data) ||
            (state.dereRegisterAccountNotificationState == DataState.data)) {
          reload = false;
          _stateHandler.refresh();
        } else if ((state.registerAccountNotificationState ==
                DataState.error) ||
            (state.dereRegisterAccountNotificationState == DataState.error)) {
          if (state.errorMessage.isNotNullAndEmpty) {
            showDialogCustom(
                context,
                AssetHelper.icoAuthError,
                AppTranslate.i18n.dialogTitleNotificationStr.localized,
                state.errorMessage ?? '',
                button1: renderDialogTextButton(
                    context: context,
                    title: AppTranslate.i18n.dialogButtonCloseStr.localized,
                    onTap: () {
                      bool enable =
                          state.accountSettingNotiModel?.enable ?? false;
                      context.read<NotificationBloc>().add(
                          UpdateListAccountSettingEvent(
                              accountSettingNotiModel: state
                                  .accountSettingNotiModel
                                  ?.copyWith(enable: enable)));
                      _stateHandler.refresh();
                    }),
                showCloseButton: false);
          }
          reload = false;
          _stateHandler.refresh();
        }
      },
      builder: (context, state) {
        Widget _container = StateBuilder(
            builder: () => AppBarContainer(
                  appBarType: AppBarType.POPUP,
                  actions: reload
                      ? [
                          Center(
                            child: Container(
                              margin: const EdgeInsets.only(left: 5, right: 15),
                              height: 20,
                              width: 20,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1.5,
                              ),
                            ),
                          ),
                        ]
                      : [],
                  child: _buildContent(state),
                  title: AppTranslate.i18n.titleAccountGetNotiStr.localized,
                ),
            routeName: ListAccountSettingScreen.routeName);
        return _container;
      },
    );
  }

  Widget _itemShimmer() {
    return AppShimmer(Container(
      child: Row(
        children: [
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 10,
                width: 50,
                decoration: kDecorationShimmer,
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                height: 10,
                width: 100,
                decoration: kDecorationShimmer,
              ),
            ],
          )),
          Container(
            height: 15,
            width: 30,
            decoration: kDecorationShimmer,
          )
        ],
      ),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black12, width: 1))),
      padding: const EdgeInsets.only(top: 18, bottom: 18),
      margin: const EdgeInsets.only(
        left: kDefaultPadding,
        right: 24,
      ),
    ));
  }

  Widget _buildContent(NotificationState state) {
    Widget _container = Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding, right: kDefaultPadding, bottom: 19),
      child: state.listAccountSettingState == DataState.error
          ? Center(
              child: Container(
                child: Text(
                  state.errorMessage ?? '',
                  style: TextStyles.itemText.slateGreyColor,
                  textAlign: TextAlign.center,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppTranslate.i18n.titleAccountGetNotiStr.localized,
                          style: TextStyles.itemText.slateGreyColor,
                        ),
                      ),
                      Text(
                        AppTranslate.i18n.titleOnOffStr.localized,
                        style: TextStyles.itemText.slateGreyColor,
                      )
                    ],
                  ),
                  color: const Color.fromRGBO(230, 246, 237, 1),
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding, vertical: 5),
                ),
                Expanded(
                    child: ((state.listAccountSettingState != DataState.data) &&
                            isFirstReload)
                        ? ListView.builder(
                            itemBuilder: (context, index) {
                              return _itemShimmer();
                            },
                            shrinkWrap: true,
                            itemCount: 5,
                            padding: const EdgeInsets.all(0),
                          )
                        : RefreshIndicator(
                            key: _refreshIndicatorKey,
                            backgroundColor: Colors.white,
                            onRefresh: _pullRefresh,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(0),
                              itemBuilder: (context, index) {
                                AccountSettingNotiModel? settingModel =
                                    state.listAccountSetting?[index];
                                if (settingModel == null) {
                                  return const SizedBox();
                                }
                                return SettingAccountItem(
                                  accountSettingNotiModel:
                                      state.listAccountSetting?[index],
                                  callBack: (value) {
                                    if (value) {
                                      context
                                          .read<NotificationBloc>()
                                          .add(RegisterAccountNotificationEvent(
                                            secureTrans:
                                                settingModel.secureTrans,
                                            accountNumber:
                                                settingModel.accountNumber,
                                            accountSettingNotiModel:
                                                settingModel,
                                          ));
                                    } else {
                                      context.read<NotificationBloc>().add(
                                              DereRegisterAccountNotificationEvent(
                                            secureTrans:
                                                settingModel.secureTrans,
                                            accountNumber:
                                                settingModel.accountNumber,
                                            aggregateId:
                                                settingModel.aggregateId,
                                            accountSettingNotiModel:
                                                settingModel,
                                          ));
                                    }
                                  },
                                );
                              },
                              itemCount: state.listAccountSetting?.length ?? 0,
                            ),
                          )),
              ],
            ),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(14))),
    );
    return _container;
  }
}
