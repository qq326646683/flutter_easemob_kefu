import 'dart:async';

import 'package:flutter/services.dart';

class FlutterEasemobKefu {
  static const MethodChannel _channel =
      const MethodChannel('flutter_easemob_kefu');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
