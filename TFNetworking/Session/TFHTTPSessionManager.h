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
#import "TFNetWorkingManager.h"



NS_ASSUME_NONNULL_BEGIN



/** 网络请求成功的回调 */
typedef void (^SuccessBlock)(id responseObject);
/** 网络请求失败的回调 */
typedef void (^FailedBlock)(NSError*error);


@interface TFHTTPSessionManager : AFHTTPSessionManager


/** 创建并初始化TFHTTPSessionManager类型的HTTPS请求对象 */
+(instancetype)httpsSessionManager;



/**
 TFNetworking 网络请求（HTTPS）
 
 @param URLString 网络请求的URL地址字符串
 @param method 网络请求的方式：GET/POST
 @param parameters 网络请求的参数
 @param successBlock 网络请求成功的回调
 @param failedBlock 网络请求失败的回调
 */
+ (void)tf_RequestURLString:(NSString *)URLString HttpMethod:(NSInteger)method  Parameters:(NSDictionary *)parameters  succeed:(SuccessBlock)successBlock failure:(FailedBlock)failedBlock;


@end

NS_ASSUME_NONNULL_END
