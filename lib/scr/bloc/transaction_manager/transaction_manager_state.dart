import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/data/model/base_item_model.dart';
import 'package:b2b/scr/data/model/bill_payment_model.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/payroll_ben_model.dart';
import 'package:b2b/scr/data/model/saving_transaction_model.dart';
import 'package:b2b/scr/data/model/transaction/payroll_manage_init_response.dart';
import 'package:b2b/scr/data/model/transaction/transaction_confirm_response.dart';
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/data/model/transaction/transaction_init_response.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:equatable/equatable.dart';

class TransactionManagerState extends Equatable {
  final String? selectedCategory;
  final List<TransactionMainModel>? listData;
  final DataState transactionListDataState;
  final List<TransactionSavingModel>? listSaving;
  final DataState listSavingDataState;
  final List<NameModel>? listServiceType;
  final List<BaseItemModel>? listDisplayServiceType;
  final String? selectedServiceTypeString;
  final NameModel? selectedServiceTypeModel;
  final bool? isFiltering;
  final TransactionFilterRequest? filterRequest;
  final TransactionManageInitState? manageInitState;
  final BillTransactionManageInitState? billManageInitState;
  final TransactionManageConfirmState? manageConfirmState;
  final BillTransactionManageConfirmState? billManageConfirmState;
  final TransactionAdditionalInfoState? additionalInfoState;
  final SavingTransactionManageInitState? savingManageInitState;
  final SavingTransactionManageConfirmState? savingManageConfirmState;
  final PayrollTransactionManageInitState? payrollManageInitState;
  final PayrollTransactionManageConfirmState? payrollManageConfirmState;
  final PayrollBenListState? payrollBenListState;
  final String? errorMessage;

