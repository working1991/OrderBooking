//
//  PageInfo_DataModal.h
//  XZD
//
//  Created by sysweal on 14/12/1.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseCommon.h"

@interface PageInfo_DataModal : NSObject

@property(nonatomic,assign) int currentPage_;
@property(nonatomic,assign) int totalPage_;
@property(nonatomic,assign) int pageSize_;
@property(nonatomic,assign) int totalSize_;
@property(nonatomic,assign) int modalTag;//辅助内存处理
//@property(nonatomic,assign) BOOL bHaveMore;
@property(nonatomic,assign) int num;

@end
