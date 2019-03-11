//
//  DataParser.h
//  XZD
//
//  Created by sysweal on 14/12/2.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataParser : NSObject

//解析数据
+(NSArray *) parserData:(NSString *)opKey data:(NSData *)data;

//解析数据
+(NSArray *) parserOldData:(NSString *)opKey data:(NSData *)data;

@end
