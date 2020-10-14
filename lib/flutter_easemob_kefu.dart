import 'dart:async';

import 'package:flutter/services.dart';

class FlutterEasemobKefu {
  static const MethodChannel _channel = const MethodChannel('flutter_easemob_kefu');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// 初始化
  /// appKey: “管理员模式 > 渠道管理 > 手机APP”页面的关联的“AppKey”
  /// tenantId: “管理员模式 > 设置 > 企业信息”页面的“租户ID”
  static void init(String appKey, String tenantId) {
    _channel.invokeMapMethod("init", <String, dynamic>{
      "appKey": appKey,
      "tenantId": tenantId,
    });
  }

  /// 注册
  static Future<bool> register(String username, String password) async {
    Map<String, dynamic> map = await _channel.invokeMapMethod("register", <String, dynamic>{
      "username": username,
      "password": password,
    });
    return map["isSuccess"];
  }

  /// 登录
  static Future<bool> login(String username, String password) async {
    Map<String, dynamic> map = await _channel.invokeMapMethod("login", <String, dynamic>{
      "username": username,
      "password": password,
    });
    return map["isSuccess"];
  }

  /// 是否登录
  static Future<bool> get isLogin {
    return _channel.invokeMethod("isLogin");
  }

  /// 注销登录
  static Future<bool> logout() async {
    Map<String, dynamic> map = await _channel.invokeMethod("logout");
    return map["isSuccess"];
  }

  /// 会话页面:
  /// imNumber: “管理员模式 > 渠道管理 > 手机APP”页面的关联的“IM服务号”
  static void jumpToPage(String imNumber) {
    _channel.invokeMapMethod("jumpToPage", <String, dynamic>{
      "imNumber": imNumber,
    });
  }
}
