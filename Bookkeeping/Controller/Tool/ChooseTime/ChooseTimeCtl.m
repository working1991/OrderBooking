//
//  ChooseTimeCtl.m
//  EherEmployee
//
//  Created by Luoqw on 2018/1/9.
//  Copyright © 2018年 eher. All rights reserved.
//

#import "ChooseTimeCtl.h"

static ChooseTimeCtl *myTimeCtl;

@interface ChooseTimeCtl ()

@end

@implementation ChooseTimeCtl

@synthesize date_,minDate_,maxDate_,dateStr_,datePicker_,okBtn_,finished, cancelView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.clearBtn.layer.cornerRadius = 4;
    self.clearBtn.hidden = self.bCanClear?NO:YES;
    
    // [datePicker_ setMotionEffects:<#(NSArray *)#>];
    //[datePicker_ setDate:<#(NSDate *)#>];
    if( date_ ){
        [datePicker_ setDate:date_];
    }
    else if( dateStr_ ){
        NSDate *date = [Common getDate:dateStr_ format:@"yyyy-MM-dd"];
        if( date ){
            [datePicker_ setDate:date];
        }
    }
    
    if( minDate_ ){
        [datePicker_ setMinimumDate:minDate_];
    }
    if( maxDate_ ){
        [datePicker_ setMaximumDate:maxDate_];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelDateView)];
    [cancelView addGestureRecognizer:tap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancelDateView
{
    [ChooseTimeCtl hide];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

-(void) viewClickResponse:(id)sender
{
    if( sender == okBtn_ ){
        if (finished) {
            finished(datePicker_.date);
        }
        [myTimeCtl.view removeFromSuperview];
    } else if (sender == self.clearBtn) {
        if (finished) {
            finished(nil);
        }
        [myTimeCtl.view removeFromSuperview];
    }
}

//开始
+(void) startByDateStr:(NSString *)dateStr showInfoView:(UIView *)showInfoView finished:(void(^)(NSDate *))finished
{
    [ChooseTimeCtl hide];
    myTimeCtl = [[ChooseTimeCtl alloc] init];
    myTimeCtl.dateStr_ = dateStr;
    myTimeCtl.finished = finished;
    [ChooseTimeCtl showChooseDate];
}

//开始
+(void) startByDate:(NSDate *)date showInfoView:(UIView *)showInfoView finished:(void(^)(NSDate *))finished
{
    [ChooseTimeCtl hide];
    myTimeCtl = [[ChooseTimeCtl alloc] init];
    myTimeCtl.date_ = date;
    myTimeCtl.finished = finished;
    [ChooseTimeCtl showChooseDate];
    
}

//开始
+(void) startByDateStr:(NSString *)dateStr minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate showInfoView:(UIView *)showInfoView finished:(void(^)(NSDate *))finished
{
    [ChooseTimeCtl startByDateStr:dateStr bCanClear:NO minDate:minDate maxDate:maxDate showInfoView:showInfoView finished:finished];
}

//开始
+(void) startByDateStr:(NSString *)dateStr bCanClear:(BOOL)bCanClear minDate:(NSDate *)minDate maxDate:(NSDate *)maxDate showInfoView:(UIView *)showInfoView finished:(void(^)(NSDate *))finished
{
    [ChooseTimeCtl hide];
    myTimeCtl = [[ChooseTimeCtl alloc] init];
    myTimeCtl.dateStr_ = dateStr;
    myTimeCtl.minDate_ = minDate;
    myTimeCtl.maxDate_ = maxDate;
    myTimeCtl.finished = finished;
    myTimeCtl.bCanClear = bCanClear;
    [ChooseTimeCtl showChooseDate];
}

//显示
+ (void) showChooseDate
{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    
    [window addSubview:myTimeCtl.view];
    myTimeCtl.view.translatesAutoresizingMaskIntoConstraints = NO;
    myTimeCtl.view.alpha = 0;
    
    NSLayoutConstraint *leftLC = [NSLayoutConstraint
                                  constraintWithItem:myTimeCtl.view
                                  attribute:NSLayoutAttributeLeft
                                  relatedBy:NSLayoutRelationEqual
                                  toItem:window
                                  attribute:NSLayoutAttributeLeft
                                  multiplier:1
                                  constant:0];
    NSLayoutConstraint *bottomLC = [NSLayoutConstraint
                                    constraintWithItem:myTimeCtl.view
                                    attribute:NSLayoutAttributeBottom
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:window
                                    attribute:NSLayoutAttributeBottom
                                    multiplier:1
                                    constant:0];
    NSLayoutConstraint *widthLC = [NSLayoutConstraint
                                   constraintWithItem:myTimeCtl.view
                                   attribute:NSLayoutAttributeWidth
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:nil
                                   attribute:NSLayoutAttributeNotAnAttribute
                                   multiplier:1
                                   constant:window.frame.size.width];
    NSLayoutConstraint *heightLC = [NSLayoutConstraint
                                    constraintWithItem:myTimeCtl.view
                                    attribute:NSLayoutAttributeHeight
                                    relatedBy:NSLayoutRelationEqual
                                    toItem:nil
                                    attribute:NSLayoutAttributeNotAnAttribute
                                    multiplier:1
                                    constant:window.frame.size.height];
    [window addConstraint:leftLC];
    [window addConstraint:bottomLC];
    [window addConstraint:widthLC];
    [window addConstraint:heightLC];
    
    double delayInSeconds = 0.15f;//allow enough time for progress to animate
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.3f
                         animations:^{
                             myTimeCtl.view.alpha = 1.0;
                             [window layoutIfNeeded];
                         }];
    });
    
    
}

//隐藏
+(void) hide
{
    myTimeCtl.view.alpha = 0.0;
    [myTimeCtl.view removeFromSuperview];
    myTimeCtl = nil;
}

@end
