//
//  TFHTTPSessionManager.m
//  TFNetworking
//
//  Created by Donkey-Tao on 2016/5/12.
//  Copyright © 2016年 http://taofei.me All rights reserved.

#import "TFHTTPSessionManager.h"

#import "AFURLRequestSerialization.h"
#import "AFURLResponseSerialization.h"

#import <Availability.h>
#import <TargetConditionals.h>
#import <Security/Security.h>

#import <netinet/in.h>
#import <netinet6/in6.h>
#import <arpa/inet.h>
#import <ifaddrs.h>
#import <netdb.h>

#if TARGET_OS_IOS || TARGET_OS_TV
#import <UIKit/UIKit.h>
#elif TARGET_OS_WATCH
#import <WatchKit/WatchKit.h>
#endif


@implementation TFHTTPSessionManager


/** 创建并初始化TFHTTPSessionManager类型的HTTPS请求对象 */
+(instancetype)httpsSessionManager{

    //1.创建TFHTTPSessionManager类型的对象
    NSString *baseURLString=[TFNetWorkingManager sharedManager].tf_BaseURLString;
    NSURL *baseURL=[NSURL URLWithString:baseURLString];
    TFHTTPSessionManager *tf_HttpsSessionManager=[[TFHTTPSessionManager alloc]initWithBaseURL:baseURL];
    //2.设置tf_HttpsSessionManager的安全策略
    [self setupSecurityPolicyForTFHttpsSessionManager:tf_HttpsSessionManager];
    //3.设置tf_HttpsSessionManager的请求和返回
    [self setupRequestAndResponseSerializerForTFHttpsSessionManager:tf_HttpsSessionManager];
    return tf_HttpsSessionManager;
}

/** 设置tf_HttpsSessionManager的安全策略 */
+(void)setupSecurityPolicyForTFHttpsSessionManager:(TFHTTPSessionManager *)tf_HttpsSessionManager{
    
    NSString * certificateString=[TFNetWorkingManager sharedManager].certificateString;
    //设置安全策略
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificateString ofType:@"cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    //tf_HttpsSessionManager.securityPolicy=[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//AFSSLPinningModeCertificate
    tf_HttpsSessionManager.securityPolicy=[AFSecurityPolicy defaultPolicy];
    tf_HttpsSessionManager.securityPolicy.allowInvalidCertificates=YES;//设置允许使用证书
    tf_HttpsSessionManager.securityPolicy.validatesDomainName=NO;//是否需要验证域名
    tf_HttpsSessionManager.securityPolicy.pinnedCertificates=[NSSet setWithObject:cerData];
}

/** 设置tf_HttpsSessionManager请求和返回的Serializer */
+(void)setupRequestAndResponseSerializerForTFHttpsSessionManager:(TFHTTPSessionManager *)tf_HttpsSessionManager{
    //初始化网络请求的设置
    tf_HttpsSessionManager.requestSerializer.timeoutInterval = 30.0;//默认设置请求的超时时间为30s
    tf_HttpsSessionManager.responseSerializer.stringEncoding=NSUTF8StringEncoding;
    
    //初始化网络请求返回的设置
    tf_HttpsSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    tf_HttpsSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",@"image/jpeg", nil];
}


#pragma mark - 网络请求方法


/**
 TFNetworking-TFHTTPSessionManager 网络请求（HTTPS）
 
 @param URLString 网络请求的URL地址字符串
 @param method 网络请求的方式：GET/POST
 @param parameters 网络请求的参数
 @param successBlock 网络请求成功的回调
 @param failedBlock 网络请求失败的回调
 */
