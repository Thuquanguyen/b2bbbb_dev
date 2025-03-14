import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/presentation/widgets/buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ContainerItem extends StatelessWidget {
  const ContainerItem({
    Key? key,
    this.listItem,
    this.callBack,
  }) : super(key: key);

  final listItem;
  final Function()? callBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(
        kDefaultPadding,
        kDefaultPadding,
        kDefaultPadding,
        kMediumPadding,
      ),
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kDefaultPadding),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: (listItem as List<Widget>).toList(),
              ),
            ),
          ),
          DefaultButton(
            onPress: callBack,
            text: AppTranslate.i18n.continueStr.localized.toUpperCase(),
            height: 45,
            radius: 32,
            margin: EdgeInsets.symmetric(vertical: kDefaultPadding),
          ),
        ],
      ),
    );
  }
}
