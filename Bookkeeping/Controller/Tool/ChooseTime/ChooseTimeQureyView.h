//
//  ChooseTimeQureyView.h
//  EherEmployee
//
//  Created by Luoqw on 2018/6/19.
//  Copyright © 2018年 eher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseTimeQuantumView.h"

@interface ChooseTimeQureyView : UIView

@property (weak, nonatomic) IBOutlet ChooseTimeQuantumView *timeQuantumView;
@property (weak, nonatomic) IBOutlet UIButton *queryBtn;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;

@property (strong, nonatomic) NSString  *initialTimeStr;
@property (strong, nonatomic) NSString  *upToTimeStr;

@property (strong, nonatomic) void(^queryBlock)(void);

- (void)showTimeView;

- (void)hiddenTimeView;

@end
