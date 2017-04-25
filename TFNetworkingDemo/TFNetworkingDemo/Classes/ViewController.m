//
//  ViewController.m
//  TFNetworkingDemo
//
//  Created by Dabay on 2017/4/21.
//  Copyright © 2017年 Donkey-Tao. All rights reserved.
//

#import "ViewController.h"
#import "TFNetworking.h"


@interface ViewController ()

@property(nonatomic,strong)TFNetWorkingManager *manager;
@property(nonatomic,strong)TFHTTPSessionManager *httpsManager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    self.manager=[TFNetWorkingManager sharedManager];
    self.httpsManager=[[TFHTTPSessionManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://app.ywrl.gov.cn:8554"]];
    self.manager.baseURLString=@"https://app.ywrl.gov.cn:8554";
    self.manager.certificateString=@"*.dabay.cn";

    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:@"1" forKey:@"paramStr"];
    [param setValue:@"1" forKey:@"access_token"];
    [param setValue:@"2" forKey:@"device_type"];
    

    NSString *urlString=[NSString stringWithFormat:@"https://app.ywrl.gov.cn:8554/shebao/shebaoQuery.json?"];

    
    [self.manager tf_RequestURLString:urlString HttpMethod:TF_HTTPSMETHOD_POST Parameters:param succeed:^(id  _Nonnull responseObject) {
        
        
    } failure:^(NSError * _Nonnull error) {
        
        
    }];
    
    
    
    NSLog(@"%d",self.manager.tf_HttpsSessionManager.securityPolicy.allowInvalidCertificates);
    


    
}




@end
