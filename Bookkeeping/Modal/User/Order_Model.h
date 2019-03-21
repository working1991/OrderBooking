//
//  Order_Model.h
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/21.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "Base_Modal.h"

typedef enum : NSUInteger {
    OrderStatus_WaitPay = 1,
    OrderStatus_Complete = 2,
    OrderStatus_Incomplete = 3,
} OrderStatus;

NS_ASSUME_NONNULL_BEGIN

@interface Order_Model : Base_Modal

@property (strong, nonatomic) NSString        *oporaterId;
@property (strong, nonatomic) NSString        *oporaterName;
@property (strong, nonatomic) NSString        *productId;
@property (strong, nonatomic) NSString        *productName;
@property (strong, nonatomic) NSString        *customerId;
@property (strong, nonatomic) NSString        *customerName;
@property (strong, nonatomic) NSString        *companyId;
@property (strong, nonatomic) NSString        *payTypeCode;
@property (assign, nonatomic) double        orderPrice;
@property (assign, nonatomic) double        realPrice;
@property (assign, nonatomic) OrderStatus   orderStatus;
@property (assign, nonatomic) int           saleCount;
@property (strong, nonatomic) NSArray       *productTypeArr;

@end

NS_ASSUME_NONNULL_END
