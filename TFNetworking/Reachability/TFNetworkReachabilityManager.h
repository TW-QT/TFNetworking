//
//  TFNetworkReachabilityManager.h
//  TFNetworking
//
//  Created by Donkey-Tao on 2016/5/12.
//  Copyright © 2016年 http://taofei.me All rights reserved.

#import <Foundation/Foundation.h>
#import <AFNetworkReachabilityManager.h>

#if !TARGET_OS_WATCH
#import <SystemConfiguration/SystemConfiguration.h>


NS_ASSUME_NONNULL_BEGIN

@interface TFNetworkReachabilityManager : AFNetworkReachabilityManager



/**
 创建或者返回网络状态管理者对象

 @return 网络状态管理者单例
 */
+ (instancetype)sharedManager;


/**
 开始通过网络状态管理者单例来监听当前的网络状态
 */
-(void)start;

@end

NS_ASSUME_NONNULL_END
#endif
