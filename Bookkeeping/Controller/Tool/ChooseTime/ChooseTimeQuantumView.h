//
//  ChooseTimeQuantumView.h
//  XZD
//
//  Created by luoqingwu on 15/10/12.
//  Copyright (c) 2015年 sysweal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseTimeCtl.h"

@interface ChooseTimeQuantumView : UIView

{
    NSString                *nowDateStr_;
    NSDate                  *nowDate_;
    NSDate                  *initialDate_;
}

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *initialTimeBtn;
@property (weak, nonatomic) IBOutlet UIButton *upToTimeBtn;

@property (strong, nonatomic) UIView    *showView;
@property (strong, nonatomic) NSString  *initialTimeStr;
@property (strong, nonatomic) NSString  *upToTimeStr;

- (void)setInitialTime:(NSString *)initialStr upToTime:(NSString *)upToStr;

@end
