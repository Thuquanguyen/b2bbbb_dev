part of 'commerce_bloc.dart';

class CommerceState extends Equatable {
  bool? isFiltering = false;
  DataState? dataState;
  CommerceFilterRequest? filterRequest;
  CommerceContractListState? contractListState;
  List<dynamic>? dataList;
  String? errMessage;

  CommerceState({
    this.isFiltering,
    this.dataState,
    this.filterRequest,
    this.contractListState,
    this.dataList,
    this.errMessage,
  });

  CommerceState copyWith({
    bool? isFiltering,
    DataState? dataState,
    CommerceFilterRequest? filterRequest,
    CommerceContractListState? contractListState,
    List<dynamic>? dataList,
    String? errMessage,
  }) {
    return CommerceState(
        isFiltering: isFiltering ?? this.isFiltering,
        dataState: dataState ?? this.dataState,
        filterRequest: filterRequest ?? this.filterRequest,
        contractListState: contractListState ?? this.contractListState,
        dataList: dataList ?? this.dataList,
        errMessage: errMessage ?? this.errMessage);
  }

  @override
  List<Object?> get props => [
        isFiltering,
        dataState,
        filterRequest,
        contractListState,
        dataList,
        errMessage,
      ];
}

class CommerceContractListState {
  List<DRContractModel>? list;
  DataState? dataState;
  String? errorMessage;

  CommerceContractListState({
    this.list,
    this.dataState,
    this.errorMessage,
  });

  CommerceContractListState copyWith({
    List<DRContractModel>? list,
    DataState? dataState,
    String? errorMessage,
  }) {
    return CommerceContractListState(
      list: list ?? this.list,
      dataState: dataState ?? this.dataState,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
