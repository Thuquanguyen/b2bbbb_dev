import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/base_item_model.dart';
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/screens/deposits/current_deposits/current_deposits_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/open_online_deposits_screen.dart';
import 'package:b2b/scr/presentation/screens/role_permission_manager.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_management_screen.dart';
import 'package:b2b/scr/presentation/widgets/action_item.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';

class DepositsScreen extends StatefulWidget {
  const DepositsScreen({Key? key}) : super(key: key);
  static const String routeName = 'DepositsScreen';

  @override
  _DepositsScreenState createState() => _DepositsScreenState();
}

class _DepositsScreenState extends State<DepositsScreen> {
  final List<BaseItemModel> _listTransfer = [];

  void initData() {
    _listTransfer.clear();
    _listTransfer.addAll(
      [
        BaseItemModel(
          title: AppTranslate.i18n.existingDepositsStr.localized,
          icon: AssetHelper.icExistingDeposit,
          onTap: (context) {
            Navigator.of(context).pushNamed(CurrentDepositsScreen.routeName);
          },
        ),
        BaseItemModel(
          title:
              AppTranslate.i18n.stsNotificationTransactionPendingStr.localized,
          icon: AssetHelper.icWaitingDeposit,
          onTap: (context) {
            Navigator.of(context).pushNamed(
              TransactionManageScreen.routeName,
              arguments: TransactionManageScreenArguments(
                selectedCategory: TransactionManage.savingCat,
              ),
            );
            // pushNamed(
            //   context,
            //   TransactionManageScreen.routeName,
            //   arguments: TransactionManageScreenArguments(
            //     selectedCategory: TransactionFilterCategory.savingCat,
            //   ),
            // );
          },
        ),
        if (RolePermissionManager().userRole == UserRole.MAKER)
          BaseItemModel(
            title: AppTranslate.i18n.openOnlineDepositsStr.localized,
            icon: AssetHelper.icOpenDepositOnline,
            onTap: (context) {
              Logger.debug('mo tine gui online -----------------');
              pushNamed(context, OpenOnlineDepositsScreen.routeName);
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
    return AppBarContainer(
      title: AppTranslate.i18n.beneficiaryTitleFindBankStr.localized,
      appBarType: AppBarType.NORMAL,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              child: Column(
                children: _listTransfer.map(
                  (itemModel) {
                    int index = _listTransfer.indexOf(itemModel);
                    return ActionItem(
                      itemModel: itemModel,
                      isLastIndex: index == (_listTransfer.length - 1),
                      callback: () {
                        itemModel.onTap?.call(context);
                      },
                    );
                  },
                ).toList(),
              ),
              decoration: kDecoration,
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }
}
