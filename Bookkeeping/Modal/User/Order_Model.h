//
//  Order_Model.h
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/21.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "Base_Modal.h"
#import "Customer_Modal.h"

typedef enum : NSUInteger {
    OrderStatus_All         = 0,
    OrderStatus_WaitPay     = 1,
    OrderStatus_Complete    = 2,
    OrderStatus_Incomplete  = 3,
} OrderStatus;

NS_ASSUME_NONNULL_BEGIN

@interface Order_Model : Base_Modal

@property (strong, nonatomic) NSString        *oporaterId;
@property (strong, nonatomic) NSString        *oporaterName;
@property (strong, nonatomic) Customer_Modal  *customerModal;
@property (strong, nonatomic) NSString        *companyId;
@property (strong, nonatomic) NSString        *payTypeCode;
@property (strong, nonatomic) NSString        *payTypeName;
@property (assign, nonatomic) double        orderPrice;
@property (assign, nonatomic) double        realPrice;
@property (assign, nonatomic) OrderStatus   orderStatus;
@property (assign, nonatomic) NSString      *orderStatusName;
@property (assign, nonatomic) int           saleCount;
@property (strong, nonatomic) NSArray       *productTypeArr;

+ (NSString *)getPayTypeName:(NSString *)code;
+ (NSString *)getOrderStatusName:(OrderStatus)status;

@end

NS_ASSUME_NONNULL_END
