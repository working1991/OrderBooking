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

//新增、修改客户
- (void)addCustomer:(Customer_Modal *)modal;

@end

@interface ExRequestCon : NSObject

@end
