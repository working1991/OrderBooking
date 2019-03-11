//
//  MsgView.m
//  XZD
//
//  Created by sysweal on 14/12/17.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import "MsgView.h"

@implementation MsgView

@synthesize lb_;

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    if( !bHaveInit_ ){
        bHaveInit_ = YES;
        
        self.userInteractionEnabled = NO;
        
        CALayer *layer=[self layer];
        [layer setMasksToBounds:YES];
        //[layer setBorderWidth:1.0];
        [layer setCornerRadius:self.frame.size.width/2.0];
        //[layer setBorderColor:[[UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1] CGColor]];
    }
}

//设置消息
+(void) setMsg:(UIView *)view cnt:(int)cnt
{
    [self setMsg:view rightLess:6 topMore:6 cnt:cnt];
}

//设置消息
+(void) setMsg:(UIView *)view rightLess:(float)rightLess topMore:(float)topMore cnt:(int)cnt
{
    if( !view ){
        return;
    }
    
    if( cnt <= 0 ){
        for ( UIView *subView in [view subviews] ) {
            if( [subView isKindOfClass:[MsgView class]] ){
                [subView removeFromSuperview];
            }
        }
    }else{
        
        [self addConstranitWithView:view rightLess:rightLess topMore:topMore cnt:cnt size:CGSizeMake(20, 20) lbHidden:NO];
    }
}

+(void) addConstranitWithView:(UIView *)view  rightLess:(float)rightLess topMore:(float)topMore cnt:(int)cnt size:(CGSize)size lbHidden:(BOOL)lbHidden
{
    MsgView *msgView = [[[NSBundle mainBundle] loadNibNamed:@"MsgView" owner:self options:nil] lastObject];
    msgView.translatesAutoresizingMaskIntoConstraints = NO;
    [view addSubview:msgView];
    msgView.lb_.text = [NSString stringWithFormat:@"%d",cnt>99?99:cnt];
    msgView.lb_.hidden = lbHidden;
    
    [view addConstraint:[NSLayoutConstraint
                         constraintWithItem:msgView
                         attribute:NSLayoutAttributeWidth
                         relatedBy:NSLayoutRelationEqual
                         toItem:nil
                         attribute:NSLayoutAttributeNotAnAttribute
                         multiplier:1
                         constant:size.width]];
    
    [view addConstraint:[NSLayoutConstraint
                         constraintWithItem:msgView
                         attribute:NSLayoutAttributeHeight
                         relatedBy:NSLayoutRelationEqual
                         toItem:nil
                         attribute:NSLayoutAttributeNotAnAttribute
                         multiplier:1
                         constant:size.height]];
    
    [view addConstraint:[NSLayoutConstraint
                         constraintWithItem:msgView
                         attribute:NSLayoutAttributeRight
                         relatedBy:NSLayoutRelationEqual
                         toItem:view
                         attribute:NSLayoutAttributeRight
                         multiplier:1
                         constant:-rightLess]];
    
    [view addConstraint:[NSLayoutConstraint
                         constraintWithItem:msgView
                         attribute:NSLayoutAttributeTop
                         relatedBy:NSLayoutRelationEqual
                         toItem:view
                         attribute:NSLayoutAttributeTop
                         multiplier:1
                         constant:topMore]];

}

//设置消息
+(void) setMsg:(UIView *)view point:(CGPoint)point cnt:(int)cnt
{
    if( cnt <= 0 ){
        for ( UIView *subView in [view subviews] ) {
            if( [subView isKindOfClass:[MsgView class]] ){
                [subView removeFromSuperview];
            }
        }
    }else{
        MsgView *msgView = [[[NSBundle mainBundle] loadNibNamed:@"MsgView" owner:self options:nil] lastObject];
        msgView.translatesAutoresizingMaskIntoConstraints = NO;
        [view addSubview:msgView];
        
//        msgView.lb_.text = [NSString stringWithFormat:@"%d",cnt];
//        
//        CGRect rect;
//        rect.origin = point;
//        rect.size.width = 20;
//        rect.size.height = 20;
//        [msgView setFrame:rect];
    }
}

//设置消息
+(void) setMsg:(UIView *)segmentControl index:(int)index cnt:(NSUInteger)cnt
{
    UIView *subView = nil;
    @try {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[segmentControl subviews]];
        //用冒泡法排序
        for ( int i = 0 ; i < [arr count] ; ++i ) {
            for ( int j = 0 ; j < [arr count] - i - 1; ++j ) {
                UIView *now = [arr objectAtIndex:j];
                UIView *next = [arr objectAtIndex:j+1];
                
                int nowValue = now.frame.origin.x;
                int nextValue = next.frame.origin.x;
                
                if( nowValue > nextValue ){
                    [arr removeObjectAtIndex:j];
                    [arr insertObject:now atIndex:j+1];
                }
            }
        }
        
        subView = [arr objectAtIndex:index];
        [self setMsg:subView rightLess:2 topMore:-12 cnt:cnt];
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
    
//    for ( int i = 0 ; i < [[segmentControl subviews] count] ; ++i ) {
//        if( i == index ){
//            subView = [[segmentControl subviews] objectAtIndex:[[segmentControl subviews] count]-i-1];
//        }
//    }
}

//设置小圆点
+(void) setMsgWithRedPoint:(UIView *)view cnt:(int)cnt
{
    if( !view ){
        return;
    }
    
    if( cnt <= 0 ){
        for ( UIView *subView in [view subviews] ) {
            if( [subView isKindOfClass:[MsgView class]] ){
                [subView removeFromSuperview];
            }
        }
    }else{
        
        [self addConstranitWithView:view rightLess:15 topMore:15 cnt:cnt size:CGSizeMake(8, 8) lbHidden:YES];
    }
}

@end
