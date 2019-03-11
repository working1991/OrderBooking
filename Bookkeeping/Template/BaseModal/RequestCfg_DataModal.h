//
//  ReqeustCfg_DataModal.h
//  XZD
//
//  Created by sysweal on 14/11/18.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OpCfg_DataModal.h"
#import "BaseCommon.h"

@interface RequestCfg_DataModal : NSObject

@property(nonatomic,strong) NSString    *debugURL_;
@property(nonatomic,strong) NSString    *releaseURL_;
@property(nonatomic,assign) BOOL        bDebug_;
@property(nonatomic,strong) NSString    *cookie_;
@property(nonatomic,strong) NSString    *loadStr_;
@property(nonatomic,strong) NSString    *noDataStr_;
@property(nonatomic,strong) NSMutableArray     *opArr_;

@property (strong, nonatomic) NSString *otherURL;

//设置BaseURL
+(void) setBaseURL:(NSString *)value;

//获取BaseURL
+(NSString *) getBaseURL;

@end

