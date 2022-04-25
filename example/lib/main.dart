import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_easemob_kefu/flutter_easemob_kefu.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

enum KefuState {
  Default,
  Inited,
  Registered,
  Logined,
  Logout,
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  KefuState state = KefuState.Default;

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initPermission();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await FlutterEasemobKefu.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  initPermission() {
    Permission.storage.request();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            Text('Running on: $_platformVersion\n'),
            Text('当前状态: $state\n'),
            ElevatedButton(
              onPressed: () async {
                FlutterEasemobKefu.init(
                    "1430220411092008#kefuchannelapp101970", "147277");
                setState(() {
                  state = KefuState.Inited;
                });
              },
              child: Text('初始化'),
            ),
            ElevatedButton(
              onPressed: () async {
                bool isSuccess =
                    await FlutterEasemobKefu.register("test2", "123456");
                if (isSuccess) {
                  setState(() {
                    state = KefuState.Registered;
                  });
                }
              },
              child: Text('注册'),
            ),
            ElevatedButton(
              onPressed: () async {
                bool isSuccess =
                    await FlutterEasemobKefu.login("test2", "123456");
                if (isSuccess) {
                  setState(() {
                    state = KefuState.Logined;
                  });
                }
              },
              child: Text('登录'),
            ),
            ElevatedButton(
              onPressed: () async {
                bool isSuccess = await FlutterEasemobKefu.logout();
                if (isSuccess) {
                  setState(() {
                    state = KefuState.Logout;
                  });
                }
              },
              child: Text('退出'),
            ),
            ElevatedButton(
              onPressed: () async {
                bool isLogin = await FlutterEasemobKefu.isLogin;
                print(isLogin);
                if (isLogin) {
                  FlutterEasemobKefu.jumpToPage(
                    "kefuchannelimid_063438",
                    email: '2660038273@qq.com',
                    titleName: '测试客服',
                  );
                }
              },
              child: Text('去会话'),
            )
          ],
        ),
      ),
    );
  }
}
