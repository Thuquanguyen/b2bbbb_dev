import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/account_service/account_model.dart';
import 'package:b2b/scr/data/model/base_response_model.dart';
import 'package:b2b/scr/data/model/saving_transaction_model.dart';
import 'package:b2b/scr/data/model/search/city_model.dart';
import 'package:b2b/scr/data/model/transaction/payroll_manage_init_response.dart';
import 'package:b2b/scr/data/model/transaction/transaction_confirm_response.dart';
import 'package:b2b/scr/data/model/transaction/transaction_init_response.dart';
import 'package:b2b/scr/data/repository/bill_repository.dart';
import 'package:b2b/scr/data/repository/payroll_repository.dart';
import 'package:b2b/scr/data/repository/saving_repository.dart';
import 'package:b2b/scr/data/repository/transaction_manager_repository.dart';
import 'package:bloc/bloc.dart';

import 'transaction_manager_event.dart';
import 'transaction_manager_state.dart';

class TransactionManagerBloc extends Bloc<TransactionManagerEvent, TransactionManagerState> {
  TransactionManagerRepository transManangerRepository;
  SavingRepository savingRepo;
  PayrollRepository payrollRepo;
  BillRepository billRepo;

  TransactionManagerBloc({
    required this.transManangerRepository,
    required this.savingRepo,
    required this.payrollRepo,
    required this.billRepo,
  }) : super(
          TransactionManagerState(
            additionalInfoState: TransactionAdditionalInfoState(
              accountInfo: DebitAccountInfo(accountDataState: DataState.init),
              cityInfo: CityInfo(cityDataState: DataState.init),
              branchInfo: BranchInfo(branchDataState: DataState.init),
            ),
          ),
        ) {
    on<InitTransactionManageEvent>(_onManageInitEvent);
    on<InitFxTransactionManageEvent>(_onManageFxInitEvent);
    on<InitSavingTransactionManageEvent>(_onSavingManageInitEvent);
    on<InitPayrollTransactionManageEvent>(_onPayrollManageInitEvent);
    on<InitBillTransactionManageEvent>(_onBillManageInitEvent);
    on<ConfirmPayrollTransactionManageEvent>(_onPayrollManageConfirmEvent);
    on<ConfirmTransactionManageEvent>(_onManageConfirmEvent);
    on<ConfirmFxTransactionManageEvent>(_onFxManageConfirmEvent);
    on<ConfirmSavingTransactionManageEvent>(_onSavingManageConfirmEvent);
    on<ConfirmBillTransactionManageEvent>(_onBillManageConfirmEvent);
    on<GetAdditionalInfoTransactionManageEvent>(_onGetAccountInfoEvent);
    on<GetSingleTransactionDetailEvent>(_onGetSingleTransactionDetailEvent);
    on<ClearTransactionManageInitConfirmState>(_onClearTransactionManageInitConfirmState);
    on<ClearSavingTransactionManageInitConfirmState>(_onClearSavingTransactionManageInitConfirmState);
    on<ClearPayrollTransactionManageInitConfirmState>(_onClearPayrollTransactionManageInitConfirmState);
  }

  void _onClearTransactionManageInitConfirmState(
    ClearTransactionManageInitConfirmState event,
    Emitter<TransactionManagerState> emit,
  ) {
    emit(
      state.copyWith(
        manageInitState: TransactionManageInitState(
          dataState: DataState.init,
          singleTransactionDetailInfo: SingleTransactionDetailInfo(
            dataState: DataState.init,
          ),
        ),
        manageConfirmState: TransactionManageConfirmState(
          dataState: DataState.init,
        ),
        additionalInfoState: const TransactionAdditionalInfoState(),
      ),
    );
  }

  void _onClearSavingTransactionManageInitConfirmState(
    ClearSavingTransactionManageInitConfirmState event,
    Emitter<TransactionManagerState> emit,
  ) {
    emit(
      state.copyWith(
        savingManageInitState: SavingTransactionManageInitState(
          dataState: DataState.init,
        ),
        savingManageConfirmState: SavingTransactionManageConfirmState(
          dataState: DataState.init,
        ),
        additionalInfoState: const TransactionAdditionalInfoState(),
      ),
    );
  }

