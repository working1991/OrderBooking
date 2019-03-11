//
//  BaseCommon.m
//  XZD
//
//  Created by sysweal on 14/11/21.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import "BaseCommon.h"
#import "Common.h"
#import "KeyChainTool.h"

@implementation BaseCommon

//获取硬件唯一标识
+(NSString *) getDeviceInditify
{
#if TARGET_IPHONE_SIMULATOR
    return @"000000";
#endif
    
    
    static NSString *dbInditify = nil;
    if( !dbInditify ){
        //        dbInditify = [BaseConfig getDBValueByKey:Config_Key_UUID];
        dbInditify = (NSString*) [KeyChainTool load:Config_Key_UUID];
    }
    
    //取DB中的值即可
    if( dbInditify && ![dbInditify isEqualToString:@""] ){
        return dbInditify;
    }
    
    //    NSString *adId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    NSString *adId = @"";
    NSUUID *uuid = [[UIDevice currentDevice] identifierForVendor];
    
    NSLog(@"uuid=%@ adid=%@",[uuid UUIDString],adId);
    
    NSMutableString *myUUID = [[NSMutableString alloc] initWithString:[uuid UUIDString]];
    if( adId && [adId length] > 12 ){
        myUUID = [[NSMutableString alloc] initWithString:adId];
    }
    
    NSRange rang;
    rang.location = 0;
    rang.length = [myUUID length];
    [myUUID replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:rang];
    
    NSString *inditify = [[myUUID substringToIndex:7] lowercaseString];
    NSString *timeStr = [Common
                         getDateStr:[NSDate date] format:@"yyyyMMdd"];
    timeStr = [timeStr substringFromIndex:4];
    inditify = [inditify stringByAppendingString:timeStr];
    
    if( !dbInditify || [dbInditify isEqualToString:@""] ){
        //        [BaseConfig setDBValueByKey:Config_Key_UUID value:inditify];
        [KeyChainTool save:Config_Key_UUID data:inditify];
    }
    
    NSLog(@"inditify=%@",inditify);
    
    return inditify;
    
    //return @"00117f29cfd7";
}

//是否全是空格
+(BOOL) isAllSpaceStr:(NSString *)str
{
    BOOL flag = str ? YES : NO;
    
    for ( int i = 0 ; i < [str length]; ++i ) {
        NSRange rang;
        rang.location = i;
        rang.length = 1;
        if( ![[str substringWithRange:rang] isEqualToString:@" "] ){
            flag = NO;
            break;
        }
    }
    
    return flag;
}

//UIView 转成 UIImage
+(UIImage*)convertViewToImage:(UIView*)v
{
    UIGraphicsBeginImageContext(v.bounds.size);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

//添加倒影
+(void) addSimpleReflectionToView:(UIView *)theView
{
    const CGFloat kReflectPercent = -0.25f;
    const CGFloat kReflectOpacity = 0.3f;
    const CGFloat kReflectDistance = 10.0f;
    
    CALayer *reflectionLayer = [CALayer layer];
    reflectionLayer.contents = [theView layer].contents;
    reflectionLayer.opacity = kReflectOpacity;
    reflectionLayer.frame = CGRectMake(0.0f, 0.0f,
                                       theView.frame.size.width, theView.frame.size.height *
                                       kReflectPercent);
   
    CATransform3D stransform = CATransform3DMakeScale(1.0f, -1.0f,
                                                      1.0f);
    CATransform3D transform = CATransform3DTranslate(stransform, 0.0f,
                                                     -(kReflectDistance + theView.frame.size.height), 0.0f);
    reflectionLayer.transform = transform;
    reflectionLayer.sublayerTransform = reflectionLayer.transform;
    //CGRect rect = reflectionLayer.frame;
    //reflectionLayer.backgroundColor = [[UIColor blackColor] CGColor];
    [[theView layer] addSublayer:reflectionLayer];
}

//转换到URL请求字符
+(NSString *) convertStringToURLString:(NSString *)str
{
    if( str && ![str isKindOfClass:[NSString class]] ){
        return str;
    }
    else if( !str || [str isEqualToString:@""] )
    {
        return @"";
    }
    
    NSString *temp = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)str,NULL,(CFStringRef)@"!*'();:@&=+-$,/?%#[]",kCFStringEncodingUTF8));
    
    return temp;
}

//通过dic获取请求字符串
+(NSString *) getURLStrFromDic:(NSDictionary *)dic
{
    NSMutableString *str = [[NSMutableString alloc] init];
    
    NSArray *keyArr = [dic allKeys];
    for ( NSString *key in keyArr ) {
        [str appendFormat:@"&%@=%@",key,[BaseCommon convertStringToURLString:[dic objectForKey:key]]];
    }
    
    return str;
}


//获取当前时间
+(NSString *) getCurrentDateTime
{
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formater stringFromDate: [NSDate date]];
}

//由NSDate获取日期
+(NSString *) getDateStr:(NSDate *)date
{
    if( !date ){
        return nil;
    }
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd"];
    return [formater stringFromDate: date];
}

