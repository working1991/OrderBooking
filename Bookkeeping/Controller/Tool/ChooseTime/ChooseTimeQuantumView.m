//
//  ChooseTimeQuantumView.m
//  XZD
//
//  Created by luoqingwu on 15/10/12.
//  Copyright (c) 2015年 sysweal. All rights reserved.
//

#import "ChooseTimeQuantumView.h"
#import "Common.h"

@implementation ChooseTimeQuantumView

@synthesize initialTimeBtn, upToTimeBtn, showView, initialTimeStr, upToTimeStr;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"ChooseTimeQuantumView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [Common copyConstraint:self srcView:self desView:self.contentView];
    
    CALayer *layer=[initialTimeBtn layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1];
    [layer setCornerRadius:4];
    [layer setBorderColor:[Color_Default CGColor]];
    
    layer=[upToTimeBtn layer];
    [layer setMasksToBounds:YES];
    [layer setBorderWidth:1];
    [layer setCornerRadius:4];
    [layer setBorderColor:[Color_Default CGColor]];
    
    nowDateStr_ = [Common getDateStr:nil format:@"yyyy-MM-dd"];
    [upToTimeBtn setTitle:nowDateStr_ forState:UIControlStateNormal];
    
    upToTimeStr = nowDateStr_;
    nowDate_ = [NSDate date];
    initialDate_ = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60*7)];
    initialTimeStr = [Common getDateStr:initialDate_ format:@"yyyy-MM-dd"];
    [initialTimeBtn setTitle:initialTimeStr forState:UIControlStateNormal];
}

- (void)setInitialTime:(NSString *)initialStr upToTime:(NSString *)upToStr
{
    initialTimeStr = initialStr;
    upToTimeStr = upToStr;
    initialDate_ = [Common getDate:initialStr format:@"yyyy-MM-dd"];
    [initialTimeBtn setTitle:initialTimeStr forState:UIControlStateNormal];
    [upToTimeBtn setTitle:upToTimeStr forState:UIControlStateNormal];
}

- (IBAction)chooseTime:(id)sender {
    
    if (sender == initialTimeBtn) {
        [ChooseTimeCtl startByDateStr:initialTimeStr minDate:nil maxDate:nowDate_ showInfoView:showView finished:^(NSDate *date) {
            NSString *dateStr = [Common getDateStr:date format:@"yyyy-MM-dd"];
            initialDate_ = date;
            initialTimeStr = dateStr;
            [sender setTitle:dateStr forState:UIControlStateNormal];
        }];
    } else if (sender == upToTimeBtn) {
        [ChooseTimeCtl startByDateStr:upToTimeStr minDate:initialDate_ maxDate:nowDate_ showInfoView:showView finished:^(NSDate *date) {
            NSString *dateStr = [Common getDateStr:date format:@"yyyy-MM-dd"];
            upToTimeStr = dateStr;
            [sender setTitle:dateStr forState:UIControlStateNormal];
        }];
    }
}



@end
