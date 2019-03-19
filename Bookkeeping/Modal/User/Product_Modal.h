//
//  Product_Modal.h
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/18.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "Base_Modal.h"

NS_ASSUME_NONNULL_BEGIN

@interface Product_Modal : Base_Modal

@property (strong, nonatomic) NSString        *imgUrl;
@property (strong, nonatomic) NSString        *unitPrice;//单价

@property (strong, nonatomic) NSString        *companyId;//公司

@end

NS_ASSUME_NONNULL_END
