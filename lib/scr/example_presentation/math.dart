import 'dart:math';

import 'package:b2b/utilities/logger.dart';

List<int> listPrisoner = List<int>.generate(23, (index) => index + 1);
late bool switch1;
late bool switch2;
int _prisoners() {
  // Random().nextInt(23) get a number from 0 to max
  switch1 = listPrisoner[Random().nextInt(23)] > Random().nextInt(23);
  switch2 = listPrisoner[Random().nextInt(23)] < Random().nextInt(23);
  int count = 0;
  int times = 0;
  final List<int> listPrisonerSwitched = [];
  while (count < 23 && times < 2000) {
    times++;
    if (times % 50 == 0) {
      Logger.debug(times);
    }
    final prisoner = listPrisoner[Random().nextInt(23)];
    // 23, default switch 2 alway have true value.
    if (listPrisonerSwitched.contains(prisoner) && prisoner != 23) {
      switch1 = !switch1;
    } else {
      if (prisoner == 23 && switch2) {
        count++;
        switch2 = false;
      } else if (switch2) {
        switch1 = !switch1;
      } else {
        switch2 = true;
      }
    }
    listPrisonerSwitched.add(prisoner);
  }
  Logger.debug(count);
  return times;
}

void main(List<String> arguments) {
  Logger.debug('times to finish: ' + _prisoners().toString());
}
