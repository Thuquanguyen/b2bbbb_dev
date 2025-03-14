import 'dart:async';
import 'dart:io';

import 'package:b2b/commons.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/presentation/widgets/lazy_widget.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';

import '../../../utilities/logger.dart';

const INPUT_TYPE_CHANGE = 'INPUT_TYPE_CHANGE';

class InputDoneView extends StatelessWidget {
  const InputDoneView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.toScreenSize,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Touchable(
          onTap: () {
            hideKeyboard(context);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              AppTranslate.i18n.titleDoneStr.localized.toUpperCase(),
              style: TextStyles.itemText
                  .setFontWeight(FontWeight.bold)
                  .setColor(Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class KeyboardTypeView extends StatelessWidget {
  TextEditingController? controller;

  KeyboardTypeView({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: () {
        Logger.debug(
            'KeyboardVisibilityView.inputId ${KeyboardVisibilityView.inputId}');
        MessageHandler().notify(KeyboardVisibilityView.inputId ?? '');
      },
      child: Container(
        width: 50.toScreenSize,
        // margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: ImageHelper.loadFromAsset(AssetHelper.keyboard,
                  width: 30, height: 30)),
        ),
      ),
    );
  }
}

class InputDecimalView extends StatelessWidget {
  TextEditingController? controller;

  InputDecimalView({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: () {
        controller?.text = '${controller?.text}.';

        controller?.selection = TextSelection.fromPosition(
          TextPosition(
            offset: controller?.text.length ?? 0,
          ),
        );
      },
      child: Container(
        width: 80.toScreenSize,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(
              '•',
              style: TextStyles.itemText
                  .setFontWeight(FontWeight.bold)
                  .setColor(Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class KeyboardVisibilityView extends StatefulWidget {
  const KeyboardVisibilityView({Key? key}) : super(key: key);
  static TextInputType? _currentInputType;
  static TextEditingController? _textEditingController;
  static bool? showDecimal;
  static bool? showKeyBoardTypeOption;
  static String? inputId;

  /**
   * isShowDecimal => show dấu . để nhập số thập phân
   * isShowKeyBoardTypeOption => showOption chọn bàn phím số or chữ
   */
  static void setCurrentInputType(TextInputType inputType,
      {TextEditingController? controller,
      bool? isShowDecimal,
      bool? isShowKeyBoardTypeOption,
      String? id}) {
    print('change input type');

    showDecimal = isShowDecimal;
    showKeyBoardTypeOption = isShowKeyBoardTypeOption;
    inputId = id;

    if (_textEditingController != controller) {
      _textEditingController = controller;
    }
    if (controller == null) {
      _textEditingController = null;
    }

    if (_currentInputType != inputType) {
      _currentInputType = inputType;
      MessageHandler().notify(INPUT_TYPE_CHANGE);
      Logger.debug('INPUT_TYPE_CHANGE');
    }
  }

  static void setTextController(TextEditingController controller) {
    print('change text controller ');
    if (_textEditingController != controller) {
      _textEditingController = controller;
      MessageHandler().notify(INPUT_TYPE_CHANGE);
    }
  }

  @override
  _KeyboardVisibilityState createState() => _KeyboardVisibilityState();
}

class _KeyboardVisibilityState extends State<KeyboardVisibilityView> {
  var keyboardVisibilityController = KeyboardVisibilityController();
  late StreamSubscription<bool> keyboardSubscription;
  bool _isShowDone = false;
  bool _isShowKeyboard = false;

  void handleChangeInputType() {
    if (_isShowKeyboard) {
      Logger.debug('handleChangeInputType');
      setState(() {
        if (KeyboardVisibilityView._currentInputType == TextInputType.number ||
            KeyboardVisibilityView._currentInputType == TextInputType.phone) {
          _isShowDone = true;
        } else {
          _isShowDone = false;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    MessageHandler().addListener(INPUT_TYPE_CHANGE, handleChangeInputType);
    // Subscribe
    keyboardSubscription = keyboardVisibilityController.onChange.listen(
      (bool visible) {
        print('Keyboard visibility update. Is visible: $visible');
        setState(
          () {
            _isShowKeyboard = visible;
            if (_isShowDone == false &&
                (KeyboardVisibilityView._currentInputType ==
                        TextInputType.number ||
                    KeyboardVisibilityView._currentInputType ==
                        TextInputType.phone)) {
              _isShowDone = true;
            } else if (_isShowDone == true) {
              _isShowDone = false;
              KeyboardVisibilityView._currentInputType = null;
            }
          },
        );
        // }
      },
    );
  }

  @override
  void dispose() {
    keyboardSubscription.cancel();
    MessageHandler().removeListener(INPUT_TYPE_CHANGE, handleChangeInputType);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Logger.debug(
        'KeyboardVisibilityView.isShowKeyBoardTypeOption ${KeyboardVisibilityView.showKeyBoardTypeOption}');
    return (_isShowDone && Platform.isAndroid == false) ||
            KeyboardVisibilityView.showKeyBoardTypeOption == true
        ? LazyWidget(
            delay: 200,
            child: Positioned(
              bottom: MediaQuery.of(context).viewInsets.bottom,
              right: 0.0,
              left: 0.0,
              child: Container(
                color: const Color(0xffd6d7dd),
                width: double.infinity,
                padding: const EdgeInsets.only(top: 5, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (KeyboardVisibilityView.showKeyBoardTypeOption == true)
                      KeyboardTypeView(),
                    if (_isShowDone && Platform.isAndroid == false)
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (KeyboardVisibilityView.showDecimal == true)
                              InputDecimalView(
                                controller: KeyboardVisibilityView
                                    ._textEditingController,
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                            const InputDoneView(),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
