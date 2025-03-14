import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/notification/notification_event.dart';
import 'package:b2b/scr/bloc/notification/notification_state.dart';
import 'package:b2b/scr/data/model/notification/notification_promote_content.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/item_shimmer.dart';
import 'package:flutter/material.dart';

import '../../../bloc/notification/notification_bloc.dart';
import '../../../core/extensions/palette.dart';
import '../../../core/extensions/textstyles.dart';
import '../../../core/language/app_translate.dart';
import '../../widgets/touchable.dart';
import 'notification_promote_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationPagePromote extends StatefulWidget {
  const NotificationPagePromote({
    Key? key,
  }) : super(key: key);

  @override
  _NotificationPagePromoteState createState() => _NotificationPagePromoteState();
}

class _NotificationPagePromoteState extends State<NotificationPagePromote>
    with AutomaticKeepAliveClientMixin<NotificationPagePromote> {
  late NotificationBloc _notificationBloc;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    _scrollController.addListener(_scrollListener);
    _notificationBloc.add(
      GetListPromoteEvent(page: 1),
    );
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 500) {
      if (_notificationBloc.state.promotionState?.calLoadMore == true &&
          _notificationBloc.state.promotionState?.dataState != DataState.preload) {
        _notificationBloc.add(
          GetListPromoteEvent(page: (_notificationBloc.state.promotionState?.currentPage ?? 1) + 1),
        );
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.removeListener(_scrollListener);
  }

  Widget buildLoading() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildItemLoading(),
            const SizedBox(
              height: 16,
            ),
            _buildItemLoading(),
            const SizedBox(
              height: 16,
            ),
            _buildItemLoading(),
          ],
        ),
      ),
    );
  }

  Widget _buildItemLoading() {
    return AppShimmer(Column(
      children: [
        itemShimmer(height: 200),
        const SizedBox(
          width: 10,
        ),
        itemShimmer(height: 10),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state.promotionState?.dataState == DataState.preload && state.promotionState?.currentPage == 1) {
          return buildLoading();
        }
        if (state.promotionState?.dataState != DataState.preload &&
            state.promotionState?.currentPage == 1 &&
            (state.promotionState?.listPromoteContent == null || state.promotionState!.listPromoteContent!.isEmpty)) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppTranslate.i18n.messageNoNotificationStr.localized,
                  style: TextStyles.headerText.slateGreyColor,
                ),
                const SizedBox(
                  height: 30,
                ),
                Touchable(
                  onTap: () {
                    _notificationBloc.add(
                      GetListPromoteEvent(
                        page: (1),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Icon(Icons.refresh, color: AppColors.gPrimaryColor, size: 30),
                      Text(
                        AppTranslate.i18n.retryStr.localized,
                        style: TextStyles.buttonText.setColor(AppColors.gPrimaryColor),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: () async {
            _notificationBloc.add(
              GetListPromoteEvent(page: 1),
            );
            await Future.delayed(const Duration(seconds: 5));
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 0),
            controller: _scrollController,
            itemBuilder: (BuildContext context, int index) => Container(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: NotificationItemPromote(
                data: state.promotionState?.listPromoteContent?[index],
              ),
            ),
            itemCount: state.promotionState?.listPromoteContent?.length,
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
