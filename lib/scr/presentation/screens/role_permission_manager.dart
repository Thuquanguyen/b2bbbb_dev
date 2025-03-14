import 'dart:core';

import 'package:b2b/scr/data/model/auth/menu_model.dart';
import 'package:b2b/scr/data/model/auth/session_model.dart';
import 'package:b2b/scr/data/model/auth/session_user_data_model.dart';
import 'package:b2b/scr/presentation/screens/main/home_action_manager.dart';
import 'package:b2b/utilities/logger.dart';

const String SYSTEM = "G0";
const String LAPLENH_LUONG = "G1";
const String LAPLENH_THANHTOAN = "G3";
const String LAPLENH_THANHTOAN_MORONG = "G31";
const String LAPLENH_TAITROTHUONGMAI = "G6";
const String LAPLENH_TAITROTHUONGMAI_MORONG = "G61";

const String DUYET_LUONG = "G2";
const String DUYET_THANHTOAN = "G4";
const String DUYET_THANHTOAN_MORONG = "G41";

const String DUYET_TAITROTHUONGMAI = "G7";
const String DUYET_TAITROTHUONGMAI_MORONG = "G71";

const String TRUYVAN = "G5";
const String TRUYVAN_MORONG = "G51";

const String UY_NHIEM_THANHTOAN = "V4";
const String UY_NHIEM_LUONG = "V2";

class RolePermissionManager {
  var roleCheckerList = {
    DUYET_LUONG,
    DUYET_THANHTOAN,
    DUYET_THANHTOAN_MORONG,
    DUYET_TAITROTHUONGMAI,
    DUYET_TAITROTHUONGMAI_MORONG
  };

  var roleMakerList = {
    LAPLENH_LUONG,
    LAPLENH_THANHTOAN,
    LAPLENH_THANHTOAN_MORONG,
    LAPLENH_TAITROTHUONGMAI,
    LAPLENH_TAITROTHUONGMAI_MORONG
  };

  var roleViewerList = {
    TRUYVAN,
    TRUYVAN_MORONG,
  };

  static const String ROLE_PERMISSION_UPDATED = 'ROLE_PERMISSION_UPDATED';

  factory RolePermissionManager() => _instance;

  RolePermissionManager._();

  static final _instance = RolePermissionManager._();

  final List<MenuModel> _userPermission = [];

  bool hasInitPermission() {
    return _userPermission.isNotEmpty;
  }

  UserRole? userRole;
  String? roleCode;

  void initPermission(List<MenuModel>? list) {
    _userPermission.clear();
    _userPermission.addAll(list ?? []);
  }

  void clearPermission() {
    _userPermission.clear();
  }

  bool checkVisible(String permissionId) {
    try {
      final check = _userPermission.firstWhere((element) => element.labelId == permissionId).visible ?? false;
      return check;
    } catch (e) {
      // Logger.debug("error $e");
    }
    return false;
  }

  bool checkPermission(String permissionId) {
    try {
      return _userPermission.firstWhere((element) => element.labelId == permissionId).lock ?? false;
    } catch (e) {
      Logger.debug(e);
    }
    return false;
  }

  bool isMaker() {
    return RolePermissionManager().checkVisible(HomeAction.TRANSACTION_MANAGER.id);
  }

  bool isChecker() {
    return RolePermissionManager().checkVisible(HomeAction.APPROVE_MANAGER.id) ||
        RolePermissionManager().checkVisible(HomeAction.APPROVE_INDIVIDUAL_PAYROLL.id);
  }

  void getUserRole(SessionModel sessionModel) {
    SessionUserDataModel? user = sessionModel.user;
    String? roleCode = user?.roleCode;

    if (roleCode == null) {
      return;
    }

    this.roleCode = roleCode;

    if (roleCheckerList.contains(roleCode)) {
      userRole = UserRole.CHECKER;
    } else if (roleMakerList.contains(roleCode)) {
      userRole = UserRole.MAKER;
    } else if (roleViewerList.contains(roleCode)) {
      userRole = UserRole.VIEWER;
    }
  }

