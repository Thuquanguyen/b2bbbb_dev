part of 'resource_bloc.dart';

@immutable
abstract class ResourceEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class GetBannerAdsEvent extends ResourceEvent {}