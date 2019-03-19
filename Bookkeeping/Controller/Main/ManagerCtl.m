//
//  ViewController.m
//  XZD
//
//  Created by sysweal on 14/11/14.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//


#import "ManagerCtl.h"
#import "LoginCtl.h"
#import "ShowProductCtl.h"

static ManagerCtl *shareMgrCtl;
static User_Modal *roleModal;

@interface ManagerCtl ()

{
    RequestCon          *loginCon;
    User_Modal          *loginModal;
}

@end

@implementation ManagerCtl

@synthesize webView, mainCtl;


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    if (self.isAutoLogin) {
        [self layoutTabbar];
        [self automaticLogin:[ManagerCtl getUserNameForUserDefault]];
    }
}

- (void)showLoadingView:(BaseRequest *)request
{
    if (request == loginCon) {
        return;
    } else {
        [super showLoadingView:request];
    }
}

- (void)finishLoadData:(BaseRequest *)request dataArr:(NSArray *)dataArr
{
    if (request == loginCon) {
        User_Modal *modal = [dataArr firstObject];
        if ([modal.restCode isEqualToString:Request_OK] && [modal isKindOfClass:[User_Modal class]]) {
            modal.password = loginModal.password;
            [ManagerCtl setRoleInfo:modal];
        } else {
            if (self.isAutoLogin) {
                [self automaticLoginFail];
            } else {
                [self showChooseAlertViewCtl:@"登录失败" msg:modal.restMsg?modal.restMsg:@"请稍后重试" confirmHandle:nil];
            }
            
        }
    }
}

- (void)errorLoadData:(BaseRequest *)request code:(BaseErrorCode)code
{
    if (request == loginCon) {
        if (self.isAutoLogin) {
            [self automaticLoginFail];
        }
    }
}

- (void)automaticLoginFail
{
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"登录失败" message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"重新登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [self backLogin];
    }];
    [alertCtl addAction:confirmAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

#pragma mark - Login
//登录
-(void) automaticLogin:(User_Modal *)modal
{
    loginModal = modal;
    loginCon = [self getNewRequestCon:NO];
    [loginCon doLogin:modal.account pwd:modal.password];
}

-(void) loginOK:(BaseUIViewController *)ctl modal:(User_Modal *)modal
{
    [ManagerCtl saveUserNameToUserDefault:modal];
    [ManagerCtl setRoleInfo:modal];
    [self layoutTabbar];
    [ctl.navigationController pushViewController:self animated:YES];
    [self removeTopViewController:ctl.navigationController];
}

- (void)layoutTabbar
{
    TabBarControllerConfig *tabBarControllerConfig = [[TabBarControllerConfig alloc] init];
    mainCtl = tabBarControllerConfig.tabBarController;
    mainCtl.delegate = self;
    [self.navigationController addChildViewController:mainCtl];
    [self.view addSubview:mainCtl.view];
}

//登出
- (void)loginOff {
    
    //清除数据
    [ManagerCtl saveUserNameToUserDefault:nil];
    [ManagerCtl setRoleInfo:nil];
    
    [self backLogin];
}

//登录页面
- (void)backLogin
{
    LoginCtl *ctrl = [LoginCtl new];
    for (BaseUIViewController *subViewCtl in mainCtl.viewControllers) {
        [subViewCtl removeFromParentViewController];
    }
    [self.navigationController pushViewController:ctrl animated:YES];
    [self removeTopViewController:self.navigationController];
}

- (void)removeTopViewController:(UINavigationController *)nav
{
    NSMutableArray *viewCtls = [NSMutableArray arrayWithObject:[nav.viewControllers lastObject]];
    nav.viewControllers = viewCtls;
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        
    }
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        BaseUIViewController *ctl = nav.viewControllers.firstObject;
        if ([ctl isKindOfClass:[ShowProductCtl class]]) {
            [ctl onStart];
        }
    }
}

