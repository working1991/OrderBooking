//
//  ExRequestCon.m
//  XZD
//
//  Created by sysweal on 14/12/1.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import "ExRequestCon.h"
#import "MD5.h"
#import "ManagerCtl.h"


#define Null_Default    [NSNull null]

@implementation RequestCon (ExReqeustCon)

#pragma mark - Login

//登录
-(void) doLogin:(NSString *)username pwd:(NSString *)pwd
{
    NSDictionary *dic = @{@"username":username ?username:@"",@"password":pwd ?pwd:@""};
    [self startPostRequest:@"doLogin" bodyDic:dic];
}

    
//修改密码
- (void)modifyPassword:(NSString *)userName oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword
{
    NSDictionary *dic = @{@"username":userName ?userName:@"",@"oldpassword":oldPassword?oldPassword:@"",@"newpassword":newPassword?newPassword:@""};
    [self startPostRequest:@"modifyPassword" bodyDic:dic];
}

#pragma mark - BASE

- (void)startPostListRequest:(NSString *)opKey bodyDic:(NSDictionary *)bodyDic
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:bodyDic];
    
    mDic[@"start"] = [NSString stringWithFormat:@"%d",self.pageModal_.currentPage_];
    mDic[@"limit"] = [NSString stringWithFormat:@"%d",PageSize];
    [self startPostRequest:opKey bodyDic:mDic];
}

- (void)startNewPostRequest:(NSString *)opKey bodyDic:(NSDictionary *)bodyDic
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:bodyDic];
    
//    mDic[@"sys_type"] = Terminal_Type;
//    mDic[@"version"] = Version_Bundle;
//    mDic[@"device"] = [Common getDeviceInditify];
//    mDic[@"sessionId"] = [ManagerCtl getRoleInfo].sessionId ?[ManagerCtl getRoleInfo].sessionId:@"";
//    mDic[@"account"] = [ManagerCtl getRoleInfo].account?[ManagerCtl getRoleInfo].account:@"";
//    if ([ManagerCtl getRoleInfo].storeId) {
//        mDic[@"organizationId"] = [ManagerCtl getRoleInfo].storeId;
//    }
    
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString * body = [jsonWriter stringWithObject:mDic];
    [super startNewPostRequest:opKey body:body];
}

- (void) startPostRequest:(NSString *)opKey bodyDic:(NSDictionary *)bodyDic
{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//
//    dic[@"sys_type"] = Terminal_Type;
//    dic[@"version"] = Version_Bundle;
//    dic[@"device"] = [Common getDeviceInditify];
//    dic[@"sessionId"] = [ManagerCtl getRoleInfo].sessionId ?[ManagerCtl getRoleInfo].sessionId:@"";
//    dic[@"account"] = [ManagerCtl getRoleInfo].account?[ManagerCtl getRoleInfo].account:@"";
//    if ([ManagerCtl getRoleInfo].storeId) {
//        dic[@"organizationId"] = [ManagerCtl getRoleInfo].storeId;
//    }
//    dic[@"data"] = bodyDic?bodyDic:[NSDictionary new];
//
//    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
//    NSString * body = [jsonWriter stringWithObject:dic];
//    [super startPostRequest:opKey param:nil body:body];
}

@end

@implementation ExRequestCon

@end
