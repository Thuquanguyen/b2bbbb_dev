import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_state.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/account_service/account_model.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/model/saving_account_model.dart';
import 'package:b2b/scr/data/model/saving_transaction_model.dart';
import 'package:b2b/scr/data/model/transaction/transaction_confirm_response.dart';
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/data/repository/saving_repository.dart';
import 'package:b2b/scr/data/repository/transaction_manager_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'current_deposits_events.dart';

part 'current_deposits_state.dart';

class CurrentDepositsBloc
    extends Bloc<CurrentDepositsEvents, CurrentDepositsState> {
  final SavingRepository _savingRepository;
  final TransactionManagerRepository _transManangerRepository;

  CurrentDepositsBloc(this._savingRepository, this._transManangerRepository)
      : super(
          CurrentDepositsState(
            list: CDSDepositsList(),
            filterRequest: TransactionFilterRequest(),
            singleDetail: CDSDepositsDetail(),
            initState: CDSDepositsDetail(),
          ),
        );

  @override
  Stream<CurrentDepositsState> mapEventToState(
      CurrentDepositsEvents event) async* {
    switch (event.runtimeType) {
      case CurrentDepositsGetListEvent:
        yield* getCurrentSavingAccount(event as CurrentDepositsGetListEvent);
        break;
      case CurrentDepositsClearFilterEvent:
        yield state.copyWith(
          filterRequest: TransactionFilterRequest(),
        );
        break;
      case CurrentDepositsGetDetailEvent:
        yield* getAzDetail((event as CurrentDepositsGetDetailEvent).accountNo);
        break;
      case CurrentDepositsInitSettlementEvent:
        yield* initSettlement(event as CurrentDepositsInitSettlementEvent);
        break;
      case CurrentDepositsConfirmSettlementEvent:
        yield* confirmSettlement(
            event as CurrentDepositsConfirmSettlementEvent);
        break;
      case CurrentDepositsGetListDebitAccountEvent:
        yield* getListDebitAccount(
            event as CurrentDepositsGetListDebitAccountEvent);
        break;
      case CurrentDepositsChangeSettlementAccEvent:
        break;
      case CurrentDepositsFinalSettlementEvent:
        break;
    }
  }

  Stream<CurrentDepositsState> getCurrentSavingAccount(
      CurrentDepositsGetListEvent event) async* {
    TransactionFilterRequest? filterRequest =
        event.filterRequest ?? state.filterRequest;
    yield state.copyWith(
      list: state.list?.copyWith(dataState: DataState.preload),
      filterRequest: filterRequest,
    );
    try {
      var response =
          await _savingRepository.getListSavingAccount(filterRequest);

      if (response.result?.isSuccess() == true) {
        final ListResponse<SavingAccountModel> listAccount =
            ListResponse<SavingAccountModel>(
          response.data,
          (item) => SavingAccountModel.fromJson(item),
        );
        List<SavingAccountModel> result = listAccount.items;

        yield state.copyWith(
          list: state.list?.copyWith(
            dataState: DataState.data,
            list: result,
          ),
        );
      } else {
        yield state.copyWith(
          list: state.list?.copyWith(
            dataState: DataState.error,
            error: response.result?.getMessage(
                defaultValue: AppTranslate.i18n.errorNoReasonStr.localized),
          ),
        );
      }
    } catch (e) {
      yield state.copyWith(
        list: state.list?.copyWith(
          dataState: DataState.error,
          error: AppTranslate.i18n.errorNoReasonStr.localized,
        ),
      );
    }
  }

  Stream<CurrentDepositsState> getAzDetail(String? accountNo) async* {
    yield state.copyWith(
      singleDetail: CDSDepositsDetail(
        dataState: DataState.preload,
      ),
    );

    try {
      BaseResponseModel<TransactionSavingModel> responseData =
          await _savingRepository.getAzDetail(accountNo ?? '');

      String? code = responseData.result?.code;
      if (code == '200') {
        TransactionSavingModel? tran = responseData
            .toModel((json) => TransactionSavingModel.fromJson(json));
        yield state.copyWith(
          singleDetail: state.singleDetail?.copyWith(
            dataState: DataState.data,
            transactionSaving: tran,
          ),
        );
        // yield* _loadDebitAccountInfo(tran?.debitAccountNumber ?? '');
      } else {
        yield state.copyWith(
          singleDetail: state.singleDetail?.copyWith(
            dataState: DataState.error,
            error: responseData.result?.getMessage(
              defaultValue: AppTranslate.i18n.errorNoReasonStr.localized,
            ),
          ),
        );
      }
    } catch (e) {
      yield state.copyWith(
        singleDetail: state.singleDetail?.copyWith(
          dataState: DataState.error,
          error: AppTranslate.i18n.errorNoReasonStr.localized,
        ),
      );
    }
  }

  Stream<CurrentDepositsState> initSettlement(
      CurrentDepositsInitSettlementEvent event) async* {
    yield state.copyWith(
      initState: CDSDepositsDetail(
        dataState: DataState.preload,
      ),
      selectedNominationAcc: event.nominatedAcc,
    );

    try {
      BaseResponseModel<TransactionSavingModel> responseData =
          await _savingRepository.initSettlementRequest(
        event.accountNo ?? '',
        event.nominatedAcc ?? '',
      );

      String? code = responseData.result?.code;
      if (code == '200') {
        TransactionSavingModel? tran = responseData
            .toModel((json) => TransactionSavingModel.fromJson(json));
        yield state.copyWith(
          initState: state.initState?.copyWith(
            dataState: DataState.data,
            transactionSaving: tran,
          ),
        );
        // yield* _loadDebitAccountInfo(tran?.debitAccountNumber ?? '');
      } else {
        yield state.copyWith(
          initState: state.initState?.copyWith(
            dataState: DataState.error,
            error: responseData.result?.getMessage(
              defaultValue: AppTranslate.i18n.errorNoReasonStr.localized,
            ),
          ),
        );
      }
    } catch (e) {
      yield state.copyWith(
        initState: state.initState?.copyWith(
          dataState: DataState.error,
          error: AppTranslate.i18n.errorNoReasonStr.localized,
        ),
      );
    }
  }

  Stream<CurrentDepositsState> _loadDebitAccountInfo(
      String accountNumber) async* {
    yield state.copyWith(
      singleDetail: state.singleDetail?.copyWith(
        additionalInfo: state.singleDetail?.additionalInfo?.copyWith(
          accountInfo: DebitAccountInfo(accountDataState: DataState.preload),
        ),
      ),
    );

    try {
      BaseResponseModel<AccountInfo> responseData =
          await _transManangerRepository.getDebitAccountDetail(accountNumber);

      String? code = responseData.result?.code;
      if (code == '200') {
        AccountInfo? a =
            responseData.toModel((json) => AccountInfo.fromJson(json));
        yield state.copyWith(
          singleDetail: state.singleDetail?.copyWith(
            additionalInfo: state.singleDetail?.additionalInfo?.copyWith(
              accountInfo: DebitAccountInfo(
                accountDataState: DataState.data,
                accountName: a?.accountName,
                accountBalance: a?.availableBalance,
                accountCcy: a?.accountCurrency,
                accountNumber: accountNumber,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      yield state.copyWith(
        singleDetail: state.singleDetail?.copyWith(
          additionalInfo: state.singleDetail?.additionalInfo?.copyWith(
            accountInfo: DebitAccountInfo(accountDataState: DataState.error),
          ),
        ),
      );
    }
  }

  Stream<CurrentDepositsState> getListDebitAccount(
      CurrentDepositsGetListDebitAccountEvent event) async* {
    yield state.copyWith(
      debitAccountList: CDSDebitAccountList(dataState: DataState.preload),
    );

    try {
      BaseResponseModel<DebitAccountResponseModel> response =
          await _savingRepository.getListDebitAccount(
        secureId: event.secureId,
        productId: event.productId,
      );

      if (response.result?.isSuccess() == true) {
        DebitAccountResponseModel? data = response
            .toModel((json) => DebitAccountResponseModel.fromJson(json));

        yield state.copyWith(
          debitAccountList: CDSDebitAccountList(
            dataState: DataState.data,
            data: data,
          ),
        );
      } else {
        yield state.copyWith(
          debitAccountList: CDSDebitAccountList(
            dataState: DataState.error,
            error: response.result?.getMessage(
                defaultValue: AppTranslate.i18n.errorNoReasonStr.localized),
          ),
        );
      }
    } catch (e) {
      yield state.copyWith(
        debitAccountList: CDSDebitAccountList(
          dataState: DataState.error,
          error: AppTranslate.i18n.errorNoReasonStr.localized,
        ),
      );
    }
  }

  Stream<CurrentDepositsState> confirmSettlement(
      CurrentDepositsConfirmSettlementEvent event) async* {
    yield state.copyWith(
      confirmState: CDSConfirmState(dataState: DataState.preload),
    );

    try {
      BaseResponseModel<TransactionManageConfirmResponse> responseData =
          await _savingRepository.confirmSettlementRequest(
              event.transCode, event.secureTrans);

      if (responseData.result?.isSuccess() == true) {
        TransactionManageConfirmResponse? confirmData = responseData
            .toModel((json) => TransactionManageConfirmResponse.fromJson(json));
        yield state.copyWith(
          confirmState: CDSConfirmState(
            dataState: DataState.data,
            data: confirmData,
            successMessage: responseData.result?.getMessage(),
          ),
        );
      } else {
        yield state.copyWith(
          confirmState: CDSConfirmState(
            dataState: DataState.error,
            error: responseData.result?.getMessage(
                defaultValue: AppTranslate.i18n.errorNoReasonStr.localized),
          ),
        );
      }
    } catch (e) {
      yield state.copyWith(
        confirmState: CDSConfirmState(
          dataState: DataState.error,
          error: AppTranslate.i18n.errorNoReasonStr.localized,
        ),
      );
    }
  }
}