  void _onClearPayrollTransactionManageInitConfirmState(
    ClearPayrollTransactionManageInitConfirmState event,
    Emitter<TransactionManagerState> emit,
  ) {
    emit(
      state.copyWith(
        payrollManageInitState: PayrollTransactionManageInitState(
          dataState: DataState.init,
        ),
        payrollManageConfirmState: PayrollTransactionManageConfirmState(
          dataState: DataState.init,
        ),
        additionalInfoState: const TransactionAdditionalInfoState(),
      ),
    );
  }

  void _onManageInitEvent(
    InitTransactionManageEvent event,
    Emitter<TransactionManagerState> emit,
  ) async {
    emit(
      state.copyWith(
        manageInitState: TransactionManageInitState(
          dataState: DataState.preload,
        ),
      ),
    );

    try {
      BaseResponseModel<TransactionManageInitResponse> responseData =
          await transManangerRepository.initTransactionManage(
        transCodeList: event.transactions ?? [],
        filterRequest: event.filterRequest,
      );

      String? code = responseData.result?.code;
      if (code == '200') {
        emit(
          state.copyWith(
            manageInitState: TransactionManageInitState(
              dataState: DataState.data,
              data: responseData.toModel(
                (json) => TransactionManageInitResponse.fromJson(json),
              ),
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            manageInitState: TransactionManageInitState(
              dataState: DataState.error,
              errorMessage: responseData.result?.getMessage(),
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          manageInitState: TransactionManageInitState(
            dataState: DataState.error,
          ),
        ),
      );
    }
  }

  void _onManageFxInitEvent(
    InitFxTransactionManageEvent event,
    Emitter<TransactionManagerState> emit,
  ) async {
    emit(
      state.copyWith(
        manageInitState: TransactionManageInitState(
          dataState: DataState.preload,
        ),
      ),
    );

    try {
      BaseResponseModel<TransactionManageInitResponse> responseData =
          await transManangerRepository.initTransactionManage(
        transCodeList: event.transactions ?? [],
        filterRequest: event.filterRequest,
        isFx: true,
      );

      String? code = responseData.result?.code;
      if (code == '200') {
        emit(
          state.copyWith(
            manageInitState: TransactionManageInitState(
              dataState: DataState.data,
              data: responseData.toModel(
                (json) => TransactionManageInitResponse.fromJson(json),
              ),
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            manageInitState: TransactionManageInitState(
              dataState: DataState.error,
              errorMessage: responseData.result?.getMessage(),
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          manageInitState: TransactionManageInitState(
            dataState: DataState.error,
          ),
        ),
      );
    }
  }

  void _onSavingManageInitEvent(
    InitSavingTransactionManageEvent event,
    Emitter<TransactionManagerState> emit,
  ) async {
    emit(
      state.copyWith(
        savingManageInitState: SavingTransactionManageInitState(
          dataState: DataState.preload,
        ),
      ),
    );

    try {
      BaseResponseModel<TransactionSavingModel> responseData =
          await savingRepo.initTransactionManage(transCode: event.transCode ?? '');

      String? code = responseData.result?.code;
      if (code == '200') {
        emit(
          state.copyWith(
            savingManageInitState: SavingTransactionManageInitState(
              dataState: DataState.data,
              data: responseData.toModel(
                (json) => TransactionSavingModel.fromJson(json),
              ),
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            savingManageInitState: SavingTransactionManageInitState(
              dataState: DataState.error,
              errorMessage: responseData.result?.getMessage(),
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          savingManageInitState: SavingTransactionManageInitState(
            dataState: DataState.error,
          ),
        ),
      );
    }
  }

  void _onPayrollManageInitEvent(
    InitPayrollTransactionManageEvent event,
    Emitter<TransactionManagerState> emit,
  ) async {
    emit(
      state.copyWith(
        payrollManageInitState: PayrollTransactionManageInitState(
          dataState: DataState.preload,
        ),
      ),
    );

    try {
      BaseResponseModel<PayrollManageInitResponse> responseData =
          await payrollRepo.initManage(event.fileCode ?? '', event.transCode);

      String? code = responseData.result?.code;
      if (code == '200') {
        emit(
          state.copyWith(
            payrollManageInitState: PayrollTransactionManageInitState(
              dataState: DataState.data,
              data: responseData.toModel(
                (json) => PayrollManageInitResponse.fromJson(json),
              ),
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            payrollManageInitState: PayrollTransactionManageInitState(
              dataState: DataState.error,
              errorMessage: responseData.result?.getMessage(),
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          payrollManageInitState: PayrollTransactionManageInitState(
            dataState: DataState.error,
          ),
        ),
      );
    }
  }

  void _onBillManageInitEvent(
    InitBillTransactionManageEvent event,
    Emitter<TransactionManagerState> emit,
  ) async {
    emit(
      state.copyWith(
        billManageInitState: BillTransactionManageInitState(
          dataState: DataState.preload,
        ),
      ),
    );

    try {
      BaseResponseModel<BillTransactionManageInitResponse> responseData = await billRepo.initBillManage(
        transCodeList: [event.transCode],
        filterRequest: event.filterRequest,
      );

      String? code = responseData.result?.code;
      if (code == '200') {
        final initData = responseData.toModel(
          (json) => BillTransactionManageInitResponse.fromJson(json),
        );
        emit(
          state.copyWith(
            billManageInitState: BillTransactionManageInitState(
              dataState: DataState.data,
              data: initData?.transactions?.first,
              secureTrans: initData?.secureTrans,
              transcodeTrusted: initData?.transcodeTrusted,
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            billManageInitState: BillTransactionManageInitState(
              dataState: DataState.error,
              errorMessage: responseData.result?.getMessage(),
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          billManageInitState: BillTransactionManageInitState(
            dataState: DataState.error,
          ),
        ),
      );
    }
  }

  void _onPayrollManageConfirmEvent(
    ConfirmPayrollTransactionManageEvent event,
    Emitter<TransactionManagerState> emit,
  ) async {
    emit(
      state.copyWith(
        payrollManageConfirmState: PayrollTransactionManageConfirmState(
          dataState: DataState.preload,
        ),
      ),
    );

    try {
      BaseResponseModel<TransactionManageConfirmResponse> responseData = await payrollRepo.confirmManage(
        secureTrans: state.payrollManageInitState?.data?.secureTrans ?? '',
        transCode: event.transCode ?? '',
        actionType: event.type,
      );

      String? code = responseData.result?.code;
      if (code == '200') {
        emit(
          state.copyWith(
            payrollManageConfirmState: PayrollTransactionManageConfirmState(
              dataState: DataState.data,
              data: responseData.toModel(
                (json) => TransactionManageConfirmResponse.fromJson(json),
              ),
              type: event.type,
              rejectReason: event.rejectReason,
              successMessage: responseData.result?.getMessage(),
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            payrollManageConfirmState: PayrollTransactionManageConfirmState(
              dataState: DataState.error,
              errorMessage: responseData.result?.getMessage(),
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          payrollManageConfirmState: PayrollTransactionManageConfirmState(
            dataState: DataState.error,
            errorMessage: AppTranslate.i18n.errorNoReasonStr.localized,
          ),
        ),
      );
    }
  }

  void _onManageConfirmEvent(
    ConfirmTransactionManageEvent event,
    Emitter<TransactionManagerState> emit,
  ) async {
    emit(
      state.copyWith(
        manageConfirmState: TransactionManageConfirmState(
          dataState: DataState.preload,
        ),
      ),
    );

    try {
      BaseResponseModel<TransactionManageConfirmResponse> responseData =
          await transManangerRepository.confirmTransactionManage(
        secureTrans: state.manageInitState?.data?.secureTrans ?? '',
        transCode: state.manageInitState?.data?.transcodeTrusted ?? '',
        actionType: event.type,
      );

      String? code = responseData.result?.code;
      if (code == '200') {
        emit(
          state.copyWith(
            manageConfirmState: TransactionManageConfirmState(
              dataState: DataState.data,
              data: responseData.toModel(
                (json) => TransactionManageConfirmResponse.fromJson(json),
              ),
              type: event.type,
              rejectReason: event.rejectReason,
              successMessage: responseData.result?.getMessage(),
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            manageConfirmState: TransactionManageConfirmState(
              dataState: DataState.error,
              errorMessage: responseData.result?.getMessage(),
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          manageConfirmState: TransactionManageConfirmState(
            dataState: DataState.error,
          ),
        ),
      );
    }
  }

  void _onBillManageConfirmEvent(
    ConfirmBillTransactionManageEvent event,
    Emitter<TransactionManagerState> emit,
  ) async {
    emit(
      state.copyWith(
        billManageConfirmState: BillTransactionManageConfirmState(
          dataState: DataState.preload,
        ),
      ),
    );

    try {
      BaseResponseModel<TransactionManageConfirmResponse> responseData = await billRepo.confirmBillManage(
        secureTrans: state.billManageInitState?.secureTrans ?? '',
        transCodes: state.billManageInitState?.transcodeTrusted ?? '',
        actionType: event.type,
      );

      String? code = responseData.result?.code;
      if (code == '200') {
        emit(
          state.copyWith(
            billManageConfirmState: BillTransactionManageConfirmState(
              dataState: DataState.data,
              data: responseData.toModel(
                (json) => TransactionManageConfirmResponse.fromJson(json),
              ),
              type: event.type,
              rejectReason: event.rejectReason,
              successMessage: responseData.result?.getMessage(),
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            billManageConfirmState: BillTransactionManageConfirmState(
              dataState: DataState.error,
              errorMessage: responseData.result?.getMessage(),
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          billManageConfirmState: BillTransactionManageConfirmState(
            dataState: DataState.error,
          ),
        ),
      );
    }
  }

  void _onFxManageConfirmEvent(
    ConfirmFxTransactionManageEvent event,
    Emitter<TransactionManagerState> emit,
  ) async {
    emit(
      state.copyWith(
        manageConfirmState: TransactionManageConfirmState(
          dataState: DataState.preload,
        ),
      ),
    );

    try {
      BaseResponseModel<TransactionManageConfirmResponse> responseData =
          await transManangerRepository.confirmTransactionManage(
        secureTrans: state.manageInitState?.data?.secureTrans ?? '',
        transCode: state.manageInitState?.data?.transcodeTrusted ?? '',
        actionType: event.type,
        isFx: true,
      );

      String? code = responseData.result?.code;
      if (code == '200') {
        emit(
          state.copyWith(
            manageConfirmState: TransactionManageConfirmState(
              dataState: DataState.data,
              data: responseData.toModel(
                (json) => TransactionManageConfirmResponse.fromJson(json),
              ),
              type: event.type,
              rejectReason: event.rejectReason,
              successMessage: responseData.result?.getMessage(),
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            manageConfirmState: TransactionManageConfirmState(
              dataState: DataState.error,
              errorMessage: responseData.result?.getMessage(),
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          manageConfirmState: TransactionManageConfirmState(
            dataState: DataState.error,
          ),
        ),
      );
    }
  }

  void _onSavingManageConfirmEvent(
    ConfirmSavingTransactionManageEvent event,
    Emitter<TransactionManagerState> emit,
  ) async {
    emit(
      state.copyWith(
        savingManageConfirmState: SavingTransactionManageConfirmState(
          dataState: DataState.preload,
        ),
      ),
    );

    try {
      BaseResponseModel<TransactionManageConfirmResponse> responseData = await savingRepo.confirmTransactionManage(
        secureTrans: state.savingManageInitState?.data?.sercureTrans ?? '',
        transCode: state.savingManageInitState?.data?.transCode ?? '',
        actionType: event.type,
      );

      String? code = responseData.result?.code;
      if (code == '200') {
        emit(
          state.copyWith(
            savingManageConfirmState: SavingTransactionManageConfirmState(
              dataState: DataState.data,
              data: responseData.toModel(
                (json) => TransactionManageConfirmResponse.fromJson(json),
              ),
              type: event.type,
              rejectReason: event.rejectReason,
              successMessage: responseData.result?.getMessage(),
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            savingManageConfirmState: SavingTransactionManageConfirmState(
              dataState: DataState.error,
              errorMessage: responseData.result?.getMessage(),
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          savingManageConfirmState: SavingTransactionManageConfirmState(
            dataState: DataState.error,
          ),
        ),
      );
    }
  }

  void _onGetAccountInfoEvent(
    GetAdditionalInfoTransactionManageEvent event,
    Emitter<TransactionManagerState> emit,
  ) async {
    bool needReloadAccountInfo = false;
    bool needReloadCityInfo = false;
    TransactionManagerState newState = state.copyWith();

    String? accountNumber = event.accountNumber;
    if (accountNumber.isNotNullAndEmpty) {
      needReloadAccountInfo = true;
      newState = newState.copyWith(
        additionalInfoState: state.additionalInfoState?.copyWith(
          accountInfo: DebitAccountInfo(accountDataState: DataState.preload),
        ),
      );
    } else {
      newState = newState.copyWith(
        additionalInfoState: state.additionalInfoState?.copyWith(
          accountInfo: DebitAccountInfo(accountDataState: DataState.init),
        ),
      );
    }

    String? cityCode = event.cityCode;
    if (cityCode.isNotNullAndEmpty) {
      if (cityCode != state.additionalInfoState?.cityInfo?.cityCode ||
          state.additionalInfoState?.cityInfo?.cityName == null) {
        needReloadCityInfo = true;
        newState = newState.copyWith(
          additionalInfoState: state.additionalInfoState?.copyWith(
            cityInfo: CityInfo(cityDataState: DataState.preload),
          ),
        );
      }
    } else {
      newState = newState.copyWith(
        additionalInfoState: state.additionalInfoState?.copyWith(
          cityInfo: CityInfo(cityDataState: DataState.init),
        ),
      );
    }

    emit(newState);

    if (needReloadAccountInfo) {
      await _loadDebitAccountInfo(accountNumber!, emit); // Safe
    }
    if (needReloadCityInfo) {
      await _loadCityInfo(cityCode!, emit); // Safe
    }
  }

  Future<void> _loadDebitAccountInfo(
    String accountNumber,
    Emitter<TransactionManagerState> emit,
  ) async {
    emit(
      state.copyWith(
        additionalInfoState: state.additionalInfoState?.copyWith(
          accountInfo: DebitAccountInfo(accountDataState: DataState.preload),
        ),
      ),
    );

    try {
      BaseResponseModel<AccountInfo> responseData = await transManangerRepository.getDebitAccountDetail(accountNumber);

      String? code = responseData.result?.code;
      if (code == '200') {
        AccountInfo? a = responseData.toModel((json) => AccountInfo.fromJson(json));
        emit(
          state.copyWith(
            additionalInfoState: state.additionalInfoState?.copyWith(
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
      } else {
        emit(
          state.copyWith(
            additionalInfoState: state.additionalInfoState?.copyWith(
              accountInfo: DebitAccountInfo(
                accountDataState: DataState.error,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          additionalInfoState: state.additionalInfoState?.copyWith(
            accountInfo: DebitAccountInfo(accountDataState: DataState.error),
          ),
        ),
      );
    }
  }

  Future<void> _loadCityInfo(
    String cityCode,
    Emitter<TransactionManagerState> emit,
  ) async {
    emit(
      state.copyWith(
        additionalInfoState: state.additionalInfoState?.copyWith(
          cityInfo: CityInfo(cityDataState: DataState.preload),
        ),
      ),
    );

    try {
      BaseResponseModel<ListResponse<CityModel>> responseData = await transManangerRepository.getCityList();

      String? code = responseData.result?.code;
      if (code == '200') {
        CityModel? c = ListResponse<CityModel>(
          responseData.data,
          (json) => CityModel.fromJson(json),
        ).getCityByCode(cityCode, true);

        emit(
          state.copyWith(
            additionalInfoState: state.additionalInfoState?.copyWith(
              cityInfo: CityInfo(
                cityName: c?.cityName,
                cityCode: c?.cityCode,
                cityDataState: DataState.data,
              ),
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          additionalInfoState: state.additionalInfoState?.copyWith(
            cityInfo: CityInfo(cityDataState: DataState.error),
          ),
        ),
      );
    }
  }

  void _onGetSingleTransactionDetailEvent(
    GetSingleTransactionDetailEvent event,
    Emitter<TransactionManagerState> emit,
  ) async {
    emit(
      state.copyWith(
        manageInitState: state.manageInitState?.copyWith(
          singleTransactionDetailInfo: SingleTransactionDetailInfo(
            dataState: DataState.preload,
          ),
        ),
      ),
    );

    try {
      BaseResponseModel<TransactionManageInitResponse> responseData =
          await transManangerRepository.initTransactionManage(
        transCodeList: [event.transCode],
        filterRequest: state.filterRequest,
        isFx: event.isFx == true,
      );

      String? code = responseData.result?.code;
      if (code == '200') {
        emit(
          state.copyWith(
            manageInitState: state.manageInitState?.copyWith(
              singleTransactionDetailInfo: SingleTransactionDetailInfo(
                dataState: DataState.data,
                data: responseData
                    .toModel(
                      (json) => TransactionManageInitResponse.fromJson(json),
                    )
                    ?.transactions
                    ?.first,
              ),
            ),
          ),
        );
      } else {
        emit(
          state.copyWith(
            manageInitState: state.manageInitState?.copyWith(
              singleTransactionDetailInfo: SingleTransactionDetailInfo(
                dataState: DataState.error,
                errorMessage: responseData.result?.getMessage(),
              ),
            ),
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          manageInitState: state.manageInitState?.copyWith(
            singleTransactionDetailInfo: SingleTransactionDetailInfo(
              dataState: DataState.error,
            ),
          ),
        ),
      );
    }
  }
}
