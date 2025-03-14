import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/datetime_ext.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/as_statement_online_response_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:flutter/material.dart';

class CardHistoryItem extends StatelessWidget {
  const CardHistoryItem({
    Key? key,
    required this.index,
    required this.data,
    required this.cardNumber,
  }) : super(key: key);

  final int index;
  final StmtData data;
  final String? cardNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: (index % 2 == 0) ? Colors.white : const Color(0xFFF3F6FD),
      ),
      padding: const EdgeInsets.all(
        kDefaultPadding,
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: (index % 2 == 0) ? const Color(0xffF5F7FA) : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(22)),
            ),
            padding: const EdgeInsets.all(4),
            height: 44,
            width: 44,
            child: Center(
              child: Text(
                data.commitTime.convertServerTime?.to24H ?? '',
                style: TextStyles.itemText,
              ),
            ),
          ),
          const SizedBox(
            width: kDefaultPadding,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        cardNumber ?? '',
                        style: TextStyles.itemText,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        (data.amount > 0 ? '+' : '') +
                            TransactionManage().tryFormatCurrency(
                              data.amount,
                              data.txnCcy,
                              showCurrency: true,
                            ),
                        style: TextStyles.itemText.medium.copyWith(
                          color: data.amount > 0 ? AppColors.gPrimaryColor : AppColors.gRedTextColor,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        data.txnNarrative ?? '',
                        style: TextStyles.itemText.medium.copyWith(
                          color: AppColors.darkInk500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
