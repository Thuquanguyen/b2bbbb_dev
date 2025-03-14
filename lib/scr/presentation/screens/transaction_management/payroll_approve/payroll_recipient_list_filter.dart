import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/iterable_ext.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/payroll_ben_model.dart';
import 'package:b2b/scr/presentation/widgets/inputs/vp_amount_input.dart';
import 'package:b2b/scr/presentation/widgets/inputs/vp_text_input.dart';
import 'package:b2b/scr/presentation/widgets/render_input_item.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/vp_dropdown.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/input_item_data.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PayrollReciFilter extends StatefulWidget {
  const PayrollReciFilter({
    Key? key,
    required this.onFilterChange,
  }) : super(key: key);
  final Function(PayrollBenListFilterRequest) onFilterChange;

  @override
  State<StatefulWidget> createState() => PayrollReciFilterState();
}

class PayrollReciFilterState extends State<PayrollReciFilter> with TickerProviderStateMixin {
  late AnimationController filterCollapsibleController;
  late Animation<double> filterCollapsibleSize;
  TextEditingController fromAmountCtl = TextEditingController();
  TextEditingController toAmountCtl = TextEditingController();
  TextEditingController keywordCtl = TextEditingController();

  final List<NameModel<int>> filterOptions = [
    NameModel(
      valueEn: AppTranslate.i18n.prciReciFilterNameStr.localized,
      valueVi: AppTranslate.i18n.prciReciFilterNameStr.localized,
      data: 1,
    ),
    NameModel(
      valueEn: AppTranslate.i18n.prciReciFilterAccStr.localized,
      valueVi: AppTranslate.i18n.prciReciFilterAccStr.localized,
      data: 2,
    ),
    NameModel(
      valueEn: AppTranslate.i18n.prciReciFilterAmtStr.localized,
      valueVi: AppTranslate.i18n.prciReciFilterAmtStr.localized,
      data: 0,
    ),
  ];

  int? selectedFilterOption;

  @override
  void initState() {
    super.initState();
    filterCollapsibleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    filterCollapsibleSize = CurvedAnimation(
      parent: filterCollapsibleController,
      curve: Curves.easeInOutCubic,
    );
    selectedFilterOption = 0;
    initFilterData();
  }

  void showFilter() {
    filterCollapsibleController.forward(from: 0);
  }

  void hideFilter() {
    filterCollapsibleController.reverse(from: 1);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: filterCollapsibleSize,
      child: SizeTransition(
        sizeFactor: filterCollapsibleSize,
        child: Container(
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
                VPDropDown(
                  options: filterOptions,
                  title: AppTranslate.i18n.prciReciFilterOptionLabelStr.localized,
                  onSelect: (c, o, i) {
                    selectedFilterOption = i;
                    initFilterData();
                  },
                  selectedIndex: selectedFilterOption,
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(sizeFactor: animation, child: child),
                    );
                  },
                  child: _buildFilterInput(),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeOut,
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                Row(
                  children: [
                    Expanded(
                      child: RoundedButtonWidget(
                        title: AppTranslate.i18n.dfClearStr.localized.toUpperCase(),
                        height: 44,
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
                        height: 44,
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
        ),
      ),
    );
  }

  Widget _buildFilterInput() {
    if (filterOptions.safeAt(selectedFilterOption)?.data == 1 ||
        filterOptions.safeAt(selectedFilterOption)?.data == 2) {
      return VPTextInput(
        controller: keywordCtl,
        title: AppTranslate.i18n.prciReciFilterKeywordLabelStr.localized,
      );
    } else {
      return Column(
        children: [
          if (filterOptions.safeAt(selectedFilterOption)?.data == 0)
            VPAmountInput(
              controller: fromAmountCtl,
              title: AppTranslate.i18n.dfFromAmountStr.localized,
              currency: 'VND',
            ),
          if (filterOptions.safeAt(selectedFilterOption)?.data == 0)
            const SizedBox(
              height: kDefaultPadding,
            ),
          if (filterOptions.safeAt(selectedFilterOption)?.data == 0)
            VPAmountInput(
              controller: toAmountCtl,
              title: AppTranslate.i18n.dfToAmountStr.localized,
              currency: 'VND',
            ),
          const SizedBox(
            height: 1,
          ),
        ],
      );
    }
  }

  void applyFilter() {
    FocusScope.of(context).unfocus();
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

    PayrollBenListFilterRequest filter = PayrollBenListFilterRequest(
      fillter: PayrollBenListFilter(
        options: filterOptions.safeAt(selectedFilterOption)?.data,
        keywords: keywordCtl.text,
        fromAmt: fromAmount ?? -1,
        toAmt: toAmount ?? -1,
      ),
    );

    widget.onFilterChange(filter);
  }

  void clearFilter() {
    FocusScope.of(context).unfocus();
    initFilterData();
  }

  void initFilterData() {
    keywordCtl.text = '';
    fromAmountCtl.text = '';
    toAmountCtl.text = '';
    setState(() {});
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
          style: TextStyles.smallText.medium,
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
