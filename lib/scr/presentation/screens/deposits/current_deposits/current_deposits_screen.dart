import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/deposits/current_deposits/current_deposits_bloc.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/presentation/screens/deposits/current_deposits/current_deposit_detail_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/widgets/deposit_list.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/transaction_filter/filter_widget.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/dashline_painter.dart';
import 'package:b2b/scr/presentation/widgets/transaction_filter/transaction_filter.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:b2b/utilities/transaction/transaction_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurrentDepositsScreen extends StatefulWidget {
  const CurrentDepositsScreen({Key? key}) : super(key: key);
  static const String routeName = 'current-deposits-screen';
  static const String RELOAD_LIST_EVENT = 'CurrentDepositsScreen_reloadlist';

  @override
  State<StatefulWidget> createState() => CurrentDepositsScreenState();
}

class CurrentDepositsScreenState extends State<CurrentDepositsScreen> with TickerProviderStateMixin {
  late TabController tabController;
  late AnimationController filterCollapsibleController;
  late Animation<double> filterCollapsibleSize;
  late CurrentDepositsBloc _bloc;
  final GlobalKey<TransactionFilterWidgetState> _filterWidget = GlobalKey();
  bool isFilterShow = false;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    filterCollapsibleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    filterCollapsibleSize = CurvedAnimation(
      parent: filterCollapsibleController,
      curve: Curves.easeInOutCirc,
    );
    _bloc = context.read<CurrentDepositsBloc>();
    _bloc.add(CurrentDepositsClearFilterEvent());
    _bloc.add(CurrentDepositsGetListEvent());
    // filterCollapsibleController.reverse(from: 0);
    MessageHandler().addListener(
      CurrentDepositsScreen.RELOAD_LIST_EVENT,
      handleReloadData,
    );
  }

  void handleReloadData() {
    _bloc.add(CurrentDepositsGetListEvent());
  }

  @override
  void dispose() {
    MessageHandler().removeListener(
      CurrentDepositsScreen.RELOAD_LIST_EVENT,
      handleReloadData,
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      appBarType: AppBarType.HOME,
      showBackButton: true,
      onTap: () {
        hideKeyboard(context);
      },
      title: AppTranslate.i18n.cdsTitleStr.localized,
      child: BlocConsumer<CurrentDepositsBloc, CurrentDepositsState>(
        listenWhen: (p, c) => p.list?.dataState != c.list?.dataState,
        listener: _stateListener,
        builder: _contentBuilder,
      ),
      actions: [_buildFilterButton()],
    );
  }

  void _stateListener(BuildContext context, CurrentDepositsState state) {
    if (state.list?.dataState == DataState.preload) {
      showLoading();
    } else {
      hideLoading();
    }

    if (state.list?.dataState == DataState.error) {
      showDialogErrorForceGoBack(
        context,
        state.list?.error ?? '',
        () {
          Navigator.of(context).pop();
        },
        barrierDismissible: false,
      );
    }
  }

  Widget _contentBuilder(BuildContext context, CurrentDepositsState state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TransactionFilterWidget(
          key: _filterWidget,
          onFilterChange: handleFilterChange,
          hideServiceList: true,
          hideWarning: true,
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: kDefaultPadding,
            left: kDefaultPadding,
            right: kDefaultPadding,
            bottom: 12,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.boxShadow,
                  offset: const Offset(0, 4),
                  blurRadius: 10,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
            child: TabBar(
              controller: tabController,
              unselectedLabelColor: AppColors.darkInk300,
              labelColor: AppColors.gPrimaryColor,
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: AppColors.gPrimaryColor,
              tabs: [
                Tab(
                  height: 26,
                  child: Text(
                    AppTranslate.i18n.cdsOnlineDepositsStr.localized,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Tab(
                  height: 26,
                  child: Text(
                    AppTranslate.i18n.cdsOfflineDepositsStr.localized,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.4,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: tabController,
            children: [
              if (state.list?.dataState == DataState.preload)
                Container()
              else
                DepositList(
                  list: TransactionHelper.groupSavingByDate(
                      state.list?.list?.where((s) => s.isOnline == true).toList() ?? []),
                  onTap: (sa) {
                    _bloc.add(CurrentDepositsGetDetailEvent(accountNo: sa.accountNo));
                    Navigator.of(context).pushNamed(CurrentDepositDetailScreen.routeName);
                  },
                  isFiltering: state.filterRequest?.isFilterActive == true,
                ),
              DepositList(
                list: TransactionHelper.groupSavingByDate(
                    state.list?.list?.where((s) => s.isOnline == false).toList() ?? []),
                isFiltering: state.filterRequest?.isFilterActive == true,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButton() {
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
  }

  void handleFilterChange(TransactionFilterRequest? request) {
    _bloc.add(
      CurrentDepositsGetListEvent(filterRequest: request),
    );
    if (isFilterShow) {
      _filterWidget.currentState?.hideFilter();
      isFilterShow = false;
    }
    FocusScope.of(context).unfocus();
    setState(() {});
  }
}
