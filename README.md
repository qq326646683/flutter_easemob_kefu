#
## 1.Describe

1.封装的环信客服的功能: 初始化、注册、登录、进入会话;

2.绘画页面easeUI里包含的同kefu-android-demo、kefu-ios-demo一样的功能:

android: 选图片、拍照片、选视频、发文件、发语音、文字、表情

ios: 选照片、拍照片、拍视频、发定位、发语音、文字、表情

3.语音、视频通话尝试均不可用

## 2.Setup
```dart
// 环信自带的ui
flutter_easemob_kefu: ${last_version}

or

flutter_easemob_kefu:
    git:
      url: https://github.com/qq326646683/flutter_easemob_kefu.git

// 自定义ui(根据自己的ui，去修改原生两端的ui代码)
flutter_easemob_kefu:
    git:
      url: https://github.com/qq326646683/flutter_easemob_kefu.git
      ref: custom-ui

```

> For Ios:

相册、相机等权限配置到plist

## 3.Usages

```dart
  /// 初始化
  /// appKey: “管理员模式 > 渠道管理 > 手机APP”页面的关联的“AppKey”
  /// tenantId: “管理员模式 > 设置 > 企业信息”页面的“租户ID”
  static void init(String appKey, String tenantId) {
    _channel.invokeMethod("init", <String, dynamic>{
      "appKey": appKey,
      "tenantId": tenantId,
    });
  }

  /// 注册
  static Future<bool> register(String username, String password) async {
    return _channel.invokeMethod("register", <String, dynamic>{
      "username": username,
      "password": password,
    });
  }

  /// 登录
  static Future<bool> login(String username, String password) async {
    return _channel.invokeMethod("login", <String, dynamic>{
      "username": username,
      "password": password,
    });
  }

  /// 是否登录
  static Future<bool> get isLogin {
    return _channel.invokeMethod("isLogin");
  }

  /// 注销登录
  static Future<bool> logout() async {
    return _channel.invokeMethod("logout");
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
```

## 4.Example
```dart
FlutterEasemobKefu.init("1439201009092337#kefuchannelapp86399", "86399");

bool isSuccess = await FlutterEasemobKefu.register("nell", "123456");

bool isSuccess = await FlutterEasemobKefu.login("nell", "123456");

bool isLogin = await FlutterEasemobKefu.isLogin;
if (isLogin) {
  FlutterEasemobKefu.jumpToPage("kefuchannelimid_316626");
}
```

