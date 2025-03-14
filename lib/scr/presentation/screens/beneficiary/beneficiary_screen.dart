import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/beneficiary/beneficiary_bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/transfer/benefician_account_model.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/beneficiary_item.dart';
import 'package:b2b/scr/presentation/widgets/search_item.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';

class BeneficiaryScreen extends StatefulWidget {
  const BeneficiaryScreen({Key? key}) : super(key: key);
  static const String routeName = 'beneficiary-screen';

  @override
  _BeneficiaryScreenState createState() => _BeneficiaryScreenState();
}

class _BeneficiaryScreenState extends State<BeneficiaryScreen> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<BeneficiaryBloc>().add(BeneficiaryEventGetListAll(
        userName: SessionManager().userData?.user?.username ?? ""));
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: AppTranslate.i18n.beneficiaryTitleHeaderStr.localized,
      appBarType: AppBarType.NORMAL,
      child: BlocConsumer<BeneficiaryBloc, BeneficiaryState>(
        listenWhen: (previous, current) =>
            previous.beneficiaryState != current.beneficiaryState,
        listener: (context, state) {
          if (state.beneficiaryState == DataState.preload) {
            showLoading();
          } else if (state.beneficiaryState == DataState.data) {
            hideLoading();
          } else if (state.beneficiaryState == DataState.error) {
            hideLoading();
          }
        },
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                SearchItem(
                  hintText: AppTranslate.i18n.beneficiaryTitleFindBankStr.localized,
                  controller: _searchController,
                  callBack: (searchText) {
                    Logger.debug("search text ===> ${searchText}");
                  },
                ),
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(
                        bottom: SizeConfig.bottomSafeAreaPadding + 16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      itemBuilder: (context, index) {
                        Logger.debug(
                            "IsLastItem =======> ${index == ((state.listBeneficiary?.length ?? 0) - 1)}");
                        return BeneficiaryItem(
                          acountBeneficianModel:
                              state.listBeneficiary?[index] ??
                                  BeneficianAccountModel(),
                          isLastItem: index ==
                              ((state.listBeneficiary?.length ?? 0) - 1),
                        );
                      },
                      itemCount: state.listBeneficiary?.length,
                    ),
                    decoration: kDecoration,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
