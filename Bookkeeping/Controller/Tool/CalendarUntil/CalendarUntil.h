//
//  CalendarUntil.h
//  Talk
//
//  Created by sysweal on 15/6/17.
//  Copyright (c) 2015年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

#define ChineseMonths @[@"正月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月",@"九月", @"十月", @"冬月", @"腊月"]
#define ChineseDays @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十", @"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"]

@interface CalendarUntil : NSObject

//获取当前月
+(NSDate *) getCurrentMonthDate;

//获取NSDate
+(NSDate *) getDate:(NSString *)timeStr format:(NSString *)format;

//获取今天的日期
+(NSDate *) getTodayDate;

//获取一个月有多少天
+(int) getMonthDays:(NSDate *)monthDate;

//获取两时间之间的天数
+(int) getBetweenDays:(NSDate *)firstDate date2:(NSDate *)secondDate;

//是否是今天
+(BOOL) isToday:(NSDate *)date;

//是否是同一天
+(BOOL) isSame:(NSDate *)date1 date2:(NSDate *)date2 format:(NSString *)format;

//获取某一天是星期几
+(int) getWeek:(NSDate *)date;

//获由date偏移day
+(NSDate *)getDateFromDate:(NSDate *)date days:(NSInteger)days;

//获由date偏移month
+(NSDate *)getDateFromDate:(NSDate *)date month:(NSInteger)month;

//序列化
+(BOOL) archiverToFile:(id)obj fileName:(NSString *)fileName;

//反序列化
+(id) unArchiverFromFile:(NSString *)fileName;

// 获取date当天的农历
+ (NSString *)chineseCalendarOfDate:(NSDate *)date;

@end
