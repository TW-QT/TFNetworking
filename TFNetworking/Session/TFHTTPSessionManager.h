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

/**
 * @brief iOS自带网络请求框架
 * @param urlstring URL地址的字符串
 * @param method URL地址的字符串
 * @param params 请求中使用的参数
 * @param SuccessBlock 请求成功的回调
 * @param failedBlock 请求失败的回调
 */
+ (void)requestURL:(NSString *)urlstring httpMethod:(NSInteger)method params:(NSMutableDictionary *)params complection:(SuccessBlock)SuccessBlock failed:(FailedBlock)failedBlock;

/**
 * @brief AFNetworking数据请求(HTTP)
 * @param URLString URL地址的字符串
 * @param method URL地址的字符串
 * @param parameters 请求中使用的参数
 * @param successBlock 请求成功的回调
 * @param failedBlock 请求失败的回调
 */
+(void)requestAFURL:(NSString *)URLString httpMethod:(NSInteger)method parameters:(id)parameters succeed:(SuccessBlock)successBlock failure:(FailedBlock)failedBlock;

/**
 * @brief AFNetworking网络请求(HTTPS)
 * @param URLString URL地址的字符串
 * @param method URL地址的字符串
 * @param parameters 请求中使用的参数
 * @param successBlock 请求成功的回调
 * @param failedBlock 请求失败的回调
 */
+ (void)requestAFURL:(NSString *)URLString httpMethod:(NSInteger)method Signature:(NSString *)signature Parameters:(NSDictionary *)parameters RequestTimes:(float)requestTimes succeed:(SuccessBlock)successBlock failure:(FailedBlock)failedBlock;



#pragma mark - 上传图片

/**
 * @brief 上传单张图片
 * @param URLString URL地址的字符串
 * @param imageData URL地址的字符串
 * @param parameters 请求中使用的参数
 * @param successBlock 请求成功的回调
 * @param failedBlock 请求失败的回调
 */
+(void)requestAFURL:(NSString *)URLString parameters:(id)parameters imageData:(NSData *)imageData succeed:(SuccessBlock)successBlock failure:(FailedBlock)failedBlock;


/**
 * @brief 上传多张图片
 * @param URLString URL地址的字符串
 * @param parameters 请求中使用的参数
 * @param imageDataArray URL地址的字符串
 * @param successBlock 请求成功的回调
 * @param failedBlock 请求失败的回调
 */
+(void)requestAFURL:(NSString *)URLString parameters:(id)parameters  imageDataArray:(NSArray *)imageDataArray succeed:(SuccessBlock)successBlock failure:(FailedBlock)failedBlock;


/**
 * @brief 上传文件
 * @param URLString URL地址的字符串
 * @param parameters 请求中使用的参数
 * @param fileData URL地址的字符串
 * @param successBlock 请求成功的回调
 * @param failedBlock 请求失败的回调
 */
+(void)requestAFURL:(NSString *)URLString parameters:(id)parameters fileData:(NSData *)fileData succeed:(SuccessBlock)successBlock  failure:(FailedBlock)failedBlock;



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
