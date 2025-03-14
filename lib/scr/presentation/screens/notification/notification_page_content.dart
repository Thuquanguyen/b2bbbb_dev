import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/notification/notification_bloc.dart';
import 'package:b2b/scr/bloc/notification/notification_event.dart';
import 'package:b2b/scr/bloc/notification/notification_state.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/data/model/bloc_model.dart';
import 'package:b2b/scr/data/model/notification/notification_model.dart';
import 'package:b2b/scr/data/model/notification/notification_transfer_content_model.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/screens/main/main_screen.dart';
import 'package:b2b/scr/presentation/screens/notification/notification_enum.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/payroll_approve/payroll_approve_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/saving_approve/saving_transaction_approve_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/transaction_approve/transaction_approve_screen.dart';
import 'package:b2b/scr/presentation/widgets/configurable_expansion_tile_custom.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/item_noti_transaction.dart';
import 'package:b2b/scr/presentation/widgets/item_noti_transfer.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sticky_headers/sticky_headers.dart';
import '../../../bloc/data_state.dart';
import '../../widgets/app_shimmer.dart';
import '../auth/account_manager.dart';
import 'notification_screen.dart';

class NotificationPageContent extends StatefulWidget {
  final NotificationPageType pageType;
  final String userName;
  final String tokenIdentity;
  final Function? reload;
  final Function? retry;
  final int? indexTab;

  const NotificationPageContent({
    Key? key,
    required this.pageType,
    required this.userName,
    required this.tokenIdentity,
    this.reload,
    this.retry,
    this.indexTab = 1,
  }) : super(key: key);

  @override
  State<NotificationPageContent> createState() => _NotificationPageContentState();
}

