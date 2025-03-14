import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';

class TaxManageEvent {}

class TaxManageGetListEvent extends TaxManageEvent {}

class TaxManageInitEvent extends TaxManageEvent {
  final String? transCode;

  TaxManageInitEvent({this.transCode});
}

class TaxManageClearInitEvent extends TaxManageEvent {}

class TaxManageConfirmEvent extends TaxManageEvent {
  final String? transCode;
  final String? secureTrans;
  final String? rejectReason;
  final CommitActionType? actionType;

  TaxManageConfirmEvent({
    this.transCode,
    this.secureTrans,
    this.rejectReason,
    this.actionType,
  });
}

class TaxManageClearConfirmEvent extends TaxManageEvent {}
