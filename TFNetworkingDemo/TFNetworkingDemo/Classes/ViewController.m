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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.manager=[TFNetWorkingManager sharedManager];
    self.manager.baseURLString=@"https://app.ywrl.gov.cn:8554";
    self.manager.certificateString=@"*.dabay.cn";
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setValue:@"1" forKey:@"paramStr"];
    [param setValue:@"1" forKey:@"access_token"];
    [param setValue:@"2" forKey:@"device_type"];
    
    NSLog(@"self.manager.baseURLString--%@",self.manager.baseURLString);
    NSLog(@"self.manager.certificateString--%@",self.manager.certificateString);
    NSString *urlString=[NSString stringWithFormat:@"https://app.ywrl.gov.cn:8554/shebao/shebaoQuery.json?"];
    [self.manager tf_RequestURLString:urlString HttpMethod:METHOD_POST Parameters:param succeed:^(id  _Nonnull responseObject) {
        
        NSLog(@"请求成功-responseObject=%@",responseObject);
        
    } failure:^(NSError * _Nonnull error) {
        
        NSLog(@"请求失败-error=%@",error);
    }];
    
    NSLog(@"self.manager-%@",self.manager);

}




@end
