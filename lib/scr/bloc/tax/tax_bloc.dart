import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/tax/tax_manage/tax_manage_events.dart';
import 'package:b2b/scr/data/model/tax/tax_online.dart';
import 'package:b2b/scr/data/repository/tax_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../utilities/logger.dart';
import '../../core/api_service/single_response.dart';
import '../../core/language/app_translate.dart';
import '../../data/model/base_result_model.dart';
import '../../data/model/transfer/confirm_transfer_model.dart';
import '../../data/model/transfer/debit_account_model.dart';
import '../../data/model/transfer/init_transfer_model.dart';
import '../card/payment_card/payment_card_event.dart';
import '../transfer/transfer_bloc.dart';

part 'tax_event.dart';

part 'tax_state.dart';

class RegisterTaxBloc extends Bloc<TaxEvent, TaxState> {
  TaxRepository repository;

  RegisterTaxBloc(this.repository) : super(TaxState());

  @override
  Stream<TaxState> mapEventToState(TaxEvent event) async* {
    switch (event.runtimeType) {
      case TaxEventGetTaxOnline:
        yield* _mapToTaxEventGetTaxOnline();
        break;
      case TaxEventGetListDebitAccount:
        yield* _mapToTaxEventGetListDebitAccount();
        break;
      case TaxEventChangeRootAccount:
        yield state.copyWith(
            rootAccount: (event as TaxEventChangeRootAccount).accountModel);
        break;
      case TaxEventChangeFeeAccount:
        yield state.copyWith(
            feeAccount: (event as TaxEventChangeFeeAccount).accountModel);
        break;
      case InitTaxEvent:
        yield* _mapInitTaxEvent();
        break;
      case ConfirmTaxEvent:
        yield* _mapTaxConfirmEvent();
        break;
      case ClearTaxState:
        yield TaxState();
        break;
      default:
        break;
    }
  }

  Stream<TaxState> _mapToTaxEventGetTaxOnline() async* {
    yield state.copyWith(
      getTaxOnlineDataState: DataState.preload,
    );

    try {
      final response = await repository.getTaxOnline();
      if (response.result!.isSuccess()) {
        yield state.copyWith(
          getTaxOnlineDataState: DataState.data,
          taxOnline: TaxOnline.fromJson(response.data),
        );
      } else {
        throw response.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        getTaxOnlineDataState: DataState.error,
        errMsg: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<TaxState> _mapToTaxEventGetListDebitAccount() async* {
    Logger.debug("start");

    yield state.copyWith(getListDebitDataState: DataState.preload);
    try {
      final response = await repository.getListDebitAccount(
        TransferType.TAX.getTransferTypeCode,
      );
      if (response.result!.isSuccess()) {
        final SingleResponse<DebitAccountResponseModel> listAccountDebitModel =
            SingleResponse<DebitAccountResponseModel>(
          response.data,
          (item) => DebitAccountResponseModel.fromJson(item),
        );
        if (listAccountDebitModel.item.debbitAccountList!.isEmpty) {
          throw AppTranslate.i18n.canNotFindAccountStr.localized;
        }
        DebitAccountModel? accountDebit;
        try {
          accountDebit =
              listAccountDebitModel.item.debbitAccountList?.firstWhere(
            (element) =>
                element.accountNumber ==
                listAccountDebitModel.item.accountDefault,
          );
        } catch (e) {
          accountDebit = listAccountDebitModel.item.debbitAccountList?[0];
        }
        yield state.copyWith(
            getListDebitDataState: DataState.data,
            rootAccount: accountDebit,
            feeAccount: accountDebit,
            listDebitAccount: listAccountDebitModel.item.debbitAccountList);
      } else {
        throw response.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
          getListDebitDataState: DataState.error,
          errMsg: (e is BaseResultModel)
              ? e.getMessage()
              : AppTranslate.i18n.havingAnErrorStr.localized);
    }
  }

  Stream<TaxState> _mapInitTaxEvent() async* {
    try {
      yield state.copyWith(
        initTaxDataState: DataState.preload,
      );

      final rawResponse = await repository.initPayment(
          debitAccountModel: state.rootAccount, feeAccount: state.feeAccount);
      if (rawResponse.result!.isSuccess()) {
        final response = SingleResponse<InitTransferModel>(
          rawResponse.data,
          (item) => InitTransferModel.fromJson(item),
        );
        yield state.copyWith(
          initTaxDataState: DataState.data,
          initTransferModel: response.item,
        );
      } else {
        throw rawResponse.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        initTaxDataState: DataState.error,
        errMsg: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<TaxState> _mapTaxConfirmEvent() async* {
    try {
      yield state.copyWith(
        confirmTaxDataState: DataState.preload,
      );
      final rawResponse = await repository.confirmPayment(
        state.initTransferModel!,
        TransferType.TAX.getTransferTypeCode,
      );
      if (rawResponse.result!.isSuccess()) {
        final response = rawResponse.data;
        yield state.copyWith(
          confirmTaxDataState: DataState.data,
          confirmPaymentModel: ConfirmTransferModel(
            rawResponse.result!.getMessage(),
            (response['verify_otp_display_type'] as int),
          ),
        );
      } else {
        throw rawResponse.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        confirmTaxDataState: DataState.error,
        errMsg: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }
}
