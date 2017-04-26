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









@end