+(void)tf_RequestURLString:(NSString *)URLString HttpMethod:(NSInteger)method  Parameters:(NSDictionary *)parameters  succeed:(SuccessBlock)successBlock failure:(FailedBlock)failedBlock{
    
    //1.创建HTTPS的session管理者
    TFHTTPSessionManager *manager=[TFHTTPSessionManager httpsSessionManager];
    //2.证书的名称
    NSString * certificateString=[TFNetWorkingManager sharedManager].certificateString;
    //3.如果URLString里面是有效的URL地址
    if (URLString != nil){
        typeof (manager) weakManager = manager ;
        [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *_credential) {
            
            //3.1获取服务器的 trust object
            SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
            
            //3.2导入自签名证书
            NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificateString ofType:@"cer"];
            NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
            
            if (!cerData) {
                NSLog(@"TFNetWorking处理时证书文件未获取到，.cer文件为空");
                return 0;
            }
            
            weakManager.securityPolicy.pinnedCertificates = [NSSet setWithArray:@[cerData]];
            SecCertificateRef caRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cerData);
            NSCAssert(caRef != nil, @"caRef is nil");
            
            NSArray *caArray = @[(__bridge id)(caRef)];
            NSCAssert(caArray != nil, @"caArray is nil");
            
            //3.3将读取到的证书设置为serverTrust的根证书
            OSStatus status = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)caArray);
            SecTrustSetAnchorCertificatesOnly(serverTrust, NO);
            NSCAssert(errSecSuccess == status, @"SectrustSetAnchorCertificates failed");
            NSLog(@"status=%d",(int)status);
            
            //3.4选择质询认证的处理方式
            NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            __autoreleasing NSURLCredential *credential = nil;
            
            //3.5NSURLAuthenTicationMethodServerTrust质询认证方式
            if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
                //基于客户端的安全策略来决定是否信任该服务器，不信任则不响应质询
                if ([weakManager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                    
                    //创建质询证书
                    credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                    if (credential) {//确认质询方式
                        disposition = NSURLSessionAuthChallengeUseCredential;
                    } else {
                        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                    }
                } else {//取消挑战
                    disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
                }
            } else {
                disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            }
            return disposition;
        }];
    }else{
        NSLog(@"URLString为nil，被TFNetWorking拦截，网络请求未发送");
        return;
    }
    
    if (method == TF_HTTPSMETHOD_GET){//发送GET请求
        [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock){
                NSString *responseStr =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                successBlock([TFHTTPSessionManager dictionaryWithJsonString:responseStr]);
            }else{
                NSLog(@"TFNetWorking发送GET请求时失败，链接异常或网络不存在");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failedBlock(error);
            NSLog(@"TFNetworking-请求-GET-请求失败-error=%@",error);
        }];
    }else if (method == TF_HTTPSMETHOD_POST){//发送POST请求
        [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock){
                //1.网络请求成功后错误信息的处理
                NSData *data = (NSData *)responseObject;
                NSDictionary* adict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                [self tf_processingErrorInfoWithDictionary:adict];
                
                //2.返回处理得到的字典
                NSString *responseStr =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                successBlock([TFHTTPSessionManager dictionaryWithJsonString:responseStr]);
            }else{
                NSLog(@"TFNetWorking发送POST请求时失败，链接异常或网络不存在");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failedBlock(error);
            NSLog(@"TFNetworking-请求-POST-请求失败-error=%@",error);
        }];
    }
}

#pragma mark - 网络请求错误的处理

/**
 处理网络请求成功的的错误请求信息处理

 @param errorInfo 网络请求返回的字典
 */
+(void)tf_processingErrorInfoWithDictionary:(NSDictionary *)errorInfo{


    NSLog(@"TFNetworking-网络请求成功-处理相关错误信息中-");
    NSLog(@"errorInfo--%@",errorInfo);
    NSLog(@"description--%@",errorInfo[@"data"][@"description"]);
}






#pragma mark - 字符串与JSON的转换

/**
 把格式化的JSON格式的字符串转换成字典
 
 @param jsonString JSON格式的字符串
 @return 返回字典
 */
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
        NSLog(@"JSON解析失败：%@",error);
        return nil;
    }
    return dic;
}


/**
 把字典转换成字符串
 
 @param paramDict 字典
 @param _type 类型
 @return 返回字典对应的字符串
 */
+(NSString*)URLEncryOrDecryString:(NSDictionary *)paramDict IsHead:(BOOL)_type
{
    
    NSArray *keyAry =  [paramDict allKeys];
    NSString *encryString = @"";
    for (NSString *key in keyAry)
    {
        NSString *keyValue = [paramDict valueForKey:key];
        encryString = [encryString stringByAppendingFormat:@"&"];
        encryString = [encryString stringByAppendingFormat:@"%@",key];
        encryString = [encryString stringByAppendingFormat:@"="];
        encryString = [encryString stringByAppendingFormat:@"%@",keyValue];
    }
    return encryString;
}


@end
