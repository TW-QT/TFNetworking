//
//  TFNetWorkingManager.m
//  TFNetworking
//
//  Created by Donkey-Tao on 2016/5/12.
//  Copyright © 2016年 http://taofei.me All rights reserved.


#import "TFNetWorkingManager.h"



@implementation TFNetWorkingManager




#pragma mark - 获取TFNetworking的单例对象

/** TFNetworking总的管理者 */
+ (TFNetWorkingManager *)sharedManager {
    
    static dispatch_once_t  onceToken;
    static TFNetWorkingManager * setSharedInstance;
    dispatch_once(&onceToken, ^{//线程锁
        setSharedInstance = [[TFNetWorkingManager alloc] init];
    });
    return setSharedInstance;
}

#pragma mark -TFNetworkingManager类的单例对象的初始化
/** 在设置BaseURL时进行创建TFNetworkingManager的TFHTTPSessionManager类型的成员属性 */
-(void)setBaseURLString:(NSString * _Nullable)baseURLString{
    self.httpSessionManager=[[TFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:self.baseURLString] sessionConfiguration:nil];
    _baseURLString=baseURLString;
    NSLog(@"设置BaseURL基地址已经完成，请设置证书名称。");
}

/** 设置证书名字符串 */
-(void)setCertificateString:(NSString * _Nullable)certificateString{
    //设置安全策略
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:certificateString ofType:@"cer"];
    NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
    self.httpSessionManager.securityPolicy=[AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    self.httpSessionManager.securityPolicy.allowInvalidCertificates=YES;//设置允许使用证书
    self.httpSessionManager.securityPolicy.validatesDomainName=NO;//是否需要验证域名
    self.httpSessionManager.securityPolicy.pinnedCertificates=[NSSet setWithObject:cerData];
    _certificateString=certificateString;
    NSLog(@"证书名称设置完毕，并设置相关安全策略完成。");
    [self setRequestandResponseSerializer];
}

/** 设置请求和相应的Serializer */
-(void)setRequestandResponseSerializer{
    //初始化网络请求的设置
    [self.httpSessionManager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.httpSessionManager.requestSerializer.timeoutInterval = 30.0;//默认设置请求的超时时间为30s
    [self.httpSessionManager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
  
    //初始化网络请求返回的设置
    self.httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.httpSessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
}




/**
 TFNetworking 网络请求（HTTPS）
 
 @param URLString 网络请求的URL地址字符串
 @param method 网络请求的方式：GET/POST
 @param parameters 网络请求的参数
 @param successBlock 网络请求成功的回调
 @param failedBlock 网络请求失败的回调
 */
- (void)tf_RequestURLString:(NSString *)URLString HttpMethod:(NSInteger)method  Parameters:(NSDictionary *)parameters  succeed:(SuccessBlock)successBlock failure:(FailedBlock)failedBlock{
    
    // 1.获取TFHTTPSessionManager类型的属性对象
    TFHTTPSessionManager *manager = [TFNetWorkingManager sharedManager].httpSessionManager;
    
    // 2.设置URLString不同类型时的安全策略
    URLString == nil || [URLString isEqualToString:@""] ? (void)(manager.securityPolicy.allowInvalidCertificates = NO,manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]):(manager.securityPolicy.allowInvalidCertificates = YES,manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate]);
    
    //3.如果URLString里面是有效的URL地址
    if (URLString != nil){
        typeof (manager) weakManager = manager ;
        [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *_credential) {
            
            //3.1获取服务器的 trust object
            SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
            
            //3.2导入自签名证书
            NSString *cerPath = [[NSBundle mainBundle] pathForResource:self.certificateString ofType:@"cer"];
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
    
    if (method == METHOD_GET){//发送GET请求
        [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock){
                successBlock(responseObject);
            }else{
                NSLog(@"TFNetWorking发送GET请求时失败，链接异常或网络不存在");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failedBlock(error);
            NSLog(@"TFNetworking-请求-GET-请求失败-error=%@",error);
        }];
    }else if (method == METHOD_POST){//发送POST请求
        [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock){
                successBlock(responseObject);
            }else{
                NSLog(@"TFNetWorking发送POST请求时失败，链接异常或网络不存在");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failedBlock(error);
            NSLog(@"TFNetworking-请求-POST-请求失败-error=%@",error);
        }];
    }
}


#pragma mark - 网络请求方法


/**
 iOS自带网络请求框架
 
 @param urlstring 网络请求的URL地址字符串
 @param method 网络请求的方式：GET/POST
 @param params 网络请求的参数
 @param SuccessBlock 网络请求成功的回调
 @param failedBlock 网络请求失败的回调
 */
