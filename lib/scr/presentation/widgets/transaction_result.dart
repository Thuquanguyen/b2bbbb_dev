import 'dart:io';

import 'package:b2b/commons.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/data/model/name_model.dart';
import 'package:b2b/scr/presentation/widgets/dash_line.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:b2b/utilities/image_helper/imagehelper.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:lottie/lottie.dart';

class TransactionResultItem {
  final String title;
  final TextStyle? titleStyle;
  final String? value;
  final TextStyle? valueStyle;
  final String? description;
  final TextStyle? descriptionStyle;

  TransactionResultItem({
    required this.title,
    this.titleStyle,
    this.value,
    this.description,
    this.valueStyle,
    this.descriptionStyle,
  });
}

class TransactionResult extends StatefulWidget {
  const TransactionResult({
    Key? key,
    required this.infoList,
    this.headerText,
    this.showLogo = false,
    this.screenTitle,
    this.headerItem1,
    this.headerItem2,
    this.status,
  }) : super(key: key);

  final List<TransactionResultItem> infoList;
  final bool showLogo;
  final String? headerText;
  final String? screenTitle;
  final TransactionResultItem? headerItem1;
  final TransactionResultItem? headerItem2;
  final NameModel? status;

  @override
  State<StatefulWidget> createState() => TransactionResultState();
}

class TransactionResultState extends State<TransactionResult> with TickerProviderStateMixin {
  late final AnimationController _controller;
  final ScreenshotController _screenshotHeaderController = ScreenshotController();
  final ScreenshotController _screenshotBodyController = ScreenshotController();
  final ScreenshotController _screenshotFeetController = ScreenshotController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _controller.duration = const Duration(milliseconds: 1500);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> infoWidgets = [];
    for (TransactionResultItem i in widget.infoList) {
      if (i.value != null) {
        infoWidgets.add(buildItemInfo(
          title: i.title,
          titleStyle: i.titleStyle,
          value: i.value,
          valueStyle: i.valueStyle,
          description: i.description,
          descriptionStyle: i.descriptionStyle,
        ));
        infoWidgets.add(const SizedBox(
          height: kItemPadding,
        ));
      }
    }

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
              padding: EdgeInsets.only(top: SizeConfig.screenPaddingTop, bottom: kMediumPadding),
              child: Text(
                (widget.screenTitle ?? AppTranslate.i18n.tisTransactionDetailStr.localized).toUpperCase(),
                style: TextStyles.headerText.whiteColor,
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AssetHelper.accountHistoryDetailDialog),
                    fit: BoxFit.fill,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: kDefaultPadding, horizontal: kDefaultPadding),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Screenshot(
                          controller: _screenshotHeaderController,
                          child: Column(
                            children: [
                              if (widget.showLogo)
                                SizedBox(
                                  height: 130.toScreenSize,
                                  child: Lottie.asset(
                                    'assets/animation/vpfly.json',
                                    controller: _controller,
                                    onLoaded: (composition) {
                                      setTimeout(() {
                                        _controller.forward();
                                      }, 250);
                                    },
                                  ),
                                ),
                              // Image.asset(
                              //   AssetHelper.accountHistoryDetailLogo,
                              //   width: 130.toScreenSize,
                              //   height: 130.toScreenSize,
                              // ),
                              if (widget.headerText != null)
                                Text(
                                  widget.headerText!,
                                  style: TextStyles.normalText,
                                  textAlign: TextAlign.center,
                                ),
                              if (widget.headerText != null)
                                const SizedBox(
                                  height: 8,
                                ),
                              if (widget.headerItem1 != null)
                                buildItemInfo(
                                  title: widget.headerItem1!.title,
                                  titleStyle: widget.headerItem1!.titleStyle,
                                  value: widget.headerItem1!.value,
                                  valueStyle: widget.headerItem1!.valueStyle,
                                ),
                              if (widget.headerItem1 != null && widget.headerItem2 != null)
                                const SizedBox(
                                  height: 4,
                                ),
                              if (widget.headerItem2 != null)
                                buildItemInfo(
                                  title: widget.headerItem2!.title,
                                  titleStyle: widget.headerItem2!.titleStyle,
                                  value: widget.headerItem2!.value,
                                  valueStyle: widget.headerItem2!.valueStyle,
                                ),
                              const SizedBox(
                                height: 20,
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
                                const SizedBox(
                                  height: 20,
                                ),
                                ...infoWidgets,
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
                                padding: const EdgeInsets.symmetric(vertical: kDefaultPadding),
                                child: widget.status != null
                                    ? Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                            widget.status!.statusDetail?.iconPath ?? '',
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
                                              widget.status!.statusDetail?.text.toUpperCase() ?? '',
                                              style: TextStyles.smallText.medium.copyWith(
                                                  color: widget.status?.key == 'OPEN_WAI'
                                                      ? const Color(0xff00B74F)
                                                      : widget.status!.statusDetail?.color),
                                              // style: TextStyle(
                                              //   color: status!.statusDetail?.color,
                                              //   fontWeight: FontWeight.w500,
                                              //   fontSize: 12,
                                              // ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ),
                              if (widget.status != null)
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
                        AppTranslate.i18n.tisGoBackStr.localized.toUpperCase(),
                        style: TextStyles.headerText.bold.whiteColor,
                      ),
                    ],
                  ),
                ),
                Touchable(
                  onTap: () {
                    takeScreenshotAndShare(context);
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
                        AppTranslate.i18n.tisShareStr.localized.toUpperCase(),
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

  void takeScreenshotAndShare(BuildContext context) async {
    try {
      showLoading();
      final imageHeader = await _screenshotHeaderController.capture();
      final imageBody = await _screenshotBodyController.capture();
      final imageFeet = await _screenshotFeetController.capture();

      final image = await ImageHelper.join([imageHeader, imageBody, imageFeet]);
      if (image != null) {
        final report =
            await ImageHelper.renderReport(AppTranslate.i18n.tisReportTitleStr.localized.toUpperCase(), image);
        if (report != null) {
          final directory = await getTemporaryDirectory();
          final imagePath = await File('${directory.path}/ahd_screenshot.png').create();
          await imagePath.writeAsBytes(report);
          await Share.shareFiles([imagePath.path], mimeTypes: ['image/png'], text: 'Shared from VPBank NEOBiz');
        }
      }
    } catch (e) {
      showDialogErrorForceGoBack(context, AppTranslate.i18n.havingAnErrorStr.localized, () {});
    }
    hideLoading();
  }

  Widget buildItemInfo({
    required String title,
    TextStyle? titleStyle,
    String? value,
    TextStyle? valueStyle,
    String? description,
    TextStyle? descriptionStyle,
  }) {
    if (!value.isNotNullAndEmpty) return const SizedBox();
    valueStyle ??= TextStyles.itemText.setColor(const Color.fromRGBO(52, 52, 52, 1));
    descriptionStyle ??= TextStyles.smallText.setColor(const Color.fromRGBO(102, 102, 103, 1));
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Text(
            title,
            textAlign: TextAlign.end,
            style: titleStyle ?? TextStyles.normalText.semibold,
          ),
        ),
        const SizedBox(
          width: kMediumPadding,
        ),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value ?? '',
                style: valueStyle,
              ),
              if (description != null)
                Padding(
                  padding: const EdgeInsets.only(top: kMinPadding - 2),
                  child: Text(
                    description,
                    style: descriptionStyle,
                  ),
                )
            ],
          ),
        ),
      ],
    );
  }
}
