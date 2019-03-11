//
//  MyDataBase.h
//  ClientTemplate
//
//  Created by job1001 job1001 on 12-12-4.
//
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "BaseCommon.h"

#define DB_FileName                 @"base_db1.sqlite"

@interface MyDataBase : NSObject{
    sqlite3                 *dataBase_;
}

//获取实例
+(MyDataBase *) defaultDB;

//打开数据库
-(int) openDB;

//打开数据库
-(int) openDB:(NSString *)name;

//关闭数据库
-(int) closeDB;

//删除操作
-(BOOL) deleteSQL:(NSString *)whereStr tableName:(NSString *)tableName;

//查询操作
-(sqlite3_stmt *) selectSQL:(NSString *)orderByStr fileds:(NSString *)fileds whereStr:(NSString *)whereStr limit:(int)count tableName:(NSString *)tableName;

//分页查询
-(sqlite3_stmt *) selectSQL:(NSString *)orderByStr fileds:(NSString *)fileds whereStr:(NSString *)whereStr pageIndex:(int)pageIndex pageSize:(int)pageSize tableName:(NSString *)tableName;

//更新操作
-(BOOL) updateSQL:(NSString *)newColumnsKeyAndValue whereStr:(NSString *)whereStr tableName:(NSString *)tableName;

//插入操作
-(BOOL) insertSQL:(NSString *)columnsName columnsValue:(NSString *)columnsValue tableName:(NSString *)tableName;

@end