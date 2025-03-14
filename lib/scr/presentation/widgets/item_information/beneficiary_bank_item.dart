import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/presentation/widgets/item_infomation_available.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';

class BeneficiaryBankItem extends StatelessWidget {
  const BeneficiaryBankItem({
    Key? key,
    required this.titleHeader,
    required this.iconHeader,
    this.titleContent,
    this.subTitleContent,
  }) : super(key: key);

  final String? titleHeader;
  final String? iconHeader;
  final String? titleContent;
  final String? subTitleContent;

  @override
  Widget build(BuildContext context) {
    if (titleHeader == null) return Container();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: kTopPadding),
      child: Column(
        children: [
          ItemInformationAvailable(
            title: titleHeader!,
            iconWidget: ImageHelper.loadFromAsset(
              iconHeader!,
            ),
            onPress: () {},
            caption: AppTranslate.i18n.dataHardCoreBankStr.localized,
            showBorder: false,
          ),
          const SizedBox(height: 20),
          Text((titleContent ?? '').toUpperCase(), style: kStyleTextUnit),
          const SizedBox(height: 4),
          Text(subTitleContent ?? '', style: kStyleTextSubtitle)
        ],
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
    );
  }
}
