//
//  ExRequestCon.m
//  XZD
//
//  Created by sysweal on 14/12/1.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import "ExRequestCon.h"

#define Null_Default    [NSNull null]

@implementation RequestCon (ExReqeustCon)

#pragma mark - Login

//登录
-(void) doLogin:(NSString *)username pwd:(NSString *)pwd
{
    NSDictionary *dic = @{@"account":username ?username:@"",@"password":pwd ?pwd:@""};
    [self startPostRequest:@"doLogin" bodyDic:dic];
}

    
//修改密码
- (void)modifyPassword:(NSString *)userName oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword
{
    NSDictionary *dic = @{@"account":userName ?userName:@"",@"old_password":oldPassword?oldPassword:@"",@"password":newPassword?newPassword:@""};
    [self startPostRequest:@"modifyPassword" bodyDic:dic];
}

//获取商品分类
- (void)getProuductGorpByCompanyId:(NSString *)companyId
{
    NSDictionary *dic = @{@"company_id":companyId?companyId:@""};
    [self startPostRequest:@"getProductGrop" bodyDic:dic];
}

//商品列表
- (void)getProductList:(NSString *)companyId groupId:(NSString *)groupId
{
    NSDictionary *dic = @{@"company_id":companyId?companyId:@"", @"group_id":groupId?groupId:@""};
    [self startPostListRequest:@"getProductList" bodyDic:dic];
}

//商品搜索
- (void)searchProductList:(NSString *)companyId keyword:(NSString *)keyword
{
    NSDictionary *dic = @{@"company_id":companyId?companyId:@"", @"key_word":keyword?keyword:@""};
    [self startPostListRequest:@"searchProduct" bodyDic:dic];
}

//商品详情
- (void)getProductDetail:(NSString *)productId
{
    NSDictionary *dic = @{@"product_id":productId?productId:@""};
    [self startPostRequest:@"getProductDetail" bodyDic:dic];
}

//新增、修改客户
- (void)addCustomer:(Customer_Modal *)modal
{
    NSDictionary *dic = @{@"company_id":modal.companyId?modal.companyId:@"", @"name":modal.name?modal.name:@"", @"id":modal.id_?modal.id_:@"", @"mobile":modal.telphone?modal.telphone:@"", @"address":modal.address?modal.address:@""};
    [self startPostListRequest:@"searchProduct" bodyDic:dic];
}


#pragma mark - BASE

- (void)startPostListRequest:(NSString *)opKey bodyDic:(NSDictionary *)bodyDic
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:bodyDic];
    
    mDic[@"page_size"] = [NSString stringWithFormat:@"%d",self.pageModal_.currentPage_];
    mDic[@"page_num"] = [NSString stringWithFormat:@"%d",PageSize];
    [self startPostRequest:opKey bodyDic:mDic];
}

- (void) startPostRequest:(NSString *)opKey bodyDic:(NSDictionary *)bodyDic
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];

    dic[@"timestamp"] = @"1";
    dic[@"req_json"] = bodyDic?bodyDic:[NSDictionary new];

    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc] init];
    NSString * body = [jsonWriter stringWithObject:dic];
    [super startPostRequest:opKey param:nil body:body];
}

@end

@implementation ExRequestCon

@end
