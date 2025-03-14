import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/search/ben_bank_model.dart';
import 'package:b2b/scr/data/model/search/beneficiary_saved_model.dart';
import 'package:b2b/scr/data/model/transfer/debit_account_model.dart';
import 'package:b2b/scr/presentation/screens/transfer/transfer_input/save_ben.dart';
import 'package:b2b/scr/presentation/screens/transfer/transfer_input/transfer_manager.dart';
import 'package:b2b/scr/presentation/widgets/item_infomation_available.dart';
import 'package:b2b/scr/presentation/widgets/item_input_transfer.dart';
import 'package:b2b/scr/presentation/widgets/item_vertical_title_value.dart';
import 'package:b2b/scr/presentation/widgets/keyboard_visibility_view.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/input_item_data.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';

Widget renderBankItem(InputItemData data) {
  Logger.debug("start");
  final bank = data.value as BenBankModel?;
  return Container(
    padding: const EdgeInsets.only(bottom: kDefaultPadding),
    child: ItemInformationAvailable(
      enable: data.isEnable,
      title: bank?.shortName ?? AppTranslate.i18n.pickBankStr.localized,
      iconWidget: bank != null
          ? ImageHelper.loadFromAsset(bank.getLogo(),
              fit: BoxFit.cover,
              width: 18.toScreenSize,
              height: 18.toScreenSize)
          : null,
      caption: AppTranslate.i18n.bankDefaultStr.localized,
      onPress: () {
        data.onTap?.call();
      },
      showIconForward: true,
      forwardIcon: AssetHelper.icoDropDown,
    ),
  );
}

Widget renderFeeAccount(InputItemData data,
    {String? title, TextStyle? textStyle, bool? hideDropDownIcon = false}) {
  Logger.debug("start");
  if (data.value is! DebitAccountModel) {
    return const SizedBox();
  }
  DebitAccountModel accountModel = data.value;
  return Touchable(
    onTap: () {
      Logger.debug("Tab change Fee account");
      data.onTap?.call();
    },
    child: Container(
      color: Colors.transparent,
      // margin: const EdgeInsets.only(top: kDefaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                    text: title ?? AppTranslate.i18n.feeAccountStr.localized,
                    style: TextStyles.captionText.slateGreyColor),
                if (data.showRequire == true)
                  TextSpan(
                    text: ' \*',
                    style: TextStyles.itemText.copyWith(color: Colors.red),
                  )
              ],
            ),
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          Row(
            children: [
              ImageHelper.loadFromAsset(
                AssetHelper.icoWallet,
                width: 26.toScreenSize,
                height: 26.toScreenSize,
              ),
              const SizedBox(
                width: kDefaultPadding,
              ),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${accountModel.accountNumber}(${accountModel.accountCurrency})",
                          style: textStyle ??
                              TextStyles.itemText.slateGreyColor.regular,
                        ),
                        if (hideDropDownIcon != true)
                          ImageHelper.loadFromAsset(AssetHelper.icoDropDown,
                              width: 18.toScreenSize, height: 18.toScreenSize),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 8),
                      height: 1,
                      width: double.infinity,
                      color: kColorDivider,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget renderAccountItem(InputItemData data, String suffixIcon) {
  if (data.focusNode != null && !(data.focusNode!.hasListeners)) {
    data.focusNode?.addListener(
      () {
        if (data.focusNode?.hasFocus == false) {
          String value = data.value ?? '';
          value = value.replaceAll(' ', '');
          if (value.length > 1) {
            if (data.onComplete != null) {
              data.onComplete!(value);
            }
          }
        }
      },
    );
  }

  return ItemInputTransfer(
    onTextChange: (String value) {
      data.value = value;
      data.onTextChange?.call(value);
    },
    hintText: data.hint,
    label: data.title,
    textEditingController: data.controller ?? TextEditingController(),
    inputType: TextInputType.number,
    errorText: data.error,
    suffixIcon: SizedBox(
      width: 50,
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          if (data.isInlineLoading)
            const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 1.0),
            ),
          const Spacer(),
          Touchable(
            onTap: data.onSuffixIconClick,
            child: ImageHelper.loadFromAsset(
              suffixIcon,
              width: 20.toScreenSize,
              height: 20.toScreenSize,
            ),
          ),
        ],
      ),
    ),
    onCompleted: data.onComplete == null
        ? null
        : () {
            Logger.debug(
                "======================ONCOMPLETED==========================");
            data.onComplete!(data.controller!.text);
            data.focusNode?.unfocus();
          },
    focusNode: data.focusNode,
  );
}

