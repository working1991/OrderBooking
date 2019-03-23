//
//  Standard_Modal.h
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/20.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "Product_Modal.h"

NS_ASSUME_NONNULL_BEGIN

@interface Standard_Modal : Product_Modal

@property (strong, nonatomic) NSString        *firstSpecId;
@property (strong, nonatomic) NSString        *firstSpecName;
@property (strong, nonatomic) NSString        *productReSpecId;
@property (strong, nonatomic) NSString        *secondSpecName;
@property (assign, nonatomic) double        productSpecPrice;
@property (assign, nonatomic) int        saleCount;
@property (assign, nonatomic) double        realPrice;

@end

NS_ASSUME_NONNULL_END
