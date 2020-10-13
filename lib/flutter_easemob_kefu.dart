import 'dart:async';

import 'package:flutter/services.dart';

class FlutterEasemobKefu {
  static const MethodChannel _channel = const MethodChannel('flutter_easemob_kefu');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// 初始化
  static void init(String appKey, String tenantId) {
    _channel.invokeMapMethod("init", <String, dynamic>{
      "appKey": appKey,
      "tenantId": tenantId,
    });
  }

  /// 注册
  static void register(String username, String password) {
    _channel.invokeMapMethod("register", <String, dynamic>{
      "username": username,
      "password": password,
    });
  }

  /// 登录
  static void login(String username, String password) {
    _channel.invokeMapMethod("login", <String, dynamic>{
      "username": username,
      "password": password,
    });
  }

  /// 是否登录
  static Future<bool> get isLogin {
    return _channel.invokeMethod("isLogin");
  }

  /// 注销登录
  static void logout() {
    _channel.invokeMethod("logout");
  }

  /// 会话页面
  static void jumpToPage(String appKey) {
    _channel.invokeMapMethod("jumpToPage", <String, dynamic>{
      "appKey": appKey,
    });
  }
}
