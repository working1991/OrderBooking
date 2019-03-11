//
//  MineItemCell.m
//  EherEducation
//
//  Created by Luoqw on 2017/2/7.
//  Copyright © 2017年 eher. All rights reserved.
//

#import "MineItemCell.h"

@implementation MineItemCell

@synthesize itemImageView,itemNameLb;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _lineHeight.constant = 0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void) showItemInfo:(NSDictionary *)info
{
    itemNameLb.text = info[@"itemName"];
    itemImageView.image = [UIImage imageNamed:info[@"icon"]];
}

@end
