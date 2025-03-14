// Created by Cuonghd2 at 05/08/2021
// Email: cuonghd2@vpbank.com.vn
// Copyright (c) 2020. All rights reserved.

import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/item_infomation_available.dart';
import 'package:flutter/material.dart';

import 'package:b2b/scr/core/extensions/num_ext.dart';

import '../../../../constants.dart';

class ListAccountTransferSaved extends StatefulWidget {
  ListAccountTransferSaved({Key? key}) : super(key: key);
  static const routeName = 'list_account_transfer_saved_screen';

  @override
  _ListAccountTransferSavedState createState() =>
      _ListAccountTransferSavedState();
}

class _ListAccountTransferSavedState extends State<ListAccountTransferSaved> {
  @override
  Widget build(BuildContext context) {
    var args = getArguments(context) as String;
    return AppBarContainer(
      title: args,
      appBarType: AppBarType.SEMI_MEDIUM,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 25.toScreenSize,
            ),
            Text(
              AppTranslate.i18n.beneficiaryTitleHeaderStr.localized,
              style: TextStyles.headerText.bold.whiteColor,
            ),
            SizedBox(
              height: kDefaultPadding.toScreenSize,
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
                child: ListView.builder(
                  itemCount: 10,
                  padding: EdgeInsets.all(kDefaultPadding),
                  itemBuilder: (context, index) {
                    return ItemInformationAvailable(
                      title: 'Nickname - ' + AppTranslate.i18n.titleSenderStr.localized.toUpperCase(),
                      iconWidget: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(
                            Radius.circular(30),
                          ),
                        ),
                        child: Text(
                          ' t g'.getLetterStartName,
                          style: TextStyles.headerText.whiteColor.semibold,
                        ),
                      ),
                      onPress: () {
                        Navigator.of(context).pop();
                      },
                      description:  AppTranslate.i18n.homeTitleAccountStr.localized,
                      // showIconForward: true,
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 40.toScreenSize,
            ),
          ],
        ),
      ),
    );
  }
}
