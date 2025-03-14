import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/payroll/payroll_bloc.dart';
import 'package:b2b/scr/bloc/payroll/payroll_events.dart';
import 'package:b2b/scr/bloc/payroll/payroll_state.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/payroll_ben_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/payroll_approve/payroll_recipient_list_filter.dart';
import 'package:b2b/scr/presentation/widgets/dashline_painter.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PayrollApproveRecipientListScreen extends StatefulWidget {
  const PayrollApproveRecipientListScreen({Key? key}) : super(key: key);
  static const String routeName = 'PayrollApproveRecipientListScreen';

  @override
  State<StatefulWidget> createState() => PayrollApproveRecipientListScreenState();
}

class PayrollApproveRecipientListScreenState extends State<PayrollApproveRecipientListScreen> {
  late PayrollBloc _bloc;
  bool isInited = false;
  final GlobalKey<PayrollReciFilterState> _filterKey = GlobalKey();
  bool isFilterShow = false;
  String? fileCode;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<PayrollBloc>();
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    if (!isInited) {
      isInited = true;
      fileCode = getArgument<String>(context, 'fileCode');
      if (fileCode == null) {
      } else {
        _bloc.add(
          PayrollGetBenListEvent(
              filterRequest: PayrollBenListFilterRequest(
            fileCode: fileCode,
          )),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = AppTranslate.i18n.prDetailListScreenTitleStr.localized;

    return BlocConsumer<PayrollBloc, PayrollState>(
      buildWhen: _shouldRebuild,
      listenWhen: _shouldRebuild,
      listener: _stateListener,
      builder: (context, state) {
        return AppBarContainer(
          appBarType: AppBarType.NORMAL,
          title: title,
          centerTitle: false,
          isTight: true,
          onTap: () {
            hideKeyboard(context);
          },
          actions: [
            Touchable(
              onTap: () {
                if (isFilterShow) {
                  _filterKey.currentState?.hideFilter();
                } else {
                  _filterKey.currentState?.showFilter();
                }
                isFilterShow = !isFilterShow;
                setState(() {});
              },
              child: Row(
                children: [
                  Stack(
                    children: [
                      Positioned.fill(
                        child: CustomPaint(
                          painter: DashedBorderPainter(color: Colors.white, dashSpace: 2),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          children: [
                            ImageHelper.loadFromAsset(
                              AssetHelper.icoSearchWhite,
                              width: 18,
                              height: 18,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              isFilterShow
                                  ? AppTranslate.i18n.prciReciFilterCloseBtnStr.localized
                                  : AppTranslate.i18n.prciReciFilterOpenBtnStr.localized, // Equal height
                              style: TextStyles.headerItemText.regular.copyWith(
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: kDefaultPadding,
                  ),
                ],
              ),
            ),
          ],
          child: Column(
            children: [
              PayrollReciFilter(
                key: _filterKey,
                onFilterChange: onFilterChange,
              ),
              Expanded(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return const LinearGradient(
                      begin: Alignment.center,
                      end: Alignment.topCenter,
                      stops: [0, 0.9],
                      colors: <Color>[
                        Color.fromRGBO(255, 255, 255, 1),
                        Color.fromRGBO(255, 255, 255, 0),
                      ],
                    ).createShader(Rect.fromLTWH(bounds.left, bounds.top, bounds.width, 20));
                  },
                  child: buildList(state.benListState?.list, state.benListState?.filterRequest?.fillter != null),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void onFilterChange(PayrollBenListFilterRequest request) {
    _bloc.add(
      PayrollGetBenListEvent(
        filterRequest: PayrollBenListFilterRequest(
          fileCode: fileCode,
          fillter: request.fillter,
        ),
      ),
    );
  }

  bool _shouldRebuild(PayrollState old, PayrollState current) {
    return old.benListState?.dataState != current.benListState?.dataState;
  }

  void _stateListener(BuildContext context, PayrollState state) {
    if (state.benListState?.dataState == DataState.preload) {
      showLoading();
    } else {
      hideLoading();
    }

    if (state.benListState?.dataState == DataState.error) {
      showDialogCustom(
        context,
        AssetHelper.icoStatementComplate,
        AppTranslate.i18n.dialogTitleNotificationStr.localized,
        state.benListState?.errorMessage ?? AppTranslate.i18n.errorNoReasonStr.localized,
        barrierDismissible: false,
        onClose: () {
          popScreen(context);
        },
        button1: renderDialogTextButton(
          context: context,
          title: AppTranslate.i18n.dialogButtonCloseStr.localized,
          onTap: () {
            popScreen(context);
          },
        ),
      );
    }
  }

  Widget buildList(List<PayrollBenModel>? list, bool isFiltering) {
    if (list == null) return const SizedBox();
    if (list.isNotEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.only(
          bottom: kDefaultPadding,
        ),
        itemCount: list.length,
        itemBuilder: (context, i) {
          return buildReciItem(list[i]);
        },
      );
    } else {
      return Container(
        padding: const EdgeInsets.only(left: 50, right: 50),
        alignment: Alignment.center,
        child: Text(
          AppTranslate.i18n.prciReciNoDataStr.localized,
          style: TextStyles.headerText.semibold,
          textAlign: TextAlign.center,
        ),
      );
    }
  }

  Widget buildReciItem(PayrollBenModel? item) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kDefaultPadding,
        vertical: kDefaultPadding / 2,
      ),
      child: Container(
        padding: const EdgeInsets.all(
          kDefaultPadding,
        ),
        decoration: kDecoration,
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.gPrimaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    '${item?.transNo?.length == 1 ? '0' : ''}${item?.transNo ?? ''}',
                    style: TextStyles.itemText.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Text(
                    AppTranslate.i18n.prciAccStr.localized.interpolate({'a': item?.benAcc}),
                    style: TextStyles.itemText.copyWith(
                      color: AppColors.darkInk500,
                    ),
                  ),
                ),
                Text(
                  item?.benBank ?? '',
                  style: TextStyles.itemText.copyWith(
                    color: AppColors.darkInk500,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 9,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppTranslate.i18n.prciReciNameStr.localized,
                  style: TextStyles.smallText.copyWith(
                    color: AppColors.darkInk400,
                  ),
                ),
                const SizedBox(
                  width: kDefaultPadding,
                ),
                Expanded(
                  child: Text(
                    item?.benName ?? '',
                    style: TextStyles.smallText.copyWith(
                      color: AppColors.darkInk400,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 9,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppTranslate.i18n.prciReciAmtStr.localized,
                  style: TextStyles.smallText.copyWith(
                    color: AppColors.darkInk400,
                  ),
                ),
                Text(
                  TransactionManage().tryFormatCurrency(double.tryParse(item?.benAmt ?? '0'), item?.benCcy) +
                      ' ' +
                      (item?.benCcy ?? ''),
                  style: TextStyles.smallText.copyWith(
                    color: AppColors.darkInk400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
