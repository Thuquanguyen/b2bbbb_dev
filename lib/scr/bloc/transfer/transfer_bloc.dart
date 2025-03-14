import 'dart:async';

import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/api_service/list_response.dart';
import 'package:b2b/scr/core/api_service/single_response.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/base_item_model.dart';
import 'package:b2b/scr/data/model/base_result_model.dart';
import 'package:b2b/scr/data/model/search/ben_bank_model.dart';
import 'package:b2b/scr/data/model/search/beneficiary_saved_model.dart';
import 'package:b2b/scr/data/model/search/branch_model.dart';
import 'package:b2b/scr/data/model/search/city_model.dart';
import 'package:b2b/scr/data/model/transfer/amount_info.dart';
import 'package:b2b/scr/data/model/transfer/benefician_account_model.dart';
import 'package:b2b/scr/data/model/transfer/confirm_transfer_model.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/data/model/transfer/init_transfer_model.dart';
import 'package:b2b/scr/data/repository/transfer_repository.dart';
import 'package:b2b/scr/presentation/screens/transfer/transfer_input/save_ben.dart';
import 'package:b2b/scr/presentation/screens/transfer/transfer_input/transfer_manager.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'transfer_event.dart';

part 'transfer_state.dart';

enum TransferType {
  TRANS247_ACCOUNT,
  TRANS247_CARD,
  TRANSINHOUSE,
  TRANSINTERBANK,
  CARD, // Thẻ,
  TAX
}

extension TransferTypeCode on TransferType {
  int get getTransferTypeCode {
    switch (this) {
      case TransferType.TRANSINHOUSE:
        return 0;
      case TransferType.TRANSINTERBANK:
        return 1;
      case TransferType.TRANS247_ACCOUNT:
        return 2;
      case TransferType.TRANS247_CARD:
        return 3;
      case TransferType.CARD:
        return 6;
      case TransferType.TAX:
        return 7;
      default:
        return -1;
    }
  }
}

class TransferBloc extends Bloc<TransferEvent, TransferState> {
  TransferBloc({required this.transferRepositoryImpl}) : super(TransferState());

  TransferRepositoryImpl transferRepositoryImpl;