Widget renderAccountAutoItem(String id, InputItemData data, String suffixIcon,
    List<BeneficiarySavedModel>? listData,
    {Function? callBack,
    Function(TextEditingController? controller)? onCreated,
    Function? onGetDetailBen,
    TextInputType? inputType}) {
  if (data.focusNode != null && !(data.focusNode!.hasListeners)) {
    data.focusNode?.addListener(
      () {
        if (data.focusNode?.hasFocus == false) {
          Logger.debug('UN FOCUS ======================');
          String value = data.value ?? '';
          value = value.replaceAll(' ', '');
          if (value.length > 1) {
            data.onComplete!(value);
          }
        }
      },
    );
  }

  Widget widgetBuild = StatefulBuilder(builder: (context, setState) {
    final inputWidget = ItemInputTransfer(
      id: id,
      listData: listData,
      autoComplete: true,
      initValue: data.value,
      showChangeKeyboardType: true,
      onTextChange: (String value) {
        data.isTextChange = true;
        data.value = value;
        data.onTextChange?.call(value);
        setState(() => data.error = null);
      },
      onResume: (model) {
        BeneficiarySavedModel beneficiarySavedModel =
            model as BeneficiarySavedModel;
        if (callBack != null) {
          callBack(beneficiarySavedModel);
        }
      },
      isTextChange: data.isTextChange,
      hintText: data.hint,
      label: data.title,
      textEditingController: data.controller ?? TextEditingController(),
      inputType: inputType ?? TextInputType.number,
      errorText: data.error,
      suffixIcon: SizedBox(
        width: 50,
        height: 20,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (data.isInlineLoading)
              const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 1.0),
              ),
            const Spacer(),
            Touchable(
              onTap: data.onSuffixIconClick,
              child: ImageHelper.loadFromAsset(
                suffixIcon,
                width: 20.toScreenSize,
                height: 20.toScreenSize,
              ),
            ),
          ],
        ),
      ),
      onCompleted: data.onComplete == null
          ? null
          : () {
              data.onComplete!(data.controller!.text);
              data.focusNode?.unfocus();
            },
      focusNode: data.focusNode,
    );
    inputWidget.setListenerAutoCompleteCreated((controller, focusNode) {
      data.controller = controller;
      if (controller != data.controller) {
        data.controller = controller;
      }
      if (focusNode != data.focusNode) {
        data.focusNode = focusNode;
        data.focusNode?.addListener(() {
          if (data.focusNode != null && data.focusNode?.hasFocus == false) {
            onGetDetailBen?.call();
          }
        });
      }
      onCreated?.call(controller);
    });
    return inputWidget;
  });

  return widgetBuild;
}

Widget renderTextChoiceItem(InputItemData data) {
  if (data.value == null) return Container();
  return Container(
    padding: const EdgeInsets.only(bottom: kDefaultPadding),
    child: ItemInformationAvailable(
      enable: data.isEnable,
      title: data.value,
      caption: data.title,
      onPress: () {
        data.onTap?.call();
      },
      showIconForward: true,
      isShowLoading: data.isInlineLoading,
      forwardIcon: AssetHelper.icoDropDown,
    ),
  );
}

Widget renderTextItem(InputItemData data) {
  if (data.value == null) return Container();

  return itemVerticalLabelValueText(data.title, data.value);
  // return Container(
  //   margin: const EdgeInsets.only(bottom: kDefaultPadding),
  //   width: double.infinity,
  //   decoration: const BoxDecoration(
  //     border: Border(
  //       bottom: kBorderSide,
  //     ),
  //   ),
  //   child: Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         data.title,
  //         style: TextStyles.captionText.slateGreyColor,
  //       ),
  //       const SizedBox(
  //         height: kMinPadding,
  //       ),
  //       Text(
  //         data.value!,
  //         style: TextStyles.semiBoldText.normalColor.regular,
  //       ),
  //       const SizedBox(
  //         height: kMinPadding,
  //       ),
  //     ],
  //   ),
  // );
}

