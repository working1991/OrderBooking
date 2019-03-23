//
//  PrintTool.h
//  XZD
//
//  Created by LcGero on 15/11/25.
//  Copyright © 2015年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Order_Model.h"

@interface PrintTool : NSObject <UIAlertViewDelegate>

+ (PrintTool *)sharedManager;

//订单
- (BOOL)printOrderInfo:(Order_Model *)dataModal;


@end
