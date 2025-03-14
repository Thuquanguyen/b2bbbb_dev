import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/bill/bill_info.dart';
import 'package:b2b/scr/presentation/widgets/expand_selection.dart';
import 'package:b2b/scr/presentation/widgets/item_vertical_title_value.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/textstyles.dart';
import '../../../../core/extensions/num_ext.dart';
import '../../../widgets/touchable_ripple.dart';

class ElectricPaymentOption extends StatefulWidget {
  const ElectricPaymentOption({Key? key, this.billInfo, this.callBack})
      : super(key: key);
  final BillInfo? billInfo;
  final Function(List<BillInfoBillList?>?)? callBack;

  @override
  _ElectricPaymentOptionState createState() =>
      _ElectricPaymentOptionState(billInfo);
}

class _ElectricPaymentOptionState extends State<ElectricPaymentOption> {
  int _groupVal = 1;
  BillInfo? billInfo;

  _ElectricPaymentOptionState(this.billInfo);

  double totalAmt = 0;

  @override
  void initState() {
    super.initState();
    billInfo?.billList?.forEach((element) {
      totalAmt += (element?.billAmt ?? 0);
      element?.setSelected(true);
    });
    widget.callBack?.call(billInfo?.billList);
  }

  @override
  Widget build(BuildContext context) {
    if (billInfo?.billList?.length == 1) {
      BillInfoBillList? data = billInfo?.billList?[0];
      return Column(
        children: [
          const SizedBox(
            height: kDefaultPadding,
          ),
          itemVerticalLabelValueText(
              AppTranslate.i18n.paymentScheduleStr.localized, data?.billMonth,
              decoration: const BoxDecoration()),
          itemVerticalLabelValueText(AppTranslate.i18n.amountStr.localized,
              '${data?.billAmt?.toMoneyString} VND',
              decoration: const BoxDecoration()),
          itemVerticalLabelValueText(
              AppTranslate.i18n.billTypeStr.localized, data?.type,
              decoration: const BoxDecoration()),
          itemVerticalLabelValueText(
              AppTranslate.i18n.billIdStr.localized, data?.billId,
              decoration: const BoxDecoration()),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: kDefaultPadding,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Radio(
                value: 1,
                groupValue: _groupVal,
                activeColor: AppColors.greenText,
                onChanged: (value) {
                  changePaymentGroup(value as int);
                },
              ),
            ),
            const SizedBox(
              width: 11,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppTranslate.i18n.paymentAllStr.localized,
                  style: TextStyles.itemText.medium
                      .copyWith(color: AppColors.blackTextColor),
                ),
                Text(
                  '${AppTranslate.i18n.amountStr.localized}: ${totalAmt.toMoneyString} VND',
                  style: TextStyles.itemText.medium
                      .copyWith(color: AppColors.gTextInputColor),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: kDefaultPadding,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 24,
              width: 24,
              child: Radio(
                value: 2,
                groupValue: _groupVal,
                activeColor: AppColors.greenText,
                onChanged: (value) {
                  changePaymentGroup(value as int);
                },
              ),
            ),
            const SizedBox(
              width: 11,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTranslate.i18n.paymentOneStr.localized,
                    style: TextStyles.itemText.medium
                        .copyWith(color: AppColors.blackTextColor),
                  ),
                  const SizedBox(
                    height: kDefaultPadding,
                  ),
                  _buildListPeriod(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buildListPeriod() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      itemBuilder: (c, i) {
        return itemChild(billInfo?.billList?[i]);
      },
      separatorBuilder: (c, s) {
        return const SizedBox(
          height: kDefaultPadding,
        );
      },
      itemCount: billInfo?.billList?.length ?? 0,
    );
  }

  itemChild(BillInfoBillList? bill) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TouchableRipple(
          onPressed: () {
            //Nếu thanh toán từng phầ
            if (_groupVal == 2) {
              //Check phải chọn các kỳ xa trc thì ms cho chọn kỳ gần
              bill?.setSelected(!(bill.isSelected ?? false));
              setState(() {});
              widget.callBack?.call(billInfo?.billList);
            }
          },
          child: Stack(
            children: [
              ImageHelper.loadFromAsset(AssetHelper.icoCheckBoxBlank,
                  width: 20, height: 20),
              if (bill?.isSelected == true && _groupVal == 2)
                ImageHelper.loadFromAsset(AssetHelper.icoCheck,
                    width: 20, height: 20),
            ],
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text(
                      bill?.billMonth ?? '',
                      style: TextStyles.itemText.medium
                          .copyWith(color: AppColors.blackTextColor),
                    ),
                  ),
                  TouchableRipple(
                    onPressed: () {
                      bill?.setExpand(!(bill.isExpand ?? false));
                      setState(() {});
                    },
                    child: ImageHelper.loadFromAsset(bill?.isExpand == true
                        ? AssetHelper.icArrowUp
                        : AssetHelper.icArrowDown),
                  ),
                ],
              ),
              Text(
                  '${AppTranslate.i18n.amountStr.localized}: ${bill?.billAmt?.toMoneyString} VND',
                  style: TextStyles.itemText),
              ExpandedSection(
                expand: bill?.isExpand ?? false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${AppTranslate.i18n.billTypeStr.localized}: ${bill?.type}',
                        style: TextStyles.itemText),
                    Text(
                        '${AppTranslate.i18n.billIdStr.localized}: ${bill?.billId}',
                        style: TextStyles.itemText),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void changePaymentGroup(int value) {
    // 1 => thanh toán toàn bộ, 2 => thanh toán từng kỳ
    _groupVal = value;
    if (value == 1) {
      billInfo?.billList?.forEach((element) {
        element?.isSelected = true;
      });
    } else {
      billInfo?.billList?.forEach((element) {
        element?.isSelected = true;
      });
    }

    widget.callBack?.call(billInfo?.billList);
    setState(() {});
  }
}