  @override
  Stream<TransferState> mapEventToState(TransferEvent event) async* {
    switch (event.runtimeType) {
      case GetBenListEvent:
        if (state.transferType == TransferType.TRANS247_ACCOUNT) {
          getBenList(TransferType.TRANS247_ACCOUNT);
          getBenList(TransferType.TRANS247_CARD);
        } else {
          getBenList(state.transferType ?? TransferType.TRANSINHOUSE);
        }
        break;
      case GetListDebitAccountEvent:
        yield* _mapGetListDebitAccountEventToState(
          event as GetListDebitAccountEvent,
        );
        break;
      case ClearAccountErrorMessage:
        yield state.copyWith(clearErrorAccountMessage: true);
        break;
      case GetBenAccountDetailEvent:
        yield* _mapGetBenAccountDetailEventToState(
          event as GetBenAccountDetailEvent,
        );
        break;
      case ChangeTransfer247TypeEvent:
        yield state.copyWith(
            transferType: (event as ChangeTransfer247TypeEvent).transferType);
        break;
      case ChangeTransferInterbankTypeEvent:
        yield state.copyWith(
            transferType:
                (event as ChangeTransferInterbankTypeEvent).transferType);
        break;
      case InitTransferEvent:
        yield* _mapInitTransferEventToState(event as InitTransferEvent);
        break;
      case GetBenListInterBankEvent:
        yield* _mapToSearchBenListEvent(event as GetBenListInterBankEvent);
        break;
      case ConfirmTransferEvent:
        yield* _mapConfirmTransferEventToState(event as ConfirmTransferEvent);
        break;
      // case UpdateBenAccountFromBenListSavedEvent:
      //   yield* _mapUpdateBenAccountFromBenListSavedEventToState(
      //     event as UpdateBenAccountFromBenListSavedEvent,
      //   );
      //   break;
      case SearchBranchListInterbankEvent:
        yield* _mapToSearchBranchInterBankEvent(
            event as SearchBranchListInterbankEvent);
        break;
      case UpdateListBranchEvent:
        yield state.copyWith(
            transferInterbankState: state.transferInterbankState
                .copyWith(listBranch: [], clearBranchModel: true));
        break;
      case ChangeDebitAccountEvent:
        yield* _mapChangeDebitAccountEventEventToState(
          event as ChangeDebitAccountEvent,
        );
        break;
      case Change247FeeAccountEvent:
        yield state.copyWith(
            transfer247: state.transfer247.copyWith(
                feeAccount:
                    (event as Change247FeeAccountEvent).debitAccountModel));
        break;
      case ChangeInterbankFeeAccountEvent:
        yield state.copyWith(
            transferInterbankState: state.transferInterbankState.copyWith(
                feeAccount: (event as ChangeInterbankFeeAccountEvent)
                    .debitAccountModel));
        break;
      case UpdateTransfer247BankEvent:
        BenBankModel? benBankModel =
            (event as UpdateTransfer247BankEvent).benBank;
        if (benBankModel?.bankNo == state.transfer247.benBank?.bankNo) {
          break;
        }
        yield state.copyWith(
          detailBeneficianAccount: BeneficianAccountModel(),
          transfer247: state.transfer247.copyWith(
            benBank: benBankModel,
          ),
        );
        break;
      case UpdateTransferInterbankEvent:
        BenBankModel? benBankModel =
            (event as UpdateTransferInterbankEvent).benBank;
        if (benBankModel?.bankNo ==
            state.transferInterbankState.benBank?.bankNo) {
          break;
        }
        yield state.copyWith(
            detailBeneficianAccount: null,
            transferInterbankState: state.transferInterbankState.copyWith(
                benBank: benBankModel,
                clearCityModel: true,
                clearBranchModel: true));
        break;
      case ChangeInterbankBranchEvent:
        BranchModel? branchModel =
            (event as ChangeInterbankBranchEvent).branchModel;
        if (branchModel?.branchCode == null) {
          break;
        }
        yield state.copyWith(
            transferInterbankState: state.transferInterbankState
                .copyWith(branchModel: branchModel));
        break;
      case ChangeInterbankAccountNumberEvent:
        String accountNumber =
            (event as ChangeInterbankAccountNumberEvent).accountNumber ?? '';
        String accountNumberState =
            state.transferInterbankState.accountNumber ?? '';
        if (accountNumber.isEmpty && accountNumberState.isEmpty) {
          break;
        }
        yield state.copyWith(
            transferInterbankState: state.transferInterbankState.copyWith(
                accountNumber: accountNumber,
                clearData: (accountNumber != accountNumberState &&
                    accountNumberState.isNotEmpty)));
        break;
      case ChangeInterbankLocationEvent:
        CityModel? cityModel =
            (event as ChangeInterbankLocationEvent).cityModel;
        if (cityModel?.cityCode ==
            state.transferInterbankState.cityModel?.cityCode) {
          break;
        }
        yield state.copyWith(
            transferInterbankState: state.transferInterbankState
                .copyWith(cityModel: cityModel, clearBranchModel: true));
        break;
      case ChangeInterbankFeeTypeEvent:
        BaseItemModel? baseItemModel =
            (event as ChangeInterbankFeeTypeEvent).baseItemModel;
        if (baseItemModel == state.transferInterbankState.baseItemModel) {
          break;
        }
        yield state.copyWith(
            transferInterbankState: state.transferInterbankState
                .copyWith(baseItemModel: baseItemModel));
        break;
      case ChangeInterbankBeneficiaryNameEvent:
        String beneficiaryName =
            (event as ChangeInterbankBeneficiaryNameEvent).beneficiaryName ??
                '';
        String beneficiaryNameState =
            state.transferInterbankState.beneficiaryName ?? '';

        if (beneficiaryName.isNotEmpty && beneficiaryNameState.isNotEmpty) {
          break;
        }

        yield state.copyWith(
          transferInterbankState: state.transferInterbankState.copyWith(
            beneficiaryName: beneficiaryName,
          ),
        );
        break;
      case UpdateInterbankSaveBenEvent:
        SaveBen? saveBen = (event as UpdateInterbankSaveBenEvent).saveBen;
        if (saveBen == state.transferInterbankState.saveBen) {
          break;
        }
        yield state.copyWith(
            transferInterbankState:
                state.transferInterbankState.copyWith(saveBen: saveBen));
        break;
      case GetBankListEvent:
        _mapToGetBankListEvent();
        break;
      case GetBankListResultEvent:
        yield state.copyWith(
          transfer247: state.transfer247.copyWith(
            benBank: (event as GetBankListResultEvent).benBank,
          ),
          transferInterbankState: state.transferInterbankState.copyWith(
            benBank: event.benBank,
          ),
        );
        break;
      case Transfer247ChangeAccountEvent:
        yield* _mapTransfer247AccountState(
            event as Transfer247ChangeAccountEvent);
        break;
      case ClearTransferStateEvent:
        yield TransferState();
        break;
      default:
        break;
    }
  }

