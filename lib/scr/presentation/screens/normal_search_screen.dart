import 'package:b2b/commons.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/search/search_bloc.dart';
import 'package:b2b/scr/bloc/search/search_event.dart';
import 'package:b2b/scr/bloc/search/search_state.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/argument/search_argument.dart';
import 'package:b2b/scr/data/model/search/normal_display_search_model.dart';
import 'package:b2b/scr/data/repository/search_repository.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/item_transaction_manager.dart';
import 'package:b2b/scr/presentation/widgets/search_item.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants.dart';

enum SearchType {
  BANK,
  BANK_PLACE,
  BEN_LIST,
  BRANCH_LIST,
}

class NormalSearchScreen extends StatefulWidget {
  static const String routeName = "NormalSearchScreen";

  final SearchArgument searchArgument;

  const NormalSearchScreen({Key? key, required this.searchArgument})
      : super(key: key);

  @override
  _NormalSearchScreenState createState() => _NormalSearchScreenState();
}

class _NormalSearchScreenState extends State<NormalSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  late SearchType searchType;
  late Function(Object) searchCallBack;
  String title = '';

  @override
  void initState() {
    super.initState();

    _init();
  }

  late SearchBloc searchBloc;

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      title: title,
      appBarType: AppBarType.SEMI_MEDIUM,
      child: Container(
        margin: const EdgeInsets.only(left: 16, right: 16),
        child: Column(
          children: [
            SearchItem(
              hintText: title,
              controller: _searchController,
              callBack: (searchText) {
                Logger.debug("search text ===> $searchText");
                searchBloc.add(SearchEvent(keyWord: searchText));
              },
            ),
            const SizedBox(
              height: kDefaultPadding,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 25, top: 0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      kDefaultPadding,
                    ),
                  ),
                ),
                child: _content(),
              ),
            ),
            SizedBox(
              height: 40.toScreenSize,
            ),
          ],
        ),
      ),
    );
  }

  void _init() {
    searchType = widget.searchArgument.searchType;
    searchCallBack = widget.searchArgument.searchCallBack;

    switch (searchType) {
      case SearchType.BANK:
        title = AppTranslate.i18n.pickBankStr.localized.toUpperCase();
        break;
      case SearchType.BANK_PLACE:
        title = AppTranslate.i18n.pickBankPlaceStr.localized.toUpperCase();
        break;
      case SearchType.BEN_LIST:
        title = AppTranslate.i18n.pickBeneficiaryStr.localized.toUpperCase();
        break;
      case SearchType.BRANCH_LIST:
        title = AppTranslate.i18n.findAtmTitleBranchStr.localized.toUpperCase();
        break;
      default:
        break;
    }
  }

  Widget _content() {
    return BlocProvider(
      create: (context) {
        searchBloc = SearchBloc(
          searchRepository: SearchRepository(
            RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
          ),
        );
        switch (searchType) {
          case SearchType.BEN_LIST:
            Logger.debug("add event $searchType");
            searchBloc.add(
              SearchBenListEvent(
                  transferTypeOfCode:
                      widget.searchArgument.transferTypeCode ?? -1),
            );
            break;
          case SearchType.BANK_PLACE:
            searchBloc.add(
              SearchLocationEvent(),
            );
            break;
          case SearchType.BANK:
            searchBloc.add(
              SearchBankListEvent(
                  transferTypeOfCode:
                      widget.searchArgument.transferTypeCode ?? -1),
            );
            break;
          case SearchType.BRANCH_LIST:
            searchBloc.add(
              SearchBranchListEvent(
                bankCode: widget.searchArgument.bankCode ?? '',
                cityCode: widget.searchArgument.cityCode ?? '',
              ),
            );
            break;
          default:
            break;
        }
        return searchBloc;
      },
      child: BlocConsumer<SearchBloc, SearchState>(
        listener: (context, state) {
          Logger.debug("Listener");
          if (state.state == DataState.error) {
            showDialogErrorForceGoBack(
              context,
              (state.errorMessage ?? ''),
              () {
                Navigator.of(context).pop();
              },
              barrierDismissible: false,
            );
          }
        },
        builder: (context, state) {
          return _buildContent(state);
        },
      ),
    );
  }

  Widget _buildContent(SearchState state) {
    if (state.state == DataState.init || state.state == DataState.preload) {
      return Container(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: kDefaultPadding),
        child: AppShimmer(
          Column(
            children: [
              itemTransactionShimmer(),
              const SizedBox(
                height: kDefaultPadding,
              ),
              itemTransactionShimmer(),
              const SizedBox(
                height: kDefaultPadding,
              ),
              itemTransactionShimmer(),
            ],
          ),
        ),
      );
    } else {
      List<NormalDisplaySearchModel> listData = state.listDataShow;
      return Stack(
        children: [
          ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: listData.length,
            itemBuilder: (context, index) {
              NormalDisplaySearchModel model = listData[index];
              return TextButton(
                style: TextButton.styleFrom(padding: const EdgeInsets.all(0)),
                onPressed: () {
                  Logger.debug("On search item click");
                  widget.searchArgument
                      .searchCallBack(state.listDataRoot[model.index]);
                  Navigator.of(context).pop();
                },
                child: ListTile(
                  leading: _buildLeadingWidget(model, index),
                  title: Text(
                    model.title ?? '',
                    style: TextStyles.normalText.semibold,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: model.subTitle != null
                      ? Text(
                          model.subTitle!,
                          style: TextStyles.smallText.slateGreyColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  trailing: _buildTrailingWidget(),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 1,
                margin: const EdgeInsets.only(
                    left: kDefaultPadding, right: kDefaultPadding),
                color: const Color.fromRGBO(237, 241, 246, 1),
              );
            },
          ),
          if (listData.isEmpty && state.state == DataState.data)
            Align(
              alignment: Alignment.center,
              child: _noItemView(),
            ),
        ],
      );
    }
  }

  Widget _buildTextIconWidget(String? text, int index) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          width: kLeadingIconSize,
          height: kLeadingIconSize,
          decoration: BoxDecoration(
            color: getColor(index + 1),
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Text(
            text ?? '',
            style: TextStyles.headerText.whiteColor.semibold,
          ),
        )
      ],
      mainAxisAlignment: MainAxisAlignment.center,
    );
  }

  Widget? _buildLeadingWidget(NormalDisplaySearchModel model, int index) {
    if (model.iconLeft == null) return null;
    if (searchType == SearchType.BEN_LIST) {
      return _buildTextIconWidget(model.iconLeft, index);
    } else if (searchType == SearchType.BANK) {
      return Container(
        width: kLeadingIconSize.toScreenSize,
        height: kLeadingIconSize.toScreenSize,
        clipBehavior: Clip.hardEdge,
        decoration: const BoxDecoration(),
        child: ImageHelper.loadFromAsset(
          model.iconLeft ?? '',
          defaultImage: AssetHelper.icoAlert,
          width: kLeadingIconSize.toScreenSize,
          height: kLeadingIconSize.toScreenSize,
          fit: BoxFit.cover,
        ),
      );
    }
    return ImageHelper.loadFromUrl(model.iconLeft!);
  }

  Widget? _buildTrailingWidget() {
    if (searchType == SearchType.BEN_LIST ||
        searchType == SearchType.BANK_PLACE) {
      return ImageHelper.loadFromAsset(
        AssetHelper.icoForward,
        width: 18.toScreenSize,
        height: 18.toScreenSize,
      );
    }
    return null;
  }

  _noItemView() {
    String text = "";
    switch (searchType) {
      case SearchType.BEN_LIST:
        text = AppTranslate.i18n.noBenListStr.localized;
        break;
      case SearchType.BANK_PLACE:
        text = AppTranslate.i18n.noCityListStr.localized;
        break;
      case SearchType.BRANCH_LIST:
        text = AppTranslate.i18n.noBranchListStr.localized;
        break;
      default:
        break;
    }
    return Container(
        child: Text(
      text,
      style: TextStyles.headerText,
    ));
  }
}
