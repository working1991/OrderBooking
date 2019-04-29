//
//  DebeListCell.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/4/29.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "DebeListCell.h"

@implementation DebeListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CALayer *layer = self.recordBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 5;
//    layer.borderColor = self.recordBtn.titleLabel.textColor.CGColor;
//    layer.borderWidth = 1.0;
    
    layer = self.payBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 5;
//    layer.borderColor = self.payBtn.titleLabel.textColor.CGColor;
//    layer.borderWidth = 1.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)queryRecord:(id)sender
{
    if (self.recordBlock) {
        self.recordBlock();
    }
}

- (IBAction)payDebt:(id)sender
{
    if (self.payBlock) {
        self.payBlock();
    }
}

@end
