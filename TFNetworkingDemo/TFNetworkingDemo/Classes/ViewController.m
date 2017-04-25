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
    manager.tf_BaseURLString=@"https://app.ywrl.gov.cn:8554";
    manager.certificateString=@"*.dabay.cn";

    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:@"1" forKey:@"paramStr"];
    [param setValue:@"1" forKey:@"access_token"];
    [param setValue:@"2" forKey:@"device_type"];
    

    NSString *urlString=[NSString stringWithFormat:@"https://app.ywrl.gov.cn:8554/shebao/shebaoQuery.json?"];
    
  
    [TFHTTPSessionManager tf_RequestURLString:urlString HttpMethod:TF_HTTPSMETHOD_POST Parameters:param succeed:^(id  _Nonnull responseObject) {
        
        
    } failure:^(NSError * _Nonnull error) {
        
        
    }];

    


    
}




@end
