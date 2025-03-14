import 'dart:io';

import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/data_state.dart';
import 'package:b2b/scr/bloc/transfer/transfer_bloc.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/session/session_manager.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/transfer/init_transfer_model.dart';
import 'package:b2b/scr/data/model/transfer/transfer_rate.dart';
import 'package:b2b/scr/presentation/screens/account_service/transaction_manage.dart';
import 'package:b2b/scr/presentation/widgets/dash_line.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/item_info.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/text_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

import '../../../bloc/transfer/rate/transfer_rate_bloc.dart';

enum AccountHistoryDetailType { PROCESS, SUCCEED }

class TransferResultScreen extends StatefulWidget {
  const TransferResultScreen({Key? key}) : super(key: key);
  static const String routeName = '/transfer_result_screen';

  @override
  _TransferResultScreenState createState() => _TransferResultScreenState();
}

class _TransferResultScreenState extends State<TransferResultScreen> {
  final ScreenshotController _screenshotHeaderController =
      ScreenshotController();
  final ScreenshotController _screenshotBodyController = ScreenshotController();
  final ScreenshotController _screenshotFeetController = ScreenshotController();

  late TransferBloc _transferBloc;
  late TransferRateBloc _rateBloc;

  @override
  void initState() {
    super.initState();
    _transferBloc = BlocProvider.of<TransferBloc>(context);
    _rateBloc = BlocProvider.of<TransferRateBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    _transferBloc.add(ClearTransferStateEvent());
  }

  _takeScreenshotAndShare() async {
    try {
      showLoading();
      final imageHeader = await _screenshotHeaderController.capture();
      final imageBody = await _screenshotBodyController.capture();
      final imageFeet = await _screenshotFeetController.capture();

      final image = await ImageHelper.join([imageHeader, imageBody, imageFeet]);
      if (image != null) {
        final report = await ImageHelper.renderReport(
            AppTranslate.i18n.transactionInformationStr.localized.toUpperCase(),
            image);
        if (report != null) {
          final directory = await getTemporaryDirectory();
          final imagePath =
              await File('${directory.path}/ahd_screenshot.png').create();
          await imagePath.writeAsBytes(report);
          Logger.debug(imagePath);
          await Share.shareFiles([imagePath.path],
              mimeTypes: ['image/png'], text: 'Shared from VPBank NEOBiz');
        }
      }
    } catch (e) {
      showDialogErrorForceGoBack(
          context, AppTranslate.i18n.havingAnErrorStr.localized, () {});
    }
    hideLoading();
  }

  String _getTimeFromNow() {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');
    final String formatted = formatter.format(DateTime.now());
    return formatted;
  }

  double itemMarginTop = 20;

