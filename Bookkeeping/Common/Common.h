//
//  Common.h
//  XZD
//
//  Created by sysweal on 14/11/24.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseCommon.h"
#import "Config.h"

#define Screen_Full_Width ([UIScreen mainScreen].bounds.size.width)

#define Screen_Full_Height ([UIScreen mainScreen].bounds.size.height)

@interface Common : BaseCommon

//密码策略是否正确(8位以上,含数字，大小写)
+(BOOL) isPasswordOK:(NSString *)password;

//判断输入金额策略
+(BOOL)checkNum:(NSString *)numString;

//UIColor生成UIImage
+(UIImage*) createImageWithColor: (UIColor*) color alpha:(CGFloat)alpha;

//播放推送消息的声音
+(void) palyPushMsgAudio;

//获取日期，不包含时间
+(NSString *) getDate:(NSString *)dateStr;

//获取NSDate
+(NSDate *) getDate:(NSString *)timeStr format:(NSString *)format;

//获取DateStr
+(NSString *) getDateStr:(NSDate *)date format:(NSString *)format;

//获取DateStr
+(NSString *) getDateStrBySeconds:(NSTimeInterval)times;

//由@“FFFFFF”字符得到颜色
+(UIColor *) getColor:(NSString*)hexColor;

+(UIColor *) getColor:(NSString*)hexColor alpha:(CGFloat)alpha;

//全屏显示
+(void) showImageFullScreen:(UIImageView *)avatarImageView backgroundColor:(UIColor *)color;

//获取本月的天数
+(NSUInteger) getDayNumberThisMonth;

//根据年月获取天数
+(NSUInteger) getDayNumberByDateStr:(NSString *)dateStr;

//根据字符串判断是否某日期是否在今天之前
+ (BOOL)isBeforeToday:(NSString *)oneDayStr;

//根据字符串判断是否某日期是否在今天之后
+ (BOOL)isAfterToday:(NSString *)oneDayStr;

//根据字符串判断是否今天
+ (BOOL)isToday:(NSString *)oneDayStr;

//获取时间秒数
+ (long long)getDateTimeToMilliSeconds:(NSDate *)datetime;

//电话号码中间四加密
+ (NSString *)processEncryptionPhone:(NSString *)phone;

+ (BOOL)URLStringEnableToPlay:(NSString *)urlStr;

//计算时间
+ (NSString *)getDistancenNowTimeStr:(NSString *)timeStr;

//去除两端空格
+ (NSString *)clearTrimmingWhitespace:(NSString *)string;

+ (id)findViewController:(Class)className formView:(UIView*)view;

@end
