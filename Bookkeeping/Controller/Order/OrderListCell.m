//
//  OrderListCell.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/14.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "OrderListCell.h"

@implementation OrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CALayer *layer = self.infoView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 10;
    
    layer = self.operateBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 5;
    layer.borderColor = self.operateBtn.titleLabel.textColor.CGColor;
    layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
