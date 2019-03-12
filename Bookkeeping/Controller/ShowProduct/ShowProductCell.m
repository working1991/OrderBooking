//
//  ShowProductCell.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/12.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "ShowProductCell.h"
#import "Common.h"

@implementation ShowProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CALayer *layer = self.infoView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 10;
    
    layer = self.iconImgView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 10;
    
    layer = self.chooseBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 5;
    layer.borderColor = self.chooseBtn.titleLabel.textColor.CGColor;
    layer.borderWidth = 1.0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
