import 'package:b2b/constants.dart';
import 'package:b2b/scr/core/language/app_translate.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:b2b/scr/presentation/widgets/lazy_widget.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:b2b/scr/core/extensions/string_ext.dart';

class TermModel {
  TermModel(this.title, this.link, this.onResult,
      {this.hideContinueButton = false});

  String title;
  String link;
  Function? onResult;
  bool? hideContinueButton;
}

class TermScreen extends StatefulWidget {
  const TermScreen({Key? key}) : super(key: key);
  static const String routeName = 'term-screen';

  @override
  _TermScreenState createState() => _TermScreenState();
}

class _TermScreenState extends State<TermScreen> {
  bool showLoading = true;

  @override
  Widget build(BuildContext context) {
    final args = getArguments(context) as TermModel;

    return AppBarContainer(
      title: args.title,
      child: Container(
        height: SizeConfig.screenHeight,
        margin: const EdgeInsets.only(left: 14, right: 14, bottom: 24),
        child: Column(
          children: [
            Expanded(
              child: webviewContainer(args.link),
            ),
            if (args.hideContinueButton != true) buttonConfirm(args)
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }

  Widget webviewContainer(String url) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Stack(children: [
          LazyWidget(
            delay: 300,
            child: InAppWebView(
                initialUrlRequest: URLRequest(url: Uri.parse(url)),
                onReceivedServerTrustAuthRequest:
                    (controller, challenge) async {
                  return ServerTrustAuthResponse(
                      action: ServerTrustAuthResponseAction.PROCEED);
                },
                onPageCommitVisible:
                    (InAppWebViewController controller, Uri? url) {
                  setState(() {
                    showLoading = false;
                  });
                }
                // initialUr
                ),
          ),
          showLoading
              ? const SizedBox(height: 2, child: LinearProgressIndicator())
              : const SizedBox(
                  height: 0,
                ),
        ]),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(kCornerRadius)),
          color: Colors.white,
        ),
      );

  Widget buttonConfirm(TermModel termModel) => Touchable(
        child: Container(
          height: kButtonHeight,
          margin: const EdgeInsets.only(
              left: kDefaultPadding,
              right: kDefaultPadding,
              top: kDefaultPadding),
          child: Center(
            child: Text(
              termModel.onResult == null
                  ? AppTranslate.i18n.gotitStr.localized
                  : AppTranslate.i18n.termTitleConfirmStr.localized,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
          decoration: const BoxDecoration(
              color: Color.fromRGBO(0, 183, 79, 1.0),
              borderRadius:
                  BorderRadius.all(Radius.circular(kButtonCornerRadius)),
              boxShadow: [kBoxShadow]),
        ),
        onTap: () {
          Navigator.of(context).pop();
          termModel.onResult?.call();
        },
      );
}