  Stream<TransferState> _mapToSearchBranchInterBankEvent(
      SearchBranchListInterbankEvent event) async* {
    Logger.debug('start');
    yield state.copyWith(
        listBranchDataState: DataState.preload, isShowLoadingBranch: true);
    try {
      var response = await transferRepositoryImpl.searchBranchList(
          event.bankCode, event.cityCode);
      if (response.result!.isSuccess()) {
        final ListResponse<BranchModel> listBranch = ListResponse<BranchModel>(
          response.data,
          (itemJson) => BranchModel.fromJson(itemJson),
        );
        Logger.debug("121212121212121212 ${listBranch.items.length}");
        yield state.copyWith(
          listBranch: listBranch.items,
          isShowLoadingBranch: false,
          transferInterbankState: state.transferInterbankState
              .copyWith(listBranch: listBranch.items),
          listBranchDataState: DataState.data,
        );
      }
    } catch (e) {
      Logger.debug("Exception $e");
      yield state.copyWith(
        listBranchDataState: DataState.error,
        isShowLoadingBranch: true,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<TransferState> _mapToSearchBenListEvent(
      GetBenListInterBankEvent event) async* {
    Logger.debug("start");
    yield state.copyWith(listBenDataState: DataState.preload);

    try {
      var response =
          await transferRepositoryImpl.searchBenList(event.transferTypeOfCode);

      if (response.result!.isSuccess()) {
        final ListResponse<BeneficiarySavedModel> listBenModel =
            ListResponse<BeneficiarySavedModel>(
          response.data,
          (item) => BeneficiarySavedModel.fromJson(item),
        );
        Logger.debug("length : ${listBenModel.items.length}");
        yield state.copyWith(
            transferInterbankState: state.transferInterbankState
                .copyWith(listBenModel: listBenModel.items),
            listBenDataState: DataState.data);
      } else {
        Logger.debug("response err");
        throw response.result as Object;
      }
    } catch (e) {
      Logger.debug("Exception $e");
      yield state.copyWith(
        listBenDataState: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<TransferState> _mapTransfer247AccountState(
      Transfer247ChangeAccountEvent event) async* {
    String accountNumber = event.accountNumber;

    if (state.detailBeneficianAccount?.accountNumber != null) {
      yield state.copyWith(clearBenDetail: true);
    }
  }

  Stream<TransferState> _mapChangeDebitAccountEventEventToState(
      ChangeDebitAccountEvent event) async* {
    try {
      yield state.copyWith(
        isShowLoading: true,
        listDebitAccountDataState: DataState.preload,
      );
      final listDebitAccount = state.listDebitAccount;
      listDebitAccount!.removeWhere(
        (element) =>
            event.accountDebitModel.accountNumber == element.accountNumber,
      );
      listDebitAccount.insert(
        0,
        event.accountDebitModel,
      );
      yield state.copyWith(
        isShowLoading: false,
        debitAccountDefault: event.accountDebitModel,
        listDebitAccount: listDebitAccount,
        listDebitAccountDataState: DataState.data,
        transfer247:
            state.transfer247.copyWith(feeAccount: event.accountDebitModel),
        transferInterbankState: state.transferInterbankState
            .copyWith(feeAccount: event.accountDebitModel),
      );
    } catch (e) {
      yield state.copyWith(
        isShowLoading: false,
        listDebitAccountDataState: DataState.error,
      );
    }
  }

  Stream<TransferState> _mapGetBenAccountDetailEventToState(
      GetBenAccountDetailEvent event) async* {
    try {
      // if (event.benAccount == state.detailBeneficianAccount?.accountNumber) return;
      yield state.copyWith(
        isShowLoading: true,
        isShowLoadingAccount: true,
        detailBeneficianAccountDataState: DataState.preload,
        detailBeneficianAccount: BeneficianAccountModel(),
      );
      if (event.benAccount.isEmpty) {
        yield state.copyWith(
          isShowLoading: false,
          isShowLoadingAccount: false,
          detailBeneficianAccount: BeneficianAccountModel(),
          detailBeneficianAccountDataState: DataState.data,
        );
        return;
      }

      final response = await transferRepositoryImpl.getBenAccountDetail(
          event.benAccount, state.transferType!.getTransferTypeCode,
          benBank: event.benBank);
      if (response.result!.isSuccess()) {
        response.data['account_number'] = event.benAccount;
        response.data['is_account_ben_from_list_saved'] =
            event.isAccountBenFromListSaved;
        final benAccountDetail = SingleResponse(
          response.data,
          (item) => BeneficianAccountModel.fromJson(item),
        );

        BeneficianAccountModel benModel = benAccountDetail.item;
        CityModel cityModel =
            CityModel(cityName: benModel.benBranch, cityCode: benModel.benCity);

        // TH stk này trc đó đã dc lưu => update thêm thông tin alias cho nó
        String accountNumber = benModel.accountNumber ?? "";
        if (state.transferType == TransferType.TRANSINHOUSE) {
          BeneficiarySavedModel? beneficiarySavedModel =
              TransferManager().findInHouseBen(accountNumber);
          benModel.benAlias = beneficiarySavedModel?.benAlias;
        } else if (state.transferType == TransferType.TRANS247_CARD) {
          BeneficiarySavedModel? beneficiarySavedModel =
              TransferManager().findNapasCardBen(accountNumber);
          benModel.benAlias = beneficiarySavedModel?.benAlias;
        } else if (state.transferType == TransferType.TRANS247_ACCOUNT) {
          BeneficiarySavedModel? beneficiarySavedModel =
              TransferManager().findNapasAccountBen(accountNumber);
          benModel.benAlias = beneficiarySavedModel?.benAlias;
        } else if (state.transferType == TransferType.TRANSINTERBANK) {
          BeneficiarySavedModel? beneficiarySavedModel =
              TransferManager().findInternetBen(accountNumber);
          benModel.benAlias = beneficiarySavedModel?.benAlias;
        }
        yield state.copyWith(
            isShowLoading: false,
            isShowLoadingAccount: false,
            detailBeneficianAccountDataState: DataState.data,
            transferInterbankState: state.transferInterbankState.copyWith(
                clearCityModel: benAccountDetail.item.benCity == null,
                cityModel: cityModel),
            detailBeneficianAccount: benModel,
            clearErrorAccountMessage: true);
      } else {
        throw response.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        isShowLoading: false,
        isShowLoadingAccount: false,
        detailBeneficianAccountDataState: DataState.error,
        transferInterbankState:
            state.transferInterbankState.copyWith(clearCityModel: true),
        detailBeneficianAccount: BeneficianAccountModel(),
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.canNotFindAccountStr.localized,
        errorAccountMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.canNotFindAccountStr.localized,
      );
    }
  }

  Stream<TransferState> _mapConfirmTransferEventToState(
    ConfirmTransferEvent event,
  ) async* {
    try {
      yield state.copyWith(
        confirmTransferModelDataState: DataState.preload,
      );
      final rawResponse = await transferRepositoryImpl.confirmTransfer(
        state.initTransferModel!,
        state.transferType!.getTransferTypeCode,
      );
      if (rawResponse.result!.isSuccess()) {
        final response = rawResponse.data;
        yield state.copyWith(
          confirmTransferModelDataState: DataState.data,
          confirmTransferModel: ConfirmTransferModel(
            rawResponse.result!.getMessage(),
            (response['verify_otp_display_type'] as int),
          ),
        );
      } else {
        throw rawResponse.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        confirmTransferModelDataState: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<TransferState> _mapInitTransferEventToState(
    InitTransferEvent event,
  ) async* {
    try {
      yield state.copyWith(
        initTransferModelDataState: DataState.preload,
      );

      if (event.amountInfo.amount <= 0) {
        throw BaseResultModel(
            messageVi:
                AppTranslate.i18n.theMoneyMustBeBiggerThanZeroStr.localized);
      }

      String? bankCode = null; // bank napas id
      bankCode = state.transferType == TransferType.TRANS247_ACCOUNT
          ? state.transfer247.benBank?.bankNapasId
          : null;
      final rawResponse = await transferRepositoryImpl.initTransfer(
          debbitAccount: state.debitAccountDefault!,
          chargeAccount: event.chargeAccount,
          benAccount: state.detailBeneficianAccount ?? BeneficianAccountModel(),
          amountInfo: event.amountInfo,
          transferTypeCode: state.transferType!.getTransferTypeCode,
          addBen: event.isAddBen,
          benAlias: event.benAlias,
          memo: event.memo,
          bankCode: bankCode ?? event.bankCode,
          city: event.city,
          branch: event.branch,
          accountName: event.accountName,
          accountNumber: event.accountNumber,
          cityName: event.cityName,
          outBenFee: event.outBenFee,
          branchName: event.branchName,
          benCcy: event.benCcy);
      if (rawResponse.result!.isSuccess()) {
        final response = SingleResponse<InitTransferModel>(
          rawResponse.data,
          (item) => InitTransferModel.fromJson(item),
        );
        yield state.copyWith(
          amountInfo: event.amountInfo,
          initTransferModelDataState: DataState.data,
          initTransferModel: response.item,
        );
      } else {
        throw rawResponse.result as Object;
      }
    } on Object catch (e) {
      Logger.debug("LOIIIIIII $e");
      yield state.copyWith(
        initTransferModelDataState: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  Stream<TransferState> _mapGetListDebitAccountEventToState(
    GetListDebitAccountEvent event,
  ) async* {
    Logger.debug("start");

    yield state.copyWith(
      isShowLoading: true,
      transferType: event.transferType,
      listDebitAccountDataState: DataState.preload,
    );
    try {
      final response = await transferRepositoryImpl.getListDebitAccount(
        event.transferType.getTransferTypeCode,
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
          isShowLoading: false,
          listDebitAccountDataState: DataState.data,
          listDebitAccount: listAccountDebitModel.item.debbitAccountList,
          debitAccountDefault: accountDebit,
          transfer247: state.transfer247.copyWith(feeAccount: accountDebit),
          transferInterbankState:
              state.transferInterbankState.copyWith(feeAccount: accountDebit),
        );
      } else {
        throw response.result as Object;
      }
    } on Object catch (e) {
      yield state.copyWith(
        isShowLoading: false,
        listDebitAccountDataState: DataState.error,
        errorMessage: (e is BaseResultModel)
            ? e.getMessage()
            : AppTranslate.i18n.havingAnErrorStr.localized,
      );
    }
  }

  void _mapToGetBankListEvent() {
    Logger.debug("start");

    _getBankList();
  }

  void _getBankList() async {
    try {
      var response = await transferRepositoryImpl.getBenBankList();

      if (response.result!.isSuccess()) {
        final ListResponse<BenBankModel> listRoot = ListResponse<BenBankModel>(
          response.data,
          (item) => BenBankModel.fromJson(item),
        );

        Logger.debug("length : ${listRoot.items.length}");

        for (var element in listRoot.items) {
          if (element.isNapas == true) {
            Logger.debug("Init bank default : ${element.toJson()}");
            add(GetBankListResultEvent(benBank: element));
            break;
          }
        }
      } else {
        Logger.debug("response err");
        throw response.result as Object;
      }
    } catch (e) {
      Logger.debug("Exception $e");
    }
  }

  getBenList(TransferType type) async {
    Logger.debug("getBenList $type");
    try {
      var response =
          await transferRepositoryImpl.searchBenList(type.getTransferTypeCode);

      if (response.result!.isSuccess()) {
        final ListResponse<BeneficiarySavedModel> listBenModel =
            ListResponse<BeneficiarySavedModel>(
          response.data,
          (item) => BeneficiarySavedModel.fromJson(item),
        );
        if (type == TransferType.TRANS247_CARD) {
          TransferManager().napasCardBenLists = listBenModel.items;
        } else if (type == TransferType.TRANS247_ACCOUNT) {
          TransferManager().napasAccountBenLists = listBenModel.items;
        } else if (type == TransferType.TRANSINHOUSE) {
          TransferManager().inHouseBenLists = listBenModel.items;
        } else if (type == TransferType.TRANSINTERBANK) {
          TransferManager().internetBenLists = listBenModel.items;
        }
      } else {
        throw response.result as Object;
      }
    } catch (e) {
      Logger.error("Add exception $e");
    }
  }
}
