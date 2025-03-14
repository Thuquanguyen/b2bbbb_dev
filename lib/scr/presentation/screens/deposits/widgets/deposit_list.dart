import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/saving_account_model.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/presentation/screens/deposits/widgets/deposit_list_item.dart';
import 'package:b2b/scr/presentation/widgets/dashline_painter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

class DepositList extends StatelessWidget {
  const DepositList({
    Key? key,
    this.moreInfo = false,
    this.isFiltering = false,
    this.isLoading = false,
    this.list,
    this.onTap,
  }) : super(key: key);

  final bool moreInfo;
  final bool isFiltering;
  final bool isLoading;
  final List<TransactionGrouped<SavingAccountModel>>? list;
  final Function(SavingAccountModel)? onTap;

  @override
  Widget build(BuildContext context) {
    if (isLoading == false && list == null || list?.isEmpty == true) {
      String msg = '';
      if (isFiltering) {
        msg = AppTranslate.i18n.dfNoDataWithFilterStr.localized;
      } else {
        msg = AppTranslate.i18n.dfNoDataStr.localized;
      }

      return Container(
        padding: const EdgeInsets.only(left: 50, right: 50),
        alignment: Alignment.center,
        child: Text(
          msg,
          style: TextStyles.headerText.semibold,
          textAlign: TextAlign.center,
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: kDefaultPadding),
      itemCount: list?.length,
      itemBuilder: (context, i) {
        TransactionGrouped<SavingAccountModel>? tg = list?[i];
        if (tg == null) return const SizedBox();
        return StickyHeader(
          header: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                begin: Alignment.center,
                end: Alignment.bottomCenter,
                stops: [0, 0.9],
                colors: <Color>[
                  Color.fromRGBO(255, 255, 255, 1),
                  Color.fromRGBO(255, 255, 255, 0),
                ],
              ).createShader(bounds);
            },
            child: Container(
              padding: const EdgeInsets.only(
                top: 4,
                left: kDefaultPadding,
                right: kDefaultPadding,
                bottom: kDefaultPadding,
              ),
              color: AppColors.screenBg,
              child: Row(
                children: [
                  Expanded(
                    child: CustomPaint(
                      painter: DashedLinePainter(
                        dashSpace: 3,
                        dashWidth: 5,
                        color: const Color.fromRGBO(196, 196, 196, 1),
                      ),
                      size: const Size(double.infinity, 1),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    tg.date,
                    style: TextStyles.smallText.copyWith(
                      color: AppColors.darkInk400,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
          content: Column(
            children: [
              ...tg.list
                  .map((a) => Padding(
                        padding: const EdgeInsets.only(
                          left: kDefaultPadding,
                          right: kDefaultPadding,
                          bottom: kDefaultPadding,
                        ),
                        child: DepositListItem(
                          account: a,
                          onTap: onTap != null
                              ? () {
                                  onTap!(a);
                                }
                              : null,
                        ),
                      ))
                  .toList(),
            ],
          ),
        );
      },
    );
  }
}
