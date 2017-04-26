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


/**
 * @brief 定义枚举类型的网络请求类型：GET OR POST
 * TF_HTTPSMETHOD_GET: 网络请求方式为GET
 * TF_HTTPSMETHOD_POST: 网络请求方式为POST
 */
typedef NS_ENUM(NSInteger,TF_HTTPSMETHOD)
{
    TF_HTTPSMETHOD_GET   = 0,
    TF_HTTPSMETHOD_POST  = 1,
};



/**
 网络请求成功的回调

 @param responseDictionary 返回从服务器返回的数据的NSDictionary类型
 */
typedef void (^SuccessBlock)(NSDictionary * responseDictionary);
/** 网络请求失败的回调 */
typedef void (^FailedBlock)(NSError *error);


@interface TFHTTPSessionManager : AFHTTPSessionManager


/** 创建并初始化TFHTTPSessionManager类型的HTTPS请求对象 */
+(instancetype)httpsSessionManager;







#pragma mark - 网络请求方法



/**
 TFNetworking 网络请求（HTTPS）
 
 @param URLString 网络请求的URL地址字符串
 @param method 网络请求的方式：GET/POST
 @param parameters 网络请求的参数
 @param successBlock 网络请求成功的回调
 @param failedBlock 网络请求失败的回调
 */
+ (void)tf_RequestURLString:(NSString *)URLString HttpMethod:(NSInteger)method  Parameters:(NSDictionary *)parameters  succeed:(SuccessBlock)successBlock failure:(FailedBlock)failedBlock;





#pragma mark - 字符串与JSON的转换

/**
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


/**
 * @brief 把字典转换成字符串
 * @param paramDict 字典
 * @param _type 类型
 * @return 返回字符串
 */
+(NSString*)URLEncryOrDecryString:(NSDictionary *)paramDict IsHead:(BOOL)_type;



@end

NS_ASSUME_NONNULL_END
