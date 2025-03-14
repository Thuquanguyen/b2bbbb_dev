import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/data/model/search/normal_display_search_model.dart';
import 'package:equatable/equatable.dart';

class SearchState extends Equatable {
  final List<Object> listDataRoot;
  final DataState? state;
  final List<NormalDisplaySearchModel> listDataFull;
  final List<NormalDisplaySearchModel> listDataShow;
  final String? errorMessage;

  const SearchState(
      {this.listDataRoot = const [],
      this.state,
      this.errorMessage,
      this.listDataFull = const [],
      this.listDataShow = const []});

  @override
  List<Object?> get props => [listDataRoot, state, listDataShow];

  SearchState copyWith({
    List<Object>? listDataRoot,
    DataState? state,
    List<NormalDisplaySearchModel>? listDataFull,
    List<NormalDisplaySearchModel>? listDataShow,
    String? errorMessage,
  }) {
    return SearchState(
        listDataRoot: listDataRoot ?? this.listDataRoot,
        state: state ?? this.state,
        listDataFull: listDataFull ?? this.listDataFull,
        listDataShow: listDataShow ?? this.listDataShow,
        errorMessage: errorMessage ?? this.errorMessage);
  }

  SearchState clearState() {
    return const SearchState(listDataRoot: [], state: DataState.init, listDataFull: [], listDataShow: []);
  }
}