////由NSDate获取日期
//+(NSString *) getDateStr:(NSDate *)date format:(NSString *)format
//{
//    if( !date ){
//        date = [NSDate date];
//    }
//    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
//    [formater setDateFormat:format];
//    return [formater stringFromDate: date];
//}

//解析Json
+(NSDictionary *) getDataDic:(NSData *)data
{
    NSDictionary *dic = NULL;
    @try {
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        dic = [parser objectWithData:data];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return dic;
}

//解析Json
+(NSDictionary *) getStrDic:(NSString *)strData
{
    NSDictionary *dic = NULL;
    
    @try {
        SBJsonParser *parser = [[SBJsonParser alloc] init];
        dic = [parser objectWithString:strData];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
    return dic;
}

//获取本地文件存储目录
+(NSString *) getLocalStoreDir
{
    NSString *documentsDirectory = NSHomeDirectory();
    documentsDirectory = [NSString stringWithFormat:@"%@/Library/Caches",documentsDirectory];
    
    return documentsDirectory;
}

//根据名称获取其中沙盒中的目录
+(NSString *) getSandBoxPath:(NSString *)name
{
    NSString *documentsDirectory = [BaseCommon getLocalStoreDir];
    return [documentsDirectory stringByAppendingPathComponent:name];
}

//根据名称获取其中App中的目录
+(NSString *) getResourcePath:(NSString *)name
{
    NSString *resourceDirectory = [[NSBundle mainBundle] resourcePath];
    return [resourceDirectory stringByAppendingPathComponent:name];
}

//给某视图添加点击事件
+(UITapGestureRecognizer *) addTapGesture:(UIView *)view target:(id)target numberOfTap:(int)cnt sel:(SEL)sel
{
    NSArray *tmpArr = [view gestureRecognizers];
    for ( id obj in tmpArr ) {
        if( [obj isKindOfClass:[UITapGestureRecognizer class]] ){
            UITapGestureRecognizer *ges = obj;
            if( ges.numberOfTapsRequired == cnt ){
                [view removeGestureRecognizer:obj];
                break;
            }
        }
    }
    
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:sel];
    singleRecognizer.numberOfTapsRequired = cnt; // 单击
    [view addGestureRecognizer:singleRecognizer];
    
    return singleRecognizer;
}

//给某视图添加长按事件
+(UILongPressGestureRecognizer *) addLongPressGesture:(UIView *)view minimumPressDuration:(CFTimeInterval)pressDuration target:(id)targert sel:(SEL)sel
{
    NSArray *tmpArr = [view gestureRecognizers];
    for ( id obj in tmpArr ) {
        if( [obj isKindOfClass:[UILongPressGestureRecognizer class]] ){
            UILongPressGestureRecognizer *ges = obj;
            if( ges.minimumPressDuration == pressDuration ){
                [view removeGestureRecognizer:obj];
                break;
            }
        }
    }
    
    // 单击的 Recognizer
    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:targert action:sel];
    longPressRecognizer.minimumPressDuration = pressDuration; // 长按时间
    [view addGestureRecognizer:longPressRecognizer];
    
    return longPressRecognizer;
}

//复制约束
+(void) copyConstraint:(UIView *)superView srcView:(UIView *)srcView desView:(UIView *)desView topMore:(float)topMore
{
    if( !superView || !srcView || !desView )
        return;
    
    [superView addConstraint:[NSLayoutConstraint
                              constraintWithItem:desView
                              attribute:NSLayoutAttributeLeft
                              relatedBy:NSLayoutRelationEqual
                              toItem:srcView
                              attribute:NSLayoutAttributeLeft
                              multiplier:1
                              constant:0]];
    [superView addConstraint:[NSLayoutConstraint
                              constraintWithItem:desView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:srcView
                              attribute:NSLayoutAttributeTop
                              multiplier:1
                              constant:topMore]];
    [superView addConstraint:[NSLayoutConstraint
                              constraintWithItem:desView
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:srcView
                              attribute:NSLayoutAttributeWidth
                              multiplier:1
                              constant:0]];
    [superView addConstraint:[NSLayoutConstraint
                              constraintWithItem:desView
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:srcView
                              attribute:NSLayoutAttributeHeight
                              multiplier:1.0
                              constant:-topMore]];
}

//复制约束
+(void) copyConstraint:(UIView *)superView srcView:(UIView *)srcView desView:(UIView *)desView
{
    if( !superView || !srcView || !desView )
        return;
    
    [superView addConstraint:[NSLayoutConstraint
                              constraintWithItem:desView
                              attribute:NSLayoutAttributeLeft
                              relatedBy:NSLayoutRelationEqual
                              toItem:srcView
                              attribute:NSLayoutAttributeLeft
                              multiplier:1
                              constant:0]];
    [superView addConstraint:[NSLayoutConstraint
                              constraintWithItem:desView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:srcView
                              attribute:NSLayoutAttributeTop
                              multiplier:1
                              constant:0]];
    [superView addConstraint:[NSLayoutConstraint
                              constraintWithItem:desView
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:srcView
                              attribute:NSLayoutAttributeWidth
                              multiplier:1
                              constant:0]];
    [superView addConstraint:[NSLayoutConstraint
                              constraintWithItem:desView
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:srcView
                              attribute:NSLayoutAttributeHeight
                              multiplier:1.0
                              constant:0]];
}

