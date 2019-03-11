//
//  KeyChainTool.h
//  XZD
//
//  Created by sysweal on 2016/12/21.
//  Copyright © 2016年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainTool : NSObject

//存
+ (void)save:(NSString *)service data:(id)data;
//取
+ (id)load:(NSString *)service;
//删除
+ (void)delete:(NSString *)service;

@end