Widget renderFiledItem(InputItemData data, {bool isUppercase = false}) {
  Logger.debug("START");
  int? maxLength;
  if (data.key == InputItemKey.amountContent) {
    maxLength = kMaxLengthAmountContent;
  } else if (data.key == InputItemKey.beneficiaryName) {
    maxLength = kMaxLengthBeneficiary;
  }

  if (data.focusNode != null && !(data.focusNode!.hasListeners)) {
    data.focusNode!.addListener(
      () {
        Logger.debug("Focus listener change");
        String? value = data.value;
        if (!value.isNullOrEmpty && data.focusNode?.hasFocus == false) {
          data.controller?.text = removeDiacritics(value!);
          data.value = removeDiacritics(value!);
        }
      },
    );
  }

  return ItemInputTransfer(
    enable: data.isEnable,
    showRequire: data.showRequire,
    onTextChange: (String value) {
      String newValue = value;
      data.value = newValue;
      data.onTextChange?.call(newValue);
      if (data.key == InputItemKey.amountContent) {
        if (value.contains('\n')) {
          value = value.replaceAll('\n', '');
          data.controller?.text = value;
        }
      }
    },
    regexFormarter: regexRuleTransferContent,
    isUpperCase: isUppercase,
    // inputType: data.key == InputItemKey.amountContent ? TextInputType.multiline : null,
    focusNode: data.focusNode,
    textEditingController: data.controller ?? TextEditingController(),
    label: data.title,
    hintText: data.hint,
    maxLength: maxLength,
  );
}

Widget renderSaveBenItem(InputItemData data,
    {String? defaultAliasName = '', bool? isShowCheckbox = true}) {
  late SaveBen saveBen;
  bool isSave = false;
  // return Container(height: 100,width: double.infinity, color: Colors.red,);
  if (data.value is SaveBen) {
    saveBen = data.value;
    isSave = saveBen.isSave ?? false;

    if (data.focusNode != null &&
        !(data.focusNode!.hasListeners) &&
        (data.value is SaveBen)) {
      data.focusNode!.addListener(() {
        SaveBen saveBen = data.value as SaveBen;
        if (saveBen.value != null &&
            (saveBen.value!.isNotEmpty) &&
            data.focusNode?.hasFocus == false) {
          data.controller?.text = removeDiacritics(saveBen.value!);
          saveBen.value = removeDiacritics(saveBen.value ?? '');
        }
      });
    }

    data.controller!.selection = TextSelection.fromPosition(
      TextPosition(
        offset: data.controller!.text.length,
      ),
    );
  } else {
    return const SizedBox();
  }
  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        children: [
          if (isShowCheckbox == true)
            Touchable(
              onTap: () {
                setState(() => isSave = !isSave);
                saveBen.isSave = isSave;

                //Để tự fill tên gợi nhớ vào.
                if (isSave &&
                    defaultAliasName!.isNotEmpty &&
                    (saveBen.value?.isEmpty ?? false)) {
                  saveBen.value = defaultAliasName;
                  data.controller?.text = defaultAliasName;
                }
              },
              child: Row(
                children: [
                  Stack(
                    children: [
                      ImageHelper.loadFromAsset(AssetHelper.icoCheckBoxBlank,
                          width: 20, height: 20),
                      if (isSave)
                        ImageHelper.loadFromAsset(AssetHelper.icoCheck,
                            width: 20, height: 20),
                    ],
                  ),
                  const SizedBox(width: kDefaultPadding),
                  Text(AppTranslate.i18n.saveBeneficiaryStr.localized,
                      style: TextStyles.itemText),
                ],
              ),
            ),
          if (isShowCheckbox == true) const SizedBox(height: kDefaultPadding),
          if (isSave || (isShowCheckbox == false))
            if (isShowCheckbox == true)
              ItemInputTransfer(
                regexFormarter: regexRuleTransferContent,
                enable: isShowCheckbox,
                onTextChange: (String value) {
                  saveBen.value = value;
                },
                textEditingController:
                    data.controller ?? TextEditingController(),
                label: AppTranslate.i18n.saveRememberNameStr.localized,
                focusNode: data.focusNode,
              )
            else
              itemVerticalLabelValueText(
                  AppTranslate.i18n.saveRememberNameStr.localized,
                  data.controller?.text)
        ],
      );
    },
  );
}

