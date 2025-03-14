import 'dart:async';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/deposits/open_online_input_deposit_state.dart';
import 'package:b2b/scr/bloc/transfer/transfer_bloc.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:b2b/scr/data/model/open_saving/init_deposits_result.dart';
import 'package:b2b/scr/data/model/open_saving/rollover_term.dart';
import 'package:b2b/scr/data/model/open_saving/rollover_term_rate.dart';
import 'package:b2b/scr/data/model/open_saving/saving_deposits_product_response.dart';
import 'package:b2b/scr/data/model/open_saving/saving_init_request.dart';
import 'package:b2b/scr/data/model/open_saving/settelment.dart';
import 'package:b2b/scr/data/model/transaction/transaction_confirm_response.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/data/repository/open_deposits_repository.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'open_online_deposits_event.dart';

part 'open_online_deposits_state.dart';

class OpenOnlineDepositsBloc
    extends Bloc<OpenOnlineDepositsEvent, OpenOnlineDepositsState> {
  OpenOnlineDepositsBloc(this.repository) : super(OpenOnlineDepositsState());

  OpenDepositsRepository repository;

  @override
  Stream<OpenOnlineDepositsState> mapEventToState(
      OpenOnlineDepositsEvent event) async* {
    switch (event.runtimeType) {
      case OpenDepositsInitEvent:
        yield* _mapToOpenDepositsInitEvent();
        break;
      case ChangeOnlineDepositsProduct:
        SavingDepositsProductResponse productResponse =
            (event as ChangeOnlineDepositsProduct).currentDepositProduct;
        yield state.copyWith(
            currentDepositProduct: productResponse,
            currentDepositType: productResponse.groupArray?[0],
            savingReceiveMethod:
                productResponse.groupArray?[0]?.productArray?[0],
            clearSavingReceiveMethod:
                (productResponse.groupArray?[0]?.productArray?[0] == null));
        break;
      case ChangeDebitAccountEvent:
        yield* _mapToChangeDebitAccountEvent(event as ChangeDebitAccountEvent);
        break;
      case GetSavingDepositsProductEvent:
        yield* _mapToGetSavingDepositsProductEvent();
        break;
      case ChangeOnlineDepositsType:
        yield* _mapToChangeOnlineDepositsType(
            event as ChangeOnlineDepositsType);
        break;
      case ChangeSavingReceiveMethod:
        yield state.copyWith(
            savingReceiveMethod:
                (event as ChangeSavingReceiveMethod).savingReceiveMethod);
        break;

      case GetRollOverTermListEvent:
        yield* _mapToGetRollOverTermListEvent(
            event as GetRollOverTermListEvent);
        break;

      case ChangeRolloverTermEvent:
        yield state.copyWith(
          depositsInputState: state.depositsInputState?.copyWith(
              selectedRollOverTerm:
                  (event as ChangeRolloverTermEvent).rolloverTerm),
        );
        yield* _getRolloverTermRate(event as ChangeRolloverTermEvent);
        break;
      case ClearRolloverTermRateEvent:
        yield state.copyWith(
          depositsInputState: state.depositsInputState
              ?.copyWith(isClearRolloverRateEvent: true),
        );
        break;
      case ClearInputState:
        yield state.copyWith(depositsInputState: const DepositsInputState());
        break;
      case ChangeSettElementEvent:
        yield state.copyWith(
          depositsInputState: state.depositsInputState?.copyWith(
              selectedSettelment: (event as ChangeSettElementEvent).settelment),
        );
        break;
      case InitDepositsEvent:
        yield* _initDepositsEvent(event as InitDepositsEvent);
        break;
      case ConfirmOpenDepositsEvent:
        yield* _confirmOpenDepositsEvent(event as ConfirmOpenDepositsEvent);
        break;
      case ClearDepositsStateEvent:
        yield state.copyWith(isClearInputState: true);
        break;
      case ClearDepositInitDataState:
        yield state.copyWith(clearDepositInitDataState: true);
        break;
      default:
        break;
    }
  }

  Stream<OpenOnlineDepositsState> _confirmOpenDepositsEvent(
      ConfirmOpenDepositsEvent event) async* {
    yield state.copyWith(confirmDepositsDataState: DataState.preload);

    Map<String, dynamic> params = {
      'trans_code': event.initDepositsResult.transCode,
      'secure_trans': event.initDepositsResult.sercureTrans,
      'transfer_type_code': 4
    };

    try {
      final response = await repository.confirmOpenDeposits(params);
      if (response.item.result?.isSuccess() == true) {
        TransactionManageConfirmResponse? confirmResponse =
            response.item.toModel(
          (json) => TransactionManageConfirmResponse.fromJson(json),
        );

        confirmResponse?.message = response.item.result?.getMessage();

        yield state.copyWith(
          confirmResponse: confirmResponse,
          confirmDepositsDataState: DataState.data,
        );
      } else {
        throw response.item.result as Object;
      }
    } on Object catch (e) {
      Logger.error('_initDepositsEvent err $e');
      yield state.copyWith(
        confirmDepositsDataState: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<OpenOnlineDepositsState> _initDepositsEvent(
      InitDepositsEvent event) async* {
    Logger.debug('_InitDepositsEvent');

    yield state.copyWith(initDepositsDataState: DataState.preload);

    try {
      final response =
          await repository.initDeposits(event.initRequest.toJson());
      if (response.item.result?.isSuccess() == true) {
        InitDepositsResult? initDepositsResult = response.item.toModel(
          (json) => InitDepositsResult.fromJson(json),
        );

        yield state.copyWith(
          intDepositsResult: initDepositsResult,
          initDepositsDataState: DataState.data,
        );
      } else {
        throw response.item.result as Object;
      }
    } on Object catch (e) {
      Logger.error('_initDepositsEvent err $e');
      yield state.copyWith(
        initDepositsDataState: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<OpenOnlineDepositsState> _getRolloverTermRate(
      ChangeRolloverTermEvent event) async* {
    Logger.debug('_getRolloverTermRate');

    yield state.copyWith(
      depositsInputState: state.depositsInputState?.copyWith(
        rollTermRateDataState: DataState.preload,
      ),
    );

    try {
      Map<String, dynamic> params = {
        'lang': AppTranslate().getCurrentLanguageApiCode(),
        'product_id': state.savingReceiveMethod?.productId,
        'secure_id': state.savingReceiveMethod?.secureId,
        'amount': event.amount,
        'term_code': event.rolloverTerm.termCode
      };
      final response = await repository.getTermRate(params);
      if (response.item.result?.isSuccess() == true) {
        RolloverTermRate? rolloverTermRate = response.item.toModel(
          (json) => RolloverTermRate.fromJson(json),
        );

        yield state.copyWith(
          depositsInputState: state.depositsInputState?.copyWith(
            rollTermRateDataState: DataState.data,
            rolloverTermRate: rolloverTermRate,
          ),
        );
      } else {
        throw response.item.result as Object;
      }
    } on Object catch (e) {
      Logger.error('_mapToGetRollOverTermListEvent err $e');
      yield state.copyWith(
        depositsInputState: state.depositsInputState?.copyWith(
          rollTermRateDataState: DataState.error,
        ),
      );
    }
  }

  Stream<OpenOnlineDepositsState> _mapToGetRollOverTermListEvent(
      GetRollOverTermListEvent event) async* {
    yield state.copyWith(
      depositsInputState: state.depositsInputState?.copyWith(
        rollOverTermListDataState: DataState.preload,
        clearRollOverTermList: true,
      ),
    );

    try {
      Map<String, dynamic> params = {
        'lang': AppTranslate().getCurrentLanguageApiCode(),
        'product_id': state.savingReceiveMethod?.productId,
        'secure_id': state.savingReceiveMethod?.secureId,
        'amount': event.amount
      };
      final response = await repository.getRolloverTermList(params);
      if (response.item.result?.isSuccess() == true) {
        List<RolloverTerm> rollOverList = response.item.toArrayModel(
          (json) => RolloverTerm.fromJson(json),
        );

        Logger.debug('---------- size ${rollOverList.length}');

        yield state.copyWith(
          depositsInputState: state.depositsInputState?.copyWith(
            rollOverTermListDataState: DataState.data,
            rollOverTermList: rollOverList,
          ),
        );
      } else {
        throw response.item.result as Object;
      }
    } on Object catch (e) {
      Logger.error('_mapToGetRollOverTermListEvent err $e');
      yield state.copyWith(
        depositsInputState: state.depositsInputState?.copyWith(
            rollOverTermListDataState: DataState.error,
            clearRollOverTermList: true),
      );
    }
  }

  Stream<OpenOnlineDepositsState> _mapToChangeOnlineDepositsType(
      ChangeOnlineDepositsType event) async* {
    yield state.copyWith(
        currentDepositType: event.depositsType,
        savingReceiveMethod: event.depositsType.productArray?[0],
        clearSavingReceiveMethod: event.depositsType.productArray?[0] == null);
  }

  Stream<OpenOnlineDepositsState> _mapToOpenDepositsInitEvent() async* {
    yield* _mapGetListDebitAccountEventToState();
    yield* _mapGetSettelment();
  }

  Stream<OpenOnlineDepositsState> _mapGetSettelment() async* {
    yield state.copyWith(
      depositsInputState: state.depositsInputState?.copyWith(
        settelmentDataState: DataState.preload,
      ),
    );
    try {
      Map<String, dynamic> params = {
        'lang': AppTranslate().currentLanguage == SupportLanguages.En ? 0 : 1,
        'product_id': state.savingReceiveMethod?.productId,
        'secure_id': state.savingReceiveMethod?.secureId,
      };
      final response = await repository.getSettelment(params);
      if (response.item.result?.isSuccess() == true) {
        List<Settelment> listSettelment = response.item.toArrayModel(
          (json) => Settelment.fromJson(json),
        );

        Logger.debug('---------- size ${listSettelment.length}');

        yield state.copyWith(
          depositsInputState: state.depositsInputState?.copyWith(
              settelmentDataState: DataState.data,
              listSettelment: listSettelment),
        );
      } else {
        throw response.item.result as Object;
      }
    } on Object catch (e) {
      Logger.error('_mapToOpenDepositsInitEvent err $e');
      yield state.copyWith(
          depositsInputState: state.depositsInputState?.copyWith(
        settelmentDataState: DataState.error,
        errMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      ));
    }
  }

  Stream<OpenOnlineDepositsState> _mapToGetSavingDepositsProductEvent() async* {
    yield state.copyWith(
      depositsSavingProductState: DataState.preload,
    );
    try {
      Map<String, dynamic> params = {
        'lang': AppTranslate().currentLanguage == SupportLanguages.En ? 0 : 1
      };
      final response = await repository.getSavingDepositsProductType(params);
      if (response.item.result?.isSuccess() == true) {
        List<SavingDepositsProductResponse> listDepositsProduct =
            response.item.toArrayModel(
          (json) => SavingDepositsProductResponse.fromJson(json),
        );

        Logger.debug('---------- size ${listDepositsProduct.length}');

        SavingDepositsProductResponse productResponse = listDepositsProduct[0];

        yield state.copyWith(
          depositsSavingProductState: DataState.data,
          listDepositsProduct: listDepositsProduct,
          currentDepositProduct: productResponse,
          currentDepositType: productResponse.groupArray?[0],
          savingReceiveMethod: productResponse.groupArray?[0]?.productArray?[0],
        );
      } else {
        throw response.item.result as Object;
      }
    } on Object catch (e) {
      Logger.error('_mapToOpenDepositsInitEvent err $e');
      yield state.copyWith(
        depositsSavingProductState: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<OpenOnlineDepositsState> _mapToChangeDebitAccountEvent(
      ChangeDebitAccountEvent event) async* {
    DebitAccountModel debitAccountModel = event.debitAccountModel;
    bool isRootAccount = event.isRootAccount;

    Logger.debug('_mapToChangeDebitAccountEvent isRootAccount $isRootAccount');

    if (isRootAccount) {
      yield state.copyWith(
          rootAccountDebit: debitAccountModel,
          receiveAccountProfit: debitAccountModel);
    } else {
      yield state.copyWith(receiveAccountProfit: debitAccountModel);
    }
  }

  Stream<OpenOnlineDepositsState> _mapGetListDebitAccountEventToState() async* {
    Logger.debug("start");

    yield state.copyWith(
      debitAccountDataState: DataState.preload,
    );
    try {
      Map<String, dynamic> params = {
        'lang': AppTranslate().currentLanguage == SupportLanguages.En ? 0 : 1,
        'secure_id': state.savingReceiveMethod?.secureId,
        'product_id': state.savingReceiveMethod?.productId,
      };

      final response = await repository.getListDebitAccount(params);
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
          debitAccountDataState: DataState.data,
          listDebitAccount: listAccountDebitModel.item.debbitAccountList,
          debitAccountDefault: accountDebit,
          rootAccountDebit: accountDebit,
          receiveAccountProfit: accountDebit,
        );
      } else {
        throw response.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        debitAccountDataState: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }
}
