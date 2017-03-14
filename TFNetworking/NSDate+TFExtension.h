//
//  NSDate+TFExtension.h
//
//  Created by 陶飞 on 16/6/1.
//  Copyright © 2016年 taofei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (TFExtension)
/**
 *比较from和self的时间差
 */
-(NSDateComponents *)deltaFrom:(NSDate *)from;


/**
 *判断是否是今年
 */
-(BOOL)isThisYear;



/**
 *判断是否是今天
 */
-(BOOL)isToday;



/**
 *判断是否是昨天
 */
-(BOOL)isYesterday;

@end
