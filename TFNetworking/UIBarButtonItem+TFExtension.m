//
//  UIBarButtonItem+TFExtension.m
//
//  Created by 陶飞 on 16/5/29.
//  Copyright © 2016年 taofei. All rights reserved.
//

#import "UIBarButtonItem+TFExtension.h"

@implementation UIBarButtonItem (TFExtension)

+(instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action{

   
    //设置导航栏左边的按钮
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size=button.currentBackgroundImage.size;
    //给左边的按钮添加点击事件
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    

    return [[self alloc]initWithCustomView:button];
}



@end