  @override
  Widget build(BuildContext context) {
    String benInfo = '';
    TransferType? transferType = _transferBloc.state.transferType;

    InitTransferModel? transferModel = _transferBloc.state.initTransferModel;

    if (transferModel == null) {
      return SizedBox();
    }

    if (transferModel.benBankName != null) {
      benInfo = benInfo + '${transferModel.benBankName} \n';
    } else if (transferType == TransferType.TRANSINHOUSE) {
      benInfo = 'VPbank\n';
    } else if (transferType == TransferType.TRANS247_ACCOUNT) {
      benInfo = '${_transferBloc.state.transfer247.benBank?.shortName ?? ''}\n';
    }
    benInfo = benInfo + (transferModel.benName ?? '');

    String amount = CurrencyInputFormatter.formatCcyString(
        transferModel.amount?.toString() ?? '',
        ccy: transferModel.amountCcy,
        removeDecimal: true);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(kMediumPadding),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(AssetHelper.accountHistoryDetailBackground),
            fit: BoxFit.fill,
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(
                  top: SizeConfig.screenPaddingTop, bottom: kMediumPadding),
              child: Text(
                AppTranslate.i18n.transactionInformationStr.localized
                    .toUpperCase(),
                style: TextStyles.headerText.whiteColor,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding, horizontal: kDefaultPadding),
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AssetHelper.accountHistoryDetailDialog),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Screenshot(
                        controller: _screenshotHeaderController,
                        child: Column(
                          children: [
                            Image.asset(
                              AssetHelper.accountHistoryDetailLogo,
                              width: 130.toScreenSize,
                              height: 130.toScreenSize,
                            ),
                            Text(
                              transferModel.transcode ?? 'Transcode',
                              style: TextStyles.normalText,
                            ),
                            const SizedBox(
                              height: kMediumPadding,
                            ),
                            DashLine(
                              height: getInScreenSize(0.5),
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                      Screenshot(
                        controller: _screenshotBodyController,
                        child: Container(
                          color: Colors.white,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: buildItemInfo(
                                  paddingTop: itemMarginTop,
                                  title: AppTranslate
                                      .i18n
                                      .transferToAccountTitleSourceAccountStr
                                      .localized,
                                  value: _transferBloc
                                          .state.initTransferModel?.debitName ??
                                      SessionManager()
                                          .userData
                                          ?.customer
                                          ?.custName,
                                  description: _transferBloc
                                      .state.initTransferModel
                                      ?.getDebitAccountSubtitle(),
                                ),
                              ),
                              buildItemInfo(
                                paddingTop: itemMarginTop,
                                title: AppTranslate
                                    .i18n
                                    .transferToAccountTitleBeneficiaryInformationStr
                                    .localized,
                                value: benInfo,
                                description: _transferBloc
                                        .state.initTransferModel?.benAcc ??
                                    (_transferBloc.state.detailBeneficianAccount
                                            ?.accountNumber ??
                                        ''),
                              ),
                              buildItemInfo(
                                paddingTop: itemMarginTop,
                                title: AppTranslate
                                    .i18n.transferAmountStr.localized,
                                value:
                                    '$amount ${(transferModel.amountCcy ?? '')}',
                              ),
                              _transferRate(transferModel),
                              buildItemInfo(
                                  paddingTop: itemMarginTop,
                                  title: AppTranslate
                                      .i18n.numberOfMoneyStr.localized,
                                  value: _transferBloc
                                          .state.initTransferModel?.amountSpell
                                          ?.localization()
                                          .toTitleCase() ??
                                      ''),
                              buildItemInfo(
                                paddingTop: itemMarginTop,
                                title:
                                    AppTranslate.i18n.feeAmountStr.localized +
                                        AppTranslate
                                            .i18n.titleVatIncludeStr.localized,
                                value: ((transferModel.vatFeeAmount ?? 0) ==
                                        0.0)
                                    ? AppTranslate.i18n.freeAmountStr.localized
                                    : TransactionManage().formatCurrency(
                                            ((_transferBloc
                                                    .state
                                                    .initTransferModel
                                                    ?.vatFeeAmount ??
                                                0)),
                                            _transferBloc
                                                    .state
                                                    .initTransferModel
                                                    ?.chargeCcy ??
                                                'VND') +
                                        ' ' +
                                        (transferModel.chargeCcy ?? ''),
                              ),
                              if (transferType == TransferType.TRANSINTERBANK)
                                buildItemInfo(
                                    paddingTop: itemMarginTop,
                                    title:
                                        AppTranslate.i18n.feeTypeStr.localized,
                                    value: getFeeTypeString(
                                        transferModel.ourBenFee ?? 'OUR', '')),
                              if (transferType != TransferType.TRANSINHOUSE &&
                                  _transferBloc
                                          .state.initTransferModel?.ourBenFee !=
                                      'BEN')
                                buildItemInfo(
                                    paddingTop: itemMarginTop,
                                    title: AppTranslate
                                        .i18n.chargeAccountStr.localized,
                                    value: transferModel.ourBenFee == 'OUR'
                                        ? _transferBloc
                                            .state.initTransferModel?.chargeAcc
                                        : _transferBloc
                                            .state.initTransferModel?.benAcc),
                              buildItemInfo(
                                paddingTop: itemMarginTop,
                                title: AppTranslate.i18n.contentStr.localized,
                                value: _transferBloc
                                        .state.initTransferModel?.memo ??
                                    AppTranslate.i18n.contentStr.localized,
                                valueStyle: TextStyles.itemText,
                              ),
                              buildItemInfo(
                                paddingTop: itemMarginTop,
                                title: AppTranslate.i18n.timeStr.localized,
                                value: _getTimeFromNow(),
                              ),
                              const SizedBox(
                                height: kDefaultPadding,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Screenshot(
                        controller: _screenshotFeetController,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            DashLine(
                              height: getInScreenSize(0.5),
                              color: Colors.black.withOpacity(0.5),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: kDefaultPadding),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    AssetHelper.icoProcessing,
                                    width: getInScreenSize(16),
                                    height: getInScreenSize(16),
                                  ),
                                  SizedBox(
                                    width: getInScreenSize(8),
                                  ),
                                  Container(
                                    height: getInScreenSize(20),
                                    alignment: Alignment.center,
                                    child: Text(
                                      AppTranslate.i18n.waitApproveStr.localized
                                          .toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            DashLine(
                              height: getInScreenSize(0.5),
                              color: Colors.black.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: kMediumPadding,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: kMediumPadding,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Touchable(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_rounded,
                        color: Colors.white,
                        size: 24.toScreenSize,
                      ),
                      const SizedBox(
                        width: kItemPadding,
                      ),
                      Text(
                        AppTranslate.i18n.backStr.localized.toUpperCase(),
                        style: TextStyles.headerText.bold.whiteColor,
                      ),
                    ],
                  ),
                ),
                Touchable(
                  onTap: () {
                    _takeScreenshotAndShare();
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        AssetHelper.icoShare,
                        width: 24.toScreenSize,
                        height: 24.toScreenSize,
                      ),
                      const SizedBox(
                        width: kItemPadding,
                      ),
                      Text(
                        AppTranslate.i18n.sendStr.localized.toUpperCase(),
                        style: TextStyles.headerText.bold.whiteColor,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: kMediumPadding,
            ),
          ],
        ),
      ),
    );
  }

  _transferRate(InitTransferModel transferModel) {
    TransferState transferState = _transferBloc.state;
    if (transferState.needGetRate() &&
        _rateBloc.state.getRateDataState == DataState.data) {
      double amt = transferModel.amount ?? 0;
      TransferRate? rate = _rateBloc.state.transferRate;

      String value = '';
      value = transferModel.amountCcy == 'VND'
          ? '${(amt / (rate?.buyRate ?? 1)).toStringAsFixed(rate?.amountCcy == 'JPY' ? 0 : 2)} ${transferModel.debitCcy ?? transferState.debitAccountDefault?.accountCurrency}'
          : '${(amt * (rate?.buyRate ?? 1)).toStringAsFixed(0).toMoneyFormat} VND';

      return Column(
        children: [
          buildItemInfo(
              paddingTop: itemMarginTop,
              title:
                  '${AppTranslate.i18n.ersExchangeRateInfoStr.localized} ${transferModel.debitCcy}',
              description: AppTranslate.i18n.fxRateNoteStr.localized,
              desStyle: TextStyles.smallText.copyWith(color: Colors.red),
              value: '${rate?.buyRate?.toMoneyString} VND'),
          buildItemInfo(
              paddingTop: itemMarginTop,
              title: transferModel.amountCcy == 'VND'
                  ? AppTranslate.i18n.fxDebitAmountStr.localized
                  : AppTranslate.i18n.fxEstimateConversionAmountStr.localized,
              value: value),
        ],
      );
    }
    return const SizedBox();
  }
}
