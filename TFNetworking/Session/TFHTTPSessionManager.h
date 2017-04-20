//
//  TFHTTPSessionManager.h
//  TFNetworking
//
//  Created by Donkey-Tao on 2016/5/12.
//  Copyright © 2016年 http://taofei.me All rights reserved.


#import <Foundation/Foundation.h>
#if !TARGET_OS_WATCH
#import <SystemConfiguration/SystemConfiguration.h>
#endif
#import <TargetConditionals.h>

#if TARGET_OS_IOS || TARGET_OS_WATCH || TARGET_OS_TV
#import <MobileCoreServices/MobileCoreServices.h>
#else
#import <CoreServices/CoreServices.h>
#endif

#import "AFHTTPSessionManager.h"



NS_ASSUME_NONNULL_BEGIN

@interface TFHTTPSessionManager : AFHTTPSessionManager





@end

NS_ASSUME_NONNULL_END
