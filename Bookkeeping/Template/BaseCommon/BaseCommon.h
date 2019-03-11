//
//  BaseCommon.h
//  XZD
//
//  Created by sysweal on 14/11/21.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AdSupport/AdSupport.h>
#import "BaseConfig.h"
#import "MyLog.h"
#import "SBJson.h"
#import "BaseErrorInfo.h"
#import "MD5.h"

@interface BaseCommon : NSObject

//获取硬件唯一标识
+(NSString *) getDeviceInditify;

//是否全是空格
+(BOOL) isAllSpaceStr:(NSString *)str;

//UIView 转成 UIImage
+(UIImage*)convertViewToImage:(UIView*)v;

//添加倒影
+(void) addSimpleReflectionToView:(UIView *)theView;

//转换到URL请求字符
+(NSString *) convertStringToURLString:(NSString *)str;

//通过dic获取请求字符串
+(NSString *) getURLStrFromDic:(NSDictionary *)dic;

//获取当前时间
+(NSString *) getCurrentDateTime;

//由NSDate获取日期
+(NSString *) getDateStr:(NSDate *)date;

////由NSDate获取日期
//+(NSString *) getDateStr:(NSDate *)date format:(NSString *)format;

//解析Json
+(NSDictionary *) getDataDic:(NSData *)data;

//解析Json
+(NSDictionary *) getStrDic:(NSString *)strData;

//获取本地文件存储目录
+(NSString *) getLocalStoreDir;

//根据名称获取其中沙盒中的目录
+(NSString *) getSandBoxPath:(NSString *)name;

//根据名称获取其中App中的目录
+(NSString *) getResourcePath:(NSString *)name;

//给某视图添加点击事件
+(UITapGestureRecognizer *) addTapGesture:(UIView *)view target:(id)target numberOfTap:(int)cnt sel:(SEL)sel;

//给某视图添加长按事件
+(UILongPressGestureRecognizer *) addLongPressGesture:(UIView *)view minimumPressDuration:(CFTimeInterval)pressDuration target:(id)targert sel:(SEL)sel;

//复制约束
+(void) copyConstraint:(UIView *)superView srcView:(UIView *)srcView desView:(UIView *)desView topMore:(float)topMore;

//复制约束
+(void) copyConstraint:(UIView *)superView srcView:(UIView *)srcView desView:(UIView *)desView;

//添加边缘约束
+(void) copyMarginConstraint:(UIView *)superView srcView:(UIView *)srcView desView:(UIView *)desView;

//添加Center约束
+(void) addCenterConstraint:(UIView *)superView view:(UIView *)view;

//缩放图片
+(UIImage*)  OriginImage:(UIImage *)image scaleToSize:(CGSize)size;

//textField只能输入数字
+ (BOOL)onlyInputNumber:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string decimalDigits:(unsigned int)decimalCount;

//拨打电话
+ (void)makeCallTelphone:(NSString *)telphone;

@end
