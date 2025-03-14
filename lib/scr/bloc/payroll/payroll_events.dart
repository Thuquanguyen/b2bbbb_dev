import 'package:b2b/scr/data/model/payroll_ben_model.dart';

class PayrollEvents {}

class PayrollGetBenListEvent extends PayrollEvents {
  final PayrollBenListFilterRequest? filterRequest;

  PayrollGetBenListEvent({
    this.filterRequest,
  });
}
