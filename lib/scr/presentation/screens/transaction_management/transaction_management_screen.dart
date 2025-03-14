import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manage_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manage_events.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manage_state.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/data/repository/payroll_repository.dart';
import 'package:b2b/scr/data/repository/saving_repository.dart';
import 'package:b2b/scr/data/repository/transaction_manager_repository.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/bill_approve/bill_approve_list.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/payroll_approve/payroll_approve_list.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_approve/transaction_approve_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/saving_approve/transaction_saving_list.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_approve/transaction_transfer_list.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/dashline_painter.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/rounded_button_widget.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/transaction_filter/transaction_filter.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionManageScreenArguments {
  final TransactionFilterCategory selectedCategory;

  TransactionManageScreenArguments({
    required this.selectedCategory,
  });
}

class TransactionManageScreen extends StatefulWidget {
  const TransactionManageScreen({Key? key}) : super(key: key);
  static const String routeName = "TransactionManagerScreen";
  static const String TRANSACTION_ACTION_COMPLETED = "TRANSACTION_ACTION_COMPLETED";
  static const String TRANSACTION_NEED_RELOAD = "TRANSACTION_NEED_RELOAD";

  @override
  _TransactionManageScreenState createState() => _TransactionManageScreenState();
}

class _TransactionManageScreenState extends State<TransactionManageScreen> with TickerProviderStateMixin {
  late TransuctionManageBloc _bloc;
  late AnimationController footerActionCollapsibleCtl;
  late Animation<double> footerActionCollapsibleSize;

  bool shouldShowMultipleSelect = false;

  final GlobalKey<TransactionFilterWidgetState> _filterWidget = GlobalKey();
  final GlobalKey _footerActionWidget = GlobalKey();
  double _footerActionHeight = 0;
  bool isFilterShow = false;
  bool isFooterActionShow = false;
  bool isFooterActionShowInProgress = false;
  TransactionFilterCategory? selectedCategory;

