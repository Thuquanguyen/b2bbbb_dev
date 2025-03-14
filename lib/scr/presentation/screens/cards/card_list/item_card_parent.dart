import 'package:b2b/scr/data/model/card/card_display.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/presentation/screens/cards/card_list/item_card_view.dart';
import 'package:b2b/scr/presentation/widgets/expand_selection.dart';
import 'package:flutter/material.dart';

class ItemCardParent extends StatelessWidget {
  final CardDisplay? cardData;
  final Function()? onArrowIconClick;
  final Function(CardModel? cardModel)? onPress;

  const ItemCardParent(
      {Key? key, this.cardData, this.onArrowIconClick, this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemCardView(
          canExpand: (cardData?.cardModel?.cardSub != null &&
              cardData!.cardModel!.cardSub!.isNotEmpty),
          onPress: (){
            onPress?.call(cardData!.cardModel);
          },
          onArrowIconClick: onArrowIconClick,
          isExpand: cardData?.isExpand,
          cardModel: cardData?.cardModel,
          cardName: cardData?.cardModel?.clientName,
          cardDes:
              '${cardData?.cardModel?.cardType} | ${cardData?.cardModel?.getLastCardNumber()}',
        ),
        ExpandedSection(
          expand: cardData?.isExpand ?? false,
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: cardData?.cardModel?.cardSub?.length ?? 0,
            itemBuilder: (_, index) {
              CardModel? cardSub = cardData?.cardModel?.cardSub?[index];
              return ItemCardView(
                cardModel: cardSub,
                isChildItem: true,
                cardName: cardSub?.clientName,
                onPress: (){
                  onPress?.call(cardSub);
                },
                cardDes: '${cardSub?.cardType}|${cardSub?.getLastCardNumber()}',
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
        ),
      ],
    );
  }
}
