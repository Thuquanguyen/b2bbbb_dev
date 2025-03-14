import 'package:b2b/scr/bloc/bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/search/search_event.dart';
import 'package:b2b/scr/bloc/search/search_state.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:b2b/scr/data/model/search/ben_bank_model.dart';
import 'package:b2b/scr/data/model/search/beneficiary_saved_model.dart';
import 'package:b2b/scr/data/model/search/branch_model.dart';
import 'package:b2b/scr/data/model/search/city_model.dart';
import 'package:b2b/scr/data/model/search/normal_display_search_model.dart';
import 'package:b2b/scr/data/repository/search_repository.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:bloc/bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({required this.searchRepository})
      : super(const SearchState(state: DataState.init));

  SearchRepository searchRepository;

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    Logger.debug("event $event");
    switch (event.runtimeType) {
      case SearchBenListEvent:
        yield* _mapToSearchBenListEvent(event as SearchBenListEvent);
        break;
      case SearchBankListEvent:
        yield* _mapToSearchBankListEvent(event as SearchBankListEvent);
        break;
      case SearchLocationEvent:
        yield* _mapToSearchLocationEvent(event as SearchLocationEvent);
        break;
      case SearchEvent:
        yield* _mapToActionSearchEvent(event);
        break;
      case SearchBranchListEvent:
        yield* _mapToSearchBranchEvent(event as SearchBranchListEvent);
        break;
      case SearchClearStateEvent:
        state.clearState();
        break;
      default:
        break;
    }
  }

  Stream<SearchState> _mapToSearchBranchEvent(
      SearchBranchListEvent event) async* {
    Logger.debug('start');
    yield state.copyWith(state: DataState.preload);
    try {
      var response = await searchRepository.searchBranchList(
          event.bankCode, event.cityCode);
      if (response.result!.isSuccess()) {
        final ListResponse<BranchModel> listBranch = ListResponse<BranchModel>(
          response.data,
          (itemJson) => BranchModel.fromJson(itemJson),
        );
        Logger.debug("length : ${listBranch.items.length}");
        List<NormalDisplaySearchModel> fullLists = [];
        List<NormalDisplaySearchModel> showLists = [];

        for (int i = 0; i < listBranch.items.length; i++) {
          fullLists.add(NormalDisplaySearchModel.convertFromBranch(
              listBranch.items[i], i));
        }
        showLists.addAll(fullLists);
        yield state.copyWith(
          listDataRoot: listBranch.items,
          listDataFull: fullLists,
          listDataShow: showLists,
          state: DataState.data,
        );
      }
    } catch (e) {
      Logger.debug("Exception $e");
      yield state.copyWith(
        state: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<SearchState> _mapToSearchLocationEvent(
      SearchLocationEvent event) async* {
    Logger.debug("start");
    yield state.copyWith(state: DataState.preload);
    try {
      var response = await searchRepository.searchLocationList();
      if (response.result!.isSuccess()) {
        final ListResponse<CityModel> listLocationModel =
            ListResponse<CityModel>(
                response.data, (item) => CityModel.fromJson(item));
        Logger.debug("length : ${listLocationModel.items.length}");
        List<NormalDisplaySearchModel> fullLists = [];
        List<NormalDisplaySearchModel> showLists = [];

        for (int i = 0; i < listLocationModel.items.length; i++) {
          fullLists.add(NormalDisplaySearchModel.convertFromLocation(
              listLocationModel.items[i], i));
        }
        showLists.addAll(fullLists);
        yield state.copyWith(
          listDataRoot: listLocationModel.items,
          listDataFull: fullLists,
          listDataShow: showLists,
          state: DataState.data,
        );
      }
    } catch (e) {
      Logger.debug("Exception $e");
      yield state.copyWith(
        state: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<SearchState> _mapToSearchBenListEvent(
      SearchBenListEvent event) async* {
    Logger.debug("start");
    yield state.copyWith(state: DataState.preload);
    try {
      var response =
          await searchRepository.searchBenList(event.transferTypeOfCode);

      if (response.result!.isSuccess()) {
        final ListResponse<BeneficiarySavedModel> listBenModel =
            ListResponse<BeneficiarySavedModel>(
          response.data,
          (item) => BeneficiarySavedModel.fromJson(item),
        );

        Logger.debug("length : ${listBenModel.items.length}");

        List<NormalDisplaySearchModel> fullLists = [];
        List<NormalDisplaySearchModel> showLists = [];
        for (int i = 0; i < listBenModel.items.length; i++) {
          fullLists.add(NormalDisplaySearchModel.convertFromBeneficiary(
              listBenModel.items[i], i));
        }
        showLists.addAll(fullLists);
        Logger.debug("showLists length : ${showLists.length}");
        yield state.copyWith(
            listDataRoot: listBenModel.items,
            listDataFull: fullLists,
            listDataShow: showLists,
            state: DataState.data);
      } else {
        Logger.debug("response err");
        throw response.result as Object;
      }
    } catch (e) {
      Logger.debug("Exception $e");
      yield state.copyWith(
        state: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<SearchState> _mapToSearchBankListEvent(
      SearchBankListEvent event) async* {
    Logger.debug("start");
    yield state.copyWith(state: DataState.preload);
    try {
      var response = await searchRepository.getBenBankList();

      if (response.result!.isSuccess()) {
        final ListResponse<BenBankModel> listRoot = ListResponse<BenBankModel>(
          response.data,
          (item) => BenBankModel.fromJson(item),
        );

        var tmpList = listRoot.items;
        List<BenBankModel> bankList = [];

        if (event.transferTypeOfCode ==
                TransferType.TRANS247_CARD.getTransferTypeCode ||
            event.transferTypeOfCode ==
                TransferType.TRANS247_ACCOUNT.getTransferTypeCode) {
          tmpList.forEach((element) {
            if (element.isNapas == true) {
              bankList.add(element);
            }
          });
        } else {
          bankList.addAll(tmpList);
        }

        List<NormalDisplaySearchModel> fullLists = [];
        List<NormalDisplaySearchModel> showLists = [];
        for (int i = 0; i < bankList.length; i++) {
          fullLists
              .add(NormalDisplaySearchModel.convertFromBenBank(bankList[i], i));
        }
        showLists.addAll(fullLists);
        yield state.copyWith(
            listDataRoot: bankList,
            listDataFull: fullLists,
            listDataShow: showLists,
            state: DataState.data);
      } else {
        Logger.debug("response err");
        throw response.result as Object;
      }
    } catch (e) {
      Logger.debug("Exception $e");
      yield state.copyWith(
        state: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<SearchState> _mapToActionSearchEvent(SearchEvent event) async* {
    String? key = event.keyWord;
    if (key == null || key == '') {
      List<NormalDisplaySearchModel> fullLists = state.listDataFull;
      List<NormalDisplaySearchModel> showLists = [];
      showLists.addAll(fullLists);
      yield state.copyWith(listDataShow: showLists);
    }
    List<NormalDisplaySearchModel> displayList = state.listDataFull;
    List<NormalDisplaySearchModel> newList = [];
    newList.addAll(displayList.where((element) =>
        element.searchKey.toLowerCase().startsWith(key!.toLowerCase())));
    newList.addAll(displayList.where((element) =>
        !element.searchKey.toLowerCase().startsWith(key!.toLowerCase()) &&
        element.searchKey.toLowerCase().contains(key.toLowerCase())));
    yield state.copyWith(listDataShow: newList);
  }
}
