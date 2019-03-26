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

//确认下单
- (void)confirmOrder:(Order_Model *)modal
{
    NSMutableArray *productArr = [NSMutableArray array];
    for (Product_Modal *productModal in modal.productTypeArr) {
        NSMutableArray *typeArr = [NSMutableArray array];
        for (Standard_Modal *typeModel in productModal.typeArr) {
            NSDictionary *typeDic = @{@"product_re_spec_id":typeModel.productReSpecId?typeModel.productReSpecId:@"" ,@"price":[NSString stringWithFormat:@"%.2lf", typeModel.realPrice], @"product_number":[NSString stringWithFormat:@"%d", (int)typeModel.saleCount]};
            [typeArr addObject:typeDic];
        }
        [productArr addObject:@{@"product_id":productModal.id_?productModal.id_:@"", @"productSpecs": typeArr}];
    }
    
    NSDictionary *dic = @{@"user_id":modal.oporaterId?modal.oporaterId:@"", @"customer_id":modal.customerModal.id_?modal.customerModal.id_:Null_Default, @"company_id":modal.companyId?modal.companyId:@"", @"order_price":[NSString stringWithFormat:@"%.2lf", modal.orderPrice], @"real_price":[NSString stringWithFormat:@"%.2lf", modal.realPrice], @"order_status":[NSString stringWithFormat:@"%d", (int)modal.orderStatus], @"pay_type":modal.payTypeCode?modal.payTypeCode:@"", @"product_number":[NSString stringWithFormat:@"%d", (int)modal.saleCount], @"products": productArr};
    [self startPostRequest:@"confirmOrder" bodyDic:dic];
}

//订单列表
- (void)queryOrderList:(NSString *)userId companyId:(NSString *)companyId orderStatus:(OrderStatus)status;
{
    NSDictionary *dic = @{@"user_id":userId?userId:@"", @"company_id":companyId?companyId:@"", @"order_status":[NSString stringWithFormat:@"%d", (int)status], @"is_permission": @"1"};
    [self startPostListRequest:@"queryOrderList" bodyDic:dic];
}

//订单详情
- (void)queryOrderDetail:(NSString *)orderId;
{
    NSDictionary *dic = @{@"order_id":orderId?orderId:@""};
    [self startPostRequest:@"queryOrderDetail" bodyDic:dic];
}

//销售汇总
- (void)querySaleTotalInfo:(NSString *)userId companyId:(NSString *)companyId
{
    NSDictionary *dic = @{@"user_id":userId?userId:@"", @"company_id":companyId?companyId:@"", @"is_permission": @"0"};
    [self startPostListRequest:@"querySaleTotalInfo" bodyDic:dic];
}

//客户列表
- (void)queryCustomerList:(NSString *)companyId
{
    NSDictionary *dic = @{@"company_id":companyId?companyId:@""};
    [self startPostRequest:@"queryCustomerList" bodyDic:dic];
}


//新增、修改客户
- (void)addCustomer:(Customer_Modal *)modal
{
    NSDictionary *dic = @{@"company_id":modal.companyId?modal.companyId:@"", @"name":modal.name?modal.name:@"", @"id":modal.id_?modal.id_:Null_Default, @"mobile":modal.telphone?modal.telphone:@"", @"address":modal.address?modal.address:@""};
    [self startPostRequest:@"addCutomer" bodyDic:dic];
}


#pragma mark - BASE

- (void)startPostListRequest:(NSString *)opKey bodyDic:(NSDictionary *)bodyDic
{
    NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:bodyDic];
    
    mDic[@"page_num"] = [NSString stringWithFormat:@"%d",self.pageModal_.currentPage_];
    mDic[@"page_size"] = [NSString stringWithFormat:@"%d",PageSize];
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
