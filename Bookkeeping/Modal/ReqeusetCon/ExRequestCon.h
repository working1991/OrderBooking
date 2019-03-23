//
//  ExRequestCon.h
//  XZD
//
//  Created by sysweal on 14/12/1.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestCon.h"
#import "Base_Modal.h"
#import "Customer_Modal.h"
#import "Standard_Modal.h"
#import "Order_Model.h"

@interface RequestCon (ExReqeustCon)

#pragma mark - Login

//登录
-(void) doLogin:(NSString *)username pwd:(NSString *)pwd;

//修改密码
- (void)modifyPassword:(NSString *)userName oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword;

//获取商品分类
- (void)getProuductGorpByCompanyId:(NSString *)companyId;

//商品列表
- (void)getProductList:(NSString *)companyId groupId:(NSString *)groupId;

//商品搜索
- (void)searchProductList:(NSString *)companyId keyword:(NSString *)keyword;

//商品详情
- (void)getProductDetail:(NSString *)productId;

//确认下单
- (void)confirmOrder:(Order_Model *)model;

//订单列表
- (void)queryOrderList:(NSString *)userId companyId:(NSString *)companyId orderStatus:(OrderStatus)status;

//订单详情
- (void)queryOrderDetail:(NSString *)orderId;

//销售汇总
- (void)querySaleTotalInfo:(NSString *)userId companyId:(NSString *)companyId;

//客户列表
- (void)queryCustomerList:(NSString *)companyId;

//新增、修改客户
- (void)addCustomer:(Customer_Modal *)modal;

@end

@interface ExRequestCon : NSObject

@end
