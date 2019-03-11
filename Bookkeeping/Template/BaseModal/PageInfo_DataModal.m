//
//  PageInfo_DataModal.m
//  XZD
//
//  Created by sysweal on 14/12/1.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import "PageInfo_DataModal.h"

@implementation PageInfo_DataModal

@synthesize currentPage_,pageSize_,totalPage_,totalSize_;//,bHaveMore;

-(id) init
{
    self = [super init];

    currentPage_ = PageStart_Index;
    totalPage_ = 0;
    totalSize_ = 0;
    pageSize_ = 0;
    //bHaveMore = YES;
    
    return self;
}

@end
