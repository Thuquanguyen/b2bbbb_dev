import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/card/card_list/card_list_bloc.dart';
import 'package:b2b/scr/bloc/card/card_list/card_list_event.dart';
import 'package:b2b/scr/bloc/card/card_list/card_list_state.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/card/card_display.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/presentation/screens/cards/card_info/card_info_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/card_list/card_menu_screen.dart';
import 'package:b2b/scr/presentation/screens/cards/card_list/item_card_parent.dart';
import 'package:b2b/scr/presentation/widgets/app_shimmer.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardListScreen extends StatefulWidget {
  const CardListScreen({Key? key}) : super(key: key);
  static const String routeName = 'CardListScreen';

  @override
  State<StatefulWidget> createState() => CardListScreenState();
}

class CardListScreenState extends State<CardListScreen> {
  late CardListBloc _bloc;

  @override
  void initState() {
    super.initState();

    _bloc = context.read<CardListBloc>();
    _bloc.add(CardListGetDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: AppTranslate.i18n.cardStr.localized.toUpperCase(),
      appBarType: AppBarType.NORMAL,
      actions: [
        IconButton(
          padding: const EdgeInsets.only(right: 15),
          icon: const Icon(Icons.menu, size: 24),
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onPressed: () {
            Navigator.of(context).pushNamed(CardMenuScreen.routeName);
          },
        )
      ],
      child: Container(
        margin: const EdgeInsets.all(kDefaultPadding),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: BlocConsumer<CardListBloc, CardListState>(
            listener: (context, state) {
              if (state.cardListDataState == DataState.error) {
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
              Logger.debug('rebuild $state');
              return Container(
                child: _content(state),
                color: Colors.white,
              );
            },
          ),
        ),
      ),
    );
  }

  _itemCardShimmer() {
    return AppShimmer(
      Container(
        margin: const EdgeInsets.only(
            left: kDefaultPadding, right: kDefaultPadding, top: 8, bottom: 8),
        alignment: Alignment.center,
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                    width: 40.toScreenSize,
                    height: 30.toScreenSize,
                    alignment: Alignment.centerRight,
                    decoration: kDecoration),
                const SizedBox(
                  width: kDefaultPadding,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 10,
                        decoration: kDecoration,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        width: 150,
                        height: 10,
                        decoration: kDecoration,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _content(CardListState state) {
    if (state.cardListDataState == DataState.error) {
      return const SizedBox();
    }

    if (state.cardListDataState == DataState.preload) {
      return Column(
        children: (['1', '1', '1', '1', '1', '1'])
            .map(
              (e) => Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  _itemCardShimmer(),
                ],
              ),
            )
            .toList(),
      );
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCardList(AppTranslate.i18n.cardDebitStr.localized,
              state.debitCards ?? [], CardType.DEBIT),
          if ((state.debitCards ?? []).isNotEmpty)
            const SizedBox(
              height: kDefaultPadding,
            ),
          _buildCardList(AppTranslate.i18n.cardCreditStr.localized,
              state.creditCards ?? [], CardType.CREDIT),
        ],
      ),
    );
  }

  _buildCardList(String title, List<CardDisplay> datas, CardType cardType) {
    if (datas.isEmpty) {
      return const SizedBox();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: const Color(0xffE6F6ED),
          padding:
              const EdgeInsets.only(top: 6.0, bottom: 6, left: kDefaultPadding),
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyles.itemText.semibold.inputTextColor,
          ),
        ),
        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: datas.length,
          itemBuilder: (_, i) {
            return ItemCardParent(
              cardData: datas[i],
              onArrowIconClick: () {
                if (cardType == CardType.DEBIT) {
                  _bloc.add(
                    CardDebitChangeExpandStatusEvent(
                        cardData: datas[i], index: i),
                  );
                } else if (cardType == CardType.CREDIT) {
                  _bloc.add(
                    CardCreditChangeExpandStatusEvent(
                        cardData: datas[i], index: i),
                  );
                }
              },
              onPress: (card) {
                pushNamed(context, CardInfoScreen.routeName,
                    arguments: CardInfoScreenArguments(cardModel: card));
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const Divider();
          },
        ),
      ],
    );
  }
}
