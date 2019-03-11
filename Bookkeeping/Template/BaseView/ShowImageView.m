//
//  ShowImageView.m
//  XZD
//
//  Created by LcGero on 15/11/30.
//  Copyright © 2015年 sysweal. All rights reserved.
//

#import "ShowImageView.h"

@implementation ShowImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    __weak typeof(ShowImageView *)weakSelf = self;
    [UIView animateWithDuration:0.25f animations:^{
        weakSelf.alpha = 0;
    }];
}

@end
