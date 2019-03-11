//
//  LCUser_DataModal.h
//  XZD
//
//  Created by LcGero on 15/10/31.
//  Copyright © 2015年 sysweal. All rights reserved.
//

#import "Base_Modal.h"

typedef enum {
    SexType_Men,     //男
    SexType_Woman,   //女
    SexType_Other,   //其他
}SexType;

@interface User_Modal : Base_Modal

@property (strong, nonatomic) NSString        *sex_;
@property (assign, nonatomic) SexType         sexType;
@property (strong, nonatomic) NSString        *telphone;
@property (strong, nonatomic) NSString        *imgUrl;

@property (strong, nonatomic) NSString        *account;
@property (strong, nonatomic) NSString        *password;

@end
