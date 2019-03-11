//
//  CustomerCell.m
//  EherEmployee
//
//  Created by Luoqw on 2018/1/26.
//  Copyright © 2018年 eher. All rights reserved.
//

#import "CustomerCell.h"

@implementation CustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CALayer *layer = self.headImgView.layer;
    layer.cornerRadius = layer.bounds.size.width/2;
    layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