+ (void)requestURL:(NSString *)urlstring
        httpMethod:(NSInteger)method
            params:(NSMutableDictionary *)params
       complection:(SuccessBlock)SuccessBlock failed:(FailedBlock)failedBlock{
    
    //1.构造URL
    urlstring = [[TFNetWorkingManager sharedManager].baseURLString stringByAppendingString:urlstring];
    NSURL *url = [NSURL URLWithString:urlstring];

    
    //2.构造request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setTimeoutInterval:60];
    method?[request setHTTPMethod:@"POST"]:[request setHTTPMethod:@"GET"];
    //[request setHTTPMethod:method];
    
    //1>拼接请求参数:username=wxhl&password=123456&key=value&....
    NSMutableString *paramsString = [NSMutableString string];
    NSArray *allKeys = params.allKeys;
    for (int i=0; i<params.count; i++) {
        NSString *key = allKeys[i];
        NSString *value = params[key];
        
        [paramsString appendFormat:@"%@=%@",key,value];
        
        if (i < params.count-1) {
            [paramsString appendString:@"&"];
        }
    }
    
    //2>添加请求参数:
    /*
     请求参数的格式1： username=wxhl&password=123456&key=value&....
     请求参数的格式2 JSON：{username:wxhl,password:12345,....}
     */
    //将字典 ----> JSON字符串
    //JSONKit
    //    NSString *jsonString = [params JSONString];
    //    NSLog(@"%@",jsonString);
    
    
    /**
     *  判断请求方式：
     GET ： 参数拼接在URL后面
     POST ： 参数添加到请求体中
     */
    if (method == METHOD_GET) {
        
        NSString *separe = url.query?@"&":@"?";
        NSString *paramsURL = [NSString stringWithFormat:@"%@%@%@",urlstring,separe,paramsString];
        
        request.URL = [NSURL URLWithString:paramsURL];
    }
    else if(method == METHOD_POST) {
        
        NSData *bodyData = [paramsString dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:bodyData];
    }
    
    //3.构造连接对象
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (connectionError != nil) {
            NSLog(@"网络请求失败 : %@",connectionError);
            failedBlock(connectionError);
            return ;
        }
        
        //1.解析JSON
        // JSON字符串 ---> 字典、数组
        id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        //2.回到主线程
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            //回调block
            SuccessBlock(result);
            
        });
    }];
}



/**
 AF网络请求 (HTTP)
 
 @param URLString 网络请求的URL地址字符串
 @param method 网络请求的方式：GET/POST
 @param parameters 网络请求的参数
 @param successBlock 网络请求成功的回调
 @param failedBlock 网络请求失败的回调
 */
+(void)requestAFURL:(NSString *)URLString
         httpMethod:(NSInteger)method
         parameters:(id)parameters
            succeed:(SuccessBlock)successBlock
            failure:(FailedBlock)failedBlock
{
    // 0.设置API地址
    URLString = [NSString stringWithFormat:@"%@%@",[TFNetWorkingManager sharedManager].baseURLString,[URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    NSLog(@"\n AF网络请求参数列表:%@\n\n 接口名: %@\n\n",parameters,URLString);
    
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 30;
    
    // 5.选择请求方式 GET 或 POST
    switch (method) {
        case METHOD_GET:
        {
            [manager GET:URLString parameters:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSString *responseStr =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                successBlock([TFNetWorkingManager dictionaryWithJsonString:responseStr]);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                failedBlock(error);
            }];
        }
            break;
        case METHOD_POST:
        {
            [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                NSString *responseStr =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                successBlock([TFNetWorkingManager dictionaryWithJsonString:responseStr]);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                failedBlock(error);
            }];
        }
            break;
        default:
            break;
    }
}




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
+ (void)requestAFURL:(NSString *)URLString httpMethod:(NSInteger)method Signature:(NSString *)signature Parameters:(NSDictionary *)parameters RequestTimes:(float)requestTimes succeed:(SuccessBlock)successBlock failure:(FailedBlock)failedBlock{
    
    //是否允许使用自签名证书和证书验证模式
    AFSecurityPolicy *securityPolicy;
    
    URLString == nil || [URLString isEqualToString:@""] ? (void)(securityPolicy.allowInvalidCertificates = NO,securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone]):(securityPolicy.allowInvalidCertificates = YES,securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate]);
    //是否需要验证域名
    securityPolicy.validatesDomainName = NO;
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    manager = [[AFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:URLString]];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy = securityPolicy;
    
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = requestTimes;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    if (URLString != nil){
        
        typeof (manager) weakManager = manager ;
        [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *_credential) {
            
            //获取服务器的 trust object
            SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
            
            //导入自签名证书
            NSString *cerPath = [[NSBundle mainBundle] pathForResource:signature ofType:@"cer"];
            NSData *cerData = [NSData dataWithContentsOfFile:cerPath];
            
            if (!cerData) {
                
                NSLog(@"==== .cer file is nil ====");
                
                return 0;
            }
            
            weakManager.securityPolicy.pinnedCertificates = [NSSet setWithArray:@[cerData]];
            SecCertificateRef caRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)cerData);
            NSCAssert(caRef != nil, @"caRef is nil");
            
            NSArray *caArray = @[(__bridge id)(caRef)];
            NSCAssert(caArray != nil, @"caArray is nil");
            
            //将读取到的证书设置为serverTrust的根证书
            OSStatus status = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)caArray);
            SecTrustSetAnchorCertificatesOnly(serverTrust, NO);
            NSCAssert(errSecSuccess == status, @"SectrustSetAnchorCertificates failed");
            NSLog(@"status=%d",(int)status);
            
            //选择质询认证的处理方式
            NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            __autoreleasing NSURLCredential *credential = nil;
            
            //NSURLAuthenTicationMethodServerTrust质询认证方式
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
    }
    
    if (method == METHOD_GET){//发送GET请求
        [manager GET:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock){
                successBlock(responseObject);
            }else{
                NSLog(@"链接异常或网络不存在");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failedBlock(error);
        }];
    }else if (method == METHOD_POST){//发送POST请求
        [manager POST:URLString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (successBlock){
                successBlock(responseObject);
            }else{
                NSLog(@"链接异常或网络不存在");
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failedBlock(error);
        }];
    }
}




