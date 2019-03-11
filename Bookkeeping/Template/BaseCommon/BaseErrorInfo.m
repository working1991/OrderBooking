//
//  ErrorInfo.m
//  XZD
//
//  Created by sysweal on 14/11/19.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import "BaseErrorInfo.h"

@implementation BaseErrorInfo

//get error des
+(NSString *) getErrorMsg:(BaseErrorCode)code
{
    NSString *str = NSLocalizedString(@"未知异常", nil);
    switch ( code ) {
        case ErrorCode_Internet:
            str = NSLocalizedString(@"网络连接异常", nil);
            break;
        case ErrorCode_DataParser:
            str = NSLocalizedString(@"处理异常", nil);
            break;
        default:
            break;
    }
    
    return str;
}

@end
