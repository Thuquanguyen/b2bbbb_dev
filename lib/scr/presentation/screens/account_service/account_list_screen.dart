import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/account_service/account_info/account_info_bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/item_account_service/account_item.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountListScreen extends StatefulWidget {
  const AccountListScreen({Key? key}) : super(key: key);
  static const String routeName = 'account-list-screen';

  @override
  _AccountListScreenState createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: AppTranslate.i18n.asListAccountStr.localized,
      appBarType: AppBarType.SMALL,
      child: BlocConsumer<AccountInfoBloc, AccountInfoState>(
        listenWhen: (previous, current) =>
            previous.dataState != current.dataState,
        listener: (context, state) {},
        builder: (context, state) {
          final List<Widget> _list = [
            AccountItem(
              account: state.accountModel?.dataBusinessAccount,
              icon: AssetHelper.icoAccountBusiness,
            ),
            AccountItem(
              account: state.accountModel?.dataPaymentAccount,
              icon: AssetHelper.icoPayment,
            ),
            AccountItem(
              account: state.accountModel?.dataSpecializedAccount,
              icon: AssetHelper.icoDedicatedAccount,
            ),
            AccountItem(
              account: state.accountModel?.dataSavingAccount,
              icon: AssetHelper.icoTermDepositAccount,
              type: savingAccountDetailArgument,
            ),
          ];
          return state.dataState != DataState.data
              ? _itemShimmer()
              : ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, i) {
                    return _list[i];
                  },
                );
        },
      ),
    );
  }

  Widget _itemShimmer() {
    List<int> _listData = [1, 2, 3, 4, 5];
    return AppShimmer(Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                    color: AppColors.shimmerItemColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
              ),
              const SizedBox(width: 16),
              Container(
                width: 200,
                height: 10,
                decoration: BoxDecoration(
                    color: AppColors.shimmerItemColor,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
              ),
            ],
          ),
          const SizedBox(
            height: kDefaultPadding,
          ),
          Expanded(
              child: Column(
                  children: _listData
                      .map((e) => Container(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: kDefaultPadding, horizontal: 12),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: AppColors.shimmerBackGroundColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(14)),
                                boxShadow: const [kBoxShadowCommon]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 10,
                                  width: 50,
                                  decoration: kDecorationShimmer,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                Container(
                                  height: 10,
                                  width: 150,
                                  decoration: kDecorationShimmer,
                                ),
                              ],
                            ),
                          ))
                      .toList()))
        ],
      ),
      margin:
          const EdgeInsets.symmetric(vertical: 32, horizontal: kDefaultPadding),
    ));
  }

// Widget _itemShimmer() {
//   return AppShimmer(
//       Container(
//     child: Container(
//       margin: const EdgeInsets.symmetric(
//           horizontal: kDefaultPadding, vertical: 12),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 22,
//                 height: 22,
//                 decoration: BoxDecoration(
//                     color: AppColors.shimmerBackGroundColor,
//                     borderRadius: const BorderRadius.all(Radius.circular(5))),
//               ),
//               const SizedBox(width: 16),
//               Container(
//                 width: 200,
//                 height: 25,
//                 decoration: BoxDecoration(
//                     color: AppColors.shimmerBackGroundColor,
//                     borderRadius: const BorderRadius.all(Radius.circular(5))),
//               ),
//             ],
//           ),
//           const SizedBox(
//             height: kDefaultPadding,
//           ),
//           Column(
//             children: ([1, 2, 3, 4, 5].map((_) {
//               return Container(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Container(
//                       height: 10,
//                       width: 50,
//                       decoration: kDecorationShimmer,
//                     ),
//                     const SizedBox(
//                       height: 8,
//                     ),
//                     Container(
//                       height: 10,
//                       width: 150,
//                       decoration: kDecorationShimmer,
//                     ),
//                   ],
//                 ),
//               );
//             })).toList(),
//           )
//         ],
//       ),
//     ),
//     margin: const EdgeInsets.symmetric(
//         vertical: kTopPadding, horizontal: kDefaultPadding),
//   ));
// }
}
