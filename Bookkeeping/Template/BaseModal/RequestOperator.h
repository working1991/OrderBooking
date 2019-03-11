//
//  RequestOperator.h
//  XZD
//
//  Created by LcGero on 2016/11/10.
//  Copyright © 2016年 sysweal. All rights reserved.
//

#import "BaseRequest.h"

typedef void(^OperateFinish)(BOOL);

@interface RequestOperator : NSObject
@property (nonatomic, copy) OperateFinish       finsh;

+(RequestOperator *) shareOperator;

-(void) operateRequest:(BaseRequest *)request checkFinish:(OperateFinish)finish;

@end
