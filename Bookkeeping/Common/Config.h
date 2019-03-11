//
//  Config.h
//  XZD
//
//  Created by sysweal on 14/11/24.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ServiceAddr_Default           @"http://oss.eher365.com:8080/eher/api"
#define Config_Key_ServiceAddr      @"service_addr"

//登录成功后，需要重新登录的时间
#define Mgr_ReLogin_Seconds         (30*24*60*60)

//主题颜色 (31b7aa)
#define Color_Default               [UIColor colorWithRed:49.0/255 green:183.0/255 blue:170.0/255 alpha:1.000]

//背景色 (F1F4F4)
#define Color_Background_Default    [UIColor colorWithRed:0.945 green:0.957 blue:0.957 alpha:1.000]

//主要字体颜色
#define Color_Text_Main             [UIColor colorWithWhite:0.200 alpha:1.000]

//次要字体颜色
#define Color_Default_Gray          [UIColor colorWithWhite:0.400 alpha:1.000]

#define Color_Default_Off           [UIColor colorWithRed:133.0/255 green:133.0/255 blue:133.0/255 alpha:1]

//UIBarButtonItem 颜色
#define Color_BarButtonItem         [UIColor whiteColor]

#define Default_Null_Str            @"--"


@interface Config : NSObject

//服务器地址
+ (void)setServiceAddr:(NSString *)addrStr;
+ (NSString *)getServiceAddr;

@end