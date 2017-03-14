//
//  UIView+TFExtension.h
//  UIView的分类,为了简化view中尺寸之类的设置
//
//  Created by 陶飞 on 15/2/29.
//  Copyright © 2015年 taofei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (TFExtension)

/** 尺寸 */
@property (nonatomic,assign) CGSize size;

/** 宽度 */
@property (nonatomic,assign) CGFloat width;
/** 高度 */
@property (nonatomic,assign) CGFloat height;
/** x */
@property (nonatomic,assign) CGFloat x;
/** y */
@property (nonatomic,assign) CGFloat y;

/** centerX */
@property (nonatomic,assign) CGFloat centerX;
/** centerY */
@property (nonatomic,assign) CGFloat centerY;

/**在分类中声明@property,只会生成方法的声明,不会生成方法的实现和带有下划线的成员变量*/



/**
 *判断一个空间是否真正显示在主窗口上 
 */
-(BOOL)isShowingOnKeyWindow;


@end
