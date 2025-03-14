import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/card/statement_card/statement_card_bloc.dart';
import 'package:b2b/scr/bloc/card/statement_card/statement_card_event.dart';
import 'package:b2b/scr/bloc/card/statement_card/statement_card_state.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/api_service/api_provider.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/data/repository/card_repository.dart';
import 'package:b2b/scr/presentation/screens/cards/card_list/item_card_view.dart';
import 'package:b2b/scr/presentation/widgets/app_divider.dart';
import 'package:b2b/scr/presentation/widgets/text_dropdown.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/vp_file_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';

import '../card_manager.dart';

class CardStatementScreen extends StatefulWidget {
  const CardStatementScreen({Key? key}) : super(key: key);
  static const String routeName = 'CardStatementScreen';

  @override
  State<StatefulWidget> createState() => CardStatementScreenState();
}

class CardStatementScreenState extends State<CardStatementScreen> {
  final CancelToken _cancelToken = CancelToken();
  late StatementCardBloc _bloc;
  List<String>? monthList;

  @override
  void initState() {
    super.initState();
    _bloc = StatementCardBloc(
      CardRepository(
        RepositoryProvider.of<ApiProviderRepositoryImpl>(context),
      ),
    );

    _bloc.add(StatementGetCardContractListEvent());
    _bloc.add(StatementGetPeriodMonthEvent());

    WidgetsBinding.instance?.addPostFrameCallback(
      (timeStamp) {
        CardModel? cardModel = getArguments(context) as CardModel?;
        if (cardModel != null) {
          _bloc.add(
            StatementChangeSelectedCardEvent(cardModel),
          );
        }
      },
    );
  }

  _stateListener(BuildContext context, StatementCardState state) {
    if (state.statementPeriodDataState == DataState.error) {
      showDialogErrorForceGoBack(context, (state.errorMessage ?? ''), () {
        Navigator.of(context).pop();
      });
    }
    if (state.getExportFileDataState == DataState.preload) {
      showLoading();
    }
    if (state.getExportFileDataState == DataState.error) {
      hideLoading();
      showDialogErrorForceGoBack(context, (state.errorMessage ?? ''), () {});
    }

    if (state.getExportFileDataState == DataState.data) {
      hideLoading();
      if ((state.fileData?.data ?? '').isNotNullAndEmpty) {
        VpFileHelper().actionShareFile(state.fileData!.data!,
            state.fileData?.fileName ?? '', VPShareFile.PDF,isFullFileName: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StatementCardBloc>(
      create: (c) => _bloc,
      child: AppBarContainer(
        title: AppTranslate.i18n.csScreenTitleStr.localized,
        appBarType: AppBarType.NORMAL,
        child: BlocConsumer<StatementCardBloc, StatementCardState>(
          listenWhen: (p, c) {
            return p.statementPeriodDataState != c.statementPeriodDataState ||
                p.getExportFileDataState != c.getExportFileDataState;
          },
          listener: _stateListener,
          builder: (c, s) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(kDefaultPadding),
                  margin: const EdgeInsets.all(kDefaultPadding),
                  decoration: BoxDecoration(
                    boxShadow: const [kBoxShadow],
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                      Radius.circular(kDefaultPadding.toScreenSize),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppTranslate.i18n.chCardInfoStr.localized,
                        style: TextStyles.smallText,
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      _buildCardContent(s),
                      AppDivider(
                        margin: const EdgeInsets.symmetric(
                            vertical: kDefaultPadding),
                      ),
                      TextDropDown(
                        isShimmer: s.statementPeriodDataState != DataState.data,
                        value: s.selectedPeriod ?? '',
                        title: AppTranslate
                            .i18n.selectStatementPeriodStr.localized,
                        onPress: () {
                          CardManager().showStatementPeriodBottomModal(
                            context: context,
                            dataList: s.listStatementPeriod,
                            selectedValue: s.selectedPeriod,
                            title: AppTranslate
                                .i18n.selectStatementPeriodStr.localized,
                            callBack: (s) {
                              _bloc.add(
                                StatementChangePeriodEvent(s),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                      DefaultButton(
                        onPress: (s.selectedPeriod.isNullOrEmpty ||
                                s.selectedCardModel == null)
                            ? null
                            : () {
                                _bloc.add(StatementExportFileEvent());
                              },
                        margin: EdgeInsets.zero,
                        radius: 40,
                        text: AppTranslate.i18n.exportFileStr.localized
                            .toUpperCase(),
                        height: 44.toScreenSize,
                      ),
                      const SizedBox(
                        height: kDefaultPadding,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(),
                  flex: 1,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  _buildCardContent(StatementCardState state) {
    return ItemCardView(
      isShimmer: state.cardContractDataState == DataState.preload,
      onPress: () {
        CardManager().showCardListBottomModal(
            context: context,
            callBack: onChangeSelectedCard,
            cardList: state.cardContractListResponse?.card,
            selectedCard: state.selectedCardModel,
            title: AppTranslate.i18n.pickStatementCardStr.localized);
      },
      margin: EdgeInsets.zero,
      cardCompanyName: state.selectedCardModel?.comMainName,
      cardName: state.selectedCardModel?.clientName,
      cardDes:
          '${state.selectedCardModel?.cardType} | ${state.selectedCardModel?.getLastCardNumber()}',
      canExpand: true,
      cardModel: state.selectedCardModel,
      isNull: state.selectedCardModel == null,
    );
  }

  void onChangeSelectedCard(dynamic cardModel) {
    _bloc.add(StatementChangeSelectedCardEvent(cardModel));
  }
}
