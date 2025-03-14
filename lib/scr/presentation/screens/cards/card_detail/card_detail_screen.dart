import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/card/card_model.dart';
import 'package:b2b/scr/presentation/screens/cards/card_detail/card_contract_detail_widget.dart';
import 'package:b2b/scr/presentation/screens/cards/card_detail/card_detail_widget.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';

class CardDetailScreenArguments {
  final CardModel cardModel;

  CardDetailScreenArguments({required this.cardModel});
}

class CardDetailScreen extends StatefulWidget {
  const CardDetailScreen({Key? key}) : super(key: key);
  static const String routeName = 'CardDetailScreen';

  @override
  State<StatefulWidget> createState() => CardDetailScreenState();
}

class CardDetailScreenState extends State<CardDetailScreen> {
  CardModel? cardModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      cardModel = getArguments<CardDetailScreenArguments>(context)?.cardModel;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    if (cardModel == null) {
      return Container();
    }

    return AppBarContainer(
      title: AppTranslate.i18n.cdScreenTitleStr.localized,
      appBarType: AppBarType.NORMAL,
      child: SingleChildScrollView(
        child: Column(
          children: [
            CardDetailWidget(
              cardModel: cardModel!,
            ),
            CardContractDetailWidget(
              cardModel: cardModel!,
            ),
          ],
        ),
      ),
    );
  }
}
