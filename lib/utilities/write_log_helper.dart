import 'dart:collection';
import 'dart:io';

import 'package:b2b/utilities/logger.dart';

class WriteLogHelper {
  factory WriteLogHelper() => _instance;

  WriteLogHelper._();

  static final _instance = WriteLogHelper._();

  Queue<String> logs = Queue<String>();

  bool isRunning = false;

  void push(String log) {
    logs.add(log);
    if (!isRunning) {
      writeLog();
    }
  }

  File? file;

  Future<void> writeLog() async {
    isRunning = true;
    String? path = await Logger.getFilePath();
    if (path != null) {
      file ??= File(path);
      while (logs.isNotEmpty) {
        await file?.writeAsString(logs.first, mode: FileMode.append);
        logs.removeFirst();
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    isRunning = false;
  }
}
