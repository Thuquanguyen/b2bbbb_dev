import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/transfer/transfer_bloc.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/argument/transfer_screen_argument.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/base_item_model.dart';
import 'package:b2b/scr/presentation/screens/main/home_action_manager.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/widgets/action_item.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';

import 'transfer_input/transfer_input_screen.dart';

class TransferArgs {
  final String? title;
  final String? subTitle;

  TransferArgs({this.title, this.subTitle});
}

class TransferScreen extends StatefulWidget {
  const TransferScreen({Key? key}) : super(key: key);
  static const String routeName = 'transfer-screen';

  @override
  _TransferScreenState createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  // late TransferBloc _transferBloc;

  final List<BaseItemModel> _listTransfer = [];

  void initData() {
    _listTransfer.clear();
    _listTransfer.addAll(
      [
        if (RolePermissionManager().checkVisible(HomeAction.PAYROLL_INHOUSE.id))
          BaseItemModel(
              title: AppTranslate.i18n.titleInternalPayrollStr.localized,
              icon: AssetHelper.icoVpbankSvg,
              onTap: (context) {
                Navigator.of(context).pushNamed(
                  TransferInputScreen.routeName,
                  arguments: TransferScreenArgument(
                      context: context,
                      transferType: TransferType.TRANSINHOUSE,
                      title:
                          AppTranslate.i18n.titleInternalPayrollStr.localized),
                );
              }),
        if (RolePermissionManager()
            .checkVisible(HomeAction.TRANSFER_INHOUSE.id))
          BaseItemModel(
              title: AppTranslate
                  .i18n.dataHardCoreTransferMoneyVpbankStr.localized,
              icon: AssetHelper.icoVpbankSvg,
              onTap: (context) {
                Navigator.of(context).pushNamed(
                  TransferInputScreen.routeName,
                  arguments: TransferScreenArgument(
                      context: context,
                      transferType: TransferType.TRANSINHOUSE,
                      title: AppTranslate
                          .i18n.dataHardCoreTransferMoneyVpbankStr.localized),
                );
              }),
        if (RolePermissionManager()
            .checkVisible(HomeAction.TRANSFER_INTERBANK_24H.id))
          BaseItemModel(
              title: AppTranslate.i18n.dataHardCoreTransfer247Str.localized,
              icon: AssetHelper.ico247,
              onTap: (context) {
                Navigator.of(context).pushNamed(
                  TransferInputScreen.routeName,
                  arguments: TransferScreenArgument(
                      context: context,
                      transferType: TransferType.TRANS247_ACCOUNT,
                      title: AppTranslate
                          .i18n.dataHardCoreTransfer247Str.localized),
                );
              }),
        if (RolePermissionManager()
            .checkVisible(HomeAction.PAYROLL_INTERBANK.id))
          BaseItemModel(
              title: AppTranslate.i18n.titleDomesticPayrollStr.localized,
              icon: AssetHelper.icoInterbank,
              onTap: (context) {
                Navigator.of(context).pushNamed(
                  TransferInputScreen.routeName,
                  arguments: TransferScreenArgument(
                      context: context,
                      transferType: TransferType.TRANSINTERBANK,
                      title:
                          AppTranslate.i18n.titleDomesticPayrollStr.localized),
                );
              }),
        if (RolePermissionManager()
            .checkVisible(HomeAction.TRANSFER_INTERBANK.id))
          BaseItemModel(
            title: AppTranslate
                .i18n.dataHardCoreInterbankMoneyTransferStr.localized,
            icon: AssetHelper.icoInterbank,
            onTap: (context) {
              Navigator.of(context).pushNamed(
                TransferInputScreen.routeName,
                arguments: TransferScreenArgument(
                    context: context,
                    transferType: TransferType.TRANSINTERBANK,
                    title: AppTranslate
                        .i18n.dataHardCoreInterbankMoneyTransferStr.localized),
              );
            },
          ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    initData();
    // _transferBloc = BlocProvider.of<TransferBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    final args = getArguments(context) as TransferArgs;

    return AppBarContainer(
      title:
          args.title ?? AppTranslate.i18n.homeTitleTransferMoneyStr.localized,
      appBarType: AppBarType.MEDIUM,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              args.subTitle ??
                  AppTranslate
                      .i18n.transferTitleChooseTransferMethodStr.localized,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 16),
            Container(
              child: Column(
                children: _listTransfer.map((itemModel) {
                  int index = _listTransfer.indexOf(itemModel);
                  return ActionItem(
                    itemModel: itemModel,
                    isLastIndex: index == (_listTransfer.length - 1),
                    callback: () {
                      // if ((RolePermissionManager().checkVisible(HomeAction.PAYROLL_INHOUSE.id) ||
                      //     RolePermissionManager().checkVisible(HomeAction.TRANSFER_INHOUSE.id)) && index == 0) {
                      //   Navigator.of(context).pushNamed(
                      //     TransferInputScreen.routeName,
                      //     arguments: TransferScreenArgument(
                      //         context: context, transferType: TransferType.TRANSINHOUSE, title: itemModel.title),
                      //   );
                      // }else if (RolePermissionManager().checkVisible(HomeAction.TRANSFER_INTERBANK_24H.id)  && index == 1) {
                      //   Navigator.of(context).pushNamed(
                      //     TransferInputScreen.routeName,
                      //     arguments: TransferScreenArgument(
                      //         context: context, transferType: TransferType.TRANS247_ACCOUNT, title: itemModel.title),
                      //   );
                      // }else {
                      //   Navigator.of(context).pushNamed(
                      //     TransferInputScreen.routeName,
                      //     arguments: TransferScreenArgument(
                      //         context: context, transferType: TransferType.TRANSINTERBANK, title: itemModel.title),
                      //   );
                      // }
                      itemModel.onTap?.call(context);
                    },
                  );
                }).toList(),
              ),
              decoration: kDecoration,
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}
