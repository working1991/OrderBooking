//
//  BaseConfig.h
//  XZD
//
//  Created by 勇 汪 on 14/12/2.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MyDataBase.h"

//DB里面的TableName
#define DB_Table_LocalCache         @"local_cache"
#define DB_Table_Config             @"config"
#define DB_Table_SearchHistory      @"search_history"

#define Config_Key_UUID             @"new_device_inditify"


//请求的配置文件名称
#define FileName_ReqeustConfig      @"request_config.json"

//分页的起始索引
#define PageStart_Index             1

//每页数据数
#define PageSize                    20

//请求的超时时间
#define Request_Timeout             25

//请求成功Code
#define Request_OK                  @"000000"

//自动更新Code
#define Request_NewVersion          @"000099"
#define Notice_NewVersion           @"haveNewVersion"

#define Request_ServiceDisabled     @"100085"

#define Localization(key)           NSLocalizedString(key, nil)

@interface BaseConfig : NSObject

//获取key对应的设置值
+(NSString *) getDBValueByKey:(NSString *)key;

//设置key对应的设置值
+(BOOL) setDBValueByKey:(NSString *)key value:(NSString *)value;

@end
