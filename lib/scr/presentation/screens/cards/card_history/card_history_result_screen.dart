import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/extensions.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/as_statement_online_response_model.dart';
import 'package:b2b/scr/presentation/screens/cards/card_history/card_history_item.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers.dart';

class CardHistoryResultScreenArguments {
  CardHistoryResultScreenArguments({
    required this.data,
    required this.cardNumber,
  });

  final StatementOnlineData data;
  final String? cardNumber;
}

class CardHistoryResultScreen extends StatefulWidget {
  const CardHistoryResultScreen({Key? key}) : super(key: key);
  static const String routeName = 'CardHistoryResultScreen';

  @override
  State<StatefulWidget> createState() => CardHistoryResultScreenState();
}

class CardHistoryResultScreenState extends State<CardHistoryResultScreen> {
  StatementOnlineData? data;
  String? cardNumber;

  @override
  initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      CardHistoryResultScreenArguments? args = getArguments<CardHistoryResultScreenArguments>(context);
      data = args?.data;
      cardNumber = args?.cardNumber;
      setState(() {});
    });
  }

  Widget _buildStatementGroup(StmtDataGroup group, int idx) {
    return StickyHeader(
      header: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        color: const Color.fromRGBO(230, 246, 237, 1),
        child: Row(
          children: [
            Expanded(
              child: Text(
                group.date,
                style: TextStyles.normalText,
              ),
            ),
          ],
        ),
      ),
      content: Container(
        color: Colors.white,
        child: Column(
          children: [
            ...group.list.mapIndexed((e, i) => _buildStatementItem(e, i)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatementItem(StmtData data, int idx) {
    return CardHistoryItem(
      index: idx,
      data: data,
      cardNumber: cardNumber,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<StmtDataGroup>? dataList = data?.groupedStmtData;
    return AppBarContainer(
      title: AppTranslate.i18n.chScreenTitleStr.localized,
      appBarType: AppBarType.NORMAL,
      child: Padding(
        padding: const EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
          bottom: kDefaultPadding,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [kBoxShadowContainer],
            borderRadius: BorderRadius.circular(14),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: (dataList?.length ?? 0) + 1,
              itemBuilder: (context, i) {
                if (i == (dataList?.length ?? 0)) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                        child: Text(
                          AppTranslate.i18n.tisEndOfListStr.localized,
                          style: kStyleASTitle.copyWith(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                  );
                }
                StmtDataGroup? sg = dataList?[i];
                if (sg == null) return const SizedBox();
                return _buildStatementGroup(sg, i);
              },
            ),
          ),
        ),
      ),
    );
  }
}
