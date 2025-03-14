import 'package:b2b/commons.dart';
import 'package:b2b/scr/data/model/bill/bill_info.dart';
import 'package:b2b/scr/data/model/bill/bill_init_request_data.dart';
import 'package:b2b/scr/data/model/bill/bill_provider.dart';
import 'package:b2b/scr/data/model/transfer/confirm_transfer_model.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/data/repository/bill_repository.dart';
import 'package:bloc/bloc.dart';

import '../../../core/api_service/single_response.dart';
import '../../../core/language/app_translate.dart';
import '../../../data/model/base_result_model.dart';
import '../../../data/model/bill/init_bill_response.dart';
import '../../data_state.dart';
import 'package:equatable/equatable.dart';

part 'payment_electric_event.dart';

part 'payment_electric_state.dart';

class PaymentElectricBloc
    extends Bloc<PaymentElectricEvent, PaymentElectricState> {
  BillRepository repository;

  PaymentElectricBloc(this.repository) : super(PaymentElectricState());

  @override
  Stream<PaymentElectricState> mapEventToState(
      PaymentElectricEvent event) async* {
    switch (event.runtimeType) {
      case PaymentElectricInitEvent:
        yield* _mapToPaymentElectricInitEvent();
        break;
      case GetListDebitEvent:
        yield* _mapToGetListDebitEvent();
        break;
      case ChangeDebitAccountEvent:
        yield* _mapToChangeDebitAccountEvent(event as ChangeDebitAccountEvent);
        break;
      case GetBillInfo:
        yield* _mapToGetBillInfoEvent(event as GetBillInfo);
        break;
      case BillInitEvent:
        yield* _mapToBillInitEvent(event as BillInitEvent);
        break;
      case ConfirmBillEvent:
        yield* _mapToConfirmBillEvent();
        break;
      case ClearBillInfoEvent:
        yield state.copyWith(clearBillInfo: true);
        break;
      default:
        break;
    }
  }

  Stream<PaymentElectricState> _mapToGetListDebitEvent() async* {
    yield state.copyWith(
      debitDataState: DataState.preload,
    );
    try {
      final response = await repository.getListDebitAccount();
      if (response.result!.isSuccess()) {
        final SingleResponse<DebitAccountResponseModel> listAccountDebitModel =
            SingleResponse<DebitAccountResponseModel>(
          response.data,
          (item) => DebitAccountResponseModel.fromJson(item),
        );
        if (listAccountDebitModel.item.debbitAccountList!.isEmpty) {
          throw AppTranslate.i18n.canNotFindAccountStr.localized;
        }
        var accountDebit;
        try {
          accountDebit =
              listAccountDebitModel.item.debbitAccountList?.firstWhere(
            (element) =>
                element.accountNumber ==
                listAccountDebitModel.item.accountDefault,
          );
          listAccountDebitModel.item.debbitAccountList!.removeWhere(
            (element) =>
                listAccountDebitModel.item.accountDefault ==
                element.accountNumber,
          );
          listAccountDebitModel.item.debbitAccountList!.insert(
            0,
            accountDebit,
          );
        } catch (e) {
          accountDebit = listAccountDebitModel.item.debbitAccountList?[0];
        }
        yield state.copyWith(
          debitDataState: DataState.data,
          listDebitAccount: listAccountDebitModel.item.debbitAccountList,
          selectedDebitAccount: accountDebit,
        );
      } else {
        throw response.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        debitDataState: DataState.error,
        getDebitErrMsg: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  //Khởi tạo
  Stream<PaymentElectricState> _mapToPaymentElectricInitEvent() async* {
    clearData();
    yield PaymentElectricState();
    yield* _mapToGetListDebitEvent();
    // add(GetListDebitEvent());
  }

  Stream<PaymentElectricState> _mapToChangeDebitAccountEvent(
      ChangeDebitAccountEvent event) async* {
    yield state.copyWith(selectedDebitAccount: event.debitAccountModel);
  }

  Stream<PaymentElectricState> _mapToGetBillInfoEvent(
      GetBillInfo event) async* {
    yield state.copyWith(clearBillInfo: true);
    await Future.delayed(const Duration(milliseconds: 100));
    yield state.copyWith(
      getBillInfoDataState: DataState.preload,
    );

    try {
      var response = await repository.getBillInfo(params: event.toJson());
      if (response.result?.isSuccess() == true) {
        BillInfo? info = response.toModel((json) => BillInfo.fromJson(json));

        //Sắp xếp ds kỳ hạn
        List<BillInfoBillList?>? periods = info?.billList;
        periods?.sort((a, b) {
          try {
            if (a?.getPeriodDateTime() != null &&
                b?.getPeriodDateTime() != null) {
              int diff =
                  a!.getPeriodDateTime()!.compareTo(b!.getPeriodDateTime()!);
              return diff;
            }
            return 1;
          } catch (_) {
            return 1;
          }
        });
        yield state.copyWith(
            getBillInfoDataState: DataState.data, billInfo: info);
      } else {
        throw response.result as Object;
      }
    } catch (e) {
      yield state.copyWith(
        getBillInfoDataState: DataState.error,
        getBillInfoErrMsg: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<PaymentElectricState> _mapToBillInitEvent(BillInitEvent event) async* {
    yield state.copyWith(initBillDataState: DataState.preload);

    try {
      var response = await repository.initBill(
        params: event.initRequestData.toJson(),
      );
      if (response.result?.isSuccess() == true) {
        InitBillResponse? resultModel =
            response.toModel((json) => InitBillResponse.fromJson(json));
        yield state.copyWith(
            initBillDataState: DataState.data, initBillResponse: resultModel);
      } else {
        throw response.result as Object;
      }
    } catch (e) {
      yield state.copyWith(
        initBillDataState: DataState.error,
        initBillErrMsg: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<PaymentElectricState> _mapToConfirmBillEvent() async* {
    print('ZZZZZZZZZZZZZ _mapToConfirmBillEvent');
    yield state.copyWith(confirmBillDataState: DataState.preload);

    try {
      var response = await repository.confirmBill(
        params: {
          "trans_code": state.initBillResponse?.transCode,
          "secure_trans": state.initBillResponse?.sercureTrans,
        },
      );
      if (response.result?.isSuccess() == true) {
        ConfirmTransferModel? confirmModel =
            response.toModel((json) => ConfirmTransferModel.fromJson(json));
        confirmModel?.message = response.result?.getMessage();
        yield state.copyWith(
            confirmBillDataState: DataState.data,
            confirmBillResponse: confirmModel);
      } else {
        throw response.result as Object;
      }
    } catch (e) {
      yield state.copyWith(
        confirmBillDataState: DataState.error,
        confirmBillErrMsg: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  BillProvider? billProvider;
  List<BillInfoBillList?> selectedBillList = [];
  String customerCode = '';

  void setBillProvider(BillProvider? billProvider) {
    this.billProvider = billProvider;
  }

  void setSelectedBillList(List<BillInfoBillList?> dataList) {
    selectedBillList.clear();
    selectedBillList.addAll(dataList);
  }

  void clearData() {
    billProvider = null;
    selectedBillList = [];
    customerCode = '';
  }

  void setCustomerCode(String code) {
    customerCode = code;
  }
}