- (UIControl *)getCurrentTabBarButton:(UITabBarController *)tabBarController
{
    /*
     打印tabBarController.tabBar.subviews
     "<_UITabBarBackgroundView: 0x7fddb21236e0; frame = (0 0; 375 49); autoresize = W; userInteractionEnabled = NO; layer = <CALayer: 0x7fddb21297d0>>",
     "<UITabBarButton: 0x7fddb23bb500; frame = (2 1; 90 48); opaque = NO; layer = <CALayer: 0x7fddb2130880>>",
     "<UITabBarButton: 0x7fddb217e1a0; frame = (96 1; 90 48); opaque = NO; layer = <CALayer: 0x7fddb217eec0>>",
     "<UITabBarButton: 0x7fddb2184700; frame = (190 1; 89 48); opaque = NO; layer = <CALayer: 0x7fddb2184e20>>",
     "<UITabBarButton: 0x7fddb21893c0; frame = (283 1; 90 48); opaque = NO; layer = <CALayer: 0x7fddb2189b60>>",
     "<UIImageView: 0x7fddb217ea70; frame = (0 -0.5; 375 0.5); autoresize = W; userInteractionEnabled = NO; layer = <CALayer: 0x7fddb219fa40>>"
     */
    NSMutableArray *tabBarButtons = [NSMutableArray array];
    for (UIView *view in tabBarController.tabBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
            [tabBarButtons addObject:view];
        }
    }
    UIControl *control = [tabBarButtons objectAtIndex:tabBarController.selectedIndex];
    return control;
}

- (void)tabBarButtonClick:(UIControl *)control
{
    CAKeyframeAnimation *keyAnimation = [CAKeyframeAnimation animation];
    keyAnimation.keyPath = @"transform.scale";
    keyAnimation.values = @[@1.0, @1.1, @0.9, @1.0];
    keyAnimation.duration = 0.3;
    keyAnimation.calculationMode = kCAAnimationCubic;
    [control.layer addAnimation:keyAnimation forKey:nil];
    /*
     打印control的子视图
     "<UITabBarSwappableImageView: 0x7fd7ebc52760; frame = (32 5.5; 25 25); opaque = NO; userInteractionEnabled = NO; tintColor = UIDeviceWhiteColorSpace 0.572549 1; layer = <CALayer: 0x7fd7ebc52940>>",
     "<UITabBarButtonLabel: 0x7fd7ebc4f360; frame = (29.5 35; 30 12); text = '\U8d2d\U7269\U8f66'; opaque = NO; userInteractionEnabled = NO; layer = <_UILabelLayer: 0x7fd7ebc4e090>>" a
     */
//    for (UIView *imageView in control.subviews) {
//        if ([imageView isKindOfClass:NSClassFromString(@"UITabBarSwappableImageView")]) {
//            
//        }
//    }
}

//共用的
+ (ManagerCtl *)defaultManagerCtl {
    if (!shareMgrCtl) {
        shareMgrCtl = [ManagerCtl new];
    }
    return shareMgrCtl;
}



//设置登录信息
+(void) setRoleInfo:(User_Modal *)modal
{
    roleModal = modal;
}

//获取登录信息
+(User_Modal *) getRoleInfo
{
    return roleModal;
}


//获取Nav
+ (UINavigationController *)getNav:(UIViewController *)ctl
                         barHidden:(BOOL)barHidden {
    EherNavigationController *nav =
    [[EherNavigationController alloc] initWithRootViewController:ctl];
    nav.navigationBarHidden = barHidden;
    
    return nav;
}

+ (UINavigationController *)getCurrentNav
{
    return [ManagerCtl defaultManagerCtl].mainCtl.selectedViewController;
}

#pragma mark - 用户缓存
+ (User_Modal *)getUserNameForUserDefault
{
    //获取用户名数组
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSArray *nameList = [userDefaultes arrayForKey:LoginIdUserDefaultKey];
    if ( nameList.count > 0 ) {
        NSDictionary *userDic = nameList[0];
        User_Modal *modal = [[User_Modal alloc] init];
        
        modal.id_ = [userDic objectForKey:@"id"];
        modal.name = [userDic objectForKey:@"name"];
        modal.telphone = [userDic objectForKey:@"mobile"];
        modal.account = [userDic objectForKey:@"account"];
        modal.password = userDic[@"password"];
        modal.companyId = userDic[@"companyId"];
        return modal;
    }
    return nil;
}

+ (void)saveUserNameToUserDefault:(User_Modal *)modal
{
    NSMutableArray *userNameList = [NSMutableArray array];
    if (modal.id_) {
        NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
        userDic[@"id"] = modal.id_?modal.id_:@"";
        userDic[@"name"] = modal.name?modal.name:@"";
        userDic[@"mobile"] = modal.telphone?modal.telphone:@"";
        userDic[@"account"] = modal.account?modal.account:@"";
        userDic[@"password"] = modal.password?modal.password:@"";
        userDic[@"companyId"] = modal.companyId?modal.companyId:@"";

        
        [userNameList addObject:userDic];
    }
    
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    [userDefaultes setObject:[NSArray arrayWithArray:userNameList] forKey:LoginIdUserDefaultKey];
}

@end
