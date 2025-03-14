import 'dart:io';
import 'package:b2b/commons.dart';
import 'package:b2b/scr/core/size/size_config.dart';
import 'package:b2b/scr/presentation/widgets/touchable.dart';
import 'package:b2b/utilities/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:b2b/scr/presentation/widgets/appbar_container.dart';
import 'package:flutter/widgets.dart';
import 'package:share_plus/share_plus.dart';

class LogScreen extends StatefulWidget {
  const LogScreen({Key? key}) : super(key: key);
  static String routeName = 'log_screen';
  static bool isShowing = false;

  @override
  _LogScreenState createState() => _LogScreenState();
}

class _LogScreenState extends State<LogScreen> {
  String data = '';
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    LogScreen.isShowing = true;
    super.initState();
    setTimeout(() {
      readLogs();
    }, 300);
  }

  @override
  void dispose() {
    LogScreen.isShowing = false;
    super.dispose();
  }

  Future<void> readLogs() async {
    data = "";
    String? path = await Logger.getFilePath();
    if (path != null) {
      String content = "";
      if (Platform.isIOS) {
        content = await rootBundle.loadString(path, cache: false);
      } else {
        File file = File(path);
        if (await file.exists()) {
          content = await file.readAsString();
        }
      }
      if (content.isNotEmpty && content != '') {
        setState(() {
          data = content;
        });
        setTimeout(() {
          scrollController.animateTo(scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 100), curve: Curves.ease);
        }, 300);
      } else {
        setState(() {
          data = 'No more logs!';
        });
      }
    }
  }

  Future<void> clearLogs() async {
    String? path = await Logger.getFilePath();
    if (path != null) {
      final file = await File(path);
      await file.delete(recursive: true);
      await file.writeAsString('', mode: FileMode.append);
      readLogs();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppBarContainer(
      title: 'LOGS',
      appBarType: AppBarType.NORMAL,
      actions: [
        Touchable(
          onTap: () async {
            showLoading();
            String? path = await Logger.getFilePath();
            if (path != null) {
              await Share.shareFiles([path], mimeTypes: ['text/plain']);
              hideLoading();
            }
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            child: Icon(Icons.share_outlined, size: 24, color: Colors.white),
          ),
        ),
        Touchable(
          onTap: () {
            clearLogs();
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
            child: Icon(Icons.clear, size: 24, color: Colors.white),
          ),
        ),
        Touchable(
          onTap: () {
            readLogs();
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 10.0, right: 16.0, top: 10.0, bottom: 10.0),
            child: Icon(Icons.sync, size: 24, color: Colors.white),
          ),
        )
      ],
      child: Container(
        padding: const EdgeInsets.all(8),
        color: Colors.white,
        width: SizeConfig.screenWidth,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Text(
            data,
            // Platform.isIOS?'Courier':''/
            style: const TextStyle(height: 1.4, fontSize: 14, fontFamily: 'sans'),
          ),
        ),
      ),
    );
  }
}
