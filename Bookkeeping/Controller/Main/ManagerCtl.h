//
//  ViewController.h
//  XZD
//
//  Created by sysweal on 14/11/14.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Template.h"
#import "RequestCon.h"
#import "TabBarControllerConfig.h"
#import "User_Modal.h"
#define LoginIdUserDefaultKey   @"UserLoginId"

@interface ManagerCtl : BaseUIViewController <UIWebViewDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic)   CYLTabBarController         *mainCtl;
@property (assign, nonatomic)   BOOL isAutoLogin;
@property (weak, nonatomic)   IBOutlet UIWebView    *webView;


//共用的
+(ManagerCtl *) defaultManagerCtl;


//设置登录信息 
+(void) setRoleInfo:(User_Modal *)modal;

//获取登录信息
+(User_Modal *) getRoleInfo;

//保存用户登录信息
+ (void)saveUserNameToUserDefault:(User_Modal *)modal;

//获取用户缓存登录信息
+ (User_Modal *)getUserNameForUserDefault;

//获取Nav
+(UINavigationController *) getNav:(UIViewController *)ctl barHidden:(BOOL)barHidden;

-(void) loginOK:(BaseUIViewController *)ctl modal:(User_Modal *)modal;

-(void) doLogin:(User_Modal *)modal;

//登出
-(void) loginOff;

+ (UINavigationController *)getCurrentNav;



@end

