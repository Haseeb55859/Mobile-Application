// lib/utils/hive_helper.dart
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static const String kBoxName = 'smarttrackerBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(kBoxName);
  }
}
