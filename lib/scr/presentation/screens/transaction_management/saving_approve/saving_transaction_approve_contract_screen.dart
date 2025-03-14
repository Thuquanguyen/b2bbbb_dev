import 'dart:convert';
import 'dart:typed_data';
import 'package:b2b/utilities/logger.dart';
import 'package:b2b/utilities/vp_file_helper.dart';
import 'package:share_plus/share_plus.dart';
import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/extensions/num_ext.dart';
import 'package:b2b/scr/core/extensions/textstyles.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/scr/presentation/widgets/widgets.dart';
import 'package:b2b/utilities/image_helper/asset_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class SavingTransactionApproveContractScreen extends StatefulWidget {
  const SavingTransactionApproveContractScreen({
    Key? key,
  }) : super(key: key);
  static const String routeName = 'saving-transaction-approve-contract-screen';

  @override
  State<StatefulWidget> createState() =>
      SavingTransactionApproveContractScreenState();
}

class SavingTransactionApproveContractScreenState
    extends State<SavingTransactionApproveContractScreen> {
  Uri? path;

  @override
  void initState() {
    super.initState();
  }

  void write(String contractContent) async {
    if (path != null) return;
    String content =
        '<html><head><meta name="viewport" content="width=device-width, initial-scale=1.0"><meta charset="UTF-8"></head>' +
            contractContent +
            '</html>';
    content = content
        .replaceAll('width: 700px;',
            'width: 100% !important; font-size: 13px !important; font-family: Arial, Helvetica, sans-serif !important; line-height: 26px !important;')
        .replaceAll(r'\"', '"');
    Uri paths = (await TempContractFile().writeFile(content)).uri;
    path = paths;
    setState(() {});
    print(path);
  }

  @override
  Widget build(BuildContext context) {
    String contractContent =
        getArgument<String>(context, 'contractContent') ?? '';

    String contractContentType =
        getArgument<String>(context, 'contractContentByte') ?? '';
    write(contractContent);
    return AppBarContainer(
      appBarType: AppBarType.FULL,
      title: 'Phê duyệt thành công',
      hideBackButton: true,
      child: Container(
        padding: const EdgeInsets.only(
          left: kDefaultPadding,
          right: kDefaultPadding,
          bottom: kDefaultPadding,
        ),
        width: double.infinity,
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                  boxShadow: const [kBoxShadowContainer],
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (path != null)
                      Expanded(
                        child: InAppWebView(
                          initialUrlRequest: URLRequest(url: path),
                          initialOptions: InAppWebViewGroupOptions(
                              android: AndroidInAppWebViewOptions(
                                useWideViewPort: true,
                                defaultFontSize: 13,
                                displayZoomControls: true,
                              ),
                              ios: IOSInAppWebViewOptions()),
                        ),
                      ),
                    const SizedBox(
                      height: 8,
                    ),
                  ],
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
                    // TODO: Handle contract share
                    // takeScreenshotAndShare(context);
                    // PdfHelper().htmlToPDF(contractContent);
                    VpFileHelper().actionShareContract(contractContentType);
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
}

class TempContractFile {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/contract.html');
  }

  Future<File> writeFile(String counter) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(counter);
  }
}
