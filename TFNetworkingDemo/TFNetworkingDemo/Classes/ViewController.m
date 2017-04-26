//
//  ViewController.m
//  TFNetworkingDemo
//
//  Created by Dabay on 2017/4/21.
//  Copyright © 2017年 Donkey-Tao. All rights reserved.
//

#import "ViewController.h"
#import "TFNetworking.h"
#import "TFHTTPSessionManager.h"

@interface ViewController ()


@property(nonatomic,strong)TFHTTPSessionManager *httpsManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TFNetWorkingManager *manager=[TFNetWorkingManager sharedManager];
    manager.tf_BaseURLString=@"http://122.226.66.214:7780/ywcitzencard";
    manager.certificateString=@"*.dabay.cn";

    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:@"1.1" forKey:@"app_version"];
    [param setValue:@"B1ABC544-F183-403F-BFD9-453E01F5ED10" forKey:@"imei"];
    [param setValue:@"2" forKey:@"device_type"];
    
    NSString *urlString=[NSString stringWithFormat:@"app/version.json"];
    
  
    //测试--HTTPS网络请求管理者：TFHTTPSessionManager
    [TFHTTPSessionManager tf_RequestURLString:urlString HttpMethod:TF_HTTPSMETHOD_POST Parameters:param succeed:^(NSDictionary * _Nonnull responseDictionary) {
        
        NSLog(@"检查是否有新版本-网络请求成功!");
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"检查是否有新版本-网络请求失败!");
    }];

    
    
    //测试--网络状态管理者：TFNetworkReachabilityManager
    TFNetworkReachabilityManager *networkManager=[TFNetworkReachabilityManager sharedManager];
    [networkManager start];

    


    
}




@end
