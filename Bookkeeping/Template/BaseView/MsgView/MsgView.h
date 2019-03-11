//
//  MsgView.h
//  XZD
//
//  Created by sysweal on 14/12/17.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    MsgViewLocationType_Right,
    MsgViewLocationType_Mid,
}MsgViewLocationType;

@interface MsgView : UIView
{
    BOOL    bHaveInit_;
}

@property(nonatomic,weak)   IBOutlet    UILabel *lb_;

//设置消息
+(void) setMsg:(UIView *)view cnt:(int)cnt;

//设置消息
+(void) setMsg:(UIView *)view rightLess:(float)rightLess topMore:(float)topMore cnt:(int)cnt;

//设置消息
+(void) setMsg:(UIView *)view point:(CGPoint)point cnt:(int)cnt;

//设置消息
+(void) setMsg:(UIView *)segmentControl index:(int)index cnt:(NSUInteger)cnt;

//设置小圆点
+(void) setMsgWithRedPoint:(UIView *)view cnt:(int)cnt;

@end
