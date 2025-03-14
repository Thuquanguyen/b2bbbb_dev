import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/data/model/notification/notification_transfer_content_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/screens/notification/notification_screen.dart';
import 'package:b2b/scr/presentation/widgets/state_builder.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:flutter/material.dart';

class ItemNotificationTransfer extends StatelessWidget {
  final Color? subTitleColor;
  final NotificationTransferContentModel? notificationModel;
  final Function? onTap;

  final StateHandler _stateHandler = StateHandler(NotificationScreen.routeName);

  ItemNotificationTransfer(
      {Key? key, this.subTitleColor, this.notificationModel, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final balance = TransactionManage().formatCurrency(
        (notificationModel?.amount ?? 0).toDouble(),
        notificationModel?.debitCcy ?? 'VND');
    return Touchable(
      onTap: () {
        if (onTap != null) {
          onTap!();
          _stateHandler.refresh();
        }
      },
      child: StateBuilder(
          builder: () {
            final isRead = notificationModel?.hasRead ?? false;
            return Container(
              padding: EdgeInsets.only(
                  top: kDefaultPadding,
                  bottom: kDefaultPadding,
                  right: 12,
                  left: isRead ? 12 : 4),
              margin: const EdgeInsets.symmetric(
                  vertical: kTopPadding, horizontal: kDefaultPadding),
              decoration: BoxDecoration(
                  color: isRead ? Colors.white : const Color(0xffEFF7FF),
                  borderRadius: const BorderRadius.all(Radius.circular(14)),
                  boxShadow: const [kBoxShadowCommon]),
              child: Row(
                children: [
                  if (!isRead)
                    Container(
                      margin: const EdgeInsets.only(right: 5),
                      height: 4,
                      width: 4,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xff00B74F),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Text(
                        notificationModel?.hoursInFormat() ?? '',
                        style:
                            TextStyles.itemText.setColor(AppColors.slateGrey),
                      ),
                    ),
                  Container(
                    height: 40,
                    width: 40,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xffEDF1F6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      notificationModel?.hoursInFormat() ?? '',
                      style: TextStyles.itemText.setColor(AppColors.slateGrey),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // _itemText(
                        //   title: AppTranslate.i18n.transactionNotiTitleStr
                        //       .localized
                        //       .interpolate(
                        //       {'value': notificationModel?.transCode ?? ''}),
                        //   subTitleColor: const Color.fromRGBO(255, 103, 99, 1),
                        //   isRead: isRead,
                        // ),
                        Text(
                          AppTranslate.i18n.transactionNotiTitleStr.localized
                              .interpolate({
                            'value': notificationModel?.transCode ?? ''
                          }),
                          style: TextStyles.itemText.medium.copyWith(
                            color: const Color(0xff22313F),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          notificationModel?.getMemo() ?? '',
                          style: TextStyles.smallText,
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
          routeName: NotificationScreen.routeName),
    );
  }

  Widget _itemText(
      {required String title,
      String? subTile,
      Color? subTitleColor,
      bool? isRead = false}) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.itemText.medium,
        ),
        if (subTile != null)
          Expanded(
            child: Text(
              subTile,
              maxLines: 2,
              style: TextStyles.itemText
                  .copyWith(color: subTitleColor)
                  .setFontWeight(FontWeight.w500),
            ),
          ),
      ],
    );
  }
}
