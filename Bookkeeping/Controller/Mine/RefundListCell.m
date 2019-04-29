//
//  RefundListCell.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/4/29.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "RefundListCell.h"

@implementation RefundListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CALayer *layer = self.infoView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 10;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
