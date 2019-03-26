//
//  LCUser_DataModal.m
//  XZD
//
//  Created by LcGero on 15/10/31.
//  Copyright © 2015年 sysweal. All rights reserved.
//

#import "User_Modal.h"
#import "Config.h"

@implementation User_Modal

-(instancetype) init
{
    self = [super init];
    if ( self ) {
        _sexType = -1;
    }
    return self;
}

- (void)setAddProductNum:(int)addProductNum
{
    [Config setAddProductNum:addProductNum];
    _addProductNum = addProductNum;
}

@end
