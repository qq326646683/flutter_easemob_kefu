#import "FlutterEasemobKefuPlugin.h"

@implementation FlutterEasemobKefuPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_easemob_kefu"
            binaryMessenger:[registrar messenger]];
  FlutterEasemobKefuPlugin* instance = [[FlutterEasemobKefuPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"getPlatformVersion" isEqualToString:call.method]) {
    result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
  } else {
  //
    result(FlutterMethodNotImplemented);
  }
}

@end
