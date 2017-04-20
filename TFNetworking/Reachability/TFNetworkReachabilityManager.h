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


@end

NS_ASSUME_NONNULL_END
#endif
