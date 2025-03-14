import 'package:b2b/commons.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_bloc.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_event.dart';
import 'package:b2b/scr/bloc/transaction_manager/transaction_manager_state.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_approve/transaction_approve_detail_widget.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionApproveDetailScreenArgument {
  TransactionMainModel? transaction;
  bool? isFx;

  TransactionApproveDetailScreenArgument({
    this.transaction,
    this.isFx,
  });
}

class TransactionApproveDetailScreen extends StatefulWidget {
  const TransactionApproveDetailScreen({Key? key}) : super(key: key);
  static const String routeName = 'transaction-approve-detail-screen';

  @override
  _TransactionApproveDetailScreenState createState() => _TransactionApproveDetailScreenState();
}

class _TransactionApproveDetailScreenState extends State<TransactionApproveDetailScreen> {
  late TransactionManagerBloc _bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      TransactionApproveDetailScreenArgument? args = getArguments<TransactionApproveDetailScreenArgument>(context);
      TransactionMainModel? trans = args?.transaction;
      bool? isFx = args?.isFx;
      _bloc = context.read<TransactionManagerBloc>();
      _bloc.add(
        GetSingleTransactionDetailEvent(
          transCode: trans?.transCode ?? '',
          isFx: isFx,
        ),
      );
    });
  }

  void _stateListener(BuildContext context, TransactionManagerState state) {
    if (state.manageInitState?.singleTransactionDetailInfo?.dataState == DataState.data) {
      TransactionMainModel? transaction = state.manageInitState?.singleTransactionDetailInfo?.data;

      _bloc.add(
        GetAdditionalInfoTransactionManageEvent(
          accountNumber: transaction?.debitAccountNumber,
          bankCode: transaction?.benBankCode,
          cityCode: transaction?.city,
          branchCode: transaction?.benBranch,
        ),
      );
    }
  }

  bool _shouldRebuild(TransactionManagerState p, TransactionManagerState c) {
    return p.manageInitState?.singleTransactionDetailInfo?.dataState !=
        c.manageInitState?.singleTransactionDetailInfo?.dataState;
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      appBarType: AppBarType.NORMAL,
      title: AppTranslate.i18n.tasApprovingTransactionDetailTitleStr.localized,
      child: BlocConsumer<TransactionManagerBloc, TransactionManagerState>(
        buildWhen: _shouldRebuild,
        listenWhen: _shouldRebuild,
        listener: _stateListener,
        builder: (BuildContext context, TransactionManagerState state) {
          TransactionMainModel? tran = state.manageInitState?.singleTransactionDetailInfo?.data;
          return TransactionApproveDetail(transaction: tran);
        },
      ),
    );
  }
}
