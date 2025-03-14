part of 'change_password_bloc.dart';

enum ChangePasswordStatus {
  SUCCESS,
  OTHER,
}

@immutable
class ChangePasswordState extends Equatable {
  const ChangePasswordState({
    this.dataState,
    this.status,
    this.message,
  });

  final DataState? dataState;
  final ChangePasswordStatus? status;
  final String? message;

  ChangePasswordState copyWith({
    DataState? dataState,
    ChangePasswordStatus? status,
    String? message,
  }) {
    return ChangePasswordState(
      dataState: dataState ?? this.dataState,
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        dataState,
        status,
        message,
      ];
}
