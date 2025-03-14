import 'dart:developer';

import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/data/model/banner_ad_model.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/repository/resource_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'resource_event.dart';

part 'resource_state.dart';

class ResourceBloc extends Bloc<ResourceEvent, ResourceState> {
  ResourceBloc({
    required this.resourceRepository,
  }) : super(const ResourceState());

  final ResourceRepositoryImpl resourceRepository;

  @override
  Stream<ResourceState> mapEventToState(ResourceEvent event) async* {
    if (event is GetBannerAdsEvent) {
      yield* mapGetBannerAdsState();
    } else {
      log('No event matched ${event.toString()}');
    }
  }

  Stream<ResourceState> mapGetBannerAdsState() async* {
    yield state.copyWith(
      bannerAdsState: BannerAdsState(
        dataState: DataState.preload,
      ),
    );

    try {
      BaseResponseModel<ListResponse<BannerAdModel>> responseData =
          await resourceRepository.getBannerAds();
      String? code = responseData.result?.code;
      if (code == '200') {
        List<BannerAdModel> adList = ListResponse<BannerAdModel>(
          responseData.data,
          (itemJson) => BannerAdModel.fromJson(itemJson),
        ).items;

        yield state.copyWith(
          bannerAdsState: BannerAdsState(
            bannerAds: adList,
            dataState: DataState.data,
          ),
        );
      } else {
        yield state.copyWith(
          bannerAdsState: BannerAdsState(
            dataState: DataState.error,
          ),
        );
      }
    } catch (_) {
      yield state.copyWith(
        bannerAdsState: BannerAdsState(
          dataState: DataState.error,
        ),
      );
    }
  }
}
