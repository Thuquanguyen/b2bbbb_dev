part of 'authen_bloc.dart';

@immutable
abstract class AuthenEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class AuthenEventStartApp extends AuthenEvent {
  AuthenEventStartApp() {
    Logger.debug('go hereeeee');
  }
}

enum AuthenType { PASSWORD, FACEID, TOUCHID, PINCODE, NONE }

extension AuthenTypeName on AuthenType {
  String get name {
    switch (this) {
      case AuthenType.PASSWORD:
        return 'PASSWORD';
      case AuthenType.FACEID:
        return 'FACEID';
      case AuthenType.TOUCHID:
        return 'TOUCHID';
      case AuthenType.PINCODE:
        return 'PINCODE';
      default:
        return '';
    }
  }

  String get icon {
    switch (this) {
      case AuthenType.PASSWORD:
        return AssetHelper.icoLoginPinCode;
      case AuthenType.FACEID:
        return AssetHelper.icoLoginFaceId;
      case AuthenType.TOUCHID:
        return AssetHelper.icoLoginTouchId;
      case AuthenType.PINCODE:
        return AssetHelper.icoLoginPinCode;
      default:
        return '';
    }
  }
}

class AuthenEventLogin extends AuthenEvent {
  AuthenEventLogin({required this.username,
    required this.password,
    this.authenType = AuthenType.PASSWORD});

  final String username;
  final String password;
  final AuthenType authenType;
}

class AuthenEventReLogin extends AuthenEvent {
  AuthenEventReLogin({required this.username,
    required this.password,
    this.authenType = AuthenType.PASSWORD});

  final String username;
  final String password;
  final AuthenType authenType;
}

class AuthenEventRegisterLoginType extends AuthenEvent {
  AuthenEventRegisterLoginType(
      {required this.authenType});

  final AuthenType authenType;
}

class AuthenEventGetSession extends AuthenEvent {
  AuthenEventGetSession();
}

class AuthenEventGetMenuUserPermission extends AuthenEvent {
  AuthenEventGetMenuUserPermission();
}

class AuthenEventLogOut extends AuthenEvent {
  AuthenEventLogOut() {
    Logger.debug('===== LOGOUT =====');
  }
}

class AuthenEventCleanUserDevice extends AuthenEvent{
  AuthenEventCleanUserDevice({required this.username});
  final String username;
}
