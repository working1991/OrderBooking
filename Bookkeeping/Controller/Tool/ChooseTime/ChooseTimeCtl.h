//
//  ChooseTimeCtl.h
//  EherEmployee
//
//  Created by Luoqw on 2018/1/9.
//  Copyright © 2018年 eher. All rights reserved.
//

#import "BaseUIViewController.h"

@interface ChooseTimeCtl : BaseUIViewController

@property(nonatomic,strong) NSDate      *date_;
@property(nonatomic,strong) NSDate      *minDate_;
@property(nonatomic,strong) NSDate      *maxDate_;
@property(nonatomic,strong) NSString    *dateStr_;
@property(nonatomic,weak)   IBOutlet    UIDatePicker    *datePicker_;
@property(nonatomic,weak)   IBOutlet    UIButton        *okBtn_;
@property (weak, nonatomic) IBOutlet UIButton *clearBtn;
@property(nonatomic,strong) void (^finished)(NSDate *);
@property(nonatomic,assign) BOOL bCanClear;

@property(nonatomic,weak)   IBOutlet    UIView *cancelView;

//开始
+(void) startByDateStr:(NSString *)dateStr showInfoView:(UIView *)showInfoView finished:(void(^)(NSDate *))finished;

//开始
+(void) startByDate:(NSDate *)date showInfoView:(UIView *)showInfoView finished:(void(^)(NSDate *))finished;

//开始
+(void) startByDateStr:(NSString *)dateStr minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate showInfoView:(UIView *)showInfoView finished:(void(^)(NSDate *))finished;

//开始
+(void) startByDateStr:(NSString *)dateStr bCanClear:(BOOL)bCanClear minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate showInfoView:(UIView *)showInfoView finished:(void(^)(NSDate *))finished;

@end
