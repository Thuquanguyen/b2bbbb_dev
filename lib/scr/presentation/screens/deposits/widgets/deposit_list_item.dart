import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/extensions/extensions.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/saving_account_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class DepositListItem extends StatelessWidget {
  const DepositListItem({
    Key? key,
    this.onTap,
    this.moreInfo = false,
    required this.account,
  }) : super(key: key);

  final Function? onTap;
  final bool moreInfo;
  final SavingAccountModel account;

  @override
  Widget build(BuildContext context) {
    return Touchable(
      onTap: () {
        if (onTap != null) onTap!();
      },
      child: Container(
        padding: const EdgeInsets.all(kDefaultPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: kDefaultPadding,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (moreInfo)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TK: 123456',
                          style: TextStyles.headerItemText.regular
                              .setColor(AppColors.darkInk500),
                        ),
                        Text(
                          'TẤT TOÁN',
                          style: TextStyles.headerItemText.regular
                              .setColor(AppColors.darkInk500),
                        ),
                      ],
                    )
                  else
                    Html(
                      style: {
                        'body': Style(
                            margin: EdgeInsets.zero, padding: EdgeInsets.zero),
                        'p': Style(
                          margin: EdgeInsets.zero,
                          fontSize: const FontSize(14),
                          fontWeight: FontWeight.w500,
                          lineHeight: const LineHeight(1.4),
                        ),
                        'span': Style(color: AppColors.gPrimaryColor),
                      },
                      data:
                          AppTranslate.i18n.diAmountStr.localized.interpolate({
                        'id': account.accountNo,
                        'amount':
                            "${TransactionManage().formatCurrency(account.balance ?? 0, account.acountCcy ?? '')} ${account.acountCcy}",
                      }),
                    ),
                  if (moreInfo)
                    const SizedBox(
                      height: 4,
                    ),
                  if (moreInfo)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Số tiền',
                          style: TextStyles.headerItemText.regular
                              .setColor(AppColors.darkInk500),
                        ),
                        Text(
                          '6 900 000 VND',
                          style: TextStyles.headerItemText.regular
                              .setColor(AppColors.darkInk500),
                        ),
                      ],
                    ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    AppTranslate.i18n.diInterestStr.localized.interpolate({
                      'r': account.rate,
                      'p': account.termDisplay?.localization(defaultValue: '')
                    }),
                    style: TextStyles.smallText,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              const SizedBox(
                width: kDefaultPadding,
              ),
            if (onTap != null)
              ImageHelper.loadFromAsset(AssetHelper.icoChevronForward),
          ],
        ),
      ),
    );
  }
}
