//
//  ErrorInfo.h
//  XZD
//
//  Created by sysweal on 14/11/19.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    ErrorCode_Success,
    
    ErrorCode_Unknow,
    ErrorCode_Internet,
    ErrorCode_DataParser,
}BaseErrorCode;

@interface BaseErrorInfo : NSObject

//get error des
+(NSString *) getErrorMsg:(BaseErrorCode)code;

@end
