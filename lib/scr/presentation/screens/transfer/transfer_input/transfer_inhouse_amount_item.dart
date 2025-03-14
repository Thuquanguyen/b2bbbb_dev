import 'package:b2b/scr/data/model/transfer/transfer_rate.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import '../../../../../constants.dart';
import '../../../../../utilities/image_helper/asset_helper.dart';
import '../../../../../utilities/image_helper/imagehelper.dart';
import '../../../../../utilities/text_formatter.dart';
import '../../../../bloc/transfer/transfer_bloc.dart';
import '../../../../core/extensions/textstyles.dart';
import '../../../../core/language/app_translate.dart';
import '../../../widgets/item_input_transfer.dart';
import 'extrange_rate_widget.dart';

Widget amountItem(
    {required TextEditingController controller,
    required FocusNode focusNode,
    String? debitCcy,
    String? benCcy,
    String? selectedCcy,
    Function(String)? onChangeCcy,
    required List<String> dataList,
    TransferRate? transferRate}) {
  /**
   * Bán ngoại tệ. tk gốc là ngoại tệ, TK thụ hưởng là tk VND
   */
  bool? isCellCcy = false;

  debitCcy = debitCcy ?? 'VND';
  String regexFormat = '';

  selectedCcy = selectedCcy ?? debitCcy;
  bool showDecimal = false;

  if (debitCcy != 'VND' && debitCcy != 'JPY' && selectedCcy != 'VND') {
    regexFormat = '[0-9.]';
    showDecimal = true;
  } else {
    regexFormat = '[0-9]';
    showDecimal = false;
  }

  if (debitCcy.isNotNullAndEmpty && debitCcy != 'VND' && benCcy == 'VND') {
    isCellCcy = true;
  }

  return Container(
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: kDefaultPadding),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 1,
              child: ItemInputTransfer(
                removeDefaultPadding: true,
                onTextChange: (String value) {
                  final currentPosition = controller.selection.baseOffset;
                  final currentLength = value.length;

                  controller.text = CurrencyInputFormatter.formatCcyString(
                      value,
                      ccy: selectedCcy,
                      isTextInput: true);
                  if (currentPosition == currentLength) {
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(
                        offset: controller.text.length,
                      ),
                    );
                  } else {
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(
                        offset: currentPosition,
                      ),
                    );
                  }
                },
                focusNode: focusNode,
                textEditingController: controller,
                label: AppTranslate.i18n.transferAmountStr.localized,
                inputType: TextInputType.number,
                regexFormarter: regexFormat,
                isMoneyFormat: true,
                suffix: !isCellCcy
                    ? debitCcy
                    : null,
                suffixStyle: TextStyles.itemText.slateGreyColor.semibold,
                hintText: AppTranslate.i18n.enterAmountStr.localized,
                showDecimal: showDecimal,
              ),
            ),
            if (isCellCcy)
              Container(
                margin: const EdgeInsets.only(left: 16),
                child: Column(
                  children: [
                    DropdownButton<String>(
                      isDense: true,
                      value: selectedCcy,
                      dropdownColor: Colors.grey.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                      icon: Container(
                        // padding: const EdgeInsets.only(left:),
                        child: ImageHelper.loadFromAsset(
                            AssetHelper.icoDropDown,
                            width: 18.toScreenSize,
                            height: 18.toScreenSize),
                      ),
                      iconSize: 18,
                      style: TextStyles.itemText.medium,
                      elevation: 0,
                      underline: SizedBox(
                        height: 9,
                        child: Container(
                          margin: const EdgeInsets.only(top: 7.5),
                          color: const Color(0xffdedfe2),
                        ),
                      ),
                      onChanged: (String? newValue) {
                        // setState(() {
                        //   selectedCcy = newValue!;
                        // });
                        onChangeCcy?.call(newValue ?? '');
                      },
                      items: dataList
                          .map<DropdownMenuItem<String>>((String? value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value ?? '',
                            style: TextStyles.itemText.medium,
                          ),
                        );
                      }).toList(),
                    ),
                    // AppDivider(),
                  ],
                ),
              )
          ],
        ),
      ],
    ),
  );
}
