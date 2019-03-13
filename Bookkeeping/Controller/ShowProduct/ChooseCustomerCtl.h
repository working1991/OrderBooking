//
//  ChooseCustomerCtl.h
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/13.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "CustomerCtl.h"

@interface ChooseCustomerCtl : CustomerCtl

- (instancetype)initWithFinish:(void(^)(Base_Modal *))finished;

@end
