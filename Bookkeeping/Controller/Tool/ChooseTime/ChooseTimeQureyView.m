//
//  ChooseTimeQureyView.m
//  EherEmployee
//
//  Created by Luoqw on 2018/6/19.
//  Copyright © 2018年 eher. All rights reserved.
//

#import "ChooseTimeQureyView.h"

@implementation ChooseTimeQureyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    [[NSBundle mainBundle] loadNibNamed:@"ChooseTimeQureyView" owner:self options:nil];
    [self addSubview:self.backView];
    self.backView.translatesAutoresizingMaskIntoConstraints = NO;
    [Common copyConstraint:self srcView:self desView:self.backView];
    [Common addTapGesture:self.backView target:self numberOfTap:1 sel:@selector(hiddenTimeView)];
    [self initUIShape];
}

- (void)initUIShape
{
    [self.timeQuantumView layoutIfNeeded];
    CALayer *layer = self.queryBtn.layer;
    layer.cornerRadius = 5;
    
    [self hiddenTimeView];
}

- (void)showTimeView
{
    if (self.initialTimeStr && self.upToTimeStr) {
        [self.timeQuantumView setInitialTime:self.initialTimeStr upToTime:self.upToTimeStr];
    }
    if (self.superview) {
        [self.superview bringSubviewToFront:self];
    }
    [UIView animateWithDuration:0.2 animations:^{
        self.heightCons.constant = 100;
        self.timeView.alpha = 1.0;
        self.backView.alpha = 1.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.timeView.hidden = NO;
        self.backView.hidden = NO;
        self.hidden = NO;
    }];
}

- (void)hiddenTimeView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.heightCons.constant = 0;
        self.timeView.alpha = 0.0;
        self.backView.alpha = 0.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.timeView.hidden = YES;
        self.backView.hidden = YES;
        self.hidden = YES;
    }];
}

- (IBAction)clickQueryBtn:(id)sender
{
    self.initialTimeStr = self.timeQuantumView.initialTimeStr;
    self.upToTimeStr = self.timeQuantumView.upToTimeStr;
    [UIView animateWithDuration:0.2 animations:^{
        self.heightCons.constant = 0;
        self.timeView.alpha = 0.0;
        self.backView.alpha = 0.0;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.timeView.hidden = YES;
        self.backView.hidden = YES;
        self.hidden = YES;
        if (self.queryBlock) {
            self.queryBlock();
        }
    }];
}

@end