#pragma mark - 上传图片

/**
 上传单张图片

 @param URLString URL字符串
 @param parameters 网络请求的参数
 @param imageData 上传的图片数据
 @param successBlock 网络请求成功的回调
 @param failedBlock 网络请求失败的回调
 */
+(void)requestAFURL:(NSString *)URLString
         parameters:(id)parameters
          imageData:(NSData *)imageData
            succeed:(SuccessBlock)successBlock
            failure:(FailedBlock)failedBlock
{
    // 0.设置API地址
    URLString = [NSString stringWithFormat:@"%@%@",[TFNetWorkingManager sharedManager].baseURLString,[URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    NSLog(@"\n POST上传单张图片参数列表:%@\n\n%@\n",parameters,[TFNetWorkingManager URLEncryOrDecryString:parameters IsHead:false]);
    
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 30;
    
    // 5. POST数据
    [manager POST:URLString  parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";   // 设置时间格式
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
        
    }progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *responseStr =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        successBlock([TFNetWorkingManager dictionaryWithJsonString:responseStr]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failedBlock(error);
    }];
}




/**
 上传多张图片
 
 @param URLString URL字符串
 @param parameters 网络请求参数
 @param imageDataArray 上传的图片数组
 @param successBlock 网络请求成功的回调
 @param failedBlock 网络请求失败的回调
 */
+(void)requestAFURL:(NSString *)URLString
         parameters:(id)parameters
     imageDataArray:(NSArray *)imageDataArray
            succeed:(SuccessBlock)successBlock
            failure:(FailedBlock)failedBlock
{
    // 0.设置API地址
    URLString = [NSString stringWithFormat:@"%@%@",[TFNetWorkingManager sharedManager].baseURLString,[URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    NSLog(@"\n POST上传多张图片参数列表:%@\n\n%@\n",parameters,[TFNetWorkingManager URLEncryOrDecryString:parameters IsHead:false]);
    
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain",nil];
    
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 30;
    
    // 5. POST数据
    [manager POST:URLString  parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i = 0; i<imageDataArray.count; i++){
            
            NSData *imageData = imageDataArray[i];
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            NSString *name = [NSString stringWithFormat:@"image_%d.png",i ];
            
            //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/png"];
        }
        
    }progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *responseStr =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        successBlock([TFNetWorkingManager dictionaryWithJsonString:responseStr]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failedBlock(error);
    }];
}



/**
 上传文件
 
 @param URLString URL字符串
 @param parameters 网络请求参数
 @param fileData 上传的文件数据
 @param successBlock 网络请求成功的回调
 @param failedBlock 网络请求失败的回调
 */
+(void)requestAFURL:(NSString *)URLString
         parameters:(id)parameters
           fileData:(NSData *)fileData
            succeed:(SuccessBlock)successBlock
            failure:(FailedBlock)failedBlock
{
    // 0.设置API地址
    URLString = [NSString stringWithFormat:@"%@%@",[TFNetWorkingManager sharedManager].baseURLString,[URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
    // NSLog(@"\n POST上传文件参数列表:%@\n\n%@\n",parameters,[Utilit URLEncryOrDecryString:parameters IsHead:false]);
    
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 30;
    
    // 5. POST数据
    [manager POST:URLString  parameters:parameters  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //将得到的二进制数据拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
        [formData appendPartWithFileData :fileData name:@"file" fileName:@"audio.MP3" mimeType:@"audio/MP3"];
        
    }progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *responseStr =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        successBlock([TFNetWorkingManager dictionaryWithJsonString:responseStr]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failedBlock(error);
    }];
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
        NSLog(@"json解析失败：%@",error);
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
