//
//  ChooseStandardCtl.h
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/12.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "BaseListController.h"

@interface ChooseStandardCtl : BaseListController

+(ChooseStandardCtl *) start:(Base_Modal *)model showInfoView:(UIView *)showInfoView finished:(void(^)(Base_Modal *))finished;

@end
