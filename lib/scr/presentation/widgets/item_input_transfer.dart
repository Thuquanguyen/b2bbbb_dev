import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textinput_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/validator/validator.dart';
import 'package:b2b/scr/data/model/search/beneficiary_saved_model.dart';
import 'package:b2b/scr/presentation/widgets/keyboard_visibility_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../utilities/logger.dart';

class ItemInputTransfer extends StatelessWidget {
  String? id;
  final TextEditingController textEditingController;
  final String? suffix;
  final bool isMoneyFormat;
  final String? label;
  final Widget? suffixIcon;
  final TextInputType? inputType;
  final String? hintText;
  final Function(String)? onTextChange;
  final Function()? onCompleted;
  final Function()? onTap;
  final Function(dynamic)? onResume;
  final FocusNode? focusNode;
  final String? errorText;
  final TextStyle? suffixStyle;
  final TextInputAction? textInputAction;
  final AutovalidateMode autovalidateMode;
  final Validator? validator;
  final bool autoComplete;
  final String? regexFormarter;
  final String? initValue;
  final List<BeneficiarySavedModel>? listData;
  final bool? enable;
  final bool isTextChange;
  final bool isUpperCase;
  final int? maxLength;
  final int? maxLine;
  final bool? removeDefaultPadding;
  final bool? showRequire;
  final bool? showDecimal; // cho nhập dấu . khi nhập số thập phân
  final bool? showChangeKeyboardType; // chọn chọn kiểu bàn phím

  ItemInputTransfer(
      {Key? key,
      this.id,
      required this.textEditingController,
      this.suffix = '',
      this.isMoneyFormat = false,
      this.showRequire = false,
      this.label,
      this.suffixIcon,
      this.inputType,
      this.hintText,
      this.onTextChange,
      this.onCompleted,
      this.onTap,
      this.onResume,
      this.focusNode,
      this.errorText,
      this.suffixStyle,
      this.textInputAction,
      this.autovalidateMode = AutovalidateMode.onUserInteraction,
      this.validator,
      this.autoComplete = false,
      this.listData,
      this.regexFormarter,
      this.maxLength,
      this.maxLine,
      this.isUpperCase = false,
      this.isTextChange = true,
      this.initValue,
      this.enable = true,
      this.removeDefaultPadding = false,
      this.showDecimal = false,
      this.showChangeKeyboardType})
      : super(key: key);

  bool hasAddListener = false;

  Function(TextEditingController? controller, FocusNode? focusNode)?
      onAutoCompleteCreated;

  setListenerAutoCompleteCreated(
      Function(TextEditingController? controller, FocusNode? focusNode)
          onCreated) {
    onAutoCompleteCreated = onCreated;
  }

