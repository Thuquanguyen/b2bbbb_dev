import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/presentation/widgets/lazy_widget.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewArgs {
  WebViewArgs({required this.url, required this.title});

  String url;
  String title;
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);
  static const String routeName = 'web_view_screen';

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool showLoading = true;

  @override
  void initState() {
    super.initState();
    // ignore: always_put_control_body_on_new_line
    // if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = getArguments<WebViewArgs>(context);
    Logger.debug('load ${args?.url}');
    return Container(
      height: SizeConfig.screenHeight,
      color: Colors.white,
      child: AppBarContainer(
          title: args?.title ?? '',
          backgroundColor: Colors.white,
          appBarType: AppBarType.NORMAL,
          child: Container(
            color: Colors.white,
            height: SizeConfig.screenHeight,
            child: Stack(children: [
              // WebviewScaffold(
              //   url: args?.url ?? '',
              //   withLocalStorage: true,
              //   ignoreSSLErrors: true,
              //   withJavascript: true,
              // ),
              LazyWidget(
                delay: 300,
                child: InAppWebView(
                    initialUrlRequest: URLRequest(url: Uri.parse(args?.url ?? '')),
                    onReceivedServerTrustAuthRequest: (controller, challenge) async {
                      return ServerTrustAuthResponse(action: ServerTrustAuthResponseAction.PROCEED);
                    },
                    onPageCommitVisible: (InAppWebViewController controller, Uri? url) {
                      setState(() {
                        showLoading = false;
                      });
                    }
                    // initialUrl: args?.url,
                    // javascriptMode: JavascriptMode.unrestricted,
                    // allowsInlineMediaPlayback: true,
                    // onWebViewCreated: (InAppWebViewController controller) {
                    //   _controller.complete(webViewController);
                    // },
                    // onPageFinished: (String url) {
                    //   Logger.debug('Page finished loading: $url');
                    // setState(() {
                    //   showLoading = false;
                    // });
                    // },
                    ),
              ),
              SizedBox(height: showLoading ? 2 : 0, child: const LinearProgressIndicator()),
            ]),
          )),
    );
  }
}
