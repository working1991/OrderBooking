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

@synthesize minNum;

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
    
    self.cntTf.userInteractionEnabled = NO;
    
    minNum = Add_Product_Num;
    
    _originalPriceLb
    .lineType = LineTypeMiddle;
    _originalPriceLb.lineColor = _originalPriceLb.textColor;
    
    [_chooseBtn setImage:[UIImage imageNamed:@"singleSelected"] forState:UIControlStateSelected];
    [_chooseBtn setImage:[UIImage imageNamed:@"singleSelect"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTypeModle:(Standard_Modal *)model
{
//    self.nameLb.text = [NSString stringWithFormat:@"尺码：%@", model.secondSpecName];
    NSMutableString *string = [NSMutableString stringWithString:@"尺码："];
    [string appendString:model.secondSpecName.length==0?@"":model.secondSpecName];
    if(model.secondSpecName.length == 0) {
        [string appendString:model.firstSpecName.length==0?@"":model.firstSpecName];
    } else {
        if (model.firstSpecName.length!=0) {
            [string appendFormat:@"(%@)", model.firstSpecName];
        }
    }
    self.nameLb.text = string;
    self.originalPriceLb.hidden = model.productSpecPrice==model.realPrice;
    self.originalPriceLb.text = [NSString stringWithFormat:@"原价：¥%.2f", model.productSpecPrice];
    self.priceLb.text = [NSString stringWithFormat:@"¥%.2lf元/件", model.realPrice];
    self.cntTf.text = [NSString stringWithFormat:@"%i", model.saleCount];
    [self updateView];
}

- (void)updateView
{
    int newNum = [_cntTf.text intValue];
    if( newNum <= minNum ){
        self.desBtn.alpha = 0.3;
    }else{
        self.desBtn.alpha = 1.0;
    }
}

- (void)updateNum:(int)newNum
{
    if (newNum<minNum) {
        newNum = minNum;
    }
    _cntTf.text = [NSString stringWithFormat:@"%i", newNum];
    if (self.numChange) {
        self.numChange([_cntTf.text intValue]);
    }
    [self updateView];
}

- (IBAction)desClick:(UIButton *)sender {
    int newNum = [_cntTf.text intValue] -Add_Product_Num;
    [self updateNum:newNum];
}
- (IBAction)addClick:(UIButton *)sender {
    
    int newNum = [_cntTf.text intValue] + Add_Product_Num;
    [self updateNum:newNum];
}

- (IBAction)chooseItemClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (self.itemChoosed) {
        self.itemChoosed(sender.selected);
    }
}

- (IBAction)modifyPriceBlock:(UIButton *)sender {
    if (self.modifyPriceBlock) {
        self.modifyPriceBlock();
    }
}

@end
