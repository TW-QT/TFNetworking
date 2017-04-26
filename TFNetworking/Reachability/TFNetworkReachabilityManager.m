//
//  TFNetworkReachabilityManager.m
//  TFNetworking
//
//  Created by Donkey-Tao on 2016/5/12.
//  Copyright © 2016年 http://taofei.me All rights reserved.


#import "TFNetworkReachabilityManager.h"
#if !TARGET_OS_WATCH

#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>


@interface TFNetworkReachabilityManager ()

@end

@implementation TFNetworkReachabilityManager


+ (instancetype)sharedManager {
    static TFNetworkReachabilityManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [self manager];
    });
    
    return _sharedManager;
}

-(void)start{

    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    //开启监听，记得开启，不然不走block
    [manager startMonitoring];
    //2.监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                NSLog(@"当前网络状态未知");
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                
                NSLog(@"当前网络不可用");

            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSLog(@"当前网络为:3G|4G");
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"当前使用的WiFi");
            }
                break;
            default:
                break;
        }
    }];



}

@end
#endif
