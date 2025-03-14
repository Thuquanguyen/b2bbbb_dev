import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/data/model/transfer/benefician_account_model.dart';
import 'package:b2b/scr/data/repository/beneficiary_repository.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';

part 'beneficiary_event.dart';

part 'beneficiary_state.dart';

class BeneficiaryBloc extends Bloc<BeneficiaryEvent, BeneficiaryState> {
  BeneficiaryBloc({required this.beneficiaryRepository}) : super(const BeneficiaryState());

  final BeneficiaryRepositoryImpl beneficiaryRepository;

  @override
  Stream<BeneficiaryState> mapEventToState(BeneficiaryEvent event) async* {
    if (event is BeneficiaryEventGetListAll) {
      yield* _mapGetListBeneficiaryState(event, state);
    } else {}
  }

  Stream<BeneficiaryState> _mapGetListBeneficiaryState(
      BeneficiaryEventGetListAll event, BeneficiaryState state) async* {
    yield const BeneficiaryState(beneficiaryState: DataState.preload);
    try {
      final responseData = await beneficiaryRepository.getListBeneficiary(event.userName);
      yield BeneficiaryState(
        listBeneficiary: responseData.item.toArrayModel((json) => BeneficianAccountModel.fromJson(json)),
        beneficiaryState: DataState.data,
      );
    } catch (e) {
      Logger.debug('catch error and return fail here' + e.toString());
      yield const BeneficiaryState(beneficiaryState: DataState.error);
    }
  }
}
