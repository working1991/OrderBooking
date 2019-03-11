//
//  CalendarUntil.m
//  Talk
//
//  Created by sysweal on 15/6/17.
//  Copyright (c) 2015年 sysweal. All rights reserved.
//

#import "CalendarUntil.h"

@implementation CalendarUntil

//获取当前月
+(NSDate *) getCurrentMonthDate
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy"];
    int year = [[formater stringFromDate: date] intValue];
    
    formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"MM"];
    int month = [[formater stringFromDate: date] intValue];
    
    return [self getDate:[NSString stringWithFormat:@"%d-%d-01",year,month] format:@"yyyy-MM-dd"];
}

//获取NSDate
+(NSDate *) getDate:(NSString *)timeStr format:(NSString *)format
{
    NSDate *date = [NSDate date];
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSTimeZone *timeZone = [NSTimeZone localTimeZone];
        
        [formatter setTimeZone:timeZone];
        [formatter setDateFormat : format];
        
        date = [formatter dateFromString:timeStr];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return date;
}

//获取今天的日期
+(NSDate *) getTodayDate
{
    return [Common getDate:[Common getDateStr:nil format:@"yyyy-MM-dd"] format:@"yyyy-MM-dd"];
}

//获取一个月有多少天
+(int) getMonthDays:(NSDate *)monthDate
{
    if( !monthDate )
        monthDate = [NSDate date];
    
    NSCalendar *c = [NSCalendar currentCalendar];
//    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSRange days = [c rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:monthDate];
    
    return (int)days.length;
}

//获取两时间之间的天数
+(int) getBetweenDays:(NSDate *)firstDate date2:(NSDate *)secondDate
{
    NSTimeInterval time=[firstDate timeIntervalSinceDate:secondDate];
    int days = ((int)time)/(3600*24);
    return days;
}

//是否是今天
+(BOOL) isToday:(NSDate *)date
{
    return [self isSame:[NSDate date] date2:date format:@"yyyy-MM-dd"];
}

//是否是同一天
+(BOOL) isSame:(NSDate *)date1 date2:(NSDate *)date2 format:(NSString *)format
{
    BOOL flag = NO;
    
    if( date1 && date2 ){
        flag = [[Common getDateStr:date1 format:format] isEqualToString:[Common getDateStr:date2 format:format]];
    }
    
    return flag;
}

//获取某一天是星期几
+(int) getWeek:(NSDate *)date
{
    //initializtion parameter
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendarUnit unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    if( !date ){
        date = [NSDate date];
    }

    comps = [calendar components:unitFlags fromDate:date];
    int week = (int)[comps weekday];
    
//    1 －－星期天
//    2－－星期一
//    3－－星期二
//    4－－星期三
//    5－－星期四
//    6－－星期五
//    7－－星期六
    
    return week;
}

//获由date偏移day
+(NSDate *)getDateFromDate:(NSDate *)date days:(NSInteger)days
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:days];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

//获由date偏移month
+(NSDate *)getDateFromDate:(NSDate *)date month:(NSInteger)month
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

//序列化
+(BOOL) archiverToFile:(id)obj fileName:(NSString *)fileName
{
    NSString *documentsDirectory = NSHomeDirectory();
    documentsDirectory = [NSString stringWithFormat:@"%@/Library/Caches",documentsDirectory];
    
    if(!documentsDirectory)
    {
        return false;
    }
    
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    return [NSKeyedArchiver archiveRootObject:obj toFile:appFile];
}

//反序列化
+(id) unArchiverFromFile:(NSString *)fileName
{
    NSString *documentsDirectory = NSHomeDirectory();
    documentsDirectory = [NSString stringWithFormat:@"%@/Library/Caches",documentsDirectory];
    
    if(!documentsDirectory)
    {
        return nil;
    }
    
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:fileName];
    
    id fileData;
    @try {
        fileData = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
        
    }
    @catch (NSException *exception) {
        fileData = nil;
    }
    @finally {
        
    }
    
    return fileData;
}

// 获取date当天的农历
+ (NSString *)chineseCalendarOfDate:(NSDate *)date {
    NSString *day;
    NSCalendar *chineseCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *components = [chineseCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    if (components.day == 1) {
        day = ChineseMonths[components.month - 1];
    } else {
        day = ChineseDays[components.day - 1];
    }
    
    return day;
}

@end
