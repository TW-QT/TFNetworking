//
//  TFNetWorkingManager.h
//  TFNetworking
//
//  Created by Donkey-Tao on 2016/5/12.
//  Copyright © 2016年 http://taofei.me All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

typedef void (^SuccessBlock)(id responseObject);
typedef void (^FailedBlock)(NSError*error);

#define BASE_URL @"http://112.74.100.122:9087/hct/api/"
#pragma mark 网络请求类型

typedef NS_ENUM(NSInteger,HTTPMETHOD)
{
    METHOD_GET   = 0,    //GET请求
    METHOD_POST  = 1,    //POST请求
};


@interface TFNetWorkingManager : NSObject


#pragma mark - 获取TFNetworking的单例对象

/**
 TFNetworking总的管理者
 
 @return TFNetworking总的管理者单例对象
 */
+ (TFNetWorkingManager *)sharedUtil;






#pragma mark - 网络请求方法

/**
 iOS自带网络请求框架
 
 @param urlstring 网络请求的URL地址字符串
 @param method 网络请求的方式：GET/POST
 @param params 网络请求的参数
 @param SuccessBlock 网络请求成功的回调
 @param failedBlock 网络请求失败的回调
 */
+ (void)requestURL:(NSString *)urlstring httpMethod:(NSInteger)method params:(NSMutableDictionary *)params complection:(SuccessBlock)SuccessBlock failed:(FailedBlock)failedBlock;


/**
 AF网络请求 (HTTP)
 
 @param URLString 网络请求的URL地址字符串
 @param method 网络请求的方式：GET/POST
 @param parameters 网络请求的参数
 @param successBlock 网络请求成功的回调
 @param failedBlock 网络请求失败的回调
 */
+(void)requestAFURL:(NSString *)URLString httpMethod:(NSInteger)method parameters:(id)parameters succeed:(SuccessBlock)successBlock failure:(FailedBlock)failedBlock;


/**
 AF 网络请求（HTTPS）
 
 @param URLString 网络请求的URL地址字符串
 @param method 网络请求的方式：GET/POST
 @param signature HTTPS证书的名称
 @param parameters 网络请求的参数
 @param requestTimes 网络请求的时间
 @param successBlock 网络请求成功的回调
 @param failedBlock 网络请求失败的回调
 */
+ (void)requestAFURL:(NSString *)URLString httpMethod:(NSInteger)method Signature:(NSString *)signature Parameters:(NSDictionary *)parameters RequestTimes:(float)requestTimes succeed:(SuccessBlock)successBlock failure:(FailedBlock)failedBlock;




#pragma mark - 上传图片

/**
 上传单张图片
 
 @param URLString URL字符串
 @param parameters 网络请求参数
 @param imageData 上传的图片数据
 @param successBlock 网络请求成功的回调
 @param failedBlock 网络请求失败的回调
 */
+(void)requestAFURL:(NSString *)URLString parameters:(id)parameters imageData:(NSData *)imageData succeed:(SuccessBlock)successBlock failure:(FailedBlock)failedBlock;


/**
 上传多张图片
 
 @param URLString URL字符串
 @param parameters 网络请求参数
 @param imageDataArray 上传的图片数组
 @param successBlock 网络请求成功的回调
 @param failedBlock 网络请求失败的回调
 */
+(void)requestAFURL:(NSString *)URLString parameters:(id)parameters  imageDataArray:(NSArray *)imageDataArray succeed:(SuccessBlock)successBlock failure:(FailedBlock)failedBlock;


/**
 上传文件
 
 @param URLString URL字符串
 @param parameters 网络请求参数
 @param fileData 上传的文件数据
 @param successBlock 网络请求成功的回调
 @param failedBlock 网络请求失败的回调
 */
+(void)requestAFURL:(NSString *)URLString parameters:(id)parameters fileData:(NSData *)fileData succeed:(SuccessBlock)successBlock  failure:(FailedBlock)failedBlock;





#pragma mark - 字符串与JSON的转换

/**
 把格式化的JSON格式的字符串转换成字典
 
 @param jsonString JSON格式的字符串
 @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


/**
 把字典转换成字符串
 
 @param paramDict 字典
 @param _type
 @return 返回字典对应的字符串
 */
+(NSString*)URLEncryOrDecryString:(NSDictionary *)paramDict IsHead:(BOOL)_type;

@end