  const TransactionManagerState({
    this.selectedCategory,
    this.isFiltering = false,
    this.listData,
    this.listSaving,
    this.listSavingDataState = DataState.init,
    this.listServiceType,
    this.transactionListDataState = DataState.init,
    this.filterRequest,
    this.selectedServiceTypeString,
    this.selectedServiceTypeModel,
    this.listDisplayServiceType,
    this.manageInitState,
    this.billManageInitState,
    this.manageConfirmState,
    this.billManageConfirmState,
    this.savingManageInitState,
    this.savingManageConfirmState,
    this.payrollManageInitState,
    this.payrollManageConfirmState,
    this.payrollBenListState,
    this.additionalInfoState,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [
        selectedCategory,
        isFiltering,
        listData,
        listServiceType,
        listSaving,
        listSavingDataState,
        transactionListDataState,
        selectedServiceTypeString,
        manageInitState,
        billManageInitState,
        manageConfirmState,
        billManageConfirmState,
        savingManageInitState,
        savingManageConfirmState,
        payrollManageInitState,
        payrollManageConfirmState,
        payrollBenListState,
        additionalInfoState,
        errorMessage
      ];

  TransactionManagerState copyWith({
    String? selectedCategory,
    bool? isFiltering,
    List<TransactionMainModel>? listData,
    List<TransactionSavingModel>? listSaving,
    DataState? listSavingDataState,
    List<NameModel>? listServiceType,
    String? selectedServiceTypeString,
    NameModel? selectedServiceTypeModel,
    DataState? transactionListDataState,
    TransactionFilterRequest? filterRequest,
    List<BaseItemModel>? listDisplayServiceType,
    TransactionManageInitState? manageInitState,
    BillTransactionManageInitState? billManageInitState,
    TransactionManageConfirmState? manageConfirmState,
    BillTransactionManageConfirmState? billManageConfirmState,
    SavingTransactionManageInitState? savingManageInitState,
    SavingTransactionManageConfirmState? savingManageConfirmState,
    PayrollTransactionManageInitState? payrollManageInitState,
    PayrollTransactionManageConfirmState? payrollManageConfirmState,
    PayrollBenListState? payrollBenListState,
    TransactionAdditionalInfoState? additionalInfoState,
    String? errorMessage,
  }) {
    return TransactionManagerState(
        selectedCategory: selectedCategory ?? this.selectedCategory,
        isFiltering: isFiltering ?? this.isFiltering,
        listData: listData ?? this.listData,
        listSaving: listSaving ?? this.listSaving,
        listSavingDataState: listSavingDataState ?? this.listSavingDataState,
        listServiceType: listServiceType ?? this.listServiceType,
        transactionListDataState: transactionListDataState ?? this.transactionListDataState,
        filterRequest: filterRequest ?? this.filterRequest,
        selectedServiceTypeString: selectedServiceTypeString ?? this.selectedServiceTypeString,
        selectedServiceTypeModel: selectedServiceTypeModel ?? this.selectedServiceTypeModel,
        listDisplayServiceType: listDisplayServiceType ?? this.listDisplayServiceType,
        manageInitState: manageInitState ?? this.manageInitState,
        billManageInitState: billManageInitState ?? this.billManageInitState,
        manageConfirmState: manageConfirmState ?? this.manageConfirmState,
        billManageConfirmState: billManageConfirmState ?? this.billManageConfirmState,
        savingManageInitState: savingManageInitState ?? this.savingManageInitState,
        savingManageConfirmState: savingManageConfirmState ?? this.savingManageConfirmState,
        payrollManageInitState: payrollManageInitState ?? this.payrollManageInitState,
        payrollManageConfirmState: payrollManageConfirmState ?? this.payrollManageConfirmState,
        payrollBenListState: payrollBenListState ?? this.payrollBenListState,
        additionalInfoState: additionalInfoState ?? this.additionalInfoState,
        errorMessage: errorMessage ?? this.errorMessage);
  }
}

class TransactionManageInitState {
  TransactionManageInitState({
    this.dataState,
    this.data,
    this.singleTransactionDetailInfo,
    this.errorMessage,
  });

  DataState? dataState;
  TransactionManageInitResponse? data;
  SingleTransactionDetailInfo? singleTransactionDetailInfo;
  String? errorMessage;

  TransactionManageInitState copyWith({
    DataState? dataState,
    TransactionManageInitResponse? data,
    SingleTransactionDetailInfo? singleTransactionDetailInfo,
    String? errorMessage,
  }) {
    return TransactionManageInitState(
      dataState: dataState ?? this.dataState,
      data: data ?? this.data,
      singleTransactionDetailInfo: singleTransactionDetailInfo ?? this.singleTransactionDetailInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class BillTransactionManageInitState {
  BillTransactionManageInitState({
    this.dataState,
    this.data,
    this.transcodeTrusted,
    this.secureTrans,
    this.errorMessage,
  });

  DataState? dataState;
  BillPaymentModel? data;
  String? transcodeTrusted;
  String? secureTrans;
  String? errorMessage;

  BillTransactionManageInitState copyWith({
    DataState? dataState,
    BillPaymentModel? data,
    String? transcodeTrusted,
    String? secureTrans,
    String? errorMessage,
  }) {
    return BillTransactionManageInitState(
      dataState: dataState ?? this.dataState,
      data: data ?? this.data,
      transcodeTrusted: transcodeTrusted ?? this.transcodeTrusted,
      secureTrans: secureTrans ?? this.secureTrans,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class TransactionManageConfirmState {
  TransactionManageConfirmState({
    this.dataState,
    this.data,
    this.type,
    this.rejectReason,
    this.errorMessage,
    this.successMessage,
  });

  DataState? dataState;
  TransactionManageConfirmResponse? data;
  CommitActionType? type;
  String? rejectReason;
  String? errorMessage;
  String? successMessage;
}

class BillTransactionManageConfirmState {
  BillTransactionManageConfirmState({
    this.dataState,
    this.data,
    this.type,
    this.rejectReason,
    this.errorMessage,
    this.successMessage,
  });

  DataState? dataState;
  TransactionManageConfirmResponse? data;
  CommitActionType? type;
  String? rejectReason;
  String? errorMessage;
  String? successMessage;
}

class SavingTransactionManageInitState {
  SavingTransactionManageInitState({
    this.dataState,
    this.data,
    this.singleTransactionDetailInfo,
    this.errorMessage,
  });

  DataState? dataState;
  TransactionSavingModel? data;
  SingleTransactionDetailInfo? singleTransactionDetailInfo;
  String? errorMessage;

  SavingTransactionManageInitState copyWith({
    DataState? dataState,
    TransactionSavingModel? data,
    SingleTransactionDetailInfo? singleTransactionDetailInfo,
    String? errorMessage,
  }) {
    return SavingTransactionManageInitState(
      dataState: dataState ?? this.dataState,
      data: data ?? this.data,
      singleTransactionDetailInfo: singleTransactionDetailInfo ?? this.singleTransactionDetailInfo,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class SavingTransactionManageConfirmState {
  SavingTransactionManageConfirmState({
    this.dataState,
    this.data,
    this.type,
    this.rejectReason,
    this.errorMessage,
    this.successMessage,
  });

  DataState? dataState;
  TransactionManageConfirmResponse? data;
  CommitActionType? type;
  String? rejectReason;
  String? errorMessage;
  String? successMessage;
}

class PayrollTransactionManageInitState {
  PayrollTransactionManageInitState({
    this.dataState,
    this.data,
    this.errorMessage,
  });

  DataState? dataState;
  PayrollManageInitResponse? data;
  String? errorMessage;

  PayrollTransactionManageInitState copyWith({
    DataState? dataState,
    PayrollManageInitResponse? data,
    String? errorMessage,
  }) {
    return PayrollTransactionManageInitState(
      dataState: dataState ?? this.dataState,
      data: data ?? this.data,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class PayrollTransactionManageConfirmState {
  PayrollTransactionManageConfirmState({
    this.dataState,
    this.data,
    this.type,
    this.rejectReason,
    this.errorMessage,
    this.successMessage,
  });

  DataState? dataState;
  TransactionManageConfirmResponse? data;
  CommitActionType? type;
  String? rejectReason;
  String? errorMessage;
  String? successMessage;
}

class TransactionAdditionalInfoState extends Equatable {
  const TransactionAdditionalInfoState({
    this.accountInfo,
    this.cityInfo,
    this.branchInfo,
  });

  final DebitAccountInfo? accountInfo;
  final CityInfo? cityInfo;
  final BranchInfo? branchInfo;

  TransactionAdditionalInfoState copyWith({
    DebitAccountInfo? accountInfo,
    CityInfo? cityInfo,
    BranchInfo? branchInfo,
  }) {
    return TransactionAdditionalInfoState(
      accountInfo: accountInfo ?? this.accountInfo,
      cityInfo: cityInfo ?? this.cityInfo,
      branchInfo: branchInfo ?? this.branchInfo,
    );
  }

  @override
  List<Object?> get props => [accountInfo, cityInfo, branchInfo];
}

class DebitAccountInfo {
  DebitAccountInfo({
    this.accountNumber,
    this.accountBalance,
    this.accountCcy,
    this.accountName,
    this.accountDataState = DataState.init,
  });

  final String? accountNumber;
  final double? accountBalance;
  final String? accountCcy;
  final String? accountName;
  final DataState? accountDataState;

  String get balanceFormatted {
    return TransactionManage().formatCurrency(accountBalance ?? 0, accountCcy ?? 'VND') + ' ${accountCcy ?? ''}';
  }
}

class CityInfo {
  CityInfo({
    this.cityCode,
    this.cityName,
    this.cityDataState = DataState.init,
  });

  final String? cityCode;
  final String? cityName;
  final DataState? cityDataState;
}

class BranchInfo {
  BranchInfo({
    this.branchCode,
    this.branchName,
    this.branchDataState = DataState.init,
  });

  final String? branchCode;
  final String? branchName;
  final DataState? branchDataState;
}

class SingleTransactionDetailInfo {
  SingleTransactionDetailInfo({this.dataState, this.data, this.errorMessage});

  final DataState? dataState;
  final TransactionMainModel? data;
  final String? errorMessage;
}

class PayrollBenListState {
  final List<PayrollBenModel>? list;
  final DataState? dataState;
  final String? error;

  PayrollBenListState({
    this.list,
    this.dataState,
    this.error,
  });
}
