//
//  Common.m
//  XZD
//
//  Created by sysweal on 14/11/24.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

static CGRect oldframe;

@implementation Common

//密码策略是否正确(8位以上,含数字，大小写)
+(BOOL) isPasswordOK:(NSString *)password
{
    BOOL flag = NO;
    
    if( password ){
        NSString *RULE = @"^(?=\\S*?[A-Z])(?=\\S*?[a-z])(?=\\S*?[0-9])\\S{8,16}$";
        NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", RULE];
        flag = [regextestmobile evaluateWithObject:password];
    }
    
    return flag;
}

//输入金额策略
+(BOOL)checkNum:(NSString *)numString
{
    BOOL isMatch = NO;
    if ( numString ) {
        NSString *regex = @"^[0-9]+(.[0-9]{2})?$";
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        isMatch = [pred evaluateWithObject:numString];
    }
    return isMatch;
}

//UIColor生成UIImage
+(UIImage*) createImageWithColor: (UIColor*) color alpha:(CGFloat)alpha
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextSetAlpha(context, alpha);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

//播放推送消息的声音
+(void) palyPushMsgAudio
{
    static AVAudioPlayer *thePlayer;
    if( thePlayer )
        [thePlayer stop];
    
    NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:@"in" ofType:@"caf"];       //创建音乐文件路径
    NSURL *musicURL = [[NSURL alloc] initFileURLWithPath:musicFilePath];
    thePlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    
    [thePlayer prepareToPlay];
    [thePlayer setVolume:1];   //设置音量大小
    thePlayer.numberOfLoops = 0;//设置音乐播放次数  -1为一直循环
    [thePlayer play];   //播放
}

//获取日期，不包含时间
+(NSString *) getDate:(NSString *)dateStr
{
    if ( dateStr && ![dateStr isEqualToString:@""] && dateStr.length > 7 ) {
        if ( [dateStr rangeOfString:@"-"].location == NSNotFound ) {
            NSString *year = [dateStr substringToIndex:4];
            NSString *mouth = [dateStr substringWithRange:NSMakeRange(4, 2)];
            NSString *day = [dateStr substringWithRange:NSMakeRange(6, 2)];
            return [NSString stringWithFormat:@"%@-%@-%@",year,mouth,day];
        } else {
            NSString *date = [dateStr substringToIndex:4+1+2+1+2];
            return date;
        }
    }
    return nil;
}

//获取NSDate
+(NSDate *) getDate:(NSString *)timeStr format:(NSString *)format
{
    NSDate *date = [NSDate date];
    if( !format ){
        format = @"yyyy-MM-dd HH:mm:ss";
    }
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

//获取DateStr
+(NSString *) getDateStr:(NSDate *)date format:(NSString *)format
{
    if( !date ){
        date = [NSDate date];
    }
    if( !format ){
        format = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:format];
    return [formater stringFromDate: date];
}

//获取DateStr
+(NSString *) getDateStrBySeconds:(NSTimeInterval)times
{
    NSString *str = @"00:00";
    
    if( times > 0 ){
        //天
        int day = ((unsigned long)times) / (24 * 60 * 60);
        
        //小时
        int hour = ((unsigned long)times) / (60 * 60) % 24;
        
        //分钟
        int min = ((unsigned long)times) / 60 % 60;
        
        //秒
        int second = ((unsigned long)times) % (60);
        
        if( day > 0 )
            str = [NSString stringWithFormat:@"%d天以上",day];
        else if( hour > 0 )
            str = [NSString stringWithFormat:@"%d:%02d:%02d",hour,min,second];
        else
            str = [NSString stringWithFormat:@"%02d:%02d",min,second];
    }
    
    return str;
}

//获取时间秒数
+ (long long)getDateTimeToMilliSeconds:(NSDate *)datetime
{
    NSTimeInterval interval = [datetime timeIntervalSince1970];
    long long totalMilliseconds = interval*1000 ;
    return totalMilliseconds;
}

//由@“FFFFFF”字符得到颜色
+(UIColor *) getColor:(NSString*)hexColor
{
    unsigned int red,green,blue;
    @try {
        NSRange range;
        range.length = 2;
        range.location = 0;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
        range.location = 2;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
        range.location = 4;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:1.0f];
}

//由@“FFFFFF”字符得到颜色
+(UIColor *) getColor:(NSString*)hexColor alpha:(CGFloat)alpha
{
    unsigned int red,green,blue;
    @try {
        NSRange range;
        range.length = 2;
        range.location = 0;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&red];
        range.location = 2;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&green];
        range.location = 4;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]]scanHexInt:&blue];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return [UIColor colorWithRed:(float)(red/255.0f)green:(float)(green / 255.0f) blue:(float)(blue / 255.0f)alpha:alpha];
}


