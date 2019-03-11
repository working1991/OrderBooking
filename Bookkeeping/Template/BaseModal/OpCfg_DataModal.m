//
//  OpCfg_DataModal.m
//  XZD
//
//  Created by sysweal on 14/12/2.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import "OpCfg_DataModal.h"

@implementation OpCfg_DataModal

@synthesize key_,des_,value_,url_,type_,loadingStr_,noDataStr_,bDataParser_,requestModelType_,bOld;

-(id) init
{
    self = [super init];
    
    loadingStr_ = NSLocalizedString(@"正在加载...", nil);
    noDataStr_ = NSLocalizedString(@"暂无数据", nil);
    bDataParser_ = YES;
    requestModelType_ = RequestModelType_Other;
    
    return self;
}

@end
