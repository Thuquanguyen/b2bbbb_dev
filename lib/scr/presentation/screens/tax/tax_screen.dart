import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/core/extensions/palette.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/data/model/tax/tax_online.dart';
import 'package:b2b/scr/data/model/transaction_model.dart';
import 'package:b2b/scr/presentation/screens/tax/tax_list_screen.dart';
import 'package:b2b/scr/presentation/screens/transaction_management/tax_approve/tax_approve_detail_screen.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/utilities/message_handler.dart';
import 'package:flutter/material.dart';
import '../../../../commons.dart';
import '../../../../utilities/image_helper/asset_helper.dart';
import '../../../../utilities/logger.dart';
import '../../../bloc/tax/tax_bloc.dart';
import '../../../core/extensions/textstyles.dart';
import '../../../data/model/base_item_model.dart';
import '../../widgets/action_item.dart';
import '../../widgets/dialog_widget.dart';
import 'create_tax_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/***
 * Chưa ĐK thông tin trên TCT => API trả về thất bại
 * Đã ĐK thông tin với TCT, chưa ĐK với VPB => API success, tran_info null
 * Đã đk với VPB check các case trong tran_info
 */

class TaxScreen extends StatefulWidget {
  const TaxScreen({Key? key}) : super(key: key);

  static String routeName = '/TaxScreen';

  static String eventCancelSuccess = 'eventCancelSuccess';

  @override
  _TaxScreenState createState() => _TaxScreenState();
}

class _TaxScreenState extends State<TaxScreen> {
  late RegisterTaxBloc _bloc;
  final List<BaseItemModel> _listItem = [];

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<RegisterTaxBloc>(context)..add(ClearTaxState());

    MessageHandler().addListener(TaxScreen.eventCancelSuccess, showMessage);

    initData();
  }

  void showMessage() {
    showToast(AppTranslate.i18n.canceledStr.localized);
  }

  @override
  void dispose() {
    super.dispose();

    MessageHandler().removeListener(TaxScreen.eventCancelSuccess, showMessage);
  }

  void initData() {
    _listItem.clear();
    _listItem.addAll(
      [
        BaseItemModel(
          title: AppTranslate.i18n.registerTaxStr.localized,
          icon: AssetHelper.icTax,
          onTap: (context) {
            _bloc.add(TaxEventGetTaxOnline());
          },
        ),
        BaseItemModel(
          title: AppTranslate.i18n.taxMenuManageStr.localized,
          icon: AssetHelper.icTaxManage,
          onTap: (context) {
            pushNamed(
              context,
              TaxListScreen.routeName,
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: AppTranslate.i18n.registerTaxStr.localized,
      isShowKeyboardDoneButton: true,
      child: RefreshIndicator(
        backgroundColor: Colors.white,
        onRefresh: onRefresh,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: _buildContent(),
        ),
      ),
      appBarType: AppBarType.MEDIUM,
      showBackButton: true,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
    );
  }

  Future<void> onRefresh() async {}

  _buildContent() {
    return BlocConsumer<RegisterTaxBloc, TaxState>(
      listener: (context, state) {
        if (state.getTaxOnlineDataState == DataState.preload) {
          showLoading();
        } else if (state.getTaxOnlineDataState == DataState.data) {
          hideLoading();
          handleGetTaxOnlineSuccess(state);
        } else {
          hideLoading();
          if (state.getTaxOnlineDataState == DataState.error) {
            hideLoading();
            showDialogErrorForceGoBack(
              context,
              (state.errMsg ?? ''),
              () {
              },
              barrierDismissible: false,
            );
          }
        }
      },
      listenWhen: (pre, cur) {
        return pre.getTaxOnlineDataState != cur.getTaxOnlineDataState;
      },
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                child: Column(
                  children: _listItem.map(
                    (itemModel) {
                      int index = _listItem.indexOf(itemModel);
                      return ActionItem(
                        itemModel: itemModel,
                        isLastIndex: index == (_listItem.length - 1),
                        callback: () {
                          itemModel.onTap?.call(context);
                        },
                      );
                    },
                  ).toList(),
                ),
                decoration: kDecoration,
              ),
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        );
      },
    );
  }

  void handleGetTaxOnlineSuccess(TaxState state) {
    TaxOnline? taxOnline = state.taxOnline;

    Logger.debug('handleGetTaxOnlineSuccess');

    if (taxOnline == null) {
      return;
    }

    if (taxOnline.transInfo == null) {
      pushNamed(context, CreateTaxScreen.routeName,
          arguments: CreateTaxArgs(context, taxBloc: _bloc));
      return;
    }

    String? message;
    String? button1;
    Function()? button1Click;
    if (taxOnline.transInfo?.status == TransactionStatus.WAI.name) {
      button1 = AppTranslate.i18n.seeDetailStr.localized;
      message = AppTranslate.i18n.noticeTaxPendingStr.localized
          .interpolate({'s': taxOnline.taxCode});
      button1Click = () async {
        popScreen(context);
        await Navigator.of(context).pushNamed(
          TaxDetailScreen.routeName,
          arguments: TaxDetailScreenArgument(
            transCode: taxOnline.transInfo?.transCode,
            fallbackRoute: TaxScreen.routeName,
          ),
        );
      };
    } else if (taxOnline.transInfo?.status == TransactionStatus.REJ.name) {
      button1 = AppTranslate.i18n.reRegisterStr.localized;
      message = AppTranslate.i18n.noticeTaxRejectStr.localized.interpolate(
          {'id': taxOnline.taxCode, 'reason': taxOnline.transInfo?.reason});
      button1Click = () {
        popScreen(context);
        pushNamed(
          context,
          CreateTaxScreen.routeName,
          arguments:
              CreateTaxArgs(context, taxOnline: taxOnline, taxBloc: _bloc),
        );
      };
    } else if (taxOnline.transInfo?.status == TransactionStatus.SUC.name) {
      button1 = AppTranslate.i18n.dialogButtonCloseStr.localized;
      message = AppTranslate.i18n.noticeTaxApprovedStr.localized.interpolate({
        'id': taxOnline.taxCode,
      });
      button1Click = () {
        popScreen(context);
      };
    }

    showDialogCustom(
      context,
      AssetHelper.icDialogNotice,
      AppTranslate.i18n.stsNotificationStr.localized,
      message ?? '',
      barrierDismissible: false,
      showCloseButton: false,
      button1: renderDialogTextButton(
        context: context,
        title: button1 ?? '',
        dismiss: false,
        onTap: button1Click,
        textStyle: TextStyles.headerText.copyWith(color: AppColors.greenText),
      ),
      button2: taxOnline.transInfo?.status != TransactionStatus.SUC.name
          ? renderDialogTextButton(
              dismiss: false,
              context: context,
              title: AppTranslate.i18n.dialogButtonCloseStr.localized,
              onTap: () {
                popScreen(context);
              },
            )
          : null,
    );
  }
}
