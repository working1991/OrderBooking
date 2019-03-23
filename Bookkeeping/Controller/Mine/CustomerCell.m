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

- (void)setDefineTypeName:(NSString *)name
{
    NSArray *colorArr = @[[UIColor colorWithRed:0.244 green:1.000 blue:0.892 alpha:0.800],
                          [UIColor colorWithRed:0.973 green:0.068 blue:0.841 alpha:0.800],
                          [UIColor colorWithRed:0.973 green:0.130 blue:0.105 alpha:0.800],
                          [UIColor colorWithRed:0.176 green:0.000 blue:0.985 alpha:0.800],
                          [UIColor colorWithRed:0.280 green:1.000 blue:0.192 alpha:0.800],
                          [UIColor colorWithRed:0.162 green:0.996 blue:0.940 alpha:1.000]];
    if (name) {
        int value = [name characterAtIndex:0];
        NSInteger index = value%colorArr.count;
        self.headImgView.backgroundColor = colorArr[index];
        self.headLb.text = [name substringToIndex:1];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
