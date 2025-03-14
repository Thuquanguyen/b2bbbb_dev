import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/base_item_model.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/presentation/widgets/inputs/vp_amount_input.dart';
import 'package:b2b/scr/presentation/widgets/my_calendar.dart';
import 'package:b2b/scr/presentation/widgets/render_input_item.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/vp_date_selector.dart';
import 'package:b2b/scr/presentation/widgets/vp_dropdown.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/input_item_data.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/iterable_ext.dart';
import 'package:intl/intl.dart';

class PeriodItem {
  final String title;
  final int value;

  PeriodItem({required this.title, required this.value});
}

class Filter extends StatefulWidget {
  const Filter({
    Key? key,
    required this.onFilterChange,
    this.serviceList,
    this.hideServiceList = false,
    this.currency,
  }) : super(key: key);

  final Function(TransactionFilterRequest) onFilterChange;
  final List<NameModel>? serviceList;
  final bool hideServiceList;
  final String? currency;

  @override
  State<StatefulWidget> createState() => FilterState();
}

class FilterState extends State<Filter> {
  final List<PeriodItem> listPeriod = [
    PeriodItem(title: '3 tháng', value: 3),
    PeriodItem(title: '6 tháng', value: 6),
    PeriodItem(title: '12 tháng', value: 12),
  ];

  int selectedServiceIndex = 0;
  DateTime? fromDate;
  DateTime? toDate;
  TextEditingController fromAmountCtl = TextEditingController();
  TextEditingController toAmountCtl = TextEditingController();

  @override
  void initState() {
    super.initState();
    initFilterData();
  }

  void initFilterData() {
    selectedServiceIndex = 0;
    fromDate = null;
    toDate = null;
    fromAmountCtl.text = '';
    toAmountCtl.text = '';
    setState(() {});
  }

  void applyFilter() {
    double? fromAmount;
    double? toAmount;

    try {
      try {
        fromAmount = double.parse(fromAmountCtl.text.toString().replaceAll(' ', ''));
      } catch (e) {
        fromAmount = -1;
      }
      try {
        toAmount = double.parse(toAmountCtl.text.toString().replaceAll(' ', ''));
      } catch (e) {
        toAmount = -1;
      }

      if (toAmount < fromAmount && toAmount != -1) {
        showDialogCustom(
          context,
          AssetHelper.icoStatementComplate,
          AppTranslate.i18n.dialogTitleNotificationStr.localized,
          AppTranslate.i18n.invalidFromToAmountStr.localized,
          button1: renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonCancelStr.localized),
        );
        return;
      }
    } catch (e) {
      Logger.error("exception $e");
    }

    //Check valid date
    try {
      if (fromDate != null || toDate != null) {
        if (fromDate != null && toDate == null ||
            fromDate == null && toDate != null ||
            ((fromDate != null && toDate != null) && fromDate!.compareTo(toDate!) > 0)) {
          showDialogCustom(
            context,
            AssetHelper.icoStatementComplate,
            AppTranslate.i18n.dialogTitleNotificationStr.localized,
            AppTranslate.i18n.invalidFromToDateStr.localized,
            button1: renderDialogTextButton(context: context, title: AppTranslate.i18n.dialogButtonCancelStr.localized),
          );
          return;
        }
      }
    } catch (e) {
      Logger.error("exception $e");
    }

    TransactionFilterRequest filter = TransactionFilterRequest(
      serviceType: widget.serviceList?.safeAt(selectedServiceIndex)?.key ?? '',
      fromAmount: fromAmount ?? -1,
      toAmount: toAmount ?? -1,
      fromDate: fromDate != null
          ? DateFormat("dd/MM/yyyy").format(
              fromDate ?? DateTime.now(),
            )
          : '',
      toDate: toDate != null
          ? DateFormat("dd/MM/yyyy").format(
              toDate ?? DateTime.now(),
            )
          : '',
    );

    Logger.debug('Filter: ${filter.toJson()}');

    widget.onFilterChange(filter);
  }

  void clearFilter() {
    initFilterData();
    applyFilter();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding),
      child: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [kBoxShadowContainer],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.hideServiceList == false)
              VPDropDown(
                options: widget.serviceList,
                title: AppTranslate.i18n.transactionServiceTypeStr.localized,
                onSelect: (c, o, i) {
                  selectedServiceIndex = i;
                  setState(() {});
                },
                selectedIndex: selectedServiceIndex,
              ),
            if (widget.hideServiceList == false)
              const SizedBox(
                height: kDefaultPadding,
              ),
            VPAmountInput(
              controller: fromAmountCtl,
              title: AppTranslate.i18n.dfFromAmountStr.localized,
              currency: widget.currency,
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            VPAmountInput(
              controller: toAmountCtl,
              title: AppTranslate.i18n.dfToAmountStr.localized,
              currency: widget.currency,
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            Row(
              children: [
                Expanded(
                  child: VPDateInput(
                    title: AppTranslate.i18n.dfFromDateStr.localized,
                    currentDate: fromDate,
                    maxDate: toDate,
                    onSelect: (date) {
                      fromDate = date;
                      setState(() {});
                    },
                    hint: AppTranslate.i18n.titleSelectDateStr.localized,
                  ),
                ),
                const SizedBox(
                  width: kDefaultPadding,
                ),
                Expanded(
                  child: VPDateInput(
                    title: AppTranslate.i18n.dfToDateStr.localized,
                    currentDate: toDate,
                    maxDate: DateTime.now(),
                    minDate: fromDate,
                    onSelect: (date) {
                      toDate = date;
                      setState(() {});
                    },
                    hint: AppTranslate.i18n.titleSelectDateStr.localized,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            Row(
              children: [
                Expanded(
                  child: RoundedButtonWidget(
                    title: AppTranslate.i18n.dfClearStr.localized.toUpperCase(),
                    height: 38,
                    radiusButton: 40,
                    onPress: () {
                      clearFilter();
                    },
                    backgroundButton: AppColors.darkInk300,
                  ),
                ),
                const SizedBox(
                  width: kDefaultPadding,
                ),
                Expanded(
                  child: RoundedButtonWidget(
                    title: AppTranslate.i18n.dfApplyStr.localized.toUpperCase(),
                    height: 38,
                    radiusButton: 40,
                    onPress: () {
                      applyFilter();
                    },
                    backgroundButton: AppColors.gPrimaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterPanelItem({
    required String title,
    String? touchableIcon,
    String? touchableTitle,
    bool touchableIndicator = false,
    Function? onTouch,
    Widget? child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyles.captionText.medium,
        ),
        const SizedBox(
          height: 8,
        ),
        if (child != null) child,
        if (onTouch != null)
          InkWell(
            onTap: () {
              onTouch();
            },
            child: Container(
              padding: const EdgeInsets.only(bottom: 4),
              decoration: const BoxDecoration(
                  border: Border(
                bottom: kBorderSide,
              )),
              child: Row(
                children: [
                  if (touchableIcon != null) ImageHelper.loadFromAsset(touchableIcon),
                  if (touchableIcon != null)
                    const SizedBox(
                      width: kDefaultPadding,
                    ),
                  Expanded(
                    child: Text(
                      touchableTitle ?? '',
                      style: TextStyles.headerText.regular.setColor(
                        AppColors.darkInk500,
                      ),
                    ),
                  ),
                  if (touchableIndicator) ImageHelper.loadFromAsset(AssetHelper.icoChevronDown24),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
