//
//  AppDelegate.m
//  ERP
//
//  Created by Luoqw on 2017/3/21.
//  Copyright © 2017年 eher. All rights reserved.
//

#import "AppDelegate.h"

#import "Common.h"
#import "Config.h"
#import "MyLog.h"
#import "RequestCon.h"
#import "ManagerCtl.h"
#import "ExDataParser.h"

#import "LoginCtl.h"
#import "BaseUIViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    //设置一下基础地址
    [RequestCon setBaseURL:[Config getServiceAddr]];
    
    [self setShowAppearence];
    [self updateContentCtl];
    
    if (@available(iOS 11.0, *)){//避免滚动视图顶部出现20的空白以及push或者pop的时候页面有一个上移或者下移的异常动画的问题
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    return YES;
}

- (void)updateContentCtl
{
    UIViewController    *rootCtl ;
    ManagerCtl *managerCtl = [ManagerCtl defaultManagerCtl];
    if ([ManagerCtl getUserNameForUserDefault].id_.length > 0) {
        [ManagerCtl setRoleInfo:[ManagerCtl getUserNameForUserDefault]];
        rootCtl = managerCtl;
        managerCtl.isAutoLogin = YES;
    } else {
        LoginCtl *ctl = [[LoginCtl alloc] init];
        managerCtl.isAutoLogin = NO;
        rootCtl = ctl;
    }
    [managerCtl beginLoad:nil exParam:nil];
    
    UINavigationController *nav = [ManagerCtl getNav:rootCtl barHidden:YES];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
}

-(void) setShowAppearence
{
    [[UITextField appearance] setTintColor:Color_Default];
    [[UITextView appearance] setTintColor:Color_Default];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:
(void (^)(UIBackgroundFetchResult))completionHandler {
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
   
}
@end
