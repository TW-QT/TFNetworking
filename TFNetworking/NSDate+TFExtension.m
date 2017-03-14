//
//  NSDate+TFExtension.m
//
//  Created by 陶飞 on 16/6/1.
//  Copyright © 2016年 taofei. All rights reserved.
//

#import "NSDate+TFExtension.h"

@implementation NSDate (TFExtension)
/**
 *比较from和self的时间差
 */
-(NSDateComponents *)deltaFrom:(NSDate *)from{

    
    //日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    //比较时间
    NSDateComponents *cmps=[calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:from toDate:self options:0];
    
    return cmps;


}

//    //获取日期的每个元素
//    NSInteger year=[calendar component:NSCalendarUnitYear fromDate:current];
//    NSInteger month=[calendar component:NSCalendarUnitMonth fromDate:current];
//    NSInteger day=[calendar component:NSCalendarUnitDay fromDate:current ];
//    TFLog(@"%zd==%zd==%zd",year,month,day);
//    //所有元素
//    NSDateComponents *cmps=[calendar components:NSCalendarUnitYear|
//                                                NSCalendarUnitMonth|
//                                                NSCalendarUnitDay fromDate:current];
//    TFLog(@"%zd年%zd月%zd日",cmps.year,cmps.month,cmps.day);
//    self.createTimeLabel.text=topic.create_time;

/**
 *判断是否是今年
 */
-(BOOL)isThisYear{
    
    //日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    NSInteger nowYear=[calendar component:NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger selfYear=[calendar component:NSCalendarUnitYear fromDate:self];

    return nowYear==selfYear;
}

/**
 *判断是否是今天
 */
-(BOOL)isToday{
    //日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
    
    NSCalendarUnit unit=NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay;
    NSDateComponents *nowCmps=[calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *selfCmps=[calendar components:unit fromDate:self];
    
    return nowCmps.year==selfCmps.year&&nowCmps.month==selfCmps.month&&nowCmps.day==selfCmps.day;
}

/**
 *判断是否是昨天
 */
-(BOOL)isYesterday{
    //去掉时分秒
    NSDateFormatter *fmt=[[NSDateFormatter alloc]init];
    fmt.dateFormat=@"yyyy-MM-dd";
    
    NSDate *nowDate=[fmt dateFromString:[fmt stringFromDate:[NSDate date]]];
    NSDate *selfDate=[fmt dateFromString:[fmt stringFromDate:self]];
    
    //日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    
   NSDateComponents *cmps= [calendar components:NSCalendarUnitDay|NSCalendarUnitYear|NSCalendarUnitMonth fromDate:selfDate toDate:nowDate options:0];

    return cmps.year==0&&cmps.month==0&&cmps.day==1;
}


@end