Widget renderSaveBenInterbankItem(InputItemData data) {
  late SaveBen saveBen;
  bool isSave = false;
  if (data.value is SaveBen) {
    saveBen = data.value;
    isSave = saveBen.isSave ?? false;

    if (data.focusNode != null &&
        !(data.focusNode!.hasListeners) &&
        (data.value is SaveBen)) {
      data.focusNode!.addListener(() {
        SaveBen saveBen = data.value as SaveBen;
        if (saveBen.value != null &&
            (saveBen.value!.isNotEmpty) &&
            data.focusNode?.hasFocus == false) {
          data.controller?.text = removeDiacritics(saveBen.value!);
          saveBen.value = removeDiacritics(saveBen.value ?? '');
        }
      });
    }

    data.controller!.selection = TextSelection.fromPosition(
      TextPosition(
        offset: data.controller!.text.length,
      ),
    );
  } else {
    return SizedBox();
  }
  return StatefulBuilder(
    builder: (context, setState) {
      return Column(
        children: [
          if (data.isEnable)
            Touchable(
              onTap: () {
                setState(() => isSave = !isSave);
                saveBen.isSave = isSave;
              },
              child: Row(
                children: [
                  Stack(
                    children: [
                      ImageHelper.loadFromAsset(AssetHelper.icoCheckBoxBlank,
                          width: 20, height: 20),
                      if (isSave)
                        ImageHelper.loadFromAsset(AssetHelper.icoCheck,
                            width: 20, height: 20),
                    ],
                  ),
                  const SizedBox(width: kDefaultPadding),
                  Text(AppTranslate.i18n.saveBeneficiaryStr.localized,
                      style: TextStyles.itemText),
                ],
              ),
            ),
          if (data.isEnable) const SizedBox(height: kDefaultPadding),
          if (isSave || !data.isEnable)
            ItemInputTransfer(
              enable: data.isEnable,
              onTextChange: (String value) {
                saveBen.value = value;
              },
              regexFormarter: regexRuleTransferContent,
              textEditingController: data.controller ?? TextEditingController(),
              label: AppTranslate.i18n.saveRememberNameStr.localized,
              focusNode: data.focusNode,
              maxLength: kMaxLengthReminiscent,
            ),
        ],
      );
    },
  );
}

Widget renderAmountItem(InputItemData data, String? currency,
    {bool? removeDefaultPadding}) {
  if (data.focusNode != null && !(data.focusNode!.hasListeners)) {
    data.focusNode?.addListener(
      () {
        if (data.focusNode?.hasFocus == false) {
          String value = data.controller?.text ?? '';
          value = value.replaceAll(' ', '');
          if (value.length > 1) {
            if (data.onComplete != null) {
              data.onComplete!(value);
            }
          }
        }
      },
    );
  }

  return ItemInputTransfer(
    showRequire: data.showRequire,
    removeDefaultPadding: removeDefaultPadding,
    onTextChange: (String value) {
      final currentPosition = data.controller!.selection.baseOffset;
      final currentLength = value.length;
      data.value = value.toMoneyFormat;
      data.controller!.text = value.toMoneyFormat;
      if (currentPosition == currentLength) {
        data.controller!.selection = TextSelection.fromPosition(
          TextPosition(
            offset: value.toMoneyFormat.length,
          ),
        );
      } else {
        data.controller!.selection = TextSelection.fromPosition(
          TextPosition(
            offset: currentPosition,
          ),
        );
      }

      Function(String)? _onTextChange = data.onTextChange;
      if (_onTextChange != null) _onTextChange(value);
    },
    onCompleted: data.onComplete == null
        ? null
        : () {
            Logger.debug(
                "======================ONCOMPLETED==========================");
            data.onComplete!(data.controller!.text);
            data.focusNode?.unfocus();
          },
    regexFormarter: '[0-9]',
    focusNode: data.focusNode,
    textEditingController: data.controller ?? TextEditingController(),
    label: data.title,
    inputType: TextInputType.number,
    isMoneyFormat: true,
    suffix: currency ?? '',
    suffixStyle: TextStyles.itemText.slateGreyColor.semibold,
    hintText: AppTranslate.i18n.enterAmountStr.localized,
    errorText: data.error,
  );
}
