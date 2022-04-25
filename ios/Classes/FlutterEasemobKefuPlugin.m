#import "FlutterEasemobKefuPlugin.h"
#import <HDSDKHelper.h>
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
      [self registerUser:call result:result];
  } else if ([@"login" isEqualToString:call.method]) {
      [self loginUser:call result:result];
  } else if ([@"isLogin" isEqualToString:call.method]) {
      [self checkLogin:result];
  } else if ([@"logout" isEqualToString:call.method]) {
      [self loginOut:result];
  } else if ([@"jumpToPage" isEqualToString:call.method]) {
      [self jumpToChat:call result:result];
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
        //添加自定义小表情
    #pragma mark smallpngface
        [[HDEmotionEscape sharedInstance] setEaseEmotionEscapePattern:@"\\[[^\\[\\]]{1,3}\\]"];
        [[HDEmotionEscape sharedInstance] setEaseEmotionEscapeDictionary:[HDConvertToCommonEmoticonsHelper emotionsDictionary]];
}

- (void)registerUser:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *arguments = call.arguments;
    HDError *error = [[HDClient sharedClient] registerWithUsername:arguments[@"username"] password:arguments[@"password"]];
    if(error.code == HDErrorUserAlreadyExist || !error){
        result([NSNumber numberWithBool:YES]);
    }else{
        result([NSNumber numberWithBool:NO]);
    }
}

- (void)loginUser:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSDictionary *arguments = call.arguments;
    HDClient *client = [HDClient sharedClient];
    HDError *error = [client loginWithUsername:arguments[@"username"] password:arguments[@"password"]];
    if(error.code == HDErrorUserAlreadyLogin || !error){
        result([NSNumber numberWithBool:YES]);
    }else{
        result([NSNumber numberWithBool:NO]);
    }

}

- (void)jumpToChat:(FlutterMethodCall *)call result:(FlutterResult)result{
    NSDictionary *arguments = call.arguments;
    NSString *titleName = call.arguments[@"titleName"];
    // 进入会话页面
    HDMessageViewController *chatVC = [[HDMessageViewController alloc] initWithConversationChatter:arguments[@"imNumber"] titleName:titleName]; // 获取地址：kefu.easemob.com，“管理员模式 > 渠道管理 > 手机APP”页面的关联的“IM服务号”
    NSString *email = call.arguments[@"email"];
    if (email.length != 0) {
        HDAgentIdentityInfo *agentInfo =[[HDAgentIdentityInfo alloc] initWithValue:email];
        chatVC.agent = agentInfo;
    }
    NSString *queueName = call.arguments[@"queueName"];
    if (queueName.length != 0) {
        HDQueueIdentityInfo *queueInfo=[[HDQueueIdentityInfo alloc] initWithValue:queueName];
        chatVC.queueInfo = queueInfo;
    }
    UINavigationController *NAV = [[UINavigationController alloc] initWithRootViewController:chatVC];
    UIViewController *rootViewController = [[UIApplication sharedApplication].delegate window].rootViewController;
    NAV.modalPresentationStyle = 0;
    [rootViewController presentViewController:NAV animated:YES completion:nil];

}
 
- (UIViewController *)visibleViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].delegate.window.rootViewController;
    return [self getVisibleViewControllerFrom:rootViewController];
}
 
- (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
 
}
 
- (UINavigationController *)visibleNavigationController {
    return [[self visibleViewController] navigationController];
}
- (void)checkLogin:(FlutterResult)result{
    if([HDClient sharedClient].isLoggedInBefore) {
         //已经登录
        result([NSNumber numberWithBool:YES]);
    }else{
        result([NSNumber numberWithBool:NO]);
    }
}

- (void)loginOut:(FlutterResult)result{
    //参数为是否解绑推送的devicetoken
    HDError *error = [[HDClient sharedClient] logout:YES];
    if (error) { //登出出错
        result([NSNumber numberWithBool:NO]);
    } else {//登出成功
        result([NSNumber numberWithBool:YES]);
    }
}

@end
