//
//  LQWCardDetailCtl.h
//  XZD
//
//  Created by luoqingwu on 15/11/13.
//  Copyright © 2015年 sysweal. All rights reserved.
//

#import "BaseListController.h"

@interface OrderDetailCtl : BaseListController

@property (weak, nonatomic) IBOutlet UIView  *headView;
@property (weak, nonatomic) IBOutlet UILabel *customerLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *operaterLb;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *realPayLb;
@property (weak, nonatomic) IBOutlet UIButton *operateBtn;

@end
