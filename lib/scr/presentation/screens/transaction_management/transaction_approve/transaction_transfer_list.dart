import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manage_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manage_events.dart';
import 'package:b2b/scr/core/extensions/iterable_ext.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_approve/transaction_approve_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_list_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/dashline_painter.dart';
import 'package:b2b/scr/presentation/widgets/transaction_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class TransactionTransferList extends StatelessWidget {
  const TransactionTransferList({
    Key? key,
    required this.transactionBloc,
    this.isFx,
  }) : super(key: key);
  final TransuctionManageBloc transactionBloc;
  final bool? isFx;

  @override
  Widget build(BuildContext context) {
    return getChild();
  }

  Widget getChild() {
    List<TransactionGrouped<TransactionMainModel>>? listData =
        transactionBloc.state.listState?.transactions?.tryCast<TransactionGrouped<TransactionMainModel>>();

    if (transactionBloc.state.listState?.dataState == DataState.preload) {
      return const TransactionListShimmer();
    }

    if (listData == null || listData.isEmpty) {
      TransactionFilterRequest? filterRequest = transactionBloc.state.currentFilterRequest;
      String msg = AppTranslate.i18n.noTransactionWaitApproveStr.localized;

      if (filterRequest != null && filterRequest.isFilterActive) {
        msg = AppTranslate.i18n.noTransactionFollowFiltterStr.localized;
      }

      if (transactionBloc.state.listState?.dataState == DataState.data) {
        return Container(
          padding: const EdgeInsets.only(left: 50, right: 50),
          alignment: Alignment.center,
          child: Text(
            msg,
            style: TextStyles.headerText.semibold,
            textAlign: TextAlign.center,
          ),
        );
      } else {
        return const SizedBox();
      }
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: kDefaultPadding),
      itemCount: listData.length,
      itemBuilder: (context, grpIdx) {
        TransactionGrouped<TransactionMainModel> tg = listData[grpIdx];
        return StickyHeader(
          header: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                stops: [0, 0.9],
                colors: <Color>[
                  Color.fromRGBO(255, 255, 255, 1),
                  Color.fromRGBO(255, 255, 255, 0),
                ],
              ).createShader(bounds);
            },
            child: Container(
              padding: const EdgeInsets.only(
                top: 4,
                left: kDefaultPadding,
                right: kDefaultPadding,
                bottom: kDefaultPadding,
              ),
              color: AppColors.screenBg,
              child: Row(
                children: [
                  Expanded(
                    child: CustomPaint(
                      painter: DashedLinePainter(
                        dashSpace: 3,
                        dashWidth: 5,
                        color: const Color.fromRGBO(196, 196, 196, 1),
                      ),
                      size: const Size(double.infinity, 1),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    tg.date,
                    style: TextStyles.smallText.copyWith(
                      color: AppColors.darkInk400,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          content: Column(
            children: tg.list
                .mapIndexed(
                  (t, transIdx) => Padding(
                    padding: const EdgeInsets.only(
                      left: kDefaultPadding,
                      right: kDefaultPadding,
                      bottom: kDefaultPadding,
                    ),
                    child: TransactionListItem(
                        key: UniqueKey(),
                        bloc: transactionBloc,
                        groupIndex: grpIdx,
                        transIndex: transIdx,
                        onPress: () {
                          _onItemPress(context, t.transCode ?? '');
                        },
                        onLongPress: () {
                          if (isFx != true) {
                            _onItemLongPress(t.transCode ?? '');
                          }
                        }),
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }

  void _onItemPress(
    BuildContext context,
    String transCode,
  ) async {
    if (transactionBloc.state.isSelecting == true) {
      HapticFeedback.mediumImpact();
      transactionBloc.add(
        TransuctionManageSelectSingleEvent(
          transCode: transCode,
        ),
      );
    } else {
      pushNamed(
        context,
        TransactionApproveScreen.routeName,
        arguments: TransactionApproveScreenArguments(
          transactionsCode: [transCode],
          filterRequest: transactionBloc.state.currentFilterRequest,
          actionType: null,
          isFx: isFx,
        ),
        async: true,
      );
      return;
    }
  }

  void _onItemLongPress(
    String transCode,
  ) {
    if (transactionBloc.state.isSelecting == false) {
      HapticFeedback.mediumImpact();
      transactionBloc.add(
        TransuctionManageSelectSingleEvent(
          transCode: transCode,
        ),
      );
    }
  }
}
