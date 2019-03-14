//
//  OrderListCell.h
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/14.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UILabel *customerLb;
@property (weak, nonatomic) IBOutlet UILabel *statusLb;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *operaterLb;
@property (weak, nonatomic) IBOutlet UILabel *productLb;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLb;
@property (weak, nonatomic) IBOutlet UILabel *realPayLb;
@property (weak, nonatomic) IBOutlet UIButton *operateBtn;

@end
