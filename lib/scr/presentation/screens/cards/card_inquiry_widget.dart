import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/iterable_ext.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/card/benefit_contract.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/rounded_button_widget.dart';
import 'package:b2b/scr/presentation/widgets/vp_date_selector.dart';
import 'package:b2b/scr/presentation/widgets/vp_dropdown.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

enum CardInquiryType {
  STATEMENT,
  HISTORY,
}

class CardInquiryWidget extends StatefulWidget {
  const CardInquiryWidget({
    Key? key,
    required this.cardContractList,
    this.statementPeriods,
    required this.mainButtonText,
    this.mainButtonAction,
    this.inquiryType,
    this.preSelectedIndex,
    this.isLoadingOption = true,
  }) : super(key: key);

  final List<dynamic>? cardContractList;
  final List<String>? statementPeriods;
  final String mainButtonText;
  final Function(int?, DateTime?, DateTime?, int?)? mainButtonAction;
  final CardInquiryType? inquiryType;
  final int? preSelectedIndex;
  final bool isLoadingOption;

  @override
  State<StatefulWidget> createState() => CardInquiryWidgetState();
}

class CardInquiryWidgetState extends State<CardInquiryWidget> {
  int? selectedCardIndex;
  int? selectedPeriod;
  DateTime? fromDate;
  DateTime? toDate;
  TextEditingController fromAmountCtl = TextEditingController();
  TextEditingController toAmountCtl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    selectedCardIndex ??= widget.preSelectedIndex;
    return Container(
      decoration: kDecoration,
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          VPDropDown<dynamic>(
            options: VPDropDown.transformOptions<dynamic>(widget.cardContractList),
            title: AppTranslate.i18n.chCardInfoStr.localized,
            modalTitle: AppTranslate.i18n.chCardSelectStr.localized,
            selectedItemBuilder: (c) {
              if (widget.isLoadingOption) return _buildShimmer();
              dynamic selected = widget.cardContractList?.safeAt(selectedCardIndex);

              if (selected != null) {
                return _buildSelected(selected);
              }

              return Container();
            },
            itemBuilder: (c, o, i) {
              return _buildCardListItem(c, o.data, i);
            },
            onSelect: (c, o, i) {
              selectedCardIndex = i;
              setState(() {});
            },
            selectedIndex: selectedCardIndex,
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          if (widget.inquiryType == CardInquiryType.STATEMENT)
            VPDropDown<String>(
              options: _buildStatementMonth(),
              title: 'Kỳ sao kê',
              modalTitle: 'Chọn kỳ sao kê',
              onSelect: (c, o, i) {
                selectedPeriod = i;
                setState(() {});
              },
              selectedIndex: selectedPeriod,
            ),
          if (widget.inquiryType == CardInquiryType.STATEMENT)
            const SizedBox(
              height: kDefaultPadding,
            ),
          if (widget.inquiryType == CardInquiryType.HISTORY)
            Row(
              children: [
                Expanded(
                  child: VPDateInput(
                    disabled: widget.inquiryType == CardInquiryType.STATEMENT,
                    title: AppTranslate.i18n.dfFromDateStr.localized,
                    currentDate: fromDate,
                    maxDate: toDate ?? DateTime.now(),
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
                    disabled: widget.inquiryType == CardInquiryType.STATEMENT,
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
          RoundedButtonWidget(
            title: widget.mainButtonText.toUpperCase(),
            onPress: () {
              widget.mainButtonAction?.call(
                selectedCardIndex,
                fromDate,
                toDate,
                selectedPeriod,
              );
            },
            height: 44,
          ),
        ],
      ),
    );
  }

  Widget _buildSelected(dynamic selected) {
    return Row(
      children: [
        ImageHelper.loadFromAsset(
          (selected is CardModel) ? selected.visual.front : AssetHelper.contract,
          width: 30,
        ),
        const SizedBox(
          width: kDefaultPadding,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: kDefaultPadding,
              ),
              if (selected is BenefitContract)
                Text(
                  (selected.contractName ?? '').toUpperCase(),
                  style: TextStyles.itemText.copyWith(color: AppColors.darkInk500),
                ),
              if (selected is BenefitContract)
                Text(
                  (selected.contractId ?? '').toUpperCase(),
                  style: TextStyles.itemText,
                ),
              if (selected is CardModel)
                Text(
                  (selected.clientName ?? '').toUpperCase(),
                  style: TextStyles.itemText.copyWith(color: AppColors.darkInk500),
                ),
              if (selected is CardModel)
                const SizedBox(
                  height: 4,
                ),
              if (selected is CardModel)
                Text(
                  selected.comMainName ?? '',
                  style: TextStyles.itemText,
                ),
              if (selected is CardModel)
                const SizedBox(
                  height: 4,
                ),
              if (selected is CardModel)
                Text(
                  '${selected.cardType} | ${selected.getLastCardNumberDotted}',
                  style: TextStyles.itemText,
                ),
              const SizedBox(
                height: kDefaultPadding / 2,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardListItem(BuildContext ctx, dynamic item, int index) {
    return Expanded(
      child: Row(
        children: [
          ImageHelper.loadFromAsset(
            (item is CardModel) ? item.visual.front : AssetHelper.contract,
            width: 30,
          ),
          const SizedBox(
            width: 8,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item is BenefitContract)
                  Text(
                    (item.contractName ?? '').toUpperCase(),
                    style: TextStyles.itemText.copyWith(color: AppColors.darkInk500),
                  ),
                if (item is BenefitContract)
                  Text(
                    (item.contractId ?? '').toUpperCase(),
                    style: TextStyles.itemText,
                  ),
                if (item is CardModel)
                  Text(
                    (item.clientName ?? '').toUpperCase(),
                    style: TextStyles.itemText.copyWith(color: AppColors.darkInk500),
                  ),
                if (item is CardModel)
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.cardType ?? '',
                          style: TextStyles.itemText,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        ' | ${item.getLastCardNumberDotted}',
                        style: TextStyles.itemText,
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<NameModel<String>>? _buildStatementMonth() {
    if (widget.statementPeriods?.isNotEmpty == true) selectedPeriod ??= 0;
    return widget.statementPeriods?.map<NameModel<String>>((e) {
      String dateString = '';
      try {
        dateString =
            DateFormat('MMMM, yyyy', AppTranslate().currentLanguage.locale).format(DateFormat('MM/yyyy').parse(e));
        dateString = dateString.substring(0, 1).toUpperCase() + dateString.substring(1);
      } catch (_) {}

      return NameModel<String>(
        valueEn: dateString,
        valueVi: dateString,
        data: e,
      );
    }).toList();
  }

  Widget _buildShimmer() {
    return AppShimmer(
      Row(
        children: [
          Container(
            width: 37,
            height: 24,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppColors.shimmerItemColor,
            ),
          ),
          const SizedBox(
            width: kDefaultPadding,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: kDefaultPadding,
              ),
              Container(
                width: 150,
                height: 13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.shimmerItemColor,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                width: 200,
                height: 13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.shimmerItemColor,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Container(
                width: 180,
                height: 13,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: AppColors.shimmerItemColor,
                ),
              ),
              const SizedBox(
                height: kDefaultPadding / 2,
              ),
            ],
          )
        ],
      ),
    );
  }
}
