part of 'beneficiary_bloc.dart';

@immutable
abstract class BeneficiaryEvent extends Equatable{
  @override
  List<Object?> get props => throw UnimplementedError();
}

class BeneficiaryEventGetListAll extends BeneficiaryEvent{
  BeneficiaryEventGetListAll({required this.userName});
  final String userName;
}