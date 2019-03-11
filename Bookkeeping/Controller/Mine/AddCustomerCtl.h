//
//  AddCustomerCtl.h
//  XZD
//
//  Created by sysweal on 15/5/19.
//  Copyright (c) 2015年 sysweal. All rights reserved.
//

#import "BaseUIViewController.h"
#import "Customer_Modal.h"

@interface AddCustomerCtl : BaseUIViewController

@property (weak, nonatomic) IBOutlet    UITextField *nameTf;
@property (weak, nonatomic) IBOutlet    UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet    UITextField *addressTf;
@property (weak, nonatomic) IBOutlet    UISegmentedControl      *sexSeg;

@property(nonatomic,strong) void (^finished)(Customer_Modal *);

//start
+(void) start:(void(^)(Customer_Modal *))finished;

@end
