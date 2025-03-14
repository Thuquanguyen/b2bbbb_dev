import 'dart:developer';
import 'dart:io';

import 'package:b2b/commons.dart';
import 'package:b2b/scr/core/routes/routes.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/presentation/widgets/state_builder.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({Key? key}) : super(key: key);
  static const String routeName = 'qr-code-screen';

  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  final StateHandler _handler = StateHandler(QRCodeScreen.routeName);
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  bool flashOn = false;
  Function? onResult;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    onResult = getArgument<Function?>(context, 'onResult');
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(height: SizeConfig.screenHeight, width: SizeConfig.screenWidth, child: _buildQrView(context)),
          Positioned(
            top: SizeConfig.topSafeAreaPadding + 10,
            left: 10,
            child: Touchable(
              onTap: () {
                popScreen(context);
              },
              child: Container(
                alignment: Alignment.center,
                height: 36,
                width: 36,
                decoration:
                    const BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(18)), color: Colors.white24),
                child: const Icon(
                  Icons.close,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          Positioned(
            top: SizeConfig.topSafeAreaPadding + 10,
            right: 10,
            child: Touchable(
              onTap: () async {
                await controller?.flipCamera();
              },
              child: Container(
                alignment: Alignment.center,
                height: 36,
                width: 36,
                // decoration: const BoxDecoration(
                //     borderRadius: BorderRadius.all(Radius.circular(18)),
                //     color: Colors.white24
                // ),
                child: const Icon(
                  Icons.sync,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: SizeConfig.bottomSafeAreaPadding + 10,
            right: 10,
            child: Touchable(
              onTap: () async {
                await controller?.toggleFlash();
                flashOn = await controller?.getFlashStatus() ?? false;
                log('flash $flashOn');
                _handler.refresh();
              },
              child: Container(
                alignment: Alignment.center,
                height: 36,
                width: 36,
                // decoration: const BoxDecoration(
                //     borderRadius: BorderRadius.all(Radius.circular(18)),
                //     color: Colors.white24
                // ),
                child: StateBuilder(
                  builder: () {
                    return Icon(
                      flashOn == true ? Icons.flash_off_outlined : Icons.flash_on_outlined,
                      size: 24,
                      color: Colors.white,
                    );
                  },
                  routeName: QRCodeScreen.routeName,
                ),
              ),
            ),
          ),

          // Expanded(
          //   flex: 1,
          //   child: FittedBox(
          //     fit: BoxFit.contain,
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       children: <Widget>[
          //         if (result != null)
          //           Text('Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}')
          //         else
          //           const Text('Scan a code'),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[
          //             Container(
          //               margin: const EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                   onPressed: () async {
          //                     await controller?.toggleFlash();
          //                     setState(() {});
          //                   },
          //                   child: FutureBuilder(
          //                     future: controller?.getFlashStatus(),
          //                     builder: (context, snapshot) {
          //                       return Text('Flash: ${snapshot.data}');
          //                     },
          //                   )),
          //             ),
          //             Container(
          //               margin: const EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                   onPressed: () async {
          //                     await controller?.flipCamera();
          //                     setState(() {});
          //                   },
          //                   child: FutureBuilder(
          //                     future: controller?.getCameraInfo(),
          //                     builder: (context, snapshot) {
          //                       if (snapshot.data != null) {
          //                         return Text('Camera facing ${describeEnum(snapshot.data!)}');
          //                       } else {
          //                         return const Text('loading');
          //                       }
          //                     },
          //                   )),
          //             )
          //           ],
          //         ),
          //         Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           crossAxisAlignment: CrossAxisAlignment.center,
          //           children: <Widget>[
          //             Container(
          //               margin: const EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                 onPressed: () async {
          //                   await controller?.pauseCamera();
          //                 },
          //                 child: Text('pause', style: const TextStyle(fontSize: 20)),
          //               ),
          //             ),
          //             Container(
          //               margin: const EdgeInsets.all(8),
          //               child: ElevatedButton(
          //                 onPressed: () async {
          //                   await controller?.resumeCamera();
          //                 },
          //                 child: Text('resume', style: const TextStyle(fontSize: 20)),
          //               ),
          //             )
          //           ],
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea =
        (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 250.0 : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: (QRViewController controller) {
        setState(() {
          this.controller = controller;
        });
        controller.scannedDataStream.listen((scanData) {
          this.controller?.pauseCamera();
          setTimeout(() {
            popScreen(context);
            onResult?.call(scanData.code);
          }, 300);
        });
      },
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white, borderRadius: 10, borderLength: 30, borderWidth: 5, cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
