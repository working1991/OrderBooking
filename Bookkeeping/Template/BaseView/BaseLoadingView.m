//
//  BaseLoadingView.m
//  XZD
//
//  Created by sysweal on 14/11/18.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import "BaseLoadingView.h"

@implementation BaseLoadingView

@synthesize txtLb_;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [super drawRect:rect];

    if( !bSetCorner_ ){
        bSetCorner_ = YES;
        
        //设置圆角
        CALayer *layer=[self layer];
        [layer setMasksToBounds:YES];
        //[layer setBorderWidth:1.0];
        [layer setCornerRadius:8.0];
        //[layer setBorderColor:[[UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1] CGColor]];
    }
}


@end
