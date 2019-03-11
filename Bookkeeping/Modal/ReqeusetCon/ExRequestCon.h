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


@end

@interface ExRequestCon : NSObject

@end
