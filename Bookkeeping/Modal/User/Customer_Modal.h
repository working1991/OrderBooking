//
//  LQWCustomer_DataModal.h
//  XZD
//
//  Created by luoqingwu on 15/10/31.
//  Copyright © 2015年 sysweal. All rights reserved.
//

#import "User_Modal.h"

@interface Customer_Modal : User_Modal

@property (strong, nonatomic) NSString        *fristChar;
@property (strong, nonatomic) NSString        *address;
@property (assign, nonatomic) double    debtAmount;//欠款金额

@end
