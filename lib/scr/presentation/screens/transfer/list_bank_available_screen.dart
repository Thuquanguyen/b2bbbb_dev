// Created by Cuonghd2 at 05/08/2021
// Email: cuonghd2@vpbank.com.vn
// Copyright (c) 2020. All rights reserved.

import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/item_infomation_available.dart';
import 'package:b2b/scr/presentation/widgets/item_input_custom.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';

import '../../../../constants.dart';
import '../../../core/extensions/num_ext.dart';

class Bank {
  Bank(this.bankName, this.des, {this.icon});
  final String bankName;
  final String des;
  final String? icon;
}

final List<Bank> listBankAvailable = [
  Bank(
    'VPBank',
    'Ngân hàng Việt Nam Thịnh Vượng',
  ),
  Bank(
    'Vietinbank',
    'Ngân hàng Công Thương Việt Nam',
  ),
  Bank(
    'Agribank',
    'NH Nông nghiệp và PTNT VN',
  ),
  Bank(
    'Techcombank',
    'Ngân hàng kỹ thương',
  ),
  Bank(
    'MBBank',
    'Ngân hàng Quân Đội',
  ),
  Bank(
    'ACB',
    'Ngân hàng Á Châu',
  ),
];

class ListBankAvailable extends StatefulWidget {
  const ListBankAvailable({Key? key}) : super(key: key);

  static String routeName = '/list_bank_available';

  @override
  _ListBankAvailableState createState() => _ListBankAvailableState();
}

class _ListBankAvailableState extends State<ListBankAvailable> {
  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: AppTranslate.i18n.pickBankStr.localized,
      appBarType: AppBarType.MEDIUM,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 45.toScreenSize,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.all(Radius.circular(kDefaultPadding))),
              padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: ItemInputCustom(
                height: 13.toScreenSize,
                inputType: TextInputType.name,
                textStyle: TextStyle(
                  fontSize: 13.toScreenSize,
                ),
                inputDecoration: InputDecoration(
                  hintText: AppTranslate.i18n.titleSearchBankStr.localized,
                  hintStyle: TextStyle(
                    fontSize: 13,
                    color: Color.fromRGBO(102, 102, 103, 1),
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  disabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  focusedErrorBorder: InputBorder.none,
                  suffixIcon: ImageHelper.loadFromAsset(AssetHelper.icoSearch),
                  suffixIconConstraints: BoxConstraints(
                      maxWidth: 18.toScreenSize, maxHeight: 18.toScreenSize),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      kDefaultPadding,
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
                margin: EdgeInsets.only(
                  bottom: 40.toScreenSize,
                ),
                child: ListView.builder(
                  padding: EdgeInsets.all(0),
                  itemCount: listBankAvailable.length,
                  itemBuilder: (context, index) {
                    final itemBank = listBankAvailable[index];
                    return ItemInformationAvailable(
                      title: itemBank.bankName,
                      iconWidget: ImageHelper.loadFromAsset(
                        AssetHelper.icoVpbankOnly,
                      ),
                      description: itemBank.des,
                      onPress: () {
                        Navigator.of(context).pop(itemBank.bankName);
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
