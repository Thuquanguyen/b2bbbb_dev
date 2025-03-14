import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/data/model/transaction/transaction_filter_request.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/transaction_filter/filter_widget.dart';
import 'package:b2b/scr/presentation/widgets/vp_tiny_scroll.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/local_storage/localStorageHelper.dart';
import 'package:flutter/material.dart';

class TransCatList {
  List<Widget> cats;

  TransCatList({required this.cats});
}

class TransactionFilterWidget extends StatefulWidget {
  const TransactionFilterWidget({
    Key? key,
    this.catList,
    this.serviceList,
    this.hideServiceList = false,
    this.hideWarning = false,
    required this.onFilterChange,
  }) : super(key: key);

  final List<TransactionFilterCategory>? catList;
  final List<NameModel>? serviceList;
  final bool hideServiceList;
  final bool hideWarning;
  final Function(TransactionFilterRequest) onFilterChange;

  @override
  State<StatefulWidget> createState() => TransactionFilterWidgetState();
}

class TransactionFilterWidgetState extends State<TransactionFilterWidget> with TickerProviderStateMixin {
  late AnimationController filterCollapsibleController;
  late Animation<double> filterCollapsibleSize;
  String selectedCat = '';
  int selectedCatIndex = 0;
  GlobalKey<FilterState> filterKey = GlobalKey();
  static const String HIDE_FILTER_WARNING_KEY = 'HIDE_FILTER_WARNING_KEY';
  bool shouldShowFilterWarning = false;
  bool userHideFilterWarning = false;
  List<TransCatList> catListPages = [];
  PageController catPageController = PageController();
  ScrollController catPageScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    filterCollapsibleController = AnimationController(vsync: this, duration: const Duration(milliseconds: 250));
    filterCollapsibleSize = CurvedAnimation(
      parent: filterCollapsibleController,
      curve: Curves.easeInOutCubic,
    );
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getShowFilterWarning();
    });
  }

  void getShowFilterWarning() async {
    userHideFilterWarning = (await LocalStorageHelper.getBool(HIDE_FILTER_WARNING_KEY)) ?? false;
    // setState(() {});
    checkShowFilterWarning(false);
  }

  void checkShowFilterWarning(bool ignoreUserChoice) async {
    if (ignoreUserChoice) {
      shouldShowFilterWarning = true;
    } else {
      shouldShowFilterWarning = userHideFilterWarning == false;
    }

    if (widget.hideWarning) {
      shouldShowFilterWarning = false;
    }

    setState(() {});
  }

  void showFilter() {
    checkShowFilterWarning(true);
    filterCollapsibleController.forward(from: 0);
  }

  void hideFilter() {
    checkShowFilterWarning(false);
    filterCollapsibleController.reverse(from: 1);
  }

  void changeCategory(String key) {
    selectedCat = key;
    if (widget.catList?.isNotEmpty == true) {
      int i = 0;
      for (final c in widget.catList!) {
        if (c.key == selectedCat) {
          selectedCatIndex = i;
          break;
        }
        i++;
      }
    }
    // checkShowFilterWarning(false);
    filterKey.currentState?.initFilterData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // catListPages = buildCatList(widget.catList ?? []);
    return Column(
      children: [
        if (widget.catList != null)
          Stack(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.only(bottom: 26),
                  height: 95,
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.catList!.length,
                    controller: catPageScrollController,
                    itemBuilder: (context, index) {
                      return buildCatItem(cat: widget.catList![index]);
                    },
                  ),
                ),
              ),
              if (widget.catList!.length > 4)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: VPTinyScrollBar(
                      controller: catPageScrollController,
                    ),
                  ),
                ),
            ],
          ),
        if (shouldShowFilterWarning)
          Padding(
            padding: const EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              bottom: kDefaultPadding,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: kDefaultPadding,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: const [kBoxShadowContainer],
              ),
              child: Row(
                children: [
                  ImageHelper.loadFromAsset(
                    AssetHelper.icoInfoGreen,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(
                    width: kDefaultPadding,
                  ),
                  Expanded(
                    child: Text(
                      AppTranslate.i18n.prFilterNoticeStr.localized,
                      style: TextStyles.captionText.regular,
                    ),
                  ),
                  const SizedBox(
                    width: kDefaultPadding,
                  ),
                  if (!userHideFilterWarning)
                    Touchable(
                      onTap: () async {
                        await LocalStorageHelper.setBool(HIDE_FILTER_WARNING_KEY, true);
                        shouldShowFilterWarning = false;
                        userHideFilterWarning = true;
                        setState(() {});
                      },
                      child: ImageHelper.loadFromAsset(
                        AssetHelper.icoX,
                        width: 24,
                        height: 24,
                      ),
                    ),
                ],
              ),
            ),
          ),
        FadeTransition(
          opacity: filterCollapsibleSize,
          child: SizeTransition(
            sizeFactor: filterCollapsibleSize,
            child: Filter(
              key: filterKey,
              onFilterChange: widget.onFilterChange,
              serviceList: widget.serviceList,
              hideServiceList: widget.hideServiceList || TransactionManage.shouldHideServiceList(selectedCat),
              currency: selectedCat == TransactionManage.fxCat.key ? '' : 'VND',
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCatItem({
    required TransactionFilterCategory cat,
  }) {
    return Touchable(
      onTap: () {
        if (cat.onTap != null) {
          cat.onTap!(cat);
        }
      },
      child: SizedBox(
        width: 90,
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: selectedCat == cat.key ? AppColors.gPrimaryColor : Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  kBoxShadowCommon,
                ],
              ),
              child: Center(
                child: ImageHelper.loadFromAsset(
                  selectedCat == cat.key ? cat.iconSelected : cat.icon,
                  width: 24,
                  height: 24,
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              cat.nameUnlocalized.localized,
              style: TextStyles.smallText.setColor(
                selectedCat == cat.key ? AppColors.gPrimaryColor : AppColors.darkInk400,
              ),
            ),
          ],
        ),
      ),
    );
  }

// List<TransCatList> buildCatList(List<TransactionFilterCategory> list) {
//   List<TransCatList> res = [];
//   int t = 0;
//
//   for (TransactionFilterCategory c in list) {
//     if (t == 0) res.add(TransCatList(cats: []));
//     res.last.cats.add(buildCatItem(cat: c));
//     if (t == 3) {
//       t = 0;
//     } else {
//       t += 1;
//     }
//   }
//
//   return res;
// }

// List<Widget> buildCatList(List<TransactionFilterCategory> list) {
//   List<Widget> res = [];
//
//   for (TransactionFilterCategory c in list) {
//     res.add(buildCatItem(cat: c));
//   }
//
//   return res;
// }
}
