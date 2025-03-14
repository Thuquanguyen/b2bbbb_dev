import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/base_item_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/screens/commerece/commerce_list_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/open_online_deposits_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_management_screen.dart';
import 'package:b2b/scr/presentation/widgets/action_item.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/material.dart';

class CommerceScreen extends StatefulWidget {
  const CommerceScreen({Key? key}) : super(key: key);
  static const String routeName = 'CommerceScreen';

  @override
  _CommerceScreenState createState() => _CommerceScreenState();
}

class _CommerceScreenState extends State<CommerceScreen> {
  final List<BaseItemModel> _listItem = [];

  void initData() {
    _listItem.clear();
    _listItem.addAll(
      [
        BaseItemModel(
          title: AppTranslate.i18n.statementLcStr.localized,
          icon: AssetHelper.icShieldCheck,
          onTap: (context) {
            pushNamed(context, CommerceListScreen.routeName,
                arguments: CommerceType.LC);
          },
        ),
        BaseItemModel(
          title: AppTranslate.i18n.statementGuaranteeStr.localized,
          icon: AssetHelper.icFlashlight,
          onTap: (context) {
            pushNamed(context, CommerceListScreen.routeName,
                arguments: CommerceType.BAO_LANH);
          },
        ),
        BaseItemModel(
          title: AppTranslate.i18n.statementCkStr.localized,
          icon: AssetHelper.icCk,
          onTap: (context) {
            pushNamed(context, CommerceListScreen.routeName,
                arguments: CommerceType.DISCOUNT);
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
      title: AppTranslate.i18n.dataHardCoreCommerceStr.localized,
      appBarType: AppBarType.NORMAL,
      child: Container(
        margin: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              child: Column(
                children: _listItem.map(
                  (itemModel) {
                    int index = _listItem.indexOf(itemModel);
                    return ActionItem(
                      itemModel: itemModel,
                      isLastIndex: index == (_listItem.length - 1),
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
