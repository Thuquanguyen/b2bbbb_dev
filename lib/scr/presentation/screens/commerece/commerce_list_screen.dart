import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/commerece/lc/commerce_bloc.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/commerce/Neogotiating_model.dart';
import 'package:b2b/scr/data/model/commerce/commerce_filter_request.dart';
import 'package:b2b/scr/data/model/commerce/guaratee_model.dart';
import 'package:b2b/scr/data/model/commerce/lc_model.dart';
import 'package:b2b/scr/presentation/screens/commerece/commerce_detail_screen.dart';
import 'package:b2b/scr/presentation/screens/commerece/commerce_filter.dart';
import 'package:b2b/scr/presentation/screens/commerece/widget/item_commerce_discount.dart';
import 'package:b2b/scr/presentation/screens/commerece/widget/item_commerce_guarantee.dart';
import 'package:b2b/scr/presentation/screens/commerece/widget/item_commerce_lc.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/dashline_painter.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/touchable_ripple.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/api_service/api_provider.dart';
import '../../widgets/dialog_widget.dart';

enum CommerceType { LC, BAO_LANH, DISCOUNT }

class CommerceListScreen extends StatefulWidget {
  const CommerceListScreen({Key? key}) : super(key: key);
  static const String routeName = 'CommerceListScreen';

  @override
  _CommerceListScreenState createState() => _CommerceListScreenState();
}

class _CommerceListScreenState extends State<CommerceListScreen> {
  late CommerceBloc bloc;
  CommerceType? commerceType;

  @override
  void initState() {
    super.initState();
    bloc = BlocProvider.of<CommerceBloc>(context)..add(ClearCommerceEvent());

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      bloc.add(CommerceGetDataList(type: commerceType));
    });
  }

  @override
  Widget build(BuildContext context) {
    commerceType = getArguments(context) as CommerceType?;
    String title = "";
    switch (commerceType) {
      case CommerceType.LC:
        title = AppTranslate.i18n.titleLcStr.localized;
        break;
      case CommerceType.BAO_LANH:
        title = AppTranslate.i18n.titleBaoLanhStr.localized;
        break;
      case CommerceType.DISCOUNT:
        title = AppTranslate.i18n.discountStr.localized;
        break;
      default:
        break;
    }
    return AppBarContainer(
      title: title,
      isShowKeyboardDoneButton: true,
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: onRefresh,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          margin: const EdgeInsets.only(top: kDefaultPadding),
          child: _buildContent(),
        ),
      ),
      appBarType: AppBarType.HOME,
      showBackButton: true,
      actions: _buildAction(),
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    );
  }

  Future<void> onRefresh() async {}

  _buildContent() {
    if (commerceType == null) {
      return const SizedBox();
    }

    return BlocConsumer<CommerceBloc, CommerceState>(
      listenWhen: (pre, cur) {
        return pre.dataState != cur.dataState;
      },
      listener: (context, state) {
        if (state.dataState == DataState.preload) {
          showLoading();
        } else {
          hideLoading();
          if (state.dataState == DataState.error) {
            showDialogErrorForceGoBack(
              context,
              (state.errMessage ?? ''),
              () {},
              barrierDismissible: false,
            );
          }
        }
      },
      builder: (context, state) {
        List<dynamic>? dataList = state.dataList;
        return Column(
          children: [
            CommerceFilter(
              onFilterChange: (request) {
                bloc.add(
                  CommerceChangeFilterStatusEvent(),
                );
                request.commerceType = commerceType;
                bloc.add(
                  CommerceGetDataList(
                      type: commerceType, filterRequest: request),
                );
              },
              isFiltering: state.isFiltering,
              commerceType: commerceType,
            ),
            if (state.dataState == DataState.data &&
                (state.dataList?.length ?? 0) == 0)
              Expanded(
                child: Center(
                  child: Text(
                    AppTranslate.i18n.titleErrorNoDataStr.localized,
                    style: TextStyles.headerText,
                  ),
                ),
              ),
            if (state.dataState == DataState.data &&
                (state.dataList?.length ?? 0) > 0)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.only(
                      left: kDefaultPadding,
                      right: kDefaultPadding,
                      bottom: kDefaultPadding),
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemBuilder: (c, i) {
                        dynamic data = dataList?[i];
                        Widget child;

                        if (data is LcModel) {
                          child = ItemCommerceLc(
                            model: data,
                          );
                        } else if (data is GuaranteeModel) {
                          child = ItemCommerceGuarantee(
                            model: data,
                          );
                        } else if (data is NegotiatingModel) {
                          child = ItemCommerceDiscount(
                            model: data,
                          );
                        } else {
                          child = const SizedBox();
                        }
                        return TouchableRipple(
                          child: child,
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              CommerceDetailScreen.routeName,
                              arguments: CommerceDetailScreenArguments(
                                data: data,
                              ),
                            );
                          },
                        );
                      },
                      separatorBuilder: (c, i) {
                        return const SizedBox(
                          height: kDefaultPadding,
                        );
                      },
                      itemCount: dataList?.length ?? 0),
                ),
              ),
          ],
        );
      },
    );
  }

  _buildAction() {
    return [
      BlocBuilder<CommerceBloc, CommerceState>(
        builder: (context, state) {
          return Touchable(
            onTap: () {
              if (state.isFiltering != true) {
                MessageHandler().notify(
                  CommerceFilter.SET_FILTER,
                  data: state.filterRequest ?? CommerceFilterRequest(),
                );
              }
              bloc.add(CommerceChangeFilterStatusEvent());
            },
            child: Row(
              children: [
                Stack(
                  children: [
                    Positioned.fill(
                      child: CustomPaint(
                        painter: DashedBorderPainter(
                            color: AppColors.filterBtnBorder, dashSpace: 2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          ImageHelper.loadFromAsset(
                            AssetHelper.icFilter,
                            width: 18,
                            height: 18,
                          ),
                          if (state.isFiltering == true)
                            const SizedBox(
                              width: 4,
                            ),
                          if (state.isFiltering == true)
                            Text(
                              AppTranslate.i18n.closeFilterStr.localized,
                              // Equal height
                              style: TextStyles.headerItemText.regular,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  width: kDefaultPadding,
                ),
              ],
            ),
          );
        },
      ),
    ];
  }
}