//添加Center约束
+(void) addCenterConstraint:(UIView *)superView view:(UIView *)view
{
    if( !superView || !view )
        return;
    
    [superView addConstraint:[NSLayoutConstraint
                              constraintWithItem:view
                              attribute:NSLayoutAttributeCenterX
                              relatedBy:NSLayoutRelationEqual
                              toItem:superView
                              attribute:NSLayoutAttributeCenterX
                              multiplier:1
                              constant:0]];
    [superView addConstraint:[NSLayoutConstraint
                              constraintWithItem:view
                              attribute:NSLayoutAttributeCenterY
                              relatedBy:NSLayoutRelationEqual
                              toItem:superView
                              attribute:NSLayoutAttributeCenterY
                              multiplier:1
                              constant:0]];
    [superView addConstraint:[NSLayoutConstraint
                              constraintWithItem:view
                              attribute:NSLayoutAttributeWidth
                              relatedBy:NSLayoutRelationEqual
                              toItem:nil
                              attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:0
                              constant:view.frame.size.width]];
    [superView addConstraint:[NSLayoutConstraint
                              constraintWithItem:view
                              attribute:NSLayoutAttributeHeight
                              relatedBy:NSLayoutRelationEqual
                              toItem:nil
                              attribute:NSLayoutAttributeNotAnAttribute
                              multiplier:0
                              constant:view.frame.size.height]];
}

//添加边缘约束
+(void) copyMarginConstraint:(UIView *)superView srcView:(UIView *)srcView desView:(UIView *)desView {
    if( !superView || !srcView || !desView )
        return;
    
    [superView addConstraint:[NSLayoutConstraint
                              constraintWithItem:desView
                              attribute:NSLayoutAttributeLeft
                              relatedBy:NSLayoutRelationEqual
                              toItem:srcView
                              attribute:NSLayoutAttributeLeft
                              multiplier:1
                              constant:0]];
    [superView addConstraint:[NSLayoutConstraint
                              constraintWithItem:desView
                              attribute:NSLayoutAttributeTop
                              relatedBy:NSLayoutRelationEqual
                              toItem:srcView
                              attribute:NSLayoutAttributeTop
                              multiplier:1
                              constant:0]];
    [superView addConstraint:[NSLayoutConstraint
                              constraintWithItem:desView
                              attribute:NSLayoutAttributeRight
                              relatedBy:NSLayoutRelationEqual
                              toItem:srcView
                              attribute:NSLayoutAttributeRight
                              multiplier:1
                              constant:0]];
    [superView addConstraint:[NSLayoutConstraint
                              constraintWithItem:desView
                              attribute:NSLayoutAttributeBottom
                              relatedBy:NSLayoutRelationEqual
                              toItem:srcView
                              attribute:NSLayoutAttributeBottom
                              multiplier:1
                              constant:0]];

}

//缩放图片
+(UIImage*)  OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

//textField只能输入数字
+ (BOOL)onlyInputNumber:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string decimalDigits:(unsigned int)decimalCount
{
    if (decimalCount == 0 && [string isEqualToString:@"."]) {
        return NO;
    }
    NSScanner      *scanner    = [NSScanner scannerWithString:string];
    NSCharacterSet *numbers;
    NSRange         pointRange = [textField.text rangeOfString:@"."];
    if ( (pointRange.length > 0) && (pointRange.location < range.location  || pointRange.location > range.location + range.length) ){
        numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    }
    else{
        numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    }
    if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] ){
        return NO;
    }
    short remain = decimalCount; //默认保留2位小数
    NSString *tempStr = [textField.text stringByAppendingString:string];
    NSUInteger strlen = [tempStr length];
    if(pointRange.length > 0 && pointRange.location > 0){
        if([string isEqualToString:@"."]){
            return NO;
        }
        if(strlen > 0 && (strlen - pointRange.location) > remain+1){
            return NO;
        }
    }
    NSRange zeroRange = [textField.text rangeOfString:@"0"];
    if(zeroRange.length == 1 && zeroRange.location == 0){
        if(![string isEqualToString:@"0"] && ![string isEqualToString:@"."] && [textField.text length] == 1){
            textField.text = string;
            return NO;
        }else{
            if(pointRange.length == 0 && pointRange.location > 0){
                if([string isEqualToString:@"0"]){
                    return NO;
                }
            }
        }
    }
    
    NSString *buffer;
    if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) ){
        return NO;
    }
    return YES;
}

//拨打电话
+ (void)makeCallTelphone:(NSString *)telphone
{
    UIWebView * callWebview = [[UIWebView alloc]init];
    NSString *telNum = [NSString stringWithFormat:@"tel:%@",telphone];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:telNum]]];
    [[UIApplication sharedApplication].keyWindow addSubview:callWebview];
}

@end
