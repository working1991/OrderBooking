//
//  ShopCarCell.m
//  EherEducation
//
//  Created by Luoqw on 2017/2/9.
//  Copyright © 2017年 eher. All rights reserved.
//

#import "ChooseStandardCell.h"
#import "Common.h"

@implementation ChooseStandardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    CALayer *layer=[_icoImgView layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:4];
    
    UIColor *borderColor = [Common getColor:@"C8C8C8"];
    layer=[_addBtn layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[borderColor CGColor]];
    
    layer=[_desBtn layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[borderColor CGColor]];
    
    layer=[_cntTf layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[borderColor CGColor]];
    
    _originalPriceLb
    .lineType = LineTypeMiddle;
    _originalPriceLb.lineColor = _originalPriceLb.textColor;
    
    [_chooseBtn setImage:[UIImage imageNamed:@"ico_checked_select"] forState:UIControlStateSelected];
    [_chooseBtn setImage:[UIImage imageNamed:@"ico_checked_normal"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateView
{
    int newNum = [_cntTf.text intValue];
    if( newNum <= 0 ){
        self.desBtn.alpha = 0.3;
    }else{
        self.desBtn.alpha = 1.0;
    }
}

- (void)updateNum:(int)newNum
{
    if (newNum<0) {
        newNum = 0;
    }
    _cntTf.text = [NSString stringWithFormat:@"%i", newNum];
    if (self.numChange) {
        self.numChange([_cntTf.text intValue]);
    }
    [self updateView];
}

- (IBAction)desClick:(UIButton *)sender {
    int newNum = [_cntTf.text intValue] -1;
    if (newNum >= 0) {
        [self updateNum:newNum];
    } else {
        NSLog(@"num can not less than 0");
    }
}
- (IBAction)addClick:(UIButton *)sender {
    
    int newNum = [_cntTf.text intValue] + 1;
    [self updateNum:newNum];
}

- (IBAction)chooseItemClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.itemChoosed) {
        self.itemChoosed(sender.selected);
    }
}

@end
