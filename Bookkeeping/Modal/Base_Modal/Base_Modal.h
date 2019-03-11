//
//  WYBase_Modal.h
//  XZD
//
//  Created by sysweal on 15/10/30.
//  Copyright © 2015年 sysweal. All rights reserved.
//

#import "PageInfo_DataModal.h"

@interface Base_Modal : PageInfo_DataModal

@property(nonatomic,assign) BOOL        bSelected_;
@property(nonatomic,strong) NSString    *restCode;
@property(nonatomic,strong) NSString    *restMsg;
@property(nonatomic,strong) NSString    *id_;
@property(nonatomic,strong) NSString    *code;
@property(nonatomic,strong) NSString    *name;
@property(nonatomic,strong) NSString    *des;

@property(nonatomic,strong) NSString    *createTime;//创建时间
@property(nonatomic,strong) NSString    *updateTime;//更新时间
@property(nonatomic,strong) NSString    *endTime;//结束时间

+(NSString *) getArrDes:(NSArray *)arr;

+(NSString *) getArrDes:(NSArray *)arr withDot:(NSString *)dot;

@end