class _NotificationPageContentState extends State<NotificationPageContent>
    with AutomaticKeepAliveClientMixin<NotificationPageContent> {
  @override
  bool get wantKeepAlive => true;

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  late NotificationBloc _notificationBloc;

  @override
  void initState() {
    super.initState();
    _notificationBloc = BlocProvider.of<NotificationBloc>(context);
    getData();
  }

  void getData() {
    String hashSignature = AccountManager().currentUsername + '_' + SECURE_PASSWORD;
    hashSignature = encryptSha256(hashSignature);
    String userName = AccountManager().currentUsername;
    String tokenIdentity = SessionManager().userData?.tokenIdentityNotification ?? '';

    if (userName.isNotNullAndEmpty) {
      if (widget.pageType == NotificationPageType.BALANCE_CHANGE) {
        _notificationBloc.add(GetListHistoryBalanceAlertEvent(
            userName: userName, hashSignature: hashSignature, tokenIdentity: tokenIdentity));
      } else {
        _notificationBloc.add(GetListPaymentPendingAlertEvent(
            userName: userName, hashSignature: hashSignature, tokenIdentity: tokenIdentity));
      }
    }
  }

  Widget _itemShimmer() {
    return AppShimmer(
      Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(245, 247, 250, 1),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Container(
                height: 10,
                width: 50,
                decoration: kDecorationShimmer,
              ),
            ),
            const SizedBox(
              width: 12,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 10,
                    width: 50,
                    decoration: kDecorationShimmer,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    height: 10,
                    width: 150,
                    decoration: kDecorationShimmer,
                  ),
                ],
              ),
            )
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: kDefaultPadding, horizontal: 12),
        margin: const EdgeInsets.symmetric(vertical: kTopPadding, horizontal: kDefaultPadding),
        decoration: BoxDecoration(
          color: AppColors.shimmerBackGroundColor,
          borderRadius: const BorderRadius.all(Radius.circular(14)),
          boxShadow: const [kBoxShadowCommon],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if ((state.notificationState != DataState.data && widget.pageType == NotificationPageType.BALANCE_CHANGE) ||
            (state.notificationPendingState != DataState.data &&
                widget.pageType == NotificationPageType.PENDING_TRANSACTION)) {
          return ListView.builder(
            padding: const EdgeInsets.only(top: 0),
            itemBuilder: (BuildContext context, int index) => _itemShimmer(),
            itemCount: 5,
          );
        }

        List<BlocModel> dataList = widget.pageType == NotificationPageType.BALANCE_CHANGE
            ? (state.listNotificationBloc ?? [])
            : (state.listNotificationPending ?? []);

        List<NotificationItemDisplay> dataListTransformed = [];
        for (var element in dataList) {
          dataListTransformed = [...dataListTransformed, ...element.transformed];
        }

        return RefreshIndicator(
          key: _refreshIndicatorKey,
          backgroundColor: Colors.white,
          onRefresh: () async {
            getData();
            // if (widget.reload != null) {
            //   await widget.reload!();
            // }
          },
          child: ListView.builder(
            padding: const EdgeInsets.only(top: 0),
            itemBuilder: (BuildContext context, int index) => _notificationItem(dataListTransformed[index]),
            itemCount: dataListTransformed.length,
          ),
        );
      },
    );
  }

  Widget _notificationItem(NotificationItemDisplay model) {
    if (model.type == NotificationItemDisplayType.ITEM) {
      if (widget.indexTab == 1) {
        NotificationModel notification = model.data as NotificationModel;
        return ItemNotificationTransaction(
          notificationModel: notification,
          onTap: () {
            String id = notification.id ?? '';
            String module = getModuleAlert[ModuleAlert.BALANCE] ?? '';
            String hash = encryptSha256('${widget.userName}$id$module$SECURE_PASSWORD');
            final balance = TransactionManage()
                .formatCurrency(double.parse(notification.balance ?? '0'), notification.ccy ?? 'VND');
            showDialogCustom(
                context,
                AssetHelper.icoAuthError,
                AppTranslate.i18n.dialogTitleNotificationStr.localized,
                AppTranslate.i18n.messageContentNotiStr.localized.interpolate({
                  'account': '${notification.account}',
                  'balance': '${(balance.startsWith('-') ? balance : '+$balance')} ${notification.ccy}',
                  'title': AppTranslate.i18n.balanceChangeStr.localized,
                  'content': '${notification.desc}',
                  'color': balance.contains('-') ? 'red' : 'green',
                }),
                showCloseButton: false,
                button1: renderDialogTextButton(
                    context: context,
                    textStyle: TextStyles.headerText.unitColor,
                    title: AppTranslate.i18n.closeFilterStr.localized.toUpperCase(),
                    onTap: () {}));
            if (!(notification.hasRead ?? false)) {
              _notificationBloc.add(
                HasReadNotificationEvent(
                    userName: widget.userName,
                    id: id,
                    hashSignature: hash,
                    tokenIdentity: widget.tokenIdentity,
                    module: module,
                    notificationModel: notification),
              );
            }
          },
        );
      } else {
        NotificationTransferContentModel notification = model.data as NotificationTransferContentModel;
        return ItemNotificationTransfer(
          notificationModel: notification,
          onTap: () {
            String id = notification.id ?? '';
            String module = getModuleAlert[ModuleAlert.TRANSFER] ?? '';
            String hash = encryptSha256('${widget.userName}$id$module$SECURE_PASSWORD');
            final balance = TransactionManage()
                .formatCurrency((notification.amount ?? 0).toDouble(), notification.debitCcy ?? 'VND');
            showDialogCustom(
              context,
              AssetHelper.icoAuthError,
              AppTranslate.i18n.dialogTitleNotificationStr.localized,
              AppTranslate.i18n.messageContentNotiStr.localized.interpolate({
                'account': '${notification.debitAccount}',
                'title': AppTranslate.i18n.tasTdAmountStr.localized,
                'balance': '-$balance ${notification.debitCcy}',
                'content': '${notification.memo}',
                'color': 'red',
              }),
              showCloseButton: false,
              button1: renderDialogTextButton(
                  context: context,
                  textStyle: TextStyles.headerText.unitColor,
                  title: AppTranslate.i18n.closeFilterStr.localized.toUpperCase(),
                  onTap: () {}),
              button2: SessionManager().isLoggedIn() == false
                  ? null
                  : renderDialogTextButton(
                      context: context,
                      textStyle: TextStyles.headerText.unitColor,
                      title: AppTranslate.i18n.seeMoreStr.localized.toUpperCase(),
                      onTap: () {
                        // notification
                        handleItemNotiTransferClick(notification);
                      },
                    ),
            );
            if (!(notification.hasRead ?? false)) {
              _notificationBloc.add(
                HasReadPaymentPendingEvent(
                    userName: widget.userName,
                    id: id,
                    hashSignature: hash,
                    tokenIdentity: widget.tokenIdentity,
                    module: module,
                    notificationModel: notification),
              );
            }
          },
        );
      }
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 8,
          horizontal: kDefaultPadding,
        ),
        child: Row(
          children: [
            Expanded(
              child: ImageHelper.loadFromAsset(AssetHelper.imgLine, fit: BoxFit.cover),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              _notificationDate(model.data),
              style: const TextStyle(
                color: Color(0xff343434),
                fontSize: 13,
              ),
            ),
          ],
        ),
      );
    }
  }

  String _notificationDate(String date) {
    try {
      DateFormat notificationDateFormat = DateFormat('dd/MM/yyyy');
      DateTime tempDate = DateFormat("dd MMM - yyyy").parse(date);
      String dateFormated = notificationDateFormat.format(tempDate);
      return dateFormated;
    } catch (e) {
      return date;
    }
  }

  void handleItemNotiTransferClick(NotificationTransferContentModel notification) {
    String routesName = '';
    dynamic arg;

    if (notification.functionType == NotiTransferType.PAYROLL.getValue()) {
      routesName = PayrollApproveScreen.routeName;
      arg = PayrollApproveScreenArguments(
        transCode: notification.transCode ?? '',
        fileCode: '',
        actionType: null,
        fallbackRoute: MainScreen.routeName,
      );
    } else {
      if (notification.functionType == NotiTransferType.SAVING.getValue()) {
        routesName = SavingTransactionApproveScreen.routeName;
        arg = SavingTransactionApproveScreenArguments(
          actionType: null,
          transactionCode: notification.transCode ?? '',
          fallbackRoute: MainScreen.routeName,
        );
      } else if (notification.functionType == NotiTransferType.TRANSFER.getValue()) {
        routesName = TransactionApproveScreen.routeName;
        arg = TransactionApproveScreenArguments(
          transactionsCode: [notification.transCode ?? ''],
          filterRequest: null,
          actionType: null,
          fallbackRoute: MainScreen.routeName,
        );
      }
    }
    if (routesName.isEmpty) {
      return;
    }

    pushNamed(context, routesName, arguments: arg, async: true);
  }
}
