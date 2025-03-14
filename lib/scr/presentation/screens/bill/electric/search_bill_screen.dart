import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/bill/bill_bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/bill/bill_provider.dart';
import 'package:b2b/scr/data/model/bill/bill_saved.dart';
import 'package:b2b/scr/presentation/widgets/app_divider.dart';
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
import '../../../../../commons.dart';

class SearchBillScreen extends StatefulWidget {
  static const String routeName = '/SearchBillScreen';
  final Function(BillSaved?)? callBack;

  SearchBillScreen({Key? key, this.callBack}) : super(key: key);

  @override
  _SearchBillScreenState createState() => _SearchBillScreenState();
}

class _SearchBillScreenState extends State<SearchBillScreen> {
  final TextEditingController _searchController = TextEditingController();

  late BillBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<BillBloc>(context)
      ..add(
        GetListBillSavedEvent(
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
                    hintText: AppTranslate.i18n.searchBillStr.localized,
                    controller: _searchController,
                    // focusNode: focusNode,
                    callBack: (searchText) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(
                  height: 2 * kDefaultPadding,
                ),
                Expanded(
                  child: _savedBill(state),
                  flex: 1,
                ),
                const SizedBox(
                  height: kDefaultPadding,
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
        widget.callBack?.call(data);
        popScreen(context);
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
    List<BillSaved>? dataList = [];
    dataList.addAll(state.listBillSaved ?? []);
    String value = _searchController.text;

    dataList = dataList.where((element) {
      if (value.isNotNullAndEmpty) {
        String code = element.customerCode ?? '';
        if (!code.toLowerCase().contains(value.toLowerCase())) {
          return false;
        }
      }
      return true;
    }).toList();

    return Container(
      decoration: kDecoration,
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Column(
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
                        : dataList?[index]);
              },
              separatorBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  height: 1,
                  child: AppDivider(height: 1),
                );
              },
              itemCount: state.getListBillSavedDataState != DataState.data
                  ? 4
                  : dataList.length),
        ],
      ),
    );
  }
}
