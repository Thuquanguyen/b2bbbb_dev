import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/bill/bill_bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/bill/bill_saved.dart';
import 'package:b2b/scr/presentation/screens/bill/electric/payment_electric_screen.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/item_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/search_item.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../commons.dart';
import 'package:diacritic/diacritic.dart';

class BillProviderScreen extends StatefulWidget {
  static String routeName = '/BillProviderScreen';

  const BillProviderScreen({Key? key}) : super(key: key);

  @override
  _BillProviderScreenState createState() => _BillProviderScreenState();
}

class _BillProviderScreenState extends State<BillProviderScreen> {
  final TextEditingController _searchController = TextEditingController();

  late BillBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<BillBloc>(context)
      ..add(
        BillProviderInitEvent(
          BillType.DIEN.getServiceCode(),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      title: AppTranslate.i18n.electricStr.localized.toUpperCase(),
      appBarType: AppBarType.SEMI_MEDIUM,
      child: BlocConsumer<BillBloc, BillState>(
        listener: (context, state) {
          if (state.getBillProviderDataState == DataState.preload) {
            showLoading();
          } else {
            hideLoading();
          }

          if (state.getBillProviderDataState == DataState.error) {
            showDialogErrorForceGoBack(
              context,
              state.getBillProviderErrMsg ?? '',
              () {
                popScreen(context);
              },
            );
          }
        },
        builder: (context, state) {
          return Container(
            margin: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: kDefaultPadding),
                  alignment: Alignment.center,
                  child: SearchItem(
                    hintText: AppTranslate.i18n.electricSearchHintStr.localized,
                    controller: _searchController,
                    // focusNode: focusNode,
                    callBack: (searchText) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                _buildListProvider(state),
                const SizedBox(
                  height: kDefaultPadding,
                ),
                Expanded(
                  child: _savedBill(state),
                  flex: 1,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  _itemBill(BillState state, BillSaved? data) {
    if (state.getListBillSavedDataState != DataState.data) {
      return AppShimmer(Row(
        children: [
          itemShimmer(width: 24, height: 24),
          const SizedBox(
            width: kDefaultPadding,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              itemShimmer(width: 250, height: 20),
              const SizedBox(
                height: 5,
              ),
              itemShimmer(width: 150, height: 20),
            ],
          )
        ],
      ));
    }
    return TouchableRipple(
      onPressed: () {
        if (data?.serviceCode == BillType.DIEN.getServiceCode()) {
          pushNamed(context, PaymentElectricScreen.routeName,
              arguments: {PaymentElectricScreen.keyBillSaved: data});
        }
      },
      child: Row(
        children: [
          ImageHelper.loadFromAsset(AssetHelper.electricHcm,
              width: 24, height: 24),
          const SizedBox(
            width: kDefaultPadding,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data?.providerName ?? '',
                style: TextStyles.itemText.medium.copyWith(
                  color: const Color(0xff22313F),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                data?.customerCode ?? '',
                style: TextStyles.itemText.regular.copyWith(
                  color: const Color(0xff666667),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _savedBill(BillState state) {
    return Column(
      children: [
        Row(
          children: [
            ImageHelper.loadFromAsset(AssetHelper.icBill),
            const SizedBox(
              width: 10,
            ),
            Text(
              AppTranslate.i18n.billSavedStr.localized,
              style: TextStyles.itemText.semibold.copyWith(
                color: const Color(0xff22313F),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: kDefaultPadding,
        ),
        if (state.getListBillSavedDataState == DataState.data &&
            (state.listBillSaved?.length ?? 0) <= 0)
          Expanded(
            flex: 1,
            child: Center(
              child: Text(
                AppTranslate.i18n.noBillSavedStr.localized,
                style: TextStyles.headerText,
              ),
            ),
          ),
        ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            return _itemBill(
                state,
                state.getListBillSavedDataState != DataState.data
                    ? null
                    : state.listBillSaved?[index]);
          },
          separatorBuilder: (context, index) {
            return const SizedBox(
              height: 8,
            );
          },
          itemCount: state.getListBillSavedDataState != DataState.data
              ? 5
              : (state.listBillSaved?.length ?? 0),
        ),
      ],
    );
  }

  _buildListProvider(BillState state) {
    if (state.getListBillSavedDataState != DataState.data) {
      return const SizedBox();
    }
    return Column(
      children: state.listBillProvider?.map(
            (e) {
              String value = _searchController.text;
              value = removeDiacritics(value);
              if (value.isNotNullAndEmpty) {
                String name = e.getProviderName()?.toLowerCase() ?? '';
                name = removeDiacritics(name);
                if (!name.contains(value.toLowerCase())) {
                  return const SizedBox();
                }
              }
              return TouchableRipple(
                onPressed: () {
                  pushNamed(
                    context,
                    PaymentElectricScreen.routeName,
                    arguments: {PaymentElectricScreen.keyBillProvider: e},
                  );
                },
                child: Container(
                  decoration: kDecoration,
                  padding: const EdgeInsets.all(kDefaultPadding),
                  child: Row(
                    children: [
                      ImageHelper.loadFromAsset(AssetHelper.electricHcm,
                          width: 24, height: 24),
                      const SizedBox(
                        width: kDefaultPadding,
                      ),
                      Text(
                        e.getProviderName() ?? '',
                        style: TextStyles.itemText.semibold.copyWith(
                          color: const Color(0xff22313F),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ).toList() ??
          [const SizedBox()],
    );
  }
}
