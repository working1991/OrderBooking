
//
//  BaseConfig.m
//  XZD
//
//  Created by 勇 汪 on 14/12/2.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import "BaseConfig.h"
#import "BaseCommon.h"

@implementation BaseConfig

//获取key对应的设置值
+(NSString *) getDBValueByKey:(NSString *)key
{
    NSString *value = nil;
    
    sqlite3_stmt *result = [[MyDataBase defaultDB] selectSQL:nil fileds:@"value" whereStr:[NSString stringWithFormat:@"key='%@'",key] limit:1 tableName:DB_Table_Config];
    
    while ( sqlite3_step(result) == SQLITE_ROW )
    {
        //data
        char *rowData_0 = (char *)sqlite3_column_text(result, 0);
        value = [NSString stringWithUTF8String:rowData_0];
    }
    sqlite3_finalize(result);
    
    return value;
}

//设置key对应的设置值
+(BOOL) setDBValueByKey:(NSString *)key value:(NSString *)value
{
    BOOL flag = NO;
    
    //先将以前的删除
    [[MyDataBase defaultDB] deleteSQL:[NSString stringWithFormat:@"key='%@'",key] tableName:DB_Table_Config];
    
    //插入新数据
    NSString *columnsName = [[NSString alloc] initWithFormat:@"key,value,create_datetime"];
    NSString *columnsValue = [[NSString alloc] initWithFormat:@"'%@','%@','%@'",key,value,[BaseCommon getCurrentDateTime]];
    
    //插入数据
    flag = [[MyDataBase defaultDB] insertSQL:columnsName columnsValue:columnsValue tableName:DB_Table_Config];
    
    return flag;
}

@end
