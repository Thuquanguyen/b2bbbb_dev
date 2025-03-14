import 'dart:ui';

import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/loan/loan_history/loan_history_bloc.dart';
import 'package:b2b/scr/bloc/loan/loan_history/loan_history_events.dart';
import 'package:b2b/scr/bloc/loan/loan_history/loan_history_state.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/extensions/extensions.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/loan_statement_model.dart';
import 'package:b2b/scr/data/repository/loan_repository.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:intl/intl.dart';
import 'package:b2b/scr/presentation/widgets/vp_date_selector.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sticky_headers/sticky_headers.dart';

class LoanHistoryScreenArguments {
  final String? loanId;

  LoanHistoryScreenArguments({this.loanId});
}

class LoanHistoryScreen extends StatefulWidget {
  const LoanHistoryScreen({Key? key}) : super(key: key);
  static const String routeName = 'LoanHistoryScreen';

  @override
  State<StatefulWidget> createState() => LoanHistoryScreenState();
}

class LoanHistoryScreenState extends State<LoanHistoryScreen> {
  GlobalKey filterWidget = GlobalKey();
  double listPaddingTop = 0;
  double filterWidgetHeight = 1;
  bool? isPullDown;
  ScrollController resultListCtl = ScrollController();
  bool allowResultScroll = false;
  ScrollDirection? lastDirection;
  DateTime? fromDate;
  DateTime? toDate;
  late LoanHistoryBloc _bloc;
  List<LoanStatementModel>? _list;
  String? _contractNumber;

