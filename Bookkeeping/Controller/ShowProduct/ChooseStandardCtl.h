//
//  ChooseStandardCtl.h
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/12.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "XHSegmentViewController.h"
#import "Product_Modal.h"

@interface ChooseStandardCtl : XHSegmentViewController

+(ChooseStandardCtl *) start:(Product_Modal *)model showInfoView:(UIView *)showInfoView finished:(void(^)(Product_Modal *))finished;

@end
