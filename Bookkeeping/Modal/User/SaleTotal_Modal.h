//
//  SaleTotal_Modal.h
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/23.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "Base_Modal.h"

NS_ASSUME_NONNULL_BEGIN

@interface SaleTotal_Modal : Base_Modal

@property (assign, nonatomic) double        saleAmount;//销售额
@property (assign, nonatomic) int        orderCount;//销售单数量
@property (assign, nonatomic) int           saleCount;//商品数量

@end

NS_ASSUME_NONNULL_END