  @override
  void initState() {
    super.initState();
    _bloc = LoanHistoryBloc(
      LoanRepository(
        RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
      ),
    );
    toDate = DateTime.now();
    fromDate = DateTime.now().subtract(const Duration(days: 7));
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      filterWidgetHeight = filterWidget.currentContext?.size?.height ?? 1;
      _contractNumber = getArguments<LoanHistoryScreenArguments>(context)?.loanId;
      listPaddingTop = filterWidgetHeight;
      setState(() {});
    });
  }

  // double interpolatedVal() {
  //   return lerpDouble(0.9, 1, (listPaddingTop / filterWidgetHeight)) ?? 1;
  // }

  bool _stateListenWhen(LoanHistoryState previous, LoanHistoryState current) {
    return previous.dataState != current.dataState;
  }

  void _stateListener(BuildContext context, LoanHistoryState state) {
    if (state.dataState == DataState.preload) {
      showLoading();
    } else {
      hideLoading();
    }

    if (state.dataState == DataState.data) {
      if (state.data?.isEmpty == true) {
        showDialogCustom(
          context,
          AssetHelper.icoAuthError,
          AppTranslate.i18n.dialogTitleNotificationStr.localized,
          AppTranslate.i18n.loanHistoryNoDataStr.localized,
          button1: renderDialogTextButton(
            context: context,
            title: AppTranslate.i18n.dialogButtonCloseStr.localized.toUpperCase(),
          ),
        );
        _list = state.data;
        setState(() {});
      } else {
        _list = state.data;
        setState(() {});
      }
    }

    if (state.dataState == DataState.error) {
      showDialogCustom(
        context,
        AssetHelper.icoAuthError,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        state.errorMessage ?? AppTranslate.i18n.errorNoReasonStr.localized,
        button1: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.dialogButtonCloseStr.localized.toUpperCase(),
        ),
      );
    }
  }

  void loadHistory() {
    _bloc.add(
      GetLoanHistoryEvent(
        contractNumber: _contractNumber ?? '',
        fromDate: fromDate != null
            ? DateFormat("dd/MM/yyyy").format(
                fromDate!,
              )
            : '',
        toDate: toDate != null
            ? DateFormat("dd/MM/yyyy").format(
                toDate!,
              )
            : '',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: 'Lịch sử giao dịch',
      actions: [
        AnimatedOpacity(
          duration: const Duration(
            milliseconds: 100,
          ),
          curve: Curves.easeOut,
          opacity: listPaddingTop == 0 ? 1 : 0,
          child: AnimatedScale(
            scale: listPaddingTop == 0 ? 1 : 0.9,
            duration: const Duration(
              milliseconds: 100,
            ),
            curve: Curves.easeOut,
            child: Touchable(
              onTap: () {
                listPaddingTop = filterWidgetHeight;
                setState(() {});
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    ImageHelper.loadFromAsset(
                      AssetHelper.icFilter,
                      width: 18,
                      height: 18,
                      tintColor: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
      child: Stack(
        children: [
          Column(
            children: [
              AnimatedOpacity(
                duration: const Duration(
                  milliseconds: 250,
                ),
                curve: Curves.easeInOutCubic,
                opacity: listPaddingTop == 0 ? 0 : 1,
                child: AnimatedScale(
                  scale: listPaddingTop == 0 ? 0.9 : 1,
                  duration: const Duration(
                    milliseconds: 250,
                  ),
                  curve: Curves.easeInOutCubic,
                  child: Padding(
                    key: filterWidget,
                    padding: const EdgeInsets.only(
                      left: kDefaultPadding,
                      right: kDefaultPadding,
                      bottom: kDefaultPadding,
                    ),
                    child: Container(
                      decoration: kDecoration,
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: VPDateInput(
                                  title: 'Từ ngày',
                                  currentDate: fromDate,
                                  maxDate: toDate,
                                  hint: 'Chọn ngày',
                                  onSelect: (dt) {
                                    fromDate = dt;
                                    setState(() {});
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: kDefaultPadding,
                              ),
                              Expanded(
                                child: VPDateInput(
                                  title: 'Đến ngày',
                                  currentDate: toDate,
                                  minDate: fromDate,
                                  maxDate: DateTime.now(),
                                  hint: 'Chọn ngày',
                                  onSelect: (dt) {
                                    toDate = dt;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: kDefaultPadding,
                          ),
                          RoundedButtonWidget(
                            height: 44,
                            title: 'Tra cứu'.toUpperCase(),
                            onPress: () {
                              loadHistory();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          AnimatedPadding(
            padding: EdgeInsets.only(top: listPaddingTop),
            duration: const Duration(
              milliseconds: 250,
            ),
            curve: Curves.easeInOutCubic,
            child: Padding(
              padding: const EdgeInsets.only(
                left: kDefaultPadding,
                right: kDefaultPadding,
                bottom: kDefaultPadding,
              ),
              child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: kDecoration,
                child: NotificationListener<UserScrollNotification>(
                  onNotification: (notification) {
                    final ScrollDirection direction = notification.direction;
                    if (direction == ScrollDirection.reverse &&
                        listPaddingTop != 0 &&
                        resultListCtl.offset > filterWidgetHeight) {
                      listPaddingTop = 0;
                      setState(() {});
                    } else if (direction == ScrollDirection.idle) {
                      if (lastDirection == ScrollDirection.forward &&
                          resultListCtl.offset == 0 &&
                          listPaddingTop != filterWidgetHeight) {
                        listPaddingTop = filterWidgetHeight;
                        setState(() {});
                      }
                    }
                    lastDirection = direction;
                    return true;
                  },
                  child: BlocConsumer<LoanHistoryBloc, LoanHistoryState>(
                    bloc: _bloc,
                    listenWhen: _stateListenWhen,
                    listener: _stateListener,
                    builder: (context, state) {
                      List<LoanStatementGrouped> grouped = TransactionManage().groupLoanStatement(_list);
                      if (grouped.isEmpty) return const SizedBox();
                      return ListView.builder(
                        // padding: const EdgeInsets.only(bottom: (kDefaultPadding * 2) + 44),
                        padding: EdgeInsets.zero,
                        controller: resultListCtl,
                        itemCount: grouped.length,
                        itemBuilder: (c, i) {
                          return _buildItem(grouped[i]);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   right: 0,
          //   child: Container(
          //     decoration: kDecoration.copyWith(
          //       borderRadius: const BorderRadius.only(
          //         topLeft: Radius.circular(14),
          //         topRight: Radius.circular(14),
          //       ),
          //     ),
          //     padding: const EdgeInsets.all(kDefaultPadding),
          //     child: RoundedButtonWidget(
          //       title: 'Xuất file'.toUpperCase(),
          //       onPress: () {
          //         VPBottomModal.show(
          //           context,
          //           title: 'Chọn định dạng file',
          //           content: ListView.builder(
          //             shrinkWrap: true,
          //             padding: const EdgeInsets.only(bottom: kDefaultPadding),
          //             itemCount: 2,
          //             itemBuilder: (c, i) {
          //               return TouchableRipple(
          //                 onPressed: () {
          //                   // onSelect(context, options![i], i);
          //                   setTimeout(() {
          //                     Navigator.of(context).pop();
          //                   }, 100);
          //                 },
          //                 child: Container(
          //                   padding: const EdgeInsets.symmetric(
          //                     vertical: kDefaultPadding,
          //                   ),
          //                   decoration: const BoxDecoration(
          //                     border: Border(
          //                       bottom: kButtonBorder,
          //                     ),
          //                   ),
          //                   child: Row(
          //                     children: [
          //                       const SizedBox(
          //                         width: 24,
          //                       ),
          //                       const SizedBox(
          //                         width: 16,
          //                       ),
          //                       Text(
          //                         'PDF',
          //                         style: TextStyles.normalText,
          //                       ),
          //                     ],
          //                   ),
          //                 ),
          //               );
          //             },
          //           ),
          //         );
          //       },
          //       height: 44,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildItem(LoanStatementGrouped lg) {
    return StickyHeader(
      header: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        color: const Color.fromRGBO(230, 246, 237, 1),
        child: Row(
          children: [
            Expanded(
              child: Text(
                lg.date,
                style: TextStyles.normalText,
              ),
            ),
          ],
        ),
      ),
      content: Container(
        color: Colors.white,
        child: Column(
          children: [
            ...lg.list.mapIndexed((e, i) => _buildStatementItem(e, i)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatementItem(LoanStatementModel ls, int index) {
    return Container(
      decoration: BoxDecoration(
        color: (index % 2 == 0) ? Colors.white : const Color(0xFFF3F6FD),
      ),
      padding: const EdgeInsets.all(
        kDefaultPadding,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        ls.transactionType ?? '',
                        style: TextStyles.itemText.medium.copyWith(
                          color: AppColors.darkInk500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        ls.theAmount?.title.localization() ?? '',
                        style: TextStyles.itemText,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        ls.theAmount?.amount.getFormattedWithCurrency('VND', showCurrency: true) ?? '',
                        style: TextStyles.itemText.medium.copyWith(
                          color: AppColors.darkInk500,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
