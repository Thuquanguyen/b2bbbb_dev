import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/loan/loan_list/loan_list_bloc.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/loan/loan_detail_info.dart';
import 'package:b2b/scr/data/model/loan/loan_list_model.dart';
import 'package:b2b/scr/presentation/screens/loan/loan_history/loan_history_screen.dart';
import 'package:b2b/scr/presentation/widgets/app_divider.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/buttons.dart';
import 'package:b2b/scr/presentation/widgets/expand_selection.dart';
import 'package:b2b/scr/presentation/widgets/item_horizontal_title_value.dart';
import 'package:b2b/scr/presentation/widgets/show_pick_file_model_bottom.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/utilities/vp_file_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/dialog_widget.dart';

class LoanInfoArg {
  BuildContext context;
  LoanListModel loanListModel;

  LoanInfoArg(this.loanListModel, this.context);
}

class LoanInfoScreen extends StatefulWidget {
  const LoanInfoScreen({Key? key, this.loanListModel}) : super(key: key);
  final LoanListModel? loanListModel;
  static const String routeName = '/LoanInfoScreen';

  @override
  _LoanInfoScreenState createState() => _LoanInfoScreenState(loanListModel);
}

class _LoanInfoScreenState extends State<LoanInfoScreen> {
  LoanListModel? loanListModel;
  bool isDueAmountExpanded = false;
  bool isOutDateAmountExpanded = false;
  VPShareFile? _fileType;

  _LoanInfoScreenState(this.loanListModel);

