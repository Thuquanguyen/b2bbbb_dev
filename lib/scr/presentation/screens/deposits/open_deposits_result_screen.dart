import 'dart:io';

import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/bloc/deposits/open_online_deposits_bloc.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/open_saving/rollover_term_rate.dart';
import 'package:b2b/scr/presentation/widgets/dash_line.dart';
import 'package:b2b/scr/presentation/widgets/dialog_widget.dart';
import 'package:b2b/scr/presentation/widgets/item_info.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

enum AccountHistoryDetailType { PROCESS, SUCCEED }

class OpenDepositsResultScreen extends StatefulWidget {
  const OpenDepositsResultScreen({Key? key}) : super(key: key);
  static const String routeName = '/OpenDepositsResultScreen';

  @override
  _OpenDepositsResultScreenState createState() =>
      _OpenDepositsResultScreenState();
}

class _OpenDepositsResultScreenState extends State<OpenDepositsResultScreen> {
  final ScreenshotController _screenshotHeaderController =
      ScreenshotController();
  final ScreenshotController _screenshotBodyController = ScreenshotController();
  final ScreenshotController _screenshotFeetController = ScreenshotController();

  late OpenOnlineDepositsBloc _depositsBloc;

  @override
  void initState() {
    super.initState();
    _depositsBloc = BlocProvider.of<OpenOnlineDepositsBloc>(context);
  }

  @override
  void dispose() {
    super.dispose();
    Logger.debug('dispose');
    _depositsBloc.add(ClearDepositsStateEvent());
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

  @override
  Widget build(BuildContext context) {
    OpenOnlineDepositsState state = _depositsBloc.state;

    RolloverTermRate? rolloverTermRate =
        state.depositsInputState?.rolloverTermRate;

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
                              state.intDepositsResult?.transCode ?? '',
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
                          child: Container(
                            color: Colors.white,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: buildItemInfo(
                                    title: AppTranslate
                                        .i18n
                                        .transferToAccountTitleSourceAccountStr
                                        .localized,
                                    value:
                                        state.rootAccountDebit?.accountNumber ??
                                            '',
                                    valueStyle: TextStyles.itemText,
                                  ),
                                ),
                                buildItemInfo(
                                  title: AppTranslate
                                      .i18n.titleDepositsStr.localized,
                                  value:
                                      '${state.intDepositsResult?.amount?.toInt().toString().toMoneyFormat} ${state.intDepositsResult?.amountCcy}',
                                ),
                                buildItemInfo(
                                  title: AppTranslate
                                      .i18n.numberOfMoneyStr.localized,
                                  value: (state.intDepositsResult?.amountSpell
                                              ?.localization() ??
                                          '')
                                      .toTitleCase(),
                                ),
                                buildItemInfo(
                                    title:
                                        AppTranslate.i18n.periodStr.localized,
                                    value: state.depositsInputState
                                            ?.selectedRollOverTerm
                                            ?.getValue() ??
                                        ''),
                                buildItemInfo(
                                  title: AppTranslate
                                      .i18n.effectiveDateStr.localized,
                                  value: rolloverTermRate?.startDate ?? '',
                                  valueStyle: TextStyles.itemText,
                                ),
                                buildItemInfo(
                                  title: AppTranslate
                                      .i18n.titleExpriedDateStr.localized,
                                  value: rolloverTermRate?.endDate ?? '',
                                  valueStyle: TextStyles.itemText,
                                ),
                                buildItemInfo(
                                  title: AppTranslate.i18n
                                      .firstLoginTitleInterestRateStr.localized,
                                  value:
                                      state.intDepositsResult?.getRateTotal(),
                                ),
                                buildItemInfo(
                                  title: AppTranslate
                                      .i18n.receiveInterestMethodStr.localized,
                                  value: state.savingReceiveMethod
                                          ?.interrestPreiod ??
                                      '',
                                  valueStyle: TextStyles.itemText,
                                ),
                                buildItemInfo(
                                  title: AppTranslate
                                      .i18n.dueProcessingMethodStr.localized,
                                  value: state.depositsInputState
                                          ?.selectedSettelment?.name ??
                                      '',
                                  valueStyle: TextStyles.itemText,
                                ),
                                buildItemInfo(
                                  title: AppTranslate
                                      .i18n.accountReceiveProfitStr.localized,
                                  value: state.receiveAccountProfit
                                          ?.accountNumber ??
                                      '',
                                  valueStyle: TextStyles.itemText,
                                ),
                                if ((state.intDepositsResult?.introducerCif)
                                    .isNotNullAndEmpty)
                                  buildItemInfo(
                                    title:
                                        AppTranslate.i18n.cifReferStr.localized,
                                    value: state
                                            .intDepositsResult?.introducerCif ??
                                        '',
                                    valueStyle: TextStyles.itemText,
                                  ),
                                if ((state.intDepositsResult?.contractNumber)
                                    .isNotNullAndEmpty)
                                  buildItemInfo(
                                    title: AppTranslate
                                        .i18n.titleNoteStr.localized,
                                    value: state.intDepositsResult
                                            ?.contractNumber ??
                                        '',
                                    valueStyle: TextStyles.itemText,
                                  ),
                                const SizedBox(
                                  height: kDefaultPadding,
                                ),
                              ],
                            ),
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
}
