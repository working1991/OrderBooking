//
//  WYBase_Modal.m
//  XZD
//
//  Created by sysweal on 15/10/30.
//  Copyright © 2015年 sysweal. All rights reserved.
//

#import "Base_Modal.h"

@implementation Base_Modal

@synthesize restCode,restMsg,code,name,des;

+(NSString *) getArrDes:(NSArray *)arr
{
    return [self getArrDes:arr withDot:@"、"];
}

+(NSString *) getArrDes:(NSArray *)arr withDot:(NSString *)dot
{
    NSMutableString *des = [NSMutableString stringWithFormat:@"暂无"];
    
    if( [arr count] > 0 ){
        des = [[NSMutableString alloc] init];
        for ( Base_Modal *dataModal in arr ) {
            if( [des isEqualToString:@""] ){
                [des appendFormat:@"%@",dataModal.name];
            }else
                [des appendFormat:@"%@%@",dot,dataModal.name];
        }
    }
    return des;
}




-(NSString *) createTime
{
    
    if ( [_createTime rangeOfString:@"-"].location == NSNotFound && _createTime && ![_createTime isKindOfClass:[NSNull class]] && _createTime.length > 7 ) {
        
        return [self formatTime:_createTime];
    }
    return _createTime;
}

-(NSString *) updateTime
{
    if ( [_updateTime rangeOfString:@"-"].location == NSNotFound && _updateTime && ![_updateTime isKindOfClass:[NSNull class]] && _updateTime.length > 7 ) {
        return [self formatTime:_updateTime];
    }
    return _updateTime;
}

-(NSString *) formatTime:(NSString *) originalTime
{
    NSString *year = [originalTime substringToIndex:4];
    NSString *mouth = [originalTime substringWithRange:NSMakeRange(4, 2)];
    NSString *day = [originalTime substringWithRange:NSMakeRange(6, 2)];
    NSString *time = [originalTime substringFromIndex:8];
    return [NSString stringWithFormat:@"%@-%@-%@%@",year,mouth,day,time];
}

@end
