part of 'change_password_bloc.dart';

@immutable
abstract class ChangePasswordEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class ChangePasswordExecuteEvent extends ChangePasswordEvent {
  ChangePasswordExecuteEvent({required this.request});

  final ChangePasswordRequestModel request;
}
