//
//  ERPNavigationController.h
//  ERP
//
//  Created by Luoqw on 2017/3/24.
//  Copyright © 2017年 eheeher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EherNavigationController : UINavigationController

//获取Nav
+(EherNavigationController *) getNav:(UIViewController *)ctl barHidden:(BOOL)barHidden;

@end
