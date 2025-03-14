part of 'beneficiary_bloc.dart';

class BeneficiaryState extends Equatable {
  const BeneficiaryState({this.listBeneficiary, this.beneficiaryState = DataState.init});

  final List<BeneficianAccountModel>? listBeneficiary;
  final DataState beneficiaryState;

  @override
  List<Object?> get props => [listBeneficiary, beneficiaryState];

  BeneficiaryState copyWith({List<BeneficianAccountModel>? listBeneficiary, DataState? beneficiaryState}) {
    return BeneficiaryState(listBeneficiary: listBeneficiary ?? this.listBeneficiary, beneficiaryState: beneficiaryState ?? this.beneficiaryState);
  }
}
