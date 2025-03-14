import 'package:b2b/constants.dart';
import 'package:b2b/scr/data/model/account_service/account_model.dart';
import 'package:b2b/scr/data/model/account_services_arguments.dart';
import 'package:b2b/scr/presentation/screens/account_service/account_service.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/widgets/item_account_service/account_header.dart';
import 'package:b2b/scr/presentation/widgets/item_account_service/account_info_item.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class AccountItem extends StatelessWidget {
  const AccountItem(
      {Key? key,
      required this.account,
      required this.icon,
      this.type = accountDetailArgument})
      : super(key: key);

  final DataAccount? account;
  final String? type;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: StickyHeader(
        header: ShaderMask(
          shaderCallback: (Rect bounds) {
            return const LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              stops: [0.85, 1],
              colors: <Color>[
                Color.fromRGBO(255, 255, 255, 1),
                Color.fromRGBO(255, 255, 255, 0),
              ],
            ).createShader(bounds);
          },
          child: AccountHeader(
            title: account?.groupName.localization() ?? '',
            icon: icon,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Container(
            decoration: kDecoration,
            child: Column(
              children: (account?.data.map((accountInfo) {
                        int index = account?.data.indexOf(accountInfo) ?? 0;
                        return Container(
                          decoration: index == ((account?.data.length ?? 0) - 1)
                              ? null
                              : const BoxDecoration(
                                  border: Border(
                                    bottom: kBorderSide,
                                  ),
                                ),
                          child: AccountInfoItem(
                            accountNumber: account?.data[index].getSubtitle(),
                            workingBalance: TransactionManage().formatCurrency(
                                account?.data[index].availableBalance ?? 0,
                                account?.data[index].accountCurrency ?? 'VND'),
                            accountCurrency:
                                account?.data[index].accountCurrency,
                            isLastIndex:
                                index == ((account?.data.length ?? 0) - 1),
                            onPress: () {
                              Navigator.of(context)
                                  .pushNamed(AccountServicesScreen.routeName,
                                      arguments: AccountServicesArguments(
                                        type ?? accountDetailArgument,
                                        accountInfo: accountInfo,
                                        accountType:
                                            account?.groupName.localization(),
                                      ));
                            },
                            icon: AssetHelper.icoForward,
                          ),
                        );
                      }) ??
                      [])
                  .toList(),
            ),
          ),
        ),
      ),
      visible: (account?.data.length ?? 0) != 0,
    );
  }
}
