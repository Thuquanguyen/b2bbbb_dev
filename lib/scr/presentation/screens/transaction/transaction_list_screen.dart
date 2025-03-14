import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/extensions/extensions.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/presentation/screens/transaction/transaction_detail.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sticky_headers/sticky_headers.dart';

class TransactionInquiryListScreen extends StatefulWidget {
  const TransactionInquiryListScreen({Key? key}) : super(key: key);
  static const String routeName = 'transaction-inquiry-list-screen';

  @override
  _TransactionInquiryListScreenState createState() => _TransactionInquiryListScreenState();
}

class _TransactionInquiryListScreenState extends State<TransactionInquiryListScreen> {
  List<String> collapsedDates = [];

  Widget _buildTransactionItem(TransactionMainModel item, int index) {
    return TouchableRipple(
      onPressed: () {
        String? code = item.transCode;
        if (code != null) {
          context.read<TransactionInquiryBloc>().add(TransactionInquiryGetDetailEvent(code: code));
        }
      },
      backgroundColor: index % 2 == 0 ? Colors.white : const Color.fromRGBO(244, 249, 253, 1),
      child: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: index % 2 == 0 ? const Color.fromRGBO(245, 247, 250, 1) : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  item.createdDate?.convertServerTime?.to24H ?? ' ',
                  style: TextStyles.itemText,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppTranslate.i18n.tisBalanceChangeStr.localized,
                        style: TextStyles.itemText,
                      ),
                      Expanded(
                        child: Text(
                          '- ${item.formattedAmount(withCurrency: true)}',
                          textAlign: TextAlign.right,
                          style: TextStyles.itemText.copyWith(
                            color: const Color.fromRGBO(255, 103, 99, 1),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppTranslate.i18n.tisTransactionTypeStr.localized,
                          style: TextStyles.itemText,
                        ),
                      ),
                      if (item.transactionType?.transactionType == TransactionType.SALARY_FILE)
                        Text(
                          AppTranslate.i18n.tisTpPayrollStr.localized,
                          style: TextStyles.itemText.blackColor,
                        )
                      else
                        Text(
                          AppTranslate.i18n.tisTpTransferStr.localized,
                          style: TextStyles.itemText.blackColor,
                        )
                    ],
                  ),
                  if (item.transactionType?.transactionType != TransactionType.SALARY_FILE)
                    const SizedBox(
                      height: 4,
                    ),
                  if (item.transactionType?.transactionType != TransactionType.SALARY_FILE)
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            item.beneficiaryName ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.itemText.blackColor,
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 4,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          '${item.memo}',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.itemText.copyWith(height: 1.3),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    item.status?.localization().toUpperCase() ?? 'N/A',
                    style: TextStyles.itemText.copyWith(
                      color: item.status?.statusDetail?.color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionGroup(TransactionGrouped<TransactionMainModel> group, int idx) {
    int i = collapsedDates.indexWhere((e) => e == group.date);
    return StickyHeader(
      header: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        color: const Color.fromRGBO(230, 246, 237, 1),
        child: Row(
          children: [
            Expanded(
              child: Text(
                group.date,
                style: TextStyles.normalText,
              ),
            ),
          ],
        ),
      ),
      content: Container(
        color: Colors.white,
        child: Column(
          children: [
            if (i == -1) ...group.list.mapIndexed((e, i) => _buildTransactionItem(e, i)).toList() else Container(),
          ],
        ),
      ),
    );
  }

  Widget _contentBuilder(BuildContext context, TransactionInquiryState state) {
    return Container(
      padding: const EdgeInsets.only(
        left: kDefaultPadding,
        right: kDefaultPadding,
        bottom: kDefaultPadding,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [kBoxShadowContainer],
            borderRadius: BorderRadius.circular(14),
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: (state.listState?.list?.length ?? 0) + 1,
            itemBuilder: (context, i) {
              if (i == (state.listState?.list?.length ?? 0)) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                      child: Text(
                        AppTranslate.i18n.tisEndOfListStr.localized,
                        style: kStyleASTitle.copyWith(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ],
                );
              }
              TransactionGrouped<TransactionMainModel>? tg = state.listState?.list?[i];
              if (tg == null) return const SizedBox();
              return _buildTransactionGroup(tg, i);
            },
          ),
        ),
      ),
    );
  }

  void _stateListener(BuildContext context, TransactionInquiryState state) {
    if (state.detailState?.dataState == DataState.preload) {
      showLoading();
    } else {
      hideLoading();
    }

    if (state.detailState?.dataState == DataState.data) {
      pushNamed(context, TransactionInquiryDetailScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      onTap: () {
        hideKeyboard(context);
      },
      appBarType: AppBarType.NORMAL,
      hideBackButton: false,
      title: AppTranslate.i18n.tisListScreenTitleStr.localized,
      child: BlocConsumer<TransactionInquiryBloc, TransactionInquiryState>(
        listenWhen: (previous, current) => previous.detailState?.dataState != current.detailState?.dataState,
        listener: _stateListener,
        builder: _contentBuilder,
      ),
    );
  }
}
