import 'dart:async';

import 'package:flutter/services.dart';

class FlutterEasemobKefu {
  static const MethodChannel _channel =
      const MethodChannel('flutter_easemob_kefu');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// 初始化
  /// appKey: “管理员模式 > 渠道管理 > 手机APP”页面的关联的“AppKey”
  /// tenantId: “管理员模式 > 设置 > 企业信息”页面的“租户ID”
  static void init(String appKey, String tenantId) {
    _channel.invokeMethod(
      "init",
      <String, dynamic>{
        "appKey": appKey,
        "tenantId": tenantId,
      },
    );
  }

  /// 注册
  static Future<bool> register(String username, String password) async {
    return await _channel.invokeMethod(
      "register",
      <String, dynamic>{
        "username": username,
        "password": password,
      },
    );
  }

  /// 登录
  static Future<bool> login(String username, String password) async {
    return await _channel.invokeMethod(
      "login",
      <String, dynamic>{
        "username": username,
        "password": password,
      },
    );
  }

  /// 是否登录
  static Future<bool> get isLogin async {
    return await _channel.invokeMethod("isLogin");
  }

  /// 注销登录
  static Future<bool> logout() async {
    return await _channel.invokeMethod("logout");
  }

  /// 会话页面:
  /// imNumber: “管理员模式 > 渠道管理 > 手机APP”页面的关联的“IM服务号”
  /// email: 客服的邮箱地址
  /// queueName: 技能组名称
  /// titleName: 页面标题
  /// showUserNick: 是否展示用户头像
  static void jumpToPage(
    String imNumber, {
    bool showUserNick = true,
    String email = '',
    String queueName = '',
    String titleName = '',
  }) {
    _channel.invokeMethod(
      "jumpToPage",
      <String, dynamic>{
        "imNumber": imNumber,
        'email': email,
        'queueName': queueName,
        'titleName': titleName,
        'showUserNick': showUserNick,
      },
    );
  }
}
