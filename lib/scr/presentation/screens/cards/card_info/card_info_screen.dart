import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/presentation/screens/cards/card_info/card_functions_widget.dart';
import 'package:b2b/scr/presentation/screens/cards/card_info/card_info_widget.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:flutter/cupertino.dart';

class CardInfoScreenArguments {
  final CardModel? cardModel;

  CardInfoScreenArguments({required this.cardModel});
}

class CardInfoScreen extends StatefulWidget {
  const CardInfoScreen({Key? key}) : super(key: key);
  static const String routeName = 'CardInfoScreen';

  @override
  State<StatefulWidget> createState() => CardInfoScreenState();
}

class CardInfoScreenState extends State<CardInfoScreen> {
  CardModel? cardModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      cardModel = (getArguments(context) as CardInfoScreenArguments).cardModel;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cardModel == null) {
      return Container();
    }

    return AppBarContainer(
      title: AppTranslate.i18n.ciScreenTitleStr.localized,
      appBarType: AppBarType.NORMAL,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CardInfoWidget(
              cardModel: cardModel!,
            ),
            // CardInfoWidget(
            //   cardType: CardType.CREDIT,
            //   cardModel: CardModel(),
            // ),
            CardFunctionWidget(
              cardModel: cardModel!,
            ),
          ],
        ),
      ),
    );
  }
}
