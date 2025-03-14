import 'package:b2b/constants.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomKeypad extends StatelessWidget {
  const CustomKeypad({
    Key? key,
    required this.onKeyPress,
    required this.onBackspacePress,
    required this.isVisible,
    required this.isDotVisible,
  }) : super(key: key);

  final Function(String) onKeyPress;
  final Function() onBackspacePress;
  final bool isVisible;
  final bool isDotVisible;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return Container();
    }

    return Container(
      color: const Color.fromRGBO(232, 232, 232, 1),
      child: SafeArea(
        top: false,
        child: Touchable(
          // Prevent keypad close when touching outside key area
          onTap: () {},
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(4),
            color: const Color.fromRGBO(232, 232, 232, 1),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildButton('1', onKeyPress)),
                    Expanded(child: _buildButton('2', onKeyPress)),
                    Expanded(child: _buildButton('3', onKeyPress)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildButton('4', onKeyPress)),
                    Expanded(child: _buildButton('5', onKeyPress)),
                    Expanded(child: _buildButton('6', onKeyPress)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: _buildButton('7', onKeyPress)),
                    Expanded(child: _buildButton('8', onKeyPress)),
                    Expanded(child: _buildButton('9', onKeyPress)),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Opacity(
                        child: _buildButton('.', onKeyPress),
                        opacity: isDotVisible ? 1 : 0,
                      ),
                    ),
                    Expanded(child: _buildButton('0', onKeyPress)),
                    Expanded(
                        child:
                            _buildButton('<', onKeyPress, isBackspace: true)),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String key, Function(String) onPress,
      {bool isBackspace = false}) {
    return Container(
      height: 50,
      margin: const EdgeInsets.all(kDefaultPadding / 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Material(
        child: InkWell(
          splashColor: const Color.fromRGBO(0, 183, 79, 0.1),
          highlightColor: const Color.fromRGBO(0, 183, 79, 0.1),
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            isBackspace ? onBackspacePress() : onPress(key);
          },
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: Container(
              child: Center(
                child: isBackspace
                    ? SizedBox(
                        height: 25,
                        child:
                            ImageHelper.loadFromAsset(AssetHelper.icoBackspace),
                      )
                    : Text(
                        key,
                        style: kStyleTextUnit.copyWith(
                          fontSize: 22,
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
