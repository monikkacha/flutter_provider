import 'package:logging/logging.dart';

import 'dart:developer' as Developer;

void loggerConfigure() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    Developer.log('${record.level.name} : ${record.time} : ${record.message}');
  });
}

final Log = Logger("flutter_basic");
