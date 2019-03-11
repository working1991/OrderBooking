//
//  RequestOperator.m
//  XZD
//
//  Created by LcGero on 2016/11/10.
//  Copyright © 2016年 sysweal. All rights reserved.
//

#import "RequestOperator.h"
#import "Common.h"
#import "MyLog.h"

#define REQUEST_TIME_MARGIN  500

@interface RequestOperator ()
@property (nonatomic, strong) NSMutableArray        *requestQueue;
@end

@implementation RequestOperator

+ (RequestOperator *) shareOperator
{
    static RequestOperator *shareOperator = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareOperator = [[self alloc] init];
    });
    return shareOperator;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestQueue = [NSMutableArray arrayWithCapacity:2]
        ;
    }
    return self;
}

-(void) operateRequest:(BaseRequest *)request checkFinish:(OperateFinish)finish
{
    self.finsh = finish;
    request.bAvailable = YES;
    [self.requestQueue  addObject:request];
    
    if ( self.requestQueue.count == 2 ) {
        BaseRequest *firstReq = self.requestQueue[0];
        if ( [request.parameter isEqualToString:firstReq.parameter] && (request.startTime - firstReq.startTime) <= REQUEST_TIME_MARGIN ) {
            request.bAvailable = NO;
        }
        [self.requestQueue removeObjectsInRange:NSMakeRange(0, self.requestQueue.count - 1)];
    }
    if ( self.finsh ) {
        self.finsh(request.bAvailable);
    }
}

- (void) dealloc
{
    [self.requestQueue removeAllObjects];
}


@end
