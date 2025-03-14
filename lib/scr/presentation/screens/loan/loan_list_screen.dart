import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/loan/loan_list/loan_list_bloc.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/loan/loan_list_model.dart';
import 'package:b2b/scr/data/repository/loan_repository.dart';
import 'package:b2b/scr/presentation/screens/loan/loan_info_screen.dart';
import 'package:b2b/scr/presentation/screens/loan/widget/item_loan_list.dart';
import 'package:b2b/scr/presentation/screens/loan/widget/item_loan_loading.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import '../../../core/api_service/api_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/extensions/textstyles.dart';
import '../../widgets/dialog_widget.dart';

class LoanListScreen extends StatefulWidget {
  const LoanListScreen({Key? key}) : super(key: key);

  static String routeName = '/LoanListScreen';

  @override
  _LoanListScreenState createState() => _LoanListScreenState();
}

class _LoanListScreenState extends State<LoanListScreen> {
  late LoanListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = LoanListBloc(
      LoanRepository(
        RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
      ),
    )..add(
        GetLoanListEvent(),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: AppTranslate.i18n.loanStr.localized,
      isShowKeyboardDoneButton: true,
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: onRefresh,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: _buildContent(),
        ),
      ),
      appBarType: AppBarType.HOME,
      showBackButton: true,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    );
  }

  Future<void> onRefresh() async {}

  _buildContent() {
    return BlocProvider<LoanListBloc>(
      create: (context) => _bloc,
      child: BlocConsumer<LoanListBloc, LoanListState>(
        listenWhen: (p, c) {
          return p.getLoanListDataState != c.getLoanListDataState;
        },
        listener: (context, state) {
          if (state.getLoanListDataState == DataState.error) {
            showDialogErrorForceGoBack(
              context,
              (state.errorMessage ?? ''),
              () {
                Navigator.of(context).pop();
              },
              barrierDismissible: false,
            );
          }
        },
        builder: (context, state) {
          return _buildLoanList(state);
        },
      ),
    );
  }

  _buildLoanList(LoanListState state) {
    if (state.getLoanListDataState == DataState.data &&
        (state.loanLists?.length ?? 0) == 0) {
      return Center(
        child: Text(
          AppTranslate.i18n.noLoanListStr.localized,
          style: TextStyles.headerText,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      padding: const EdgeInsets.only(bottom: kDefaultPadding),
      child: ListView.separated(
        itemCount: (state.getLoanListDataState == DataState.data)
            ? (state.loanLists?.length ?? -1)
            : 3,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) => TouchableRipple(
          onPressed: () {
            if (state.getLoanListDataState == DataState.data) {
              LoanListModel? loanListModel = state.loanLists?[index];
              if (loanListModel != null) {
                pushNamed(context, LoanInfoScreen.routeName,
                    arguments: LoanInfoArg(loanListModel, context));
              }
            }
          },
          child: (state.getLoanListDataState == DataState.data)
              ? ItemLoanList(
                  loan: state.loanLists?[index],
                )
              : const ItemLoanListLoading(),
        ),
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(
            height: kDefaultPadding,
          );
        },
      ),
    );
  }
}
