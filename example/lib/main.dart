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

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

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
            RaisedButton(
              onPressed: () {
                FlutterEasemobKefu.init("1439201009092337#kefuchannelapp86399", "86399");
              },
              child: Text('初始化'),
            ),
            RaisedButton(
              onPressed: () {
                FlutterEasemobKefu.register("nell", "123456");
              },
              child: Text('注册'),
            ),
            RaisedButton(
              onPressed: () {
                FlutterEasemobKefu.login("nell", "123456");
              },
              child: Text('登录'),
            ),
            RaisedButton(
              onPressed: () async {
                bool isLogin = await FlutterEasemobKefu.isLogin;
                if (isLogin) {
                  FlutterEasemobKefu.jumpToPage("1439201009092337#kefuchannelapp86399");
                }
              },
              child: Text('去会话'),
            ),
          ],
        ),
      ),
    );
  }
}
