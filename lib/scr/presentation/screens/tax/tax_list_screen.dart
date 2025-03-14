import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/tax/tax_manage/tax_manage_bloc.dart';
import 'package:b2b/scr/bloc/tax/tax_manage/tax_manage_events.dart';
import 'package:b2b/scr/bloc/tax/tax_manage/tax_manage_state.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/tax/tax_online.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/tax_approve/tax_approve_detail_screen.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b2b/scr/core/extensions/extensions.dart';

class TaxListScreen extends StatefulWidget {
  const TaxListScreen({Key? key}) : super(key: key);
  static const String routeName = 'TaxListScreen';
  static const String TAX_LIST_RELOAD_EVENT = 'TAX_LIST_RELOAD_EVENT';

  @override
  State<StatefulWidget> createState() => TaxListScreenState();
}

class TaxListScreenState extends State<TaxListScreen> {
  List<TaxOnline>? _list;
  bool isDataLoaded = false;
  late TaxManageBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<TaxManageBloc>(context);
    _bloc.add(TaxManageGetListEvent());
    MessageHandler().addListener(TaxListScreen.TAX_LIST_RELOAD_EVENT, onRefresh);
  }

  @override
  void dispose() {
    MessageHandler().removeListener(TaxListScreen.TAX_LIST_RELOAD_EVENT, onRefresh);
    super.dispose();
  }

  Future<void> onRefresh() async {
    _bloc.add(TaxManageGetListEvent());
  }

  bool _listenWhen(TaxManageState p, TaxManageState c) {
    return p.listState?.dataState != c.listState?.dataState;
  }

  void _listener(BuildContext context, TaxManageState state) {
    if (state.listState?.dataState == DataState.data) {
      isDataLoaded = true;
      _list = state.listState?.list?.where((to) => to.transInfo?.statusDisplay?.key != 'DEL').toList();
      setState(() {});
    }

    if (state.listState?.dataState == DataState.error) {
      showDialogErrorForceGoBack(
        context,
        state.listState?.errorMessage ?? AppTranslate.i18n.errorNoReasonStr.localized,
        () {
          popScreen(context);
        },
        barrierDismissible: false,
      );
    }
  }

  Widget _buildContent() {
    return BlocConsumer<TaxManageBloc, TaxManageState>(
      listenWhen: _listenWhen,
      listener: _listener,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: SingleChildScrollView(
            child: _list?.isNotEmpty == true
                ? Container(
                    decoration: kDecoration,
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Column(
                      children: _list!
                          .mapIndexed(
                            (to, i) => TouchableRipple(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  TaxDetailScreen.routeName,
                                  arguments: TaxDetailScreenArgument(
                                    transCode: to.transInfo?.transCode,
                                    fallbackRoute: TaxListScreen.routeName,
                                  ),
                                );
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: kBorderSide1pxGrey,
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: kDecoration.copyWith(
                                          color: AppColors.itemTimeBg, borderRadius: BorderRadius.circular(20)),
                                      child: Center(
                                        child: Text(
                                          to.transInfo?.createdDateTime.convertServerTime?.to24H ?? '',
                                          style: TextStyles.itemText,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: kDefaultPadding,
                                    ),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                '${AppTranslate.i18n.taxCodeStr.localized} ${to.taxCode ?? ''}',
                                                style: TextStyles.itemText.blackColor,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  (to.transInfo?.statusDisplay?.statusDetail?.text ?? '').toUpperCase(),
                                                  textAlign: TextAlign.right,
                                                  style: TextStyles.itemText.blackColor.copyWith(
                                                      color: to.transInfo?.statusDisplay?.statusDetail?.color),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                AppTranslate.i18n.taxAccountStr.localized,
                                                style: TextStyles.smallText,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  to.transInfo?.account ?? '',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyles.itemText.blackColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                AppTranslate.i18n.taxFeeAccountStr.localized,
                                                style: TextStyles.smallText,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  to.transInfo?.accountFee ?? '',
                                                  textAlign: TextAlign.right,
                                                  style: TextStyles.itemText.blackColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  )
                : isDataLoaded
                    ? Center(
                        child: Text(
                          AppTranslate.i18n.taxNoPendingTransactionStr.localized,
                          style: TextStyles.itemText,
                        ),
                      )
                    : Container(
                        decoration: kDecoration,
                        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                        child: AppShimmer(
                          _listShimmer(),
                        ),
                      ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: AppTranslate.i18n.registerTaxStr.localized,
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

  Widget _listShimmer() {
    return Row(
      children: [
        Container(
          height: 40,
          width: 40,
          decoration: kDecoration.copyWith(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        const SizedBox(
          width: kDefaultPadding,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 16,
              ),
              Container(
                height: 13 * 1.4,
                width: 150,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                height: 13 * 1.4,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Container(
                height: 13 * 1.4,
                width: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        )
      ],
    );
  }
}
