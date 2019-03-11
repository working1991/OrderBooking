//
//  TabBarControllerConfig.m
//  ERP
//
//  Created by Luoqw on 2017/3/30.
//  Copyright © 2017年 eheeher. All rights reserved.
//

#import "TabBarControllerConfig.h"
#import "Config.h"
#import "ShowProductCtl.h"
#import "OrderListCtl.h"
#import "MineCtl.h"

@interface TabBarControllerConfig ()

@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;

@end

@implementation TabBarControllerConfig

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [CenterPlusButton registerPlusButton];
//    }
//    return self;
//}

/**
 *  lazy load tabBarController
 *
 *  @return CYLTabBarController
 */
- (CYLTabBarController *)tabBarController {
    if (_tabBarController == nil) {
        /**
         * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
         * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
         * 更推荐后一种做法。
         */
        UIEdgeInsets imageInsets = UIEdgeInsetsMake(-2, 0, 2, 0);
        UIOffset titlePositionAdjustment = UIOffsetZero;
        
        CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers
                                                                                   tabBarItemsAttributes:self.tabBarItemsAttributesForController
                                                                                             imageInsets:imageInsets
                                                                                 titlePositionAdjustment:titlePositionAdjustment
                                                                                                 context:nil
                                                 ];
        [self customizeTabBarAppearance:tabBarController];
        _tabBarController = tabBarController;
    }
    return _tabBarController;
}
- (NSArray *)viewControllers {
    //首页
    UIViewController *productCtl = [[ShowProductCtl alloc] init];
    UIViewController *productNav = [EherNavigationController getNav:productCtl barHidden:NO];

    //订单
    UIViewController *orderCtl = [[OrderListCtl alloc] init];
    UIViewController *orderNav = [EherNavigationController getNav:orderCtl barHidden:NO];;
    //我
    UIViewController *mineCtl = [[MineCtl alloc] init];
    UIViewController *mineNav = [EherNavigationController getNav:mineCtl barHidden:NO];;
    
    NSArray *viewControllers = @[
                                 productNav,
                                 orderNav,
                                 mineNav
                                 ];
    return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController {
    NSDictionary *productTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"首页",
                                                 CYLTabBarItemImage : @"tabBar_product_off",  /* NSString and UIImage are supported*/
                                                 CYLTabBarItemSelectedImage : @"tabBar_product_on", /* NSString and UIImage are supported*/
                                                 };
    NSDictionary *orderTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"订单",
                                                  CYLTabBarItemImage : @"tabBar_order_off",
                                                  CYLTabBarItemSelectedImage : @"tabBar_order_on",
                                                  };
    NSDictionary *mineTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"我",
                                                  CYLTabBarItemImage : @"tabBar_mine_off",
                                                  CYLTabBarItemSelectedImage : @"tabBar_mine_on"
                                                  };
    NSArray *tabBarItemsAttributes = @[
                                       productTabBarItemsAttributes,
                                       orderTabBarItemsAttributes,
                                       mineTabBarItemsAttributes
                                       ];
    return tabBarItemsAttributes;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
#warning CUSTOMIZE YOUR TABBAR APPEARANCE
    // Customize UITabBar height
    // 自定义 TabBar 高度
    tabBarController.tabBarHeight = 50.f;
    tabBarController.tabBarHeight = CYL_IS_IPHONE_X ? 80 : 50;
    
//    tabBarController.tabBarWidth = 600.f;
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = Color_Default;
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    
    
    // Set the dark color to selected tab (the dimmed background)
    // TabBarItem选中后的背景颜色
    // [self customizeTabBarSelectionIndicatorImage];

    
    // set the bar shadow image
    // This shadow image attribute is ignored if the tab bar does not also have a custom background image.So at least set somthing.
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
    
    // set the bar background image
    // 设置背景图片
    // UITabBar *tabBarAppearance = [UITabBar appearance];
    // [tabBarAppearance setBackgroundImage:[UIImage imageNamed:@"tabbar_background"]];
    
    // remove the bar system shadow image
    // 去除 TabBar 自带的顶部阴影
    // [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}


- (void)customizeTabBarSelectionIndicatorImage {
    ///Get initialized TabBar Height if exists, otherwise get Default TabBar Height.
    UITabBarController *tabBarController = [self cyl_tabBarController] ?: [[UITabBarController alloc] init];
    CGFloat tabBarHeight = tabBarController.tabBar.frame.size.height;
    CGSize selectionIndicatorImageSize = CGSizeMake(CYLTabBarItemWidth, tabBarHeight);
    //Get initialized TabBar if exists.
    UITabBar *tabBar = [self cyl_tabBarController].tabBar ?: [UITabBar appearance];
    [tabBar setSelectionIndicatorImage:
     [[self class] imageWithColor:[UIColor redColor]
                             size:selectionIndicatorImageSize]];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width + 1, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