  @override
  Widget build(BuildContext context) {
    List<TextInputFormatter> textInputFormatter = [];
    // if (isUpperCase) {
    //   textInputFormatter.add(UpperCaseTextFormatter());
    // }
    if (maxLength != null) {
      textInputFormatter.add(LengthLimitingTextInputFormatter(maxLength));
    }
    if (regexFormarter != null) {
      textInputFormatter
          .add(FilteringTextInputFormatter.allow(RegExp(regexFormarter!)));
    }
    TextStyle _textStyle = const TextStyle();
    if (!(enable ?? false)) {
      _textStyle = const TextStyle(color: Colors.black38, fontSize: 13).regular;
    } else {
      if (isMoneyFormat) {
        _textStyle = TextStyles.countdownText1;
      } else {
        _textStyle = TextStyles.itemText.inputTextColor;
      }
    }
    if (!autoComplete && focusNode != null && !hasAddListener) {
      hasAddListener = true;
      focusNode!.addListener(
        () {
          if (focusNode!.hasFocus) {
            KeyboardVisibilityView.setCurrentInputType(
                inputType ?? TextInputType.text,
                controller: textEditingController,
                isShowDecimal: showDecimal,
                id: id,
                isShowKeyBoardTypeOption: showChangeKeyboardType);
          } else {
            KeyboardVisibilityView.setCurrentInputType(TextInputType.text,
                controller: textEditingController,
                id: id,
                isShowKeyBoardTypeOption: false);
          }
        },
      );
    }

    return Container(
      padding: EdgeInsets.only(
          bottom: (removeDefaultPadding == true) ? 0 : kDefaultPadding),
      child: Stack(
        children: [
          if (autoComplete)
            Autocomplete<BeneficiarySavedModel>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  List<BeneficiarySavedModel> _listBen =
                      (listData ?? []).where((element) {
                    if (textEditingValue.text.length <= 2) {
                      return false;
                    }
                    String benAccount = element.benAccount ?? '';
                    String benAlias = element.benAlias ?? '';
                    return (benAccount.startsWith(textEditingValue.text) ||
                        benAccount.contains(textEditingValue.text) ||
                        benAlias.contains(textEditingValue.text));
                  }).toList();
                  return _listBen;
                },
                displayStringForOption: (option) => option.benAccount ?? '',
                fieldViewBuilder: (context, controller, focusNode, callBack) {
                  onAutoCompleteCreated?.call(controller, focusNode);
                  if (!hasAddListener) {
                    hasAddListener = true;
                    focusNode.addListener(() {
                      if (focusNode.hasFocus) {
                        KeyboardVisibilityView.setCurrentInputType(
                            inputType ?? TextInputType.text,
                            controller: controller,
                            isShowKeyBoardTypeOption: showChangeKeyboardType,
                            id: id);
                      } else {
                        KeyboardVisibilityView.setCurrentInputType(
                            TextInputType.text,
                            controller: controller,
                            isShowKeyBoardTypeOption: false,
                            id: id);
                      }
                    });
                  }
                  return TextFormField(
                    keyboardAppearance: Brightness.light,
                    enableSuggestions: false,
                    textCapitalization: isUpperCase
                        ? TextCapitalization.characters
                        : TextCapitalization.none,
                    enabled: enable,
                    onTap: onTap,
                    maxLines: maxLine,
                    // maxLength: maxLength,
                    cursorHeight: isMoneyFormat ? 32 : 15,
                    textInputAction: textInputAction,
                    controller: controller,
                    onChanged: (value) {
                      if (onTextChange != null) {
                        onTextChange!(
                            isUpperCase ? value.toUpperCase() : value);
                      }
                    },
                    validator: (value) {},
                    autovalidateMode: autovalidateMode,
                    inputFormatters: regexFormarter != null
                        ? <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                                RegExp(regexFormarter!)),
                          ]
                        : null,
                    focusNode: focusNode,
                    onEditingComplete: onCompleted,
                    keyboardType: inputType ?? TextInputType.text,
                    autocorrect: false,
                    style: isMoneyFormat
                        ? TextStyles.countdownText1
                        : TextStyles.itemText.inputTextColor,
                    decoration: InputDecoration(
                      errorText: errorText,
                      labelText: label,
                      hintText: hintText ?? '',
                      labelStyle: TextStyles.itemText.slateGreyColor,
                      suffixStyle: suffixStyle,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: kBorderSide,
                      ),
                      border: const UnderlineInputBorder(
                        borderSide: kBorderSide,
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: kBorderSide,
                      ),
                      contentPadding: const EdgeInsets.only(right: 30),
                      suffixText: suffix ?? '',
                      suffixIconConstraints:
                          const BoxConstraints(maxHeight: 20),
                    ),
                  );
                },
                onSelected: (BeneficiarySavedModel selection) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (onResume != null) {
                    onResume!(selection);
                  }
                },
                optionsViewBuilder: (context,
                    AutocompleteOnSelected<BeneficiarySavedModel> onSelected,
                    Iterable<BeneficiarySavedModel> options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration: const BoxDecoration(
                          boxShadow: [kBoxShadowCommon],
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10.0),
                              bottomLeft: Radius.circular(10.0))),
                      width: MediaQuery.of(context).size.width - 60,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 220),
                        child: ListView.separated(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: options.length,
                          itemBuilder: (context, index) {
                            BeneficiarySavedModel model =
                                options.elementAt(index);
                            return TextButton(
                              style: TextButton.styleFrom(
                                  padding: const EdgeInsets.all(0)),
                              onPressed: () {
                                onSelected(model);
                              },
                              child: ListTile(
                                leading: Column(
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      width: kLeadingIconSize,
                                      height: kLeadingIconSize,
                                      decoration: BoxDecoration(
                                        color: getColor(index + 1),
                                        borderRadius: const BorderRadius.all(
                                          Radius.circular(30),
                                        ),
                                      ),
                                      child: Text(
                                        getLetterAvatar(
                                            (model.benAlias ?? '').trim()),
                                        style: TextStyles
                                            .headerText.whiteColor.semibold,
                                      ),
                                    )
                                  ],
                                  mainAxisAlignment: MainAxisAlignment.center,
                                ),
                                title: Text(
                                  model.benAlias ?? '',
                                  style: TextStyles.normalText.semibold,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: model.benBankName != null
                                    ? Text(
                                        '${model.benBankName!} - ${model.benAccount}',
                                        style:
                                            TextStyles.smallText.slateGreyColor,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      )
                                    : null,
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return Container(
                              height: 1,
                              margin: const EdgeInsets.only(
                                  left: kDefaultPadding,
                                  right: kDefaultPadding),
                              color: const Color.fromRGBO(237, 241, 246, 1),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                }),
          if (!autoComplete)
            TextFormField(
              keyboardAppearance: Brightness.light,
              textCapitalization: isUpperCase
                  ? TextCapitalization.characters
                  : TextCapitalization.none,
              enableSuggestions: false,
              enabled: enable,
              maxLines: maxLine,
              // maxLength: maxLength,
              cursorHeight: isMoneyFormat ? 32 : 15,
              textInputAction: textInputAction,
              controller: textEditingController,
              onChanged: (value) {
                if (onTextChange != null) {
                  onTextChange!(isUpperCase ? value.toUpperCase() : value);
                }
              },
              validator: (value) {},
              autovalidateMode: autovalidateMode,
              inputFormatters: textInputFormatter,
              focusNode: focusNode,
              onEditingComplete: onCompleted,
              keyboardType: inputType ?? TextInputType.text,
              autocorrect: false,
              style: _textStyle,
              decoration: InputDecoration(
                errorText: errorText,
                // labelText: label,
                label: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                          text: label,
                          style: TextStyles.itemText.slateGreyColor),
                      if (showRequire == true)
                        TextSpan(
                          text: ' *',
                          style:
                              TextStyles.itemText.copyWith(color: Colors.red),
                        )
                    ],
                  ),
                ),
                hintText: hintText ?? '',
                labelStyle: TextStyles.itemText.slateGreyColor,
                suffixStyle: suffixStyle,
                focusedBorder: const UnderlineInputBorder(
                  borderSide: kBorderSide,
                ),
                border: const UnderlineInputBorder(
                  borderSide: kBorderSide,
                ),
                enabledBorder: const UnderlineInputBorder(
                  borderSide: kBorderSide,
                ),
                contentPadding: EdgeInsets.zero,
                suffixText: suffix ?? '',
                suffixIconConstraints: const BoxConstraints(maxHeight: 20),
              ),
            ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.centerRight,
              child: suffixIcon,
            ),
          ),
        ],
      ),
    );
  }
}
