//
//  JHNetWorkTools.h
//  AFNRequestTool
//
//  Created by Jivan on 2017/3/2.
//  Copyright © 2017年 Jivan. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailedBlock)(NSError*error);

#define BASE_URL @"http://112.74.100.122:9087/hct/api/"
#pragma mark 网络请求类型

typedef NS_ENUM(NSInteger,HTTPMETHOD)
{
    METHOD_GET   = 0,    //GET请求
    METHOD_POST  = 1,    //POST请求
};


@interface JHNetWorkTools : NSObject


/**
 *  类方法
 */
+ (JHNetWorkTools *)sharedUtil;

/**
 * iOS自带网络请求框架
 */
+ (void)requestURL:(NSString *)urlstring httpMethod:(NSInteger)method params:(NSMutableDictionary *)params complection:(SuccessBlock)SuccessBlock failed:(FailedBlock)failedBlock;
/**
 *  AF数据请求(HTTP)
 */
+(void)requestAFURL:(NSString *)URLString httpMethod:(NSInteger)method parameters:(id)parameters succeed:(SuccessBlock)successBlock failure:(FailedBlock)failedBlock;

/**
 *  AF 网络请求（HTTPS）
 */
+ (void)requestAFURL:(NSString *)URLString httpMethod:(NSInteger)method Signature:(NSString *)signature Parameters:(NSDictionary *)parameters RequestTimes:(float)requestTimes succeed:(SuccessBlock)successBlock failure:(FailedBlock)failedBlock;
/**
 * 上传单张图片
 */
+(void)requestAFURL:(NSString *)URLString parameters:(id)parameters imageData:(NSData *)imageData succeed:(SuccessBlock)successBlock failure:(FailedBlock)failedBlock;


/**
 * 上传多张图片
 */
+(void)requestAFURL:(NSString *)URLString parameters:(id)parameters  imageDataArray:(NSArray *)imageDataArray succeed:(SuccessBlock)successBlock failure:(FailedBlock)failedBlock;

/**
 * 上传文件
 */
+(void)requestAFURL:(NSString *)URLString parameters:(id)parameters fileData:(NSData *)fileData succeed:(SuccessBlock)successBlock  failure:(FailedBlock)failedBlock;

/*json
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


/*json
 * @brief 把字典转换成字符串
 * @param jsonString JSON格式的字符串
 * @return 返回字符串
 */
+(NSString*)URLEncryOrDecryString:(NSDictionary *)paramDict IsHead:(BOOL)_type;

@end
