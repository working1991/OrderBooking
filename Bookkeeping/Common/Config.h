//
//  Config.h
//  XZD
//
//  Created by sysweal on 14/11/24.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ServiceAddr_Default           @"http://193.112.93.183:8080/api"
#define Config_Key_ServiceAddr      @"service_addr"

//登录成功后，需要重新登录的时间
#define Mgr_ReLogin_Seconds         (30*24*60*60)

//主题颜色 (31b7aa)
#define Color_Default               [UIColor colorWithRed:49.0/255 green:183.0/255 blue:170.0/255 alpha:1.000]

//背景色 (F1F4F4)
#define Color_Background_Default    [UIColor colorWithRed:0.945 green:0.957 blue:0.957 alpha:1.000]

//主要字体颜色
#define Color_Text_Main             [UIColor colorWithWhite:0.200 alpha:1.000]

//UIBarButtonItem 颜色
#define Color_BarButtonItem         [UIColor whiteColor]

#define Default_Null_Str            @"--"


#define Add_Product_Num             [Config getAddProductNum]

//购物车变化通知Key
#define NotifyKey_ShopCartChanged    @"NotifyKey_ShopCartChanged"


@interface Config : NSObject

//服务器地址
+ (void)setServiceAddr:(NSString *)addrStr;
+ (NSString *)getServiceAddr;

+ (void)setAddProductNum:(int)num;
+ (int)getAddProductNum;

@end
