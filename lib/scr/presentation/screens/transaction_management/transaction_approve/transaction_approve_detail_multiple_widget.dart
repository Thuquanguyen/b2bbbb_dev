import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/screens/smart_otp/verify_otp_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_approve/transaction_approve_detail_screen.dart';
import 'package:b2b/scr/presentation/widgets/item_transaction_manager.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/scr/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

class TransactionApproveDetailMulti extends StatelessWidget {
  const TransactionApproveDetailMulti({
    Key? key,
    required this.transactions,
    required this.actionType,
    this.isFx,
  }) : super(key: key);

  final List<TransactionMainModel> transactions;
  final CommitActionType? actionType;
  final bool? isFx;

  String getActionText(String text) {
    String action = '';
    switch (actionType) {
      case null:
        break;
      case CommitActionType.APPROVE:
        action = AppTranslate.i18n.tasActionApproveStr.localized;
        break;
      case CommitActionType.REJECT:
        action = AppTranslate.i18n.tasActionRejectStr.localized;
        break;
      case CommitActionType.CANCEL:
        action = AppTranslate.i18n.tasActionCancelStr.localized;
        break;
    }

    return text.interpolate({'action': action}).toSentence();
  }

  @override
  Widget build(BuildContext context) {
    double total = 0;
    bool isSameCcy = true;
    String? firstCcy;
    for (var t in transactions) {
      firstCcy ??= t.currency;

      if (firstCcy != t.currency) {
        isSameCcy = false;
        break;
      }

      total += (t.amount ?? 0);
    }

    String totalString = TransactionManage().formatCurrency(total, firstCcy ?? 'VND');

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
            ),
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.all(kDefaultPadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: const [kBoxShadowCommon],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    getActionText(AppTranslate.i18n.tasActionTitleStr.localized),
                    style: kStyleASTitle,
                  ).withShimmer(
                    visible: transactions.isEmpty,
                    expectedCharacterCount: 15,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    '${transactions.length} ${AppTranslate.i18n.tasApprovingTransactionStr.localized}'.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(0, 183, 79, 1),
                    ),
                  ).withShimmer(
                    visible: transactions.isEmpty,
                    expectedCharacterCount: 18,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  isSameCcy
                      ? Text(
                          getActionText(AppTranslate.i18n.tasActionTotalAmountStr.localized),
                          style: kStyleASTitle,
                        ).withShimmer(
                          visible: transactions.isEmpty,
                          expectedCharacterCount: 18,
                        )
                      : Container(),
                  SizedBox(
                    height: isSameCcy ? 8 : 0,
                  ),
                  isSameCcy
                      ? Text(
                          '$totalString $firstCcy',
                          style: kStyleTitleText.copyWith(fontWeight: FontWeight.w500),
                        ).withShimmer(
                          visible: transactions.isEmpty,
                          expectedCharacterCount: 18,
                        )
                      : Container(),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 35 - kDefaultPadding,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
            padding: const EdgeInsets.all(kDefaultPadding / 2),
            decoration: const BoxDecoration(
              color: Color.fromRGBO(237, 241, 246, 1),
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            child: Row(
              children: [
                Container(
                  child: ImageHelper.loadFromAsset(AssetHelper.icoWallet1),
                ).withShimmer(visible: transactions.isEmpty),
                const SizedBox(
                  width: kDefaultPadding,
                ),
                Text(
                  AppTranslate.i18n.tasActionTransListStr.localized,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Color.fromRGBO(52, 52, 52, 1),
                  ),
                ).withShimmer(
                  visible: transactions.isEmpty,
                  expectedCharacterCount: 20,
                ),
              ],
            ),
          ),
          ...transactions
              .map<Widget>(
                (e) => Container(
                  padding: const EdgeInsets.only(
                    top: kDefaultPadding,
                    left: kDefaultPadding,
                    right: kDefaultPadding,
                  ),
                  child: ItemTransactionManager(
                    e,
                    enableSelected: false,
                    onPress: () {
                      pushNamed(
                        context,
                        TransactionApproveDetailScreen.routeName,
                        arguments: TransactionApproveDetailScreenArgument(
                          transaction: e,
                          isFx: isFx,
                        ),
                      );
                    },
                  ),
                ),
              )
              .toList(),
          const SizedBox(
            height: kDefaultPadding,
          ),
        ],
      ),
    );
  }
}
