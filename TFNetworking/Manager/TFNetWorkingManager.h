//
//  TFNetWorkingManager.h
//  TFNetworking
//
//  Created by Donkey-Tao on 2016/5/12.
//  Copyright © 2016年 http://taofei.me All rights reserved.


#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "TFNetworking.h"


#define openHttpsSSL YES

NS_ASSUME_NONNULL_BEGIN


///---------------------------------------------------
/// @name Some Preferences Infomation
///---------------------------------------------------

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
/** 网络请求成功的回调 */
typedef void (^SuccessBlock)(id responseObject);
/** 网络请求失败的回调 */
typedef void (^FailedBlock)(NSError*error);



///----------------------------------------------------
/// @name Method declarations of TFNetWorkingManager
///----------------------------------------------------

/** TFNetWorkingManager是继承自TFHTTPSessionManager的子类，是在TFHTTPSessionManager基础上进行的封装。 */
@interface TFNetWorkingManager : NSObject

#pragma mark - TFNetworkingManager的属性


/** TFHTTPSessionManager是TFNetworkingManager的一个最重要的属性 */
@property (nonatomic, strong, nullable) AFHTTPSessionManager *tf_HttpsSessionManager;
/** 证书名的字符串 */
@property (nonatomic, strong, nullable) NSString *certificateString;
/** 整个项目的网络请求的URL的基地址 */
@property (nonatomic, strong, nullable) NSString *tf_BaseURLString;
/* 网络是否可用 */
@property (nonatomic, assign, nullable) BOOL *hasNet;
/* 是否已经登录 */
@property (nonatomic, assign, nullable) BOOL *isLogin;



#pragma mark - 获取TFNetworking的单例对象
/**
 * @brief TFNetworkingManager的类方法，创建并获取TFNetworkingManager的单例对象
 * @return 返回类型为TFNetWorkingManager的单例对象
 */
+ (instancetype)sharedManager;




@end


NS_ASSUME_NONNULL_END
