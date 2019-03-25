//
//  ShopCarHeaderView.m
//  EherEducation
//
//  Created by Luoqw on 2017/2/9.
//  Copyright © 2017年 eher. All rights reserved.
//

#import "ShopCarHeaderView.h"

@implementation ShopCarHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    CALayer *layer = self.iconImgView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 10;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (IBAction)chooseItemClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.itemChoosed) {
        self.itemChoosed(sender.selected);
    }
}

@end