+(void)hideImageWithNoAnimation:(UITapGestureRecognizer *)tap
{
    UIView *backgroundView = tap.view;
    [UIView animateWithDuration:0.25f animations:^{
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

//全屏显示
+(void) showImageFullScreen:(UIImageView *)avatarImageView backgroundColor:(UIColor *)color
{

    UIImage *image = avatarImageView.image;
    // 获得根窗口
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    UIView *backgroundView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    
    oldframe = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:oldframe];
    if (color) {
        imageView.backgroundColor = color;
    } else {
        imageView.backgroundColor = [UIColor clearColor];
    }
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHight = [UIScreen mainScreen].bounds.size.height;
    if (image.size.width >= screenWidth || image.size.height >= screenHight) {
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    } else {
        imageView.contentMode = UIViewContentModeCenter;
    }
    
    imageView.image = image;
    imageView.tag = 1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
  
    [window makeKeyAndVisible];
    
    // 缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchImageView:)];
    [backgroundView addGestureRecognizer:pinchGestureRecognizer];

    //点击图片缩小的手势
    UITapGestureRecognizer *tap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer:tap];
    [UIView animateWithDuration:0.25f animations:^{
        imageView.frame = CGRectMake(0, 0, screenWidth, screenHight);
        backgroundView.alpha = 1.0;
    }];
}

+(void)hideImage:(UITapGestureRecognizer *)tap
{
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView *)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.25f animations:^{
        imageView.frame = oldframe;
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

+ (void)pinchImageView:(UIPinchGestureRecognizer *)pinGes
{
    UIImageView *imageView = (UIImageView *)[pinGes.view viewWithTag:1];
    if (pinGes.state == UIGestureRecognizerStateBegan || pinGes.state == UIGestureRecognizerStateChanged) {
        imageView.transform = CGAffineTransformScale(imageView.transform, pinGes.scale, pinGes.scale);
        pinGes.scale = 1;
    }
}

//根据年月获取天数
+(NSUInteger) getDayNumberByDateStr:(NSString *)dateStr {
    NSString *monthStr = [dateStr substringWithRange:NSMakeRange(5, 2)];
    NSUInteger month = [monthStr intValue];
    NSString *yearStr = [dateStr substringToIndex:4];
    NSUInteger year = [yearStr intValue];
    NSUInteger totalDays = 0;
    if (month == 4|| month == 6 || month == 9|| month == 11) {
        totalDays = 30;
    }
    else if (month == 2) {
        if((year%4==0&&year%100!=0)||(year%400==0)){
            totalDays =29;
        }
        else {
            totalDays =28;
        }
    }
    else {
        totalDays = 31;
    }
    return totalDays;
}

//获得本月天数
+(NSUInteger) getDayNumberThisMonth{
    NSString *monthStr = [self getDateStr:nil format:@"MM"];
    NSUInteger month = [monthStr intValue];
    NSString *yearStr = [self getDateStr:nil format:@"yyyy"];
    NSUInteger year = [yearStr intValue];
    NSUInteger totalDays = 0;
    if (month == 4|| month == 6 || month == 9|| month == 11) {
        totalDays = 30;
    }
    else if (month == 2) {
        if((year%4==0&&year%100!=0)||(year%400==0)){
            totalDays =29;
        }
        else {
            totalDays =28;
        }
    }
    else {
        totalDays = 31;
    }
    return totalDays;

}

//根据字符串判断是否某日期是否在今天之前
+ (BOOL)isBeforeToday:(NSString *)oneDayStr {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear
    |NSCalendarUnitMonth
    |NSCalendarUnitDay;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger thisYear=[comps year];
    NSInteger thisMonth = [comps month];
    NSInteger today = [comps day];
    
    NSInteger oneYear = [[oneDayStr substringToIndex:4]integerValue];
    NSInteger oneMonth = [[oneDayStr substringWithRange:NSMakeRange(5, 2)]integerValue];;
    NSInteger oneDay = [[oneDayStr substringFromIndex:8]integerValue];
    
    if (thisYear>oneYear) {
        return YES;
    }
    else if (thisYear < oneYear) {
        return NO;
    }
    else {
        if (thisMonth > oneMonth) {
            return YES;
        }
        else if (thisMonth < oneMonth) {
            return NO;
        }
        else {
            if (today > oneDay) {
                return YES;
            }
            else {
                return NO;
            }
        }
    }
}

//根据字符串判断是否某日期是否在今天之后
+ (BOOL)isAfterToday:(NSString *)oneDayStr {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear
    |NSCalendarUnitMonth
    |NSCalendarUnitDay;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger thisYear=[comps year];
    NSInteger thisMonth = [comps month];
    NSInteger today = [comps day];
    
    NSInteger oneYear = [[oneDayStr substringToIndex:4]integerValue];
    NSInteger oneMonth = [[oneDayStr substringWithRange:NSMakeRange(5, 2)]integerValue];;
    NSInteger oneDay = [[oneDayStr substringFromIndex:8]integerValue];
    
    if (thisYear<oneYear) {
        return YES;
    }
    else if (thisYear > oneYear) {
        return NO;
    }
    else {
        if (thisMonth < oneMonth) {
            return YES;
        }
        else if (thisMonth > oneMonth) {
            return NO;
        }
        else {
            if (today < oneDay) {
                return YES;
            }
            else {
                return NO;
            }
        }
    }
}

//根据字符串判断是否今天
+ (BOOL)isToday:(NSString *)oneDayStr {
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear
    |NSCalendarUnitMonth
    |NSCalendarUnitDay;
    comps = [calendar components:unitFlags fromDate:date];
    NSInteger thisYear=[comps year];
    NSInteger thisMonth = [comps month];
    NSInteger today = [comps day];
    
    NSInteger oneYear = [[oneDayStr substringToIndex:4]integerValue];
    NSInteger oneMonth = [[oneDayStr substringWithRange:NSMakeRange(5, 2)]integerValue];;
    NSInteger oneDay = [[oneDayStr substringFromIndex:8]integerValue];
    if (thisYear == oneYear && thisMonth == oneMonth && today == oneDay) {
        return YES;
    }
    return NO;
}

//电话号码中间四加密
+ (NSString *)processEncryptionPhone:(NSString *)phone
{
    if (!phone) {
        return nil;
    }
    if (phone.length < 11) {
        return phone;
    }
//    NSString *midStr = [phone substringWithRange:NSMakeRange(phone.length - 8, 4)];
    phone = [phone stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"];
    return phone;
}

+ (BOOL)URLStringEnableToPlay:(NSString *)urlStr {
    if ([[urlStr pathExtension] isEqualToString:@"mp3"] || [[urlStr pathExtension] isEqualToString:@"mp4"]) {
        return YES;
    }
    return NO;
}

+ (NSString *)getDistancenNowTimeStr:(NSString *)timeStr
{
    NSString *str = timeStr;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //按秒计算
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:timeStr];
    NSTimeInterval timeLate = [date timeIntervalSince1970];
    NSDate *nowDate = [NSDate date];
    NSTimeInterval nowLate = [nowDate timeIntervalSince1970];
    
    CGFloat second = nowLate - timeLate;
    CGFloat minute = second/60;
    CGFloat hour = minute/60;
    
    //按天计算
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *d1=[dateFormatter dateFromString:[dateFormatter stringFromDate:date]];
    NSTimeInterval late1=[d1 timeIntervalSince1970];
    NSDate *d2 = [dateFormatter dateFromString:[dateFormatter stringFromDate:nowDate]];
    NSTimeInterval late2=[d2 timeIntervalSince1970];
    
    NSTimeInterval differ = late2 - late1;
    CGFloat day = differ/60/60/24;
    
    if (minute < 1) {
        str = NSLocalizedString(@"刚刚", nil);
    } else if (minute < 60) {
        str = [NSString stringWithFormat:NSLocalizedString(@"%0.f分钟以前", nil), minute];
    } else if (hour < 24) {
        str = [NSString stringWithFormat:NSLocalizedString(@"%0.f小时以前", nil), hour];
    } else if (day < 2) {
        str = NSLocalizedString(@"昨天", nil);
    } else if (day < 3) {
        str = NSLocalizedString(@"前天", nil);
    } else {
        //[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        str = [dateFormatter stringFromDate:date];
    }
    
    return str;
}

//去除两端空格  
+ (NSString *)clearTrimmingWhitespace:(NSString *)string
{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (id)findViewController:(Class)className formView:(UIView*)view
{
    id responder = view;
    while (responder){
        if ([responder isKindOfClass:className]){
            return responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
    
}

@end
