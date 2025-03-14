import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/data/model/transaction_base_model.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:equatable/equatable.dart';

class TransuctionManageState extends Equatable {
  final TransuctionManageListState? listState;
  final String? selectedCategory;
  final bool isSelecting;
  final bool isFiltering;
  final bool isFilterShow;
  final List<NameModel>? filterServiceTypes;
  final TransactionFilterRequest? currentFilterRequest;
  final bool shouldShowFilterBtn;
  final bool shouldShowSelectAllBtn;

  const TransuctionManageState({
    this.listState,
    this.selectedCategory,
    this.isSelecting = false,
    this.isFiltering = false,
    this.isFilterShow = false,
    this.filterServiceTypes,
    this.currentFilterRequest,
    this.shouldShowFilterBtn = false,
    this.shouldShowSelectAllBtn = false,
  });

  TransuctionManageState copyWith({
    TransuctionManageListState? listState,
    String? selectedCategory,
    bool? isSelecting,
    bool? isFiltering,
    List<NameModel>? filterServiceTypes,
    TransactionFilterRequest? currentFilterRequest,
    bool? shouldShowFilterBtn,
    bool? shouldShowSelectAllBtn,
  }) {
    TransuctionManageState x = TransuctionManageState(
      listState: listState ?? this.listState,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isSelecting: isSelecting ?? this.isSelecting,
      isFiltering: isFiltering ?? this.isFiltering,
      filterServiceTypes: filterServiceTypes ?? this.filterServiceTypes,
      currentFilterRequest: currentFilterRequest ?? this.currentFilterRequest,
      shouldShowFilterBtn: shouldShowFilterBtn ?? this.shouldShowFilterBtn,
      shouldShowSelectAllBtn:
          shouldShowSelectAllBtn ?? this.shouldShowSelectAllBtn,
    );
    return x;
  }

  @override
  List<Object?> get props => [
        listState,
        selectedCategory,
        isSelecting,
        isFiltering,
        filterServiceTypes,
        currentFilterRequest,
        shouldShowFilterBtn,
        shouldShowSelectAllBtn,
      ];
}

class TransuctionManageListState<T extends TransactionBaseModel> {
  final DataState? dataState;
  final List<TransactionGrouped<T>>? transactions;
  final List<String> selected;
  final String? errorMessage;

  TransuctionManageListState({
    this.dataState,
    this.transactions,
    this.selected = const [],
    this.errorMessage,
  });

  TransuctionManageListState copyWith({
    DataState? dataState,
    List<TransactionGrouped<T>>? transactions,
    List<String>? selected,
    String? errorMessage,
  }) {
    return TransuctionManageListState(
      dataState: dataState ?? this.dataState,
      transactions: transactions ?? this.transactions,
      selected: selected ?? this.selected,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
