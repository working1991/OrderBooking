//
//  Config.m
//  XZD
//
//  Created by sysweal on 14/11/24.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import "Config.h"

@implementation Config

//设置服务器地址
+ (void)setServiceAddr:(NSString *)addrStr
{
    [[NSUserDefaults standardUserDefaults] setObject:addrStr forKey:Config_Key_ServiceAddr];
}

//获取应用服务器地址
+(NSString *) getServiceAddr
{
    if ( [[NSUserDefaults standardUserDefaults] objectForKey:Config_Key_ServiceAddr] ) {
        return [[NSUserDefaults standardUserDefaults] objectForKey:Config_Key_ServiceAddr];
    }
    return ServiceAddr_Default;
}

@end
