import 'package:equatable/equatable.dart';

import '../../data/model/notification/notification_promote_content.dart';
import '../data_state.dart';

class NotificationPromotionState extends Equatable {
  DataState? dataState;
  final List<NotificationPromoteContent>? listPromoteContent;
  final int? currentPage;
  final bool? calLoadMore;

  NotificationPromotionState(
      {this.dataState,
      this.listPromoteContent,
      this.currentPage = 1,
      this.calLoadMore = true});

  NotificationPromotionState copyWith(
      {DataState? dataState,
      List<NotificationPromoteContent>? listPromoteContent,
      int? currentPage,
      bool? calLoadMore}) {
    return NotificationPromotionState(
      dataState: dataState ?? this.dataState,
      listPromoteContent: listPromoteContent ?? this.listPromoteContent,
      currentPage: currentPage ?? this.currentPage,
      calLoadMore: calLoadMore ?? this.calLoadMore,
    );
  }

  @override
  List<Object?> get props => [dataState, listPromoteContent];
}
