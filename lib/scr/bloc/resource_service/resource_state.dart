part of 'resource_bloc.dart';

@immutable
class ResourceState extends Equatable {
  const ResourceState({
    this.bannerAdsState,
  });

  final BannerAdsState? bannerAdsState;

  ResourceState copyWith({
    BannerAdsState? bannerAdsState,
  }) {
    return ResourceState(
      bannerAdsState: bannerAdsState ?? this.bannerAdsState,
    );
  }

  @override
  List<Object?> get props => [
        bannerAdsState,
      ];
}

class BannerAdsState {
  BannerAdsState({this.bannerAds, this.dataState});

  final List<BannerAdModel>? bannerAds;
  final DataState? dataState;
}
