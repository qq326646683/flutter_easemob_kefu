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
  if ([@"setConfig" isEqualToString:call.method]) {
      [self setConfig:call result:result];
  } else {
  //
    result(FlutterMethodNotImplemented);
  }
}

- (void)setConfig:(FlutterMethodCall *)call result:(FlutterResult)result{
    HDOptions *option = [[HDOptions alloc] init];
    option.appkey = @"1439201009092337#kefuchannelapp86399"; // 必填项，appkey获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面的关联的“AppKey”
    option.tenantId = @"86399";// 必填项，tenantId获取地址：kefu.easemob.com，“管理员模式 > 设置 > 企业信息”页面的“租户ID”
    //推送证书名字
//    option.apnsCertName = @"your apnsCerName";//(集成离线推送必填)
    //Kefu SDK 初始化,初始化失败后将不能使用Kefu SDK
    HDError *initError = [[HDClient sharedClient] initializeSDKWithOptions:option];
    if (initError) { // 初始化错误
        
    }
    NSLog(@"initerror=%@",initError);
    [self registerUser];
}

- (void)registerUser{
//    HDError *error = [[HDClient sharedClient] registerWithUsername:@"yunio_wouter" password:@"123456"];
//    NSLog(@"resisterError=%@", error);
    [self loginUser];
}

- (void)loginUser{
    HDClient *client = [HDClient sharedClient];
    if (client.isLoggedInBefore != YES) {
        HDError *error = [client loginWithUsername:@"yunio_wouter" password:@"123456"];
        NSLog(@"这里是登录的error%@",error.errorDescription);
        if (!error) { //登录成功
        } else { //登录失败
            return;
        }
    }
    NSLog(@"这里是准备跳转");
//    UIViewController *viewctl = [[UIViewController alloc] init];
    // 进入会话页面
    HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:@"kefuchannelimid_316626"]; // 获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面的关联的“IM服务号”
    UIViewController *viewController =
        [UIApplication sharedApplication].delegate.window.rootViewController;
    UINavigationController *NAV = [[UINavigationController alloc] initWithRootViewController:chatVC];
    [viewController presentViewController:NAV animated:YES completion:nil];
}

@end