  @override
  void initState() {
    super.initState();
    _bloc = TransuctionManageBloc(
      savingRepo: SavingRepository(
        RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
      ),
      transManangerRepository: TransactionManagerRepository(
        RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
      ),
      payrollRepo: PayrollRepository(
        RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
      ),
    );
    _bloc.add(TransuctionManageClearEvent());
    MessageHandler().addListener(TransactionManageScreen.TRANSACTION_ACTION_COMPLETED, handleActionComplete);
    MessageHandler().addListener(TransactionManageScreen.TRANSACTION_NEED_RELOAD, reloadCallBack);
    footerActionCollapsibleCtl = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    footerActionCollapsibleSize = CurvedAnimation(
      parent: footerActionCollapsibleCtl,
      curve: Curves.easeInOutCirc,
    );
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      TransactionManageScreenArguments? args = getArguments<TransactionManageScreenArguments>(context);
      selectedCategory = args?.selectedCategory ?? TransactionManage().catList().first;
      // _bloc.add(TransuctionManageStartEvent(category: selectedCategory));
      _filterWidget.currentState
          ?.changeCategory(selectedCategory != null ? selectedCategory!.key : TransactionManage().catList().first.key);
      _filterWidget.currentState?.filterKey.currentState?.clearFilter();
    });
  }

  void showFooter() {
    if (!isFooterActionShowInProgress) {
      isFooterActionShowInProgress = true;
      footerActionCollapsibleCtl.forward(from: 0).then((_) {
        setState(() {
          _footerActionHeight = (_footerActionWidget.currentContext?.size?.height ?? 16) - 16;
          isFooterActionShowInProgress = false;
          isFooterActionShow = true;
        });
      });
    }
  }

  void hideFooter() {
    if (!isFooterActionShowInProgress) {
      isFooterActionShowInProgress = true;
      footerActionCollapsibleCtl.reverse(from: 1).then((_) {
        setState(() {
          _footerActionHeight = 0;
          isFooterActionShowInProgress = false;
          isFooterActionShow = false;
        });
      });
    }
  }

  void reloadCallBack() {
    _bloc.add(TransuctionManageRefreshEvent());
  }

  void handleActionComplete(dynamic data) async {
    if (data is CommitActionType && data != CommitActionType.APPROVE) {
      await Future.delayed(const Duration(milliseconds: 100));
      showDialogCustom(
        SessionManager().getContext!,
        AssetHelper.icoStatementComplate,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        data == CommitActionType.REJECT
            ? AppTranslate.i18n.tasRejectedToastStr.localized
            : AppTranslate.i18n.tasCanceledToastStr.localized,
        barrierDismissible: false,
        button1: renderDialogTextButton(
          context: SessionManager().getContext!,
          title: AppTranslate.i18n.dialogButtonCloseStr.localized,
        ),
      );
    }
  }

  @override
  void dispose() {
    MessageHandler().removeListener(TransactionManageScreen.TRANSACTION_ACTION_COMPLETED, handleActionComplete);
    MessageHandler().removeListener(TransactionManageScreen.TRANSACTION_NEED_RELOAD, reloadCallBack);
    footerActionCollapsibleCtl.dispose();
    _bloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: AppTranslate.i18n.transactionManagementStr.localized,
      isShowKeyboardDoneButton: true,
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: onRefresh,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.only(top: kDefaultPadding),
          child: _buildContent(),
        ),
      ),
      appBarType: AppBarType.HOME,
      showBackButton: true,
      actions: _buildAction(),
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    );
  }

  List<Widget> _buildAction() {
    final buttons = [
      BlocConsumer<TransuctionManageBloc, TransuctionManageState>(
        bloc: _bloc,
        buildWhen: (old, current) {
          return old.shouldShowSelectAllBtn != current.shouldShowSelectAllBtn ||
              old.isSelecting != current.isSelecting ||
              old.listState?.selected != current.listState?.selected;
        },
        listener: (context, state) {},
        builder: (context, state) {
          String title = AppTranslate.i18n.selectedStr.localized;
          Function selectBtnHandler = () {};
          if (state.shouldShowSelectAllBtn == false || isFilterShow == true) {
            return const SizedBox(
              width: 0,
            );
          }

          if (state.isSelecting == true) {
            if (_bloc.isAllSelected == true) {
              selectBtnHandler = () {
                _bloc.add(TransuctionManageClearSelectEvent());
              };
              title = AppTranslate.i18n.unSelectedAllStr.localized;
            } else {
              selectBtnHandler = () {
                _bloc.add(TransuctionManageSelectAllEvent());
              };
              title = AppTranslate.i18n.selectedAllStr.localized;
            }
          } else {
            selectBtnHandler = () {
              _bloc.add(TransuctionManageEnableSelectEvent());
            };
            title = AppTranslate.i18n.selectedStr.localized;
          }

          return Touchable(
            onTap: () {
              selectBtnHandler();
            },
            child: Row(
              children: [
                Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: DashedBorderPainter(color: AppColors.filterBtnBorder, dashSpace: 2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          ImageHelper.loadFromAsset(
                            AssetHelper.checkAll,
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            title, // Equal height
                            style: TextStyles.headerItemText.regular,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: kDefaultPadding,
                ),
              ],
            ),
          );
        },
      ),
      BlocConsumer<TransuctionManageBloc, TransuctionManageState>(
        bloc: _bloc,
        buildWhen: (old, current) {
          return old.shouldShowFilterBtn != current.shouldShowFilterBtn || old.isSelecting != current.isSelecting;
        },
        listener: (context, state) {},
        builder: (context, state) {
          if (state.shouldShowFilterBtn == false || state.isSelecting) {
            return const SizedBox(
              width: 0,
            );
          }
          String? title;
          if (state.isFiltering == true) {
            title = AppTranslate.i18n.closeFilterStr.localized;
          } else {
            title = null;
          }

          return Touchable(
            onTap: () {
              if (isFilterShow) {
                _filterWidget.currentState?.hideFilter();
              } else {
                _filterWidget.currentState?.showFilter();
              }
              isFilterShow = !isFilterShow;
              setState(() {});
            },
            child: Row(
              children: [
                Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: DashedBorderPainter(color: AppColors.filterBtnBorder, dashSpace: 2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          ImageHelper.loadFromAsset(
                            AssetHelper.icFilter,
                            width: 18,
                            height: 18,
                          ),
                          if (isFilterShow)
                            const SizedBox(
                              width: 4,
                            ),
                          if (isFilterShow)
                            Text(
                              AppTranslate.i18n.dfBtnCloseStr.localized,
                              // Equal height
                              style: TextStyles.headerItemText.regular,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: kDefaultPadding,
                ),
              ],
            ),
          );
        },
      )
    ];
    return [
      Row(
        children: buttons,
      )
    ];
  }

  Widget _buildContent() {
    return BlocConsumer<TransuctionManageBloc, TransuctionManageState>(
      bloc: _bloc,
      buildWhen: (old, current) {
        return (old.isFiltering != current.isFiltering) ||
            (old.selectedCategory != current.selectedCategory) ||
            (old.listState?.dataState != current.listState?.dataState);
      },
      listenWhen: (old, current) {
        return (old.isFiltering != current.isFiltering) || (old.listState?.dataState != current.listState?.dataState);
      },
      listener: (context, state) {
        if (state.listState?.dataState == DataState.preload) {
          showLoading();
        } else {
          hideLoading();
        }

        if (state.listState?.dataState == DataState.error) {
          showDialogErrorForceGoBack(
            context,
            (state.listState?.errorMessage ?? ''),
            () {
              Navigator.of(context).pop();
            },
            barrierDismissible: false,
          );
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TransactionFilterWidget(
                  key: _filterWidget,
                  onFilterChange: handleFilterChange,
                  serviceList: state.filterServiceTypes,
                  catList: TransactionManage().catList().map((c) {
                    return c.copyWith(onTap: (TransactionFilterCategory cat) {
                      if (cat.key == selectedCategory?.key) return;
                      selectedCategory = cat;
                      if (isFilterShow == true) {
                        _filterWidget.currentState?.hideFilter();
                        isFilterShow = false;
                      }
                      if (isFooterActionShow == true) {
                        hideFooter();
                      }
                      setState(() {});
                      _filterWidget.currentState?.changeCategory(cat.key);
                      onChangeCateogry();
                    });
                  }).toList(),
                ),
                // const SizedBox(
                //   height: 8,
                // ),
                if (state.isFiltering == true)
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                Expanded(child: _listContent(state)),
                SizeTransition(
                  sizeFactor: footerActionCollapsibleSize,
                  child: SizedBox(
                    height: _footerActionHeight,
                  ),
                ),
              ],
            ),
            Positioned(
              child: _approveTransactionView(state),
              bottom: 0,
              left: 0,
              right: 0,
            ),
          ],
        );
      },
    );
  }

  void handleFilterChange(TransactionFilterRequest request) {
    _bloc.add(
      TransuctionManageUpdateFilterEvent(
        filterRequest: request,
        category: selectedCategory,
      ),
    );
    if (isFilterShow) {
      _filterWidget.currentState?.hideFilter();
      isFilterShow = false;
    }
    FocusScope.of(context).unfocus();
    setState(() {});
  }

  Widget _listContent(TransuctionManageState state) {
    Widget r;
    if (selectedCategory?.key == TransactionManage.savingCat.key) {
      r = TransactionSavingList(
        transactionBloc: _bloc,
      );
    } else if (selectedCategory?.key == TransactionManage.payrollCat.key) {
      r = TransactionPayrollList(
        transactionBloc: _bloc,
      );
    } else if (selectedCategory?.key == TransactionManage.billCat.key) {
      r = BillApproveList(
        transactionBloc: _bloc,
      );
    } else {
      r = TransactionTransferList(
        transactionBloc: _bloc,
        isFx: selectedCategory?.key == TransactionManage.fxCat.key,
      );
    }
    return r;
  }

  Widget _approveTransactionView(TransuctionManageState state) {
    return BlocConsumer<TransuctionManageBloc, TransuctionManageState>(
        bloc: _bloc,
        listenWhen: (o, c) {
          return o.isSelecting != c.isSelecting || o.listState?.selected != c.listState?.selected;
        },
        listener: (context, state) {
          if (state.isSelecting == true && isFooterActionShow == false) {
            showFooter();
          } else if (state.isSelecting != true && isFooterActionShow == true) {
            hideFooter();
          }
        },
        buildWhen: (o, c) {
          return o.isSelecting != c.isSelecting || o.listState?.selected != c.listState?.selected;
        },
        builder: (context, state) {
          List<String> selectedTransCode = state.listState?.selected ?? [];
          return SizeTransition(
            sizeFactor: footerActionCollapsibleSize,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              key: _footerActionWidget,
              child: Container(
                padding: const EdgeInsets.only(
                    bottom: 24, top: kDefaultPadding, left: kDefaultPadding, right: kDefaultPadding),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
                  boxShadow: [kBoxShadowCenterContainer],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: '${AppTranslate.i18n.selected1Str.localized}:  ',
                            style: TextStyles.smallText.copyWith(
                              color: const Color(0xff666667),
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${selectedTransCode.length} ${AppTranslate.i18n.transactionStr.localized}',
                                style: TextStyles.itemText.copyWith(
                                  color: const Color(0xff666667),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Touchable(
                          onTap: () {
                            _bloc.add(TransuctionManageClearSelectEvent());
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.clear,
                                size: 15.toScreenSize,
                                color: const Color(0xffFF6763),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                AppTranslate.i18n.unSelectedAllStr.localized,
                                style: TextStyles.itemText.copyWith(color: const Color(0xffFF6763)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    Opacity(
                      opacity: selectedTransCode.isNotEmpty ? 1 : 0.6,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: RoundedButtonWidget(
                              title: RolePermissionManager().isChecker()
                                  ? AppTranslate.i18n.cancelStr.localized.toUpperCase()
                                  : AppTranslate.i18n.cancelTransactionStr.localized.toUpperCase(),
                              height: 44,
                              radiusButton: 40,
                              onPress: () {
                                if (selectedTransCode.isNotEmpty) {
                                  navigateToApproveScreen(
                                    context,
                                    RolePermissionManager().isChecker()
                                        ? CommitActionType.REJECT
                                        : CommitActionType.CANCEL,
                                  );
                                }
                              },
                              backgroundButton: const Color(0xffFF6763),
                            ),
                          ),
                          if (RolePermissionManager().isChecker())
                            const SizedBox(
                              width: kDefaultPadding,
                            ),
                          if (RolePermissionManager().isChecker())
                            Expanded(
                              flex: 2,
                              child: RoundedButtonWidget(
                                title: AppTranslate.i18n.approveStr.localized.toUpperCase(),
                                height: 44,
                                radiusButton: 40,
                                backgroundButton: const Color(0xff00B74F),
                                onPress: () {
                                  if (selectedTransCode.isNotEmpty) {
                                    navigateToApproveScreen(context, CommitActionType.APPROVE);
                                  }
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> navigateToApproveScreen(
    BuildContext context,
    CommitActionType? actionType,
  ) async {
    pushNamed(
      context,
      TransactionApproveScreen.routeName,
      arguments: TransactionApproveScreenArguments(
        transactionsCode: _bloc.state.listState?.selected ?? [],
        filterRequest: _bloc.state.currentFilterRequest,
        actionType: actionType,
        isFx: selectedCategory?.key == TransactionManage.fxCat.key,
      ),
      async: true,
    );
    // checkReload();
  }

  Future<void> onRefresh() async {
    _bloc.add(TransuctionManageRefreshEvent());
    FocusScope.of(context).unfocus();
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void onChangeCateogry() async {
    // _bloc.add(TransuctionManageStartEvent(category: selectedCategory));
    _filterWidget.currentState?.filterKey.currentState?.clearFilter();
    FocusScope.of(context).unfocus();
  }
}
