import 'package:b2b/constants.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';

import '../../core/extensions/textstyles.dart';

class SearchItem extends StatelessWidget {
  const SearchItem({Key? key, this.hintText, required this.controller, required this.callBack,this.focusNode}) : super(key: key);

  final hintText;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final Function(String searchText) callBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:  const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: Center(
              child: TextFormField(
                keyboardAppearance: Brightness.light,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                    hintStyle: const TextStyle(color: Color.fromRGBO(102, 102, 103, 1.0), fontSize: 13)),
                controller: controller,
                focusNode: focusNode,
                style: TextStyles.itemText.regular,
                onChanged: (text) {
                  callBack(text);
                },
              ),
            ),
          ),
          const SizedBox(width: 5),
          Touchable(
              child: ImageHelper.loadFromAsset(AssetHelper.icoSearch, width: 24.toScreenSize, height: 24.toScreenSize),
              onTap: () {
                Logger.debug("search search ");
              })
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
      ),
      decoration: kDecoration,
    );
  }
}
