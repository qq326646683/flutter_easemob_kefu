#import "FlutterEasemobKefuPlugin.h"
#import <HelpDeskLite/HelpDeskLite.h>
#import <HyphenateLite/HyphenateLite.h>
#import "HelpDeskUI.h"

@implementation FlutterEasemobKefuPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_easemob_kefu"
            binaryMessenger:[registrar messenger]];
  FlutterEasemobKefuPlugin* instance = [[FlutterEasemobKefuPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"init" isEqualToString:call.method]) {
      [self init:call result:result];
  } else if ([@"register" isEqualToString:call.method]) {
      [self registerUser:call];
  } else if ([@"login" isEqualToString:call.method]) {
      [self loginUser:call];
  } else if ([@"isLogin" isEqualToString:call.method]) {
      [self checkLogin];
  } else if ([@"logout" isEqualToString:call.method]) {
      [self loginOut];
  } else if ([@"jumpToPage" isEqualToString:call.method]) {
      [self jumpToChat:call];
  }
}

- (void)init:(FlutterMethodCall *)call result:(FlutterResult)result{
    HDOptions *option = [[HDOptions alloc] init];
    NSDictionary *arguments = call.arguments;
    option.appkey = arguments[@"appKey"]; // 必填项，appkey获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面的关联的“AppKey”
    option.tenantId = arguments[@"tenantId"];// 必填项，tenantId获取地址：kefu.easemob.com，“管理员模式 > 设置 > 企业信息”页面的“租户ID”
    //推送证书名字
//    option.apnsCertName = @"your apnsCerName";//(集成离线推送必填)
    //Kefu SDK 初始化,初始化失败后将不能使用Kefu SDK
    HDError *initError = [[HDClient sharedClient] initializeSDKWithOptions:option];
    if (initError) { // 初始化错误
        
    }
    NSLog(@"initerror=%@",initError);
}

- (void)registerUser:(FlutterMethodCall *)call {
    NSDictionary *arguments = call.arguments;
    HDError *error = [[HDClient sharedClient] registerWithUsername:arguments[@"username"] password:arguments[@"password"]];
    NSLog(@"resisterError=%@", error);
}

- (void)loginUser:(FlutterMethodCall *)call {
    NSDictionary *arguments = call.arguments;
    NSLog(@"name=%@---pwd=%@",arguments[@"username"],arguments[@"password"]);
    HDClient *client = [HDClient sharedClient];
    NSLog(@"1111111");
    if (client.isLoggedInBefore != YES) {
        NSLog(@"22222222");
        HDError *error = [client loginWithUsername:arguments[@"username"] password:arguments[@"password"]];
        NSLog(@"这里是登录的error%@",error.errorDescription);
        if (!error) { //登录成功
        } else { //登录失败
            return;
        }
    }

}

- (void)jumpToChat:(FlutterMethodCall *)call{
    NSLog(@"这里是跳转聊天");
    NSDictionary *arguments = call.arguments;
    // 进入会话页面
    HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:arguments[@"imNumber"]]; // 获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面的关联的“IM服务号”
    UIViewController *viewController =
        [UIApplication sharedApplication].delegate.window.rootViewController;
    UINavigationController *NAV = [[UINavigationController alloc] initWithRootViewController:chatVC];
    [viewController presentViewController:NAV animated:YES completion:nil];
}

- (void)checkLogin{
    if([HDClient sharedClient].isLoggedInBefore) {
         //已经登录
    }else{
         //未登录
    }
}

- (void)loginOut{
    //参数为是否解绑推送的devicetoken
    HDError *error = [[HDClient sharedClient] logout:YES];
    if (error) { //登出出错
    } else {//登出成功
    }
}

@end
