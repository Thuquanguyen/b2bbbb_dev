import 'package:b2b/scr/data/model/commerce/commerce_filter_request.dart';
import 'package:b2b/scr/presentation/screens/commerece/commerce_list_screen.dart';
import 'package:b2b/scr/presentation/widgets/expand_selection.dart';
import 'package:b2b/scr/presentation/widgets/inputs/vp_text_input.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/material.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/presentation/widgets/inputs/vp_amount_input.dart';
import 'package:b2b/scr/presentation/widgets/vp_date_selector.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:intl/intl.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';

import '../../widgets/keyboard_visibility_view.dart';

class CommerceFilter extends StatefulWidget {
  static String SET_FILTER = 'SetCommerceFilter';

  final bool? isFiltering;
  final CommerceType? commerceType;

  const CommerceFilter({
    Key? key,
    required this.onFilterChange,
    this.isFiltering = false,
    this.commerceType,
  }) : super(key: key);

  final Function(CommerceFilterRequest) onFilterChange;

  @override
  State<StatefulWidget> createState() => CommerceFilterState();
}

class CommerceFilterState extends State<CommerceFilter> {
  int selectedServiceIndex = 0;
  DateTime? fromDate;
  DateTime? toDate;
  TextEditingController fromAmountCtl = TextEditingController();
  TextEditingController toAmountCtl = TextEditingController();
  TextEditingController idController = TextEditingController();

  FocusNode fromAmountFocusNode = FocusNode();
  FocusNode toAmountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    initFilterData();

    if (!toAmountFocusNode.hasListeners) {
      toAmountFocusNode.addListener(() {
        if (toAmountFocusNode.hasFocus) {
          KeyboardVisibilityView.setCurrentInputType(TextInputType.number,
              controller: toAmountCtl, isShowDecimal: true);
        } else {
          KeyboardVisibilityView.setCurrentInputType(TextInputType.text,
              controller: toAmountCtl);
        }
      });
    }

    if (!fromAmountFocusNode.hasListeners) {
      fromAmountCtl.addListener(() {
        if (fromAmountFocusNode.hasFocus) {
          KeyboardVisibilityView.setCurrentInputType(TextInputType.number,
              controller: fromAmountCtl, isShowDecimal: true);
        } else {
          KeyboardVisibilityView.setCurrentInputType(TextInputType.text,
              controller: fromAmountCtl);
        }
      });
    }

    MessageHandler().register(
      CommerceFilter.SET_FILTER,
      (p0) => {
        if (p0 is CommerceFilterRequest) {setFilter(p0)}
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    MessageHandler().unregister(CommerceFilter.SET_FILTER);
  }

  void initFilterData() {
    selectedServiceIndex = 0;
    fromDate = null;
    toDate = null;
    fromAmountCtl.text = '';
    toAmountCtl.text = '';
    idController.text = '';
    setState(() {});
  }

  void applyFilter() {
    double? fromAmount;
    double? toAmount;

    try {
      try {
        fromAmount =
            double.parse(fromAmountCtl.text.toString().replaceAll(' ', ''));
      } catch (e) {
        fromAmount = -1;
      }
      try {
        toAmount =
            double.parse(toAmountCtl.text.toString().replaceAll(' ', ''));
      } catch (e) {
        toAmount = -1;
      }

      if (toAmount < fromAmount && toAmount != -1) {
        showDialogCustom(
          context,
          AssetHelper.icoStatementComplate,
          AppTranslate.i18n.dialogTitleNotificationStr.localized,
          AppTranslate.i18n.invalidFromToAmountStr.localized,
          button1: renderDialogTextButton(
              context: context,
              title: AppTranslate.i18n.dialogButtonCancelStr.localized),
        );
        return;
      }
    } catch (e) {
      Logger.error("exception $e");
    }

    //Check valid date
    try {
      if (fromDate != null &&
          toDate != null &&
          fromDate!.compareTo(toDate!) > 0) {
        showDialogCustom(
          context,
          AssetHelper.icoStatementComplate,
          AppTranslate.i18n.dialogTitleNotificationStr.localized,
          AppTranslate.i18n.invalidFromToDateStr.localized,
          button1: renderDialogTextButton(
              context: context,
              title: AppTranslate.i18n.dialogButtonCancelStr.localized),
        );
        return;
      }
    } catch (e) {
      Logger.error("exception $e");
    }

    CommerceFilterRequest filter = CommerceFilterRequest(
      id: idController.text.toString(),
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

    widget.onFilterChange(filter);
  }

  void clearFilter() {
    initFilterData();
  }

  @override
  Widget build(BuildContext context) {
    // if(widget.isFiltering == true && widget.currentFilter != null){
    //   widget.
    // }
    Logger.debug('CommerceFilter build');

    return ExpandedSection(
      expand: widget.isFiltering ?? false,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding),
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
              VPTextInput(
                controller: idController,
                title: widget.commerceType == CommerceType.LC
                    ? AppTranslate.i18n.referenceNumberStr.localized
                    : widget.commerceType == CommerceType.DISCOUNT
                        ? AppTranslate.i18n.contractNumberStr.localized
                        : AppTranslate.i18n.guaranteeNumberStr.localized,
                hint: widget.commerceType == CommerceType.LC
                    ? AppTranslate.i18n.enterReferenceNumberStr.localized
                    : widget.commerceType == CommerceType.DISCOUNT
                        ? AppTranslate.i18n.enterContractNumberStr.localized
                        : AppTranslate.i18n.enterGuaranteeNumberStr.localized,
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              VPAmountInput(
                controller: fromAmountCtl,
                title: AppTranslate.i18n.dfFromAmountStr.localized,
                focusNode: fromAmountFocusNode,
                ccy: 'USD',
              ),
              const SizedBox(
                height: kDefaultPadding,
              ),
              VPAmountInput(
                controller: toAmountCtl,
                title: AppTranslate.i18n.dfToAmountStr.localized,
                focusNode: toAmountFocusNode,
                ccy: 'USD',
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
                      maxDate: DateTime.now(),
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
                      title:
                          AppTranslate.i18n.dfClearStr.localized.toUpperCase(),
                      height: 38,
                      radiusButton: 40,
                      onPress: () {
                        FocusScope.of(context).unfocus();
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
                      title:
                          AppTranslate.i18n.dfApplyStr.localized.toUpperCase(),
                      height: 38,
                      radiusButton: 40,
                      onPress: () {
                        FocusScope.of(context).unfocus();
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
                  if (touchableIcon != null)
                    ImageHelper.loadFromAsset(touchableIcon),
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
                  if (touchableIndicator)
                    ImageHelper.loadFromAsset(AssetHelper.icoChevronDown24),
                ],
              ),
            ),
          ),
      ],
    );
  }

  setFilter(CommerceFilterRequest p0) {
    Logger.debug('setFilter ${p0.fromDate}');
    idController.text = p0.id ?? '';

    if ((p0.fromAmount ?? -1) > 0) {
      fromAmountCtl.text = p0.fromAmount?.toMoneyString ?? '';
    }

    if ((p0.toAmount ?? -1) > 0) {
      toAmountCtl.text = p0.toAmount?.toMoneyString ?? '';
    }
    try {
      fromDate = DateFormat('dd/MM/yyyy').parse(p0.fromDate ?? '');
    } catch (e) {
      fromDate = null;
    }

    try {
      toDate = DateFormat('dd/MM/yyyy').parse(p0.toDate ?? '');
    } catch (e) {
      toDate = null;
    }

    // setState(() {});
  }
}
