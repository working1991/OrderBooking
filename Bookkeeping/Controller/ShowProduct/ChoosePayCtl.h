//
//  ChoosePayCtl.h
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/13.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "BaseListController.h"

@interface ChoosePayCtl : BaseListController

+(ChoosePayCtl *) start:(UIView *)showInfoView finished:(void(^)(Base_Modal *))finished;

@end
