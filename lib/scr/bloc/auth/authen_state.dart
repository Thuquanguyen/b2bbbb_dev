part of 'authen_bloc.dart';

// ignore: constant_identifier_names
enum AuthenStatus { OTP, SUCCESS, MAINTENANCE, ERROR, CHANGE_PASSWORD, BIOMETRIC_INVALID }

@immutable
class AuthenState extends Equatable {
  const AuthenState({
    this.loginModel,
    this.loginState = DataState.init,
    this.loginStatus,
    this.registerModel,
    this.registerState = DataState.init,
    this.registerStatus,
    this.sessionModel,
    this.sessionResult,
    this.sessionState = DataState.init,
    this.sessionStatus,
    this.menuResult,
    this.menuState = DataState.init,
    this.menuStatus,
    this.menuModel,
  });

  final LoginModel? loginModel;
  final DataState loginState;
  final AuthenStatus? loginStatus;

  final RegisterTypeModel? registerModel;
  final DataState registerState;
  final AuthenStatus? registerStatus;

  final SessionModel? sessionModel;
  final BaseResultModel? sessionResult;
  final DataState sessionState;
  final AuthenStatus? sessionStatus;

  final List<MenuModel>? menuModel;
  final BaseResultModel? menuResult;
  final DataState menuState;
  final AuthenStatus? menuStatus;

  @override
  List<Object?> get props => [
        loginModel,
        loginState,
        loginStatus,
        registerModel,
        registerState,
        registerStatus,
        sessionModel,
        sessionResult,
        sessionState,
        sessionStatus,
        menuResult,
        menuState,
        menuStatus,
        menuModel,
      ];

  AuthenState copyWith({
    LoginModel? loginModel,
    DataState? loginState,
    AuthenStatus? loginStatus,
    RegisterTypeModel? registerModel,
    DataState? registerState,
    AuthenStatus? registerStatus,
    SessionModel? sessionModel,
    BaseResultModel? sessionResult,
    DataState? sessionState,
    AuthenStatus? sessionStatus,
    BaseResultModel? menuResult,
    DataState? menuState,
    AuthenStatus? menuStatus,
    List<MenuModel>? menuModel,
  }) {
    return AuthenState(
      loginModel: loginModel ?? this.loginModel,
      loginState: loginState ?? this.loginState,
      loginStatus: loginStatus ?? this.loginStatus,
      registerModel: registerModel ?? this.registerModel,
      registerState: registerState ?? this.registerState,
      registerStatus: registerStatus ?? this.registerStatus,
      sessionModel: sessionModel ?? this.sessionModel,
      sessionResult: sessionResult ?? this.sessionResult,
      sessionState: sessionState ?? this.sessionState,
      sessionStatus: sessionStatus ?? this.sessionStatus,
      menuResult: menuResult ?? this.menuResult,
      menuState: sessionState ?? this.menuState,
      menuStatus: sessionStatus ?? this.menuStatus,
      menuModel: menuModel ?? this.menuModel,
    );
  }
}
