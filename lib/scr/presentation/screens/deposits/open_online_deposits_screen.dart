import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/deposits/open_online_deposits_bloc.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/open_saving/saving_deposits_product_response.dart';
import 'package:b2b/scr/data/repository/open_deposits_repository.dart';
import 'package:b2b/scr/presentation/screens/deposits/open_deposits_input_screen.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/dropdown_item.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OpenOnlineDepositsScreen extends StatefulWidget {
  const OpenOnlineDepositsScreen({Key? key}) : super(key: key);

  static const String routeName = 'OpenOnlineDepositsScreen';

  @override
  _OpenOnlineDepositsScreenState createState() =>
      _OpenOnlineDepositsScreenState();
}

class _OpenOnlineDepositsScreenState extends State<OpenOnlineDepositsScreen> {
  late OpenOnlineDepositsBloc _bloc;

  @override
  void initState() {
    super.initState();
    Logger.debug('-------------------- initState');
    _bloc = OpenOnlineDepositsBloc(
      OpenDepositsRepository(
        RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
      ),
    );
    _bloc.add(
      GetSavingDepositsProductEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: AppTranslate.i18n.beneficiaryTitleFindBankStr.localized,
      appBarType: AppBarType.NORMAL,
      child: BlocProvider<OpenOnlineDepositsBloc>(
        create: (context) => _bloc,
        child: BlocConsumer<OpenOnlineDepositsBloc, OpenOnlineDepositsState>(
          listener: (context, state) {
            if (state.depositsSavingProductState == DataState.error) {
              showDialogErrorForceGoBack(context, (state.errorMessage ?? ''),
                  () {
                popScreen(context);
              });
            }
          },
          builder: (context, state) {
            if (state.depositsSavingProductState == DataState.init ||
                state.depositsSavingProductState == DataState.preload) {
              return _shimmerLoading();
            } else if (state.depositsSavingProductState == DataState.data) {
              return Container(
                margin: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: kDecoration,
                      padding: const EdgeInsets.all(kDefaultPadding),
                      child: _buildTab(),
                    ),
                    const SizedBox(
                      height: kDefaultPadding,
                    ),
                    _contentDepositType()
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  _buildTab() {
    return BlocBuilder<OpenOnlineDepositsBloc, OpenOnlineDepositsState>(
      buildWhen: (pre, current) {
        return (pre.depositsSavingProductState !=
                current.depositsSavingProductState ||
            pre.currentDepositProduct != current.currentDepositProduct);
      },
      builder: (context, state) {
        if ((state.listDepositsProduct?.length ?? 0) < 1) {
          return const SizedBox();
        }

        late Widget title;

        if ((state.listDepositsProduct?.length ?? 0) < 2) {
          title = Text(
            state.listDepositsProduct![0].name ?? '',
            style: TextStyles.headerText.copyWith(
              color: const Color(0xff00B74F),
            ),
            textAlign: TextAlign.left,
          );
        } else {
          SavingDepositsProductResponse productResponse1 =
              state.listDepositsProduct![0];
          SavingDepositsProductResponse productResponse2 =
              state.listDepositsProduct![1];

          title = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: _buildTabTitle(
                  productResponse1.name ?? '',
                  productResponse1.mainGroupId ==
                      state.currentDepositProduct?.mainGroupId,
                  productResponse1,
                ),
              ),
              Expanded(
                flex: 1,
                child: _buildTabTitle(
                  productResponse2.name ?? '',
                  productResponse2.mainGroupId ==
                      state.currentDepositProduct?.mainGroupId,
                  productResponse2,
                ),
              ),
            ],
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
            const SizedBox(
              height: kDefaultPadding,
            ),
            ListView.separated(
                padding: const EdgeInsets.all(0),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Text(
                    '•  ${state.currentDepositProduct?.desc?[index]?.text ?? ''}',
                    style: TextStyles.itemText,
                  );
                },
                separatorBuilder: (context, state) {
                  return const SizedBox(
                    height: 5,
                  );
                },
                itemCount: state.currentDepositProduct?.desc?.length ?? 0),
          ],
        );
      },
    );
  }

  Widget _buildTabTitle(String title, bool isSelected,
      SavingDepositsProductResponse productResponse) {
    return Touchable(
      onTap: () {
        _bloc.add(ChangeOnlineDepositsProduct(productResponse));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            title,
            style: isSelected
                ? TextStyles.headerText.tabSelctedColor
                : TextStyles.headerText.tabUnSelctedColor,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 3,
          ),
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            width: double.infinity,
            height: 2,
            color: isSelected ? kColorTabIndicator : Colors.transparent,
          ),
        ],
      ),
    );
  }

  _contentDepositType() {
    return BlocBuilder<OpenOnlineDepositsBloc, OpenOnlineDepositsState>(
      builder: (context, state) {
        return Container(
          decoration: kDecoration,
          padding: const EdgeInsets.all(kDefaultPadding),
          child: Column(
            children: [
              DropDownItem(
                // isRequire: true,
                title: AppTranslate.i18n.depositTypeStr.localized,
                value: state.currentDepositType?.name ?? '',
                textStyle: TextStyles.itemText
                    .copyWith(
                      color: const Color(0xff343434),
                    )
                    .medium,
                onTap: () {
                  showBottomSheetDepositType(state);
                },
              ),
              if ((state.currentDepositType?.productArray?.length ?? 0) > 1)
                const SizedBox(
                  height: 24,
                ),
              if ((state.currentDepositType?.productArray?.length ?? 0) > 1)
                DropDownItem(
                  // isRequire: true,
                  title: AppTranslate.i18n.receiveInterestMethodStr.localized,
                  value: state.savingReceiveMethod?.interrestPreiod ?? '',
                  textStyle: TextStyles.itemText
                      .copyWith(
                        color: const Color(0xff343434),
                      )
                      .medium,
                  onTap: () {
                    showBottomSheetSavingMethod(state);
                  },
                ),
              const SizedBox(
                height: 24,
              ),
              TextButton(
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: () {
                  Logger.debug('------- Meo hieu');
                  Navigator.of(context).pushNamed(
                    OpenDepositsInputScreen.routeName,
                    arguments: context,
                  );
                },
                child: Text(
                  AppTranslate.i18n.openNowStr.localized,
                  style: TextStyles.headerText.copyWith(
                    color: const Color(0xff00B74F),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _shimmerLoading() {
    return Column(
      children: [
        Container(
          height: 80,
          decoration: kDecoration,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: AppShimmer(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: kDefaultPadding,
                      right: kDefaultPadding,
                      top: 8,
                      bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.shimmerItemColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: double.infinity,
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ),
        Container(
          padding: const EdgeInsets.all(16),
          height: 150,
          decoration: kDecoration,
          margin: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: AppShimmer(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: kDefaultPadding,
                      right: kDefaultPadding,
                      top: 8,
                      bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.shimmerItemColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: double.infinity,
                  height: 20,
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: kDefaultPadding,
                      right: kDefaultPadding,
                      top: 8,
                      bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.shimmerItemColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: 150,
                  height: 25,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void showBottomSheetDepositType(OpenOnlineDepositsState state) {
    if (state.currentDepositProduct?.groupArray == null ||
        state.currentDepositProduct!.groupArray!.isEmpty) {
      return;
    }

    Logger.debug('showBottomSheetDepositType');

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(14),
            ),
          ),
          child: ListView.separated(
              itemBuilder: (context, index) {
                DepositsType? depositsType =
                    state.currentDepositProduct?.groupArray?[index];
                if (depositsType == null) {
                  return const SizedBox();
                }
                return Touchable(
                  onTap: () {
                    _bloc.add(
                      ChangeOnlineDepositsType(depositsType),
                    );
                    setTimeout(() {
                      Navigator.of(context).pop();
                    }, 100);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding, vertical: 10),
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Row(
                      children: [
                        Opacity(
                          opacity: depositsType.groupId ==
                                  state.currentDepositType?.groupId
                              ? 1
                              : 0,
                          child: ImageHelper.loadFromAsset(AssetHelper.icoCheck,
                              width: 24, height: 24),
                        ),
                        const SizedBox(width: kDefaultPadding),
                        Text(depositsType.name ?? '',
                            style: TextStyles.normalText.normalColor)
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: state.currentDepositProduct!.groupArray!.length),
          padding: EdgeInsets.only(bottom: SizeConfig.bottomSafeAreaPadding),
        );
      },
    );
  }

  void showBottomSheetSavingMethod(OpenOnlineDepositsState state) {
    if (state.currentDepositType?.productArray == null ||
        state.currentDepositType!.productArray!.length <= 1) {
      return;
    }

    Logger.debug(
        'showBottomSheetSavingMethod groupId ${state.savingReceiveMethod?.groupId}');

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(14),
            ),
          ),
          child: ListView.separated(
              itemBuilder: (context, index) {
                SavingReceiveMethod? savingReceiveMethod =
                    state.currentDepositType?.productArray?[index];
                if (savingReceiveMethod == null) {
                  return const SizedBox();
                }
                return Touchable(
                  onTap: () {
                    _bloc.add(
                      ChangeSavingReceiveMethod(savingReceiveMethod),
                    );
                    setTimeout(() {
                      Navigator.of(context).pop();
                    }, 100);
                  },
                  child: Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.symmetric(
                        horizontal: kDefaultPadding, vertical: 10),
                    padding: const EdgeInsets.only(
                      left: 8,
                    ),
                    child: Row(
                      children: [
                        Opacity(
                          opacity: savingReceiveMethod.productId ==
                                  state.savingReceiveMethod?.productId
                              ? 1
                              : 0,
                          child: ImageHelper.loadFromAsset(AssetHelper.icoCheck,
                              width: 24, height: 24),
                        ),
                        const SizedBox(width: kDefaultPadding),
                        Text(savingReceiveMethod.interrestPreiod ?? '',
                            style: TextStyles.normalText.normalColor)
                      ],
                      crossAxisAlignment: CrossAxisAlignment.center,
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
              itemCount: state.currentDepositType!.productArray!.length),
          padding: EdgeInsets.only(bottom: SizeConfig.bottomSafeAreaPadding),
        );
      },
    );
  }
}
