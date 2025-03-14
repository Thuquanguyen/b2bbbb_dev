import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/bloc_model.dart';
import 'package:b2b/scr/data/model/notification/notification_promote_content.dart';
import 'package:b2b/scr/presentation/screens/bill/bill_screen.dart';
import 'package:b2b/scr/presentation/screens/deposits/open_online_deposits_screen.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/language/app_translate.dart';
import '../role_permission_manager.dart';
import '../transfer/transfer_screen.dart';
import 'package:intl/intl.dart';

class NotificationItemPromote extends StatelessWidget {
  final NotificationPromoteContent? data;

  const NotificationItemPromote({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data == null) return const SizedBox();
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        decoration: kDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data?.imageUrl.isNotNullAndEmpty == true)
              Touchable(
                onTap: () {
                  _handleLinkTap(data!.imgAction, context, data!);
                },
                child: ImageHelper.loadFromUrl(data!.imageUrl ?? '',
                    imageWidth: double.infinity, imageHeight: 200, fit: BoxFit.fill),
              ),
            if (data?.imageUrl.isNotNullAndEmpty == true)
              const SizedBox(
                height: kDefaultPadding,
              ),
            if (data?.content.isNotNullAndEmpty == true)
              Html(
                data: data!.content,
                onLinkTap: (url, c, d, e) {
                  _handleLinkTap(url, context, data!);
                },
                style: {
                  'body': Style(
                    margin: EdgeInsets.zero,
                    padding: const EdgeInsets.all(kDefaultPadding),
                    fontSize: const FontSize(13),
                    lineHeight: const LineHeight(1.4),
                  ),
                },
                customImageRenders: {
                  (a, b) {
                    return true;
                  }: (context, attributes, element) {
                    return Image.network(
                      attributes["src"] ?? "about:blank",
                      frameBuilder: (ctx, child, frame, _) {
                        if (frame == null) {
                          return Text(attributes["alt"] ?? "", style: context.style.generateTextStyle());
                        }
                        return child;
                      },
                    );
                  },
                },
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text(
                AppUtils.getDateTimeInFormat(
                  DateFormat('M/d/yyyy hh:mm:ss a').parse(data?.dateCreated ?? ''),
                  'dd MMMM yyyy HH:mm',
                ),
                style: TextStyles.captionText,
              ),
            ),
            if (data?.content.isNotNullAndEmpty == true)
              const SizedBox(
                height: kDefaultPadding,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLinkTap(String? url, BuildContext context, NotificationPromoteContent data) async {
    print('_handleLinkTap url $url');

    if (url.isNullOrEmpty) {
      return;
    }
    if (url!.startsWith('http') || url.startsWith('https')) {
      openBrowser(url);
      return;
    } else if (url == PromoteTye.transfer.getHref()) {
      if (RolePermissionManager().allowNotiTransfer()) {
        pushNamed(context, TransferScreen.routeName,
            arguments: TransferArgs(title: AppTranslate.i18n.homeTitleTransferMoneyStr.localized));
      } else {
        openBrowser(data.backLink ?? '');
      }
      return;
    } else if (url == PromoteTye.bill.getHref()) {
      if (RolePermissionManager().allowNotiSavingBill()) {
        pushNamed(context, BillScreen.routeName);
      } else {
        openBrowser(data.backLink ?? '');
      }
      return;
    } else if (url == PromoteTye.saving.getHref()) {
      if (RolePermissionManager().allowNotiSavingBill()) {
        pushNamed(context, OpenOnlineDepositsScreen.routeName);
      } else {
        openBrowser(data.backLink ?? '');
      }
      return;
    }
    openBrowser(data.backLink ?? '');
  }

  Future<void> openBrowser(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return;
    }
    launch(url);
    return;
  }
}
