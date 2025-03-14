// Created by Cuonghd2 at 05/08/2021
// Email: cuonghd2@vpbank.com.vn
// Copyright (c) 2020. All rights reserved.

import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/rollover_term_saving/rollover_term_saving_bloc.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/presentation/screens/saving/interest_rate_manager.dart';
import 'package:b2b/scr/presentation/screens/saving/item_popop_choose_term.dart';
import 'package:b2b/scr/presentation/screens/saving/item_term_saving.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:shimmer/shimmer.dart';

class RolloverTermSavingScreen extends StatefulWidget {
  static const routeName = 'saving_screen';

  const RolloverTermSavingScreen({Key? key}) : super(key: key);

  @override
  _RolloverTermSavingScreenState createState() => _RolloverTermSavingScreenState();
}

class _RolloverTermSavingScreenState extends State<RolloverTermSavingScreen> {
  late RolloverTermSavingBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<RolloverTermSavingBloc>(context);
  }

  Widget itemGroupName(InterestRateDisplayModel data) {
    return Container(
      height: 27.toScreenSize,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Color(0xffE6F6ED),
        border: Border.symmetric(vertical: BorderSide(width: 0.5, color: Colors.black12)),
      ),
      child: Text(
        data.groupName ?? '',
        style: TextStyles.itemText.regular.copyWith(color: const Color(0xff666667)),
      ),
    );
  }

  Widget itemGroupNameHolder() {
    return Container(
      width: double.infinity,
      height: 27.toScreenSize,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: const Color(0xffE6F6ED).withOpacity(0.2),
        border: const Border.symmetric(vertical: BorderSide(width: 0.5, color: Colors.black12)),
      ),
    );
  }

  Widget itemDesHolder(double width, double width2) {
    return Container(
      width: double.infinity,
      height: 45.toScreenSize,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.shimmerBackGroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: width,
            decoration: BoxDecoration(
              color: AppColors.shimmerItemColor,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
          ),
          Container(
            width: width2,
            decoration: BoxDecoration(
              color: AppColors.shimmerItemColor,
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget itemDes() {
    return Container(
      height: 45.toScreenSize,
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border.symmetric(vertical: BorderSide(width: 0.5, color: Colors.black12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppTranslate.i18n.savingTitlePeriodStr.localized,
            style: TextStyles.itemText.regular.copyWith(color: AppColors.shimmerItemColor, fontSize: 14),
          ),
          Text(
            AppTranslate.i18n.savingTitleInterestRateStr.localized,
            style: TextStyles.itemText.regular.copyWith(color: AppColors.shimmerItemColor, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget itemTypeHolder() {
    return Container(
      height: getInScreenSize(36, min: 36),
      padding: const EdgeInsets.only(left: kDefaultPadding, right: kDefaultPadding, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.shimmerBackGroundColor,
        border: const Border.symmetric(vertical: BorderSide(width: 0.5, color: Colors.black12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 150,
                height: 8,
                color: AppColors.shimmerItemColor,
              ),
              Container(
                width: 50,
                height: 8,
                color: AppColors.shimmerItemColor,
              ),
            ],
          ),
          Container(
            width: 15,
            height: 15,
            color: AppColors.shimmerItemColor,
          )
        ],
      ),
    );
  }

  Widget itemData(InterestRateDisplayModel data, int index) {
    final item = data.itemData;
    if (item == null) {
      return const SizedBox();
    }
    return ItemTermSaving(
      period: item.getTermName(),
      rate: item.intRate?.toString() ?? '',
      index: index,
    );
  }

  Widget buildItem(InterestRateDisplayModel data, int index) {
    switch (data.type) {
      case InterestRateDisplayType.GROUP_NAME:
        return itemGroupName(data);
      case InterestRateDisplayType.DES:
        return itemDes();
      case InterestRateDisplayType.DATA:
        return itemData(data, index);
      default:
        return const SizedBox();
    }
  }

  Widget textFeet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text("• "),
        const SizedBox(
          width: 5,
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Color.fromRGBO(102, 102, 103, 1.0),
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      appBarType: AppBarType.MEDIUM,
      title: AppTranslate.i18n.firstLoginTitleInterestRateStr.localized,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(14),
                ),
              ),
              height: double.infinity,
              width: double.infinity,
              padding: const EdgeInsets.only(bottom: 14),
              margin: const EdgeInsets.only(left: kDefaultPadding, right: kDefaultPadding, top: 30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: kDefaultPadding),
                    decoration: const BoxDecoration(
                      border: Border.symmetric(
                        vertical: BorderSide(
                          width: 0.5,
                          color: Colors.black12,
                        ),
                      ),
                    ),
                    child: BlocBuilder<RolloverTermSavingBloc, RolloverTermSavingState>(
                      buildWhen: (previous, current) =>
                          previous.rolloverTermSavingDataState != current.rolloverTermSavingDataState ||
                          previous.termSaving != current.termSaving ||
                          previous.termSavingPeriodically != current.termSavingPeriodically,
                      builder: (context, state) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (state.rolloverTermSavingDataState == DataState.init ||
                                state.rolloverTermSavingDataState == DataState.preload)
                              AppShimmer(
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: kDefaultPadding,
                                  ),
                                  child: itemTypeHolder(),
                                ),
                              ),
                            if (state.rolloverTermSavingDataState == DataState.data)
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding,
                                ),
                                child: Touchable(
                                  onTap: showBottomSheet,
                                  child: Container(
                                    color: Colors.transparent,
                                    child: ItemPopupChooseTerm(
                                      title: AppTranslate.i18n.savingTitleTermDepositOnlineStr.localized,
                                      desc: _bloc.state.termSaving.termSavingToText,
                                      onShowModalPopup: showBottomSheet,
                                    ),
                                  ),
                                ),
                              ),
                            if (state.rolloverTermSavingDataState == DataState.data &&
                                state.termSaving == TermSaving.periodically)
                              Padding(
                                padding: const EdgeInsets.only(
                                  left: kDefaultPadding,
                                  right: kDefaultPadding,
                                  top: kDefaultPadding,
                                ),
                                child: Touchable(
                                  onTap: showPeriodicallyTypeBottomSheet,
                                  child: Container(
                                    color: Colors.transparent,
                                    child: ItemPopupChooseTerm(
                                      title: AppTranslate.i18n.savingTitleMethodOfReceivingInterestStr.localized,
                                      desc: _bloc.state.termSavingPeriodically?.termSavingPeriodicallyToText ?? '',
                                      onShowModalPopup: showPeriodicallyTypeBottomSheet,
                                    ),
                                  ),
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10,
                                horizontal: kDefaultPadding,
                              ),
                              child: Builder(
                                builder: (context) {
                                  final dashCount = (SizeConfig.screenWidth / 4).floor();
                                  return Row(
                                    children: List.generate(
                                      dashCount,
                                      (index) => Expanded(
                                        child: Container(
                                          color: index % 2 != 0
                                              ? Colors.transparent
                                              : const Color.fromRGBO(186, 205, 223, 1.0),
                                          height: 1,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: BlocConsumer<RolloverTermSavingBloc, RolloverTermSavingState>(
                      listenWhen: (previous, current) =>
                          previous.rolloverTermSavingDataState != current.rolloverTermSavingDataState ||
                          previous.termSaving != current.termSaving,
                      listener: (context, state) {
                        if (state.rolloverTermSavingDataState == DataState.init ||
                            state.rolloverTermSavingDataState == DataState.preload) {
                          Logger.debug("Show loading");
                          // showLoading();
                        } else if (state.rolloverTermSavingDataState == DataState.error) {
                          // hideLoading();
                          showDialogErrorForceGoBack(
                            context,
                            state.errorMessage!,
                            () {
                              popScreen(context);
                            },
                          );
                        } else if (state.rolloverTermSavingDataState == DataState.data) {
                          // hideLoading();
                        }
                      },
                      builder: (context, state) {
                        if (state.rolloverTermSavingDataState == DataState.init ||
                            state.rolloverTermSavingDataState == DataState.preload) {
                          return AppShimmer(
                            Container(
                              margin: const EdgeInsets.all(
                                kDefaultPadding,
                              ),
                              child: Column(
                                children: [
                                  itemDesHolder(150, 16),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  itemDesHolder(120, 16),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  itemDesHolder(180, 16),
                                ],
                              ),
                            ),
                          );
                        } else if (state.rolloverTermSavingDataState == DataState.data) {
                          List<InterestRateDisplayModel>? listData = state.listDisplayData;
                          if (listData == null || listData.isEmpty) {
                            return Container(
                              alignment: Alignment.center,
                              child: Text(AppTranslate.i18n.titleErrorNoDataStr.localized),
                            );
                          }
                          return ListView.builder(
                            padding: const EdgeInsets.all(0),
                            shrinkWrap: true,
                            itemCount: listData.length,
                            itemBuilder: (context, index) {
                              return buildItem(listData[index], index);
                            },
                          );
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin:
                const EdgeInsets.only(left: kDefaultPadding, right: kDefaultPadding, top: kDefaultPadding, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textFeet(AppTranslate.i18n.savingTitleTextFeet1Str.localized),
                textFeet(AppTranslate.i18n.savingTitleTextFeet3Str.localized),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showPeriodicallyTypeBottomSheet() {
    Logger.debug('showPeriodicallyTypeBottomSheet');
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: SizeConfig.screenHeight / 2,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(kDefaultPadding),
                topRight: Radius.circular(kDefaultPadding),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kTopPadding),
            child: ListView.separated(
                itemBuilder: (context, index) {
                  TermSavingPeriodically type = TermSavingPeriodically.values[index];
                  return TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _bloc.add(
                        ChooseTermSavingPeriodicallyEvent(
                          type,
                        ),
                      );
                    },
                    child: Container(
                      height: 45.toScreenSize,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            type.termSavingPeriodicallyToText,
                            style: TextStyles.itemText.semibold.copyWith(color: const Color(0xff666667)),
                          ),
                          if (type == _bloc.state.termSavingPeriodically)
                            ImageHelper.loadFromAsset(
                              AssetHelper.icoCheck,
                              width: 18.toScreenSize,
                              height: 18.toScreenSize,
                            ),
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: kBorderSide,
                      ),
                    ),
                  );
                },
                itemCount: TermSavingPeriodically.values.length),
          ),
        );
      },
    );
  }

  void showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: SizeConfig.screenHeight / 2,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(kDefaultPadding),
                topRight: Radius.circular(kDefaultPadding),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kTopPadding),
            child: ListView.separated(
                itemBuilder: (context, index) {
                  TermSaving type = TermSaving.values[index];
                  return TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _bloc.add(
                        ChooseTermSavingEvent(
                          type,
                        ),
                      );
                    },
                    child: Container(
                      height: 45.toScreenSize,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            type.termSavingToText,
                            style: TextStyles.itemText.semibold.copyWith(color: const Color(0xff666667)),
                          ),
                          if (type == _bloc.state.termSaving)
                            ImageHelper.loadFromAsset(
                              AssetHelper.icoCheck,
                              width: 18.toScreenSize,
                              height: 18.toScreenSize,
                            )
                        ],
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: kBorderSide,
                      ),
                    ),
                  );
                },
                itemCount: TermSaving.values.length),
          ),
        );
      },
    );
  }
}
