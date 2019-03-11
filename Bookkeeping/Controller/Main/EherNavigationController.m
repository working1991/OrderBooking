//
//  EherNavigationController.m
//  ERP
//
//  Created by Luoqw on 2017/3/24.
//  Copyright © 2017年 eheeher. All rights reserved.
//

#import "EherNavigationController.h"
#import "Common.h"

@interface EherNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation EherNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        [EherNavigationController setupNavBarTheme];
        [EherNavigationController setupBarButtonItemTheme];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  设置导航栏主题
 */
+ (void)setupNavBarTheme
{
    //1、取出导航栏
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    //2、设置标题属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:18];
    textAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:textAttrs];
    //    [navBar setBackgroundImage:[UIImage imageNamed:@"nav_background"] forBarMetrics:UIBarMetricsDefault];
    navBar.tintColor = [UIColor whiteColor];
    
    [navBar setBackgroundImage:[self imageWithColor:Color_Default] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
 *  设置导航栏按钮的主题
 */
+ (void)setupBarButtonItemTheme
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    //设置文字属性
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    textAttrs[NSForegroundColorAttributeName] = Color_BarButtonItem;
    [item setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:textAttrs forState:UIControlStateHighlighted];
    
//    NSMutableDictionary *disableAttrs = [NSMutableDictionary dictionary];
//    disableAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
//    disableAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
//    [item setTitleTextAttributes:disableAttrs forState:UIControlStateDisabled];
    
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    //判断是否是栈顶控制器，如果不是栈顶控制器就隐藏tabbar
    if (self.viewControllers.count > 0)
    {
        [viewController setHidesBottomBarWhenPushed:YES];
    
    }
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    return [super popViewControllerAnimated:animated];
}

#pragma mark - UIGestureRecognizerDelegate 在根视图时不响应interactivePopGestureRecognizer手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.navigationController.viewControllers.count == 1) {
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - navigationDelegate 实现此代理方法也是为防止滑动返回时界面卡死
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //开启滑动手势
    if ([navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


//获取Nav
+ (EherNavigationController *)getNav:(UIViewController *)ctl
                         barHidden:(BOOL)barHidden {
    EherNavigationController *nav =
    [[EherNavigationController alloc] initWithRootViewController:ctl];
    nav.navigationBarHidden = barHidden;
    return nav;
}

@end
