//
//  Order_Model.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/21.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "Order_Model.h"

@implementation Order_Model

+ (NSString *)getPayTypeName:(NSString *)code
{
    NSString *name = @"";
    if ([code isEqualToString:@"1"]) {
        name = @"现金";
    } else if ([code isEqualToString:@"2"]) {
        name = @"支付宝";
    } else if ([code isEqualToString:@"3"]) {
        name = @"微信";
    } else if ([code isEqualToString:@"4"]) {
        name = @"赊账";
    }
    return name;
}

- (void)setOrderStatus:(OrderStatus)orderStatus
{
    _orderStatus = orderStatus;
    self.orderStatusName = [Order_Model getOrderStatusName:orderStatus];
}

+ (NSString *)getOrderStatusName:(OrderStatus)status
{
    NSString *name = @"全部";
    switch (status) {
        case OrderStatus_WaitPay:
            name = @"待支付";
            break;
        case OrderStatus_Complete:
            name = @"支付完成";
            break;
        case OrderStatus_Incomplete:
            name = @"支付未完成";
            break;
            
        default:
            break;
    }
    return name;
}

@end