  String? getRoleName(String? roleCode) {
    if (roleCode == null) {
      return null;
    }
    if (roleCheckerList.contains(roleCode)) {
      return UserRole.CHECKER.getValue();
    } else if (roleMakerList.contains(roleCode)) {
      return UserRole.MAKER.getValue();
    } else if (roleViewerList.contains(roleCode)) {
      return UserRole.VIEWER.getValue();
    } else {
      return '';
    }
  }

  // truy vấn, mà mấy cái role maker ko cho mở tiền gửi : G1, G2, G6, G7
  bool isRoleViewerSaving() {
    if ({'G5', 'G51', 'G1', 'G2', 'G6', 'G7'}.contains(roleCode)) {
      return true;
    }
    return false;
  }

  bool shouldShowSavingManage() {
    if ({
      LAPLENH_LUONG,
      DUYET_LUONG,
      LAPLENH_TAITROTHUONGMAI,
      DUYET_TAITROTHUONGMAI,
    }.contains(roleCode)) {
      return false;
    }
    return true;
  }

  bool shouldShowSettlementButton() {
    if ({
      LAPLENH_LUONG,
      DUYET_LUONG,
      TRUYVAN,
      TRUYVAN_MORONG,
    }.contains(roleCode)) {
      return false;
    }
    return true;
  }

  bool isPayrollOnly() {
    if ({
      LAPLENH_LUONG,
      DUYET_LUONG,
    }.contains(roleCode)) {
      return true;
    }
    return false;
  }

  bool shouldShowPayrollManage() {
    if ({
      LAPLENH_LUONG,
      DUYET_LUONG,
      LAPLENH_THANHTOAN_MORONG,
      DUYET_THANHTOAN_MORONG,
      LAPLENH_TAITROTHUONGMAI_MORONG,
      DUYET_TAITROTHUONGMAI_MORONG,
    }.contains(roleCode)) {
      return true;
    }
    return false;
  }

  bool shouldShowFxManage() {
    if ({
      // LAPLENH_THANHTOAN,
      DUYET_THANHTOAN,
      // LAPLENH_THANHTOAN_MORONG,
      DUYET_THANHTOAN_MORONG,
      // LAPLENH_TAITROTHUONGMAI_MORONG,
      DUYET_TAITROTHUONGMAI_MORONG,
    }.contains(roleCode)) {
      return true;
    }
    return false;
  }

  bool shouldShowBillManage() {
    if ({
      LAPLENH_THANHTOAN,
      DUYET_THANHTOAN,
      LAPLENH_THANHTOAN_MORONG,
      DUYET_THANHTOAN_MORONG,
      LAPLENH_TAITROTHUONGMAI_MORONG,
      DUYET_TAITROTHUONGMAI_MORONG,
    }.contains(roleCode)) {
      return true;
    }
    return false;
  }

  bool allowNotiTransfer() {
    if ({
      LAPLENH_LUONG,
      LAPLENH_THANHTOAN,
      LAPLENH_THANHTOAN_MORONG,
      LAPLENH_TAITROTHUONGMAI_MORONG,
    }.contains(roleCode)) {
      return true;
    }
    return false;
  }

  bool allowNotiSavingBill() {
    if ({
      LAPLENH_THANHTOAN,
      LAPLENH_THANHTOAN_MORONG,
      LAPLENH_TAITROTHUONGMAI_MORONG,
    }.contains(roleCode)) {
      return true;
    }
    return false;
  }

  bool canPayCard() {
    if ({
      TRUYVAN,
      TRUYVAN_MORONG,
    }.contains(roleCode)) {
      return false;
    }
    return true;
  }
}

enum UserRole { CHECKER, MAKER, VIEWER, OTHER }

extension UserRoleValue on UserRole {
  String getValue() {
    switch (this) {
      case UserRole.CHECKER:
        return 'Checker';
      case UserRole.MAKER:
        return 'Maker';
      case UserRole.VIEWER:
        return 'Viewer';
      default:
        return '';
    }
  }
}