  late LoanListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<LoanListBloc>(context)
      ..add(
        GetLoanDetailEvent(loanListModel?.contractNumber ?? ''),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: AppTranslate.i18n.loanInfoStr.localized.toUpperCase(),
      isShowKeyboardDoneButton: true,
      appBarType: AppBarType.SEMI_MEDIUM,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      onBack: () {
        Navigator.of(context).pop();
      },
      child: Container(
        decoration: kDecoration,
        margin: const EdgeInsets.all(kDefaultPadding),
        child: _buildContent(),
      ),
    );
  }

  _buildContent() {
    return MultiBlocListener(
      listeners: [
        BlocListener<LoanListBloc, LoanListState>(
          listenWhen: (previous, current) {
            return previous.loanDetailState?.loanInfoDataState !=
                current.loanDetailState?.loanInfoDataState;
          },
          listener: (context, state) {
            if (state.loanDetailState?.loanInfoDataState == DataState.preload) {
              showLoading();
            } else if (state.loanDetailState?.loanInfoDataState ==
                DataState.error) {
              hideLoading();
              showDialogErrorForceGoBack(
                context,
                (state.loanDetailState?.errorMessage ?? ''),
                () {
                  Navigator.of(context).pop();
                },
                barrierDismissible: false,
              );
            } else {
              hideLoading();
            }
          },
        ),
        BlocListener<LoanListBloc, LoanListState>(
          listenWhen: (previous, current) {
            return previous.loanDetailState?.exportLoanDataState !=
                current.loanDetailState?.exportLoanDataState;
          },
          listener: (context, state) {
            if (state.loanDetailState?.exportLoanDataState ==
                DataState.preload) {
              showLoading();
            } else if (state.loanDetailState?.exportLoanDataState ==
                DataState.error) {
              hideLoading();
              showDialogErrorForceGoBack(
                context,
                (state.loanDetailState?.errorMessage ?? ''),
                () {
                  Navigator.of(context).pop();
                },
                barrierDismissible: false,
              );
            } else {
              hideLoading();
              VpFileHelper().actionShareFile(
                  state.loanDetailState?.exportLoanData ?? '',
                  'loan',
                  _fileType ?? VPShareFile.PDF);
            }
          },
        ),
      ],
      child: BlocBuilder<LoanListBloc, LoanListState>(
        builder: (context, state) {
          return _loanInfo(state);
        },
      ),
    );
  }

  _header(LoanDetailInfo loanInfo) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ImageHelper.loadFromAsset(AssetHelper.icoVpbankOnly,
                  width: 20.toScreenSize,
                  height: 20.toScreenSize,
                  fit: BoxFit.cover),
              const SizedBox(
                width: 8,
              ),
              Text(
                loanListModel?.contractNumber ?? '',
                style: TextStyles.itemText.medium
                    .copyWith(color: AppColors.blackTextColor),
              )
            ],
          ),
          Text(
            loanListModel?.contractTypeDisplay?.localization() ?? '',
            style: TextStyles.itemText,
          )
        ],
      ),
    );
  }

  _info(LoanDetailInfo loanInfo) {
    return Container(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        children: [
          itemTextHorizontalTitleValue(
              title: AppTranslate.i18n.approvedAmountStr.localized,
              value:
                  '${loanInfo.approvalMoney?.toMoneyString} ${loanListModel?.accountCurrency}'),
          const SizedBox(
            height: 10,
          ),
          itemTextHorizontalTitleValue(
              title: AppTranslate.i18n.debtStr.localized,
              value:
                  '${loanListModel?.currentOutstanding?.toMoneyString} ${loanListModel?.accountCurrency}'),
          const SizedBox(
            height: 10,
          ),
          itemTextHorizontalTitleValue(
              title: AppTranslate.i18n.interestValueStr.localized,
              value: '${loanListModel?.rate} %'),
          const SizedBox(
            height: 10,
          ),
          itemTextHorizontalTitleValue(
              title: AppTranslate.i18n.borrowDateStr.localized,
              value: loanListModel?.lendingDate),
          const SizedBox(
            height: 10,
          ),
          itemTextHorizontalTitleValue(
              title: AppTranslate.i18n.expireDateStr.localized,
              value: loanListModel?.maturityDate),
        ],
      ),
    );
  }

  _amountInfo(
      bool isExpanded, String title, List<Widget> data, Function() onPress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Touchable(
            onTap: onPress,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyles.itemText.semibold
                      .copyWith(color: AppColors.blackTextColor),
                ),
                Container(
                  padding: const EdgeInsets.all(7),
                  child: isExpanded == true
                      ? ImageHelper.loadFromAsset(
                          AssetHelper.icArrowUp,
                          width: 18.toScreenSize,
                          height: 18.toScreenSize,
                        )
                      : ImageHelper.loadFromAsset(
                          AssetHelper.icArrowDown,
                          width: 18.toScreenSize,
                          height: 18.toScreenSize,
                        ),
                ),
              ],
            ),
          ),
        ),
        ExpandedSection(
          expand: isExpanded,
          child: Container(
            padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding, vertical: 12),
            color: const Color(0xffFAFAFA),
            child: Column(children: data),
          ),
        ),
      ],
    );
  }

  _amountDueInfo() {
    List<Widget> content = [
      itemTextHorizontalTitleValue(
          title: AppTranslate.i18n.totalAmountDueToPayStr.localized,
          value:
              '${loanListModel?.getTotalAmountDueDate()?.toMoneyString} ${loanListModel?.accountCurrency}',
          titleStyle: TextStyles.captionText),
      const SizedBox(
        height: 10,
      ),
      itemTextHorizontalTitleValue(
          title: AppTranslate.i18n.nextPaymentDueDateStr.localized,
          value: loanListModel?.nextPayInterestDate,
          titleStyle: TextStyles.captionText),
      const SizedBox(
        height: 10,
      ),
      itemTextHorizontalTitleValue(
          title: AppTranslate.i18n.rootAmountDueToPayStr.localized,
          value:
              '${loanListModel?.thisPeriodPrincipleAmount?.toMoneyString} ${loanListModel?.accountCurrency}',
          titleStyle: TextStyles.captionText),
      const SizedBox(
        height: 10,
      ),
      itemTextHorizontalTitleValue(
          title: AppTranslate.i18n.interestDueToPayStr.localized,
          value:
              '${loanListModel?.thisPeriodInterestAmount?.toMoneyString} ${loanListModel?.accountCurrency}',
          titleStyle: TextStyles.captionText),
    ];
    return _amountInfo(isDueAmountExpanded,
        AppTranslate.i18n.infoAmountDueToPayStr.localized, content, () {
      setState(() {
        isDueAmountExpanded = !isDueAmountExpanded;
      });
    });
  }

  _amountOutDateInfo(LoanDetailInfo loanInfo) {
    List<Widget> content = [
      itemTextHorizontalTitleValue(
          title: AppTranslate.i18n.totalAmountOutDateStr.localized,
          value:
              '${loanInfo.totalOvd?.toMoneyString} ${loanListModel?.accountCurrency}',
          titleStyle: TextStyles.captionText),
      const SizedBox(
        height: 10,
      ),
      itemTextHorizontalTitleValue(
          title: AppTranslate.i18n.rootAmountOutDateStr.localized,
          value:
              '${loanInfo.prAmt?.toMoneyString} ${loanListModel?.accountCurrency}',
          titleStyle: TextStyles.captionText),
      const SizedBox(
        height: 10,
      ),
      itemTextHorizontalTitleValue(
          title: AppTranslate.i18n.interestAmountOutDateStr.localized,
          value:
              '${loanInfo.inAmt?.toMoneyString} ${loanListModel?.accountCurrency}',
          titleStyle: TextStyles.captionText),
      const SizedBox(
        height: 10,
      ),
      itemTextHorizontalTitleValue(
          title: AppTranslate.i18n.interestPenaltyOutDateStr.localized,
          value:
              '${loanInfo.intPenalty?.toMoneyString} ${loanListModel?.accountCurrency}',
          titleStyle: TextStyles.captionText),
    ];
    return _amountInfo(isOutDateAmountExpanded,
        AppTranslate.i18n.infoAmountOutDateStr.localized, content, () {
      setState(() {
        isOutDateAmountExpanded = !isOutDateAmountExpanded;
      });
    });
  }

  _historyLoan() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(kDefaultPadding),
      child: TouchableRipple(
        onPressed: () {
          Navigator.of(context).pushNamed(
            LoanHistoryScreen.routeName,
            arguments: LoanHistoryScreenArguments(
                loanId: loanListModel?.contractNumber),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageHelper.loadFromAsset(AssetHelper.icoClock,
                width: 24.toScreenSize, height: 24.toScreenSize),
            const SizedBox(
              width: 8,
            ),
            Text(
              AppTranslate.i18n.loanHistoryStr.localized,
              style:
                  TextStyles.itemText.copyWith(color: const Color(0xff00B74F)),
            )
          ],
        ),
      ),
    );
  }

  _loanInfo(LoanListState state) {
    if (state.loanDetailState?.loanInfoDataState != DataState.data) {
      return const SizedBox();
    }
    LoanDetailInfo? loanDetail = state.loanDetailState?.loanDetailInfo;
    if (loanDetail == null) {
      return const SizedBox();
    }
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _header(loanDetail),
                AppDivider(),
                _info(loanDetail),
                AppDivider(),
                _amountDueInfo(),
                AppDivider(),
                _amountOutDateInfo(loanDetail),
                AppDivider(),
                _historyLoan(),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: kDefaultPadding,
        ),
        DefaultButton(
          onPress: () {
            showPickFileBottomModal(
              context,
              (fileType) {
                _fileType = fileType;
                _bloc.add(
                  ExportLoan(fileType),
                );
              },
            );
          },
          text: AppTranslate.i18n.exportLoanStr.localized.toUpperCase(),
          height: 44,
          radius: 40,
        ),
        const SizedBox(
          height: kDefaultPadding,
        ),
      ],
    );
  }
}
