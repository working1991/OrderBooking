//
//  OpCfg_DataModal.h
//  XZD
//
//  Created by sysweal on 14/12/2.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    RequestLoadingType_Null,    //无
    RequestLoadingType_Model,   //模态
    RequestLoadingType_Normal,  //常态
}RequestLoadingType;

typedef enum
{
    RequestModelType_Other,     //其它
    
    RequestModelType_Show = 1,  //展示区
}RequestModelType;

@interface OpCfg_DataModal : NSObject

@property(nonatomic,strong) NSString    *key_;
@property(nonatomic,strong) NSString    *des_;
@property(nonatomic,strong) NSString    *value_;
@property(nonatomic,strong) NSString    *url_;
@property(nonatomic,assign) RequestLoadingType type_;
@property(nonatomic,strong) NSString    *loadingStr_;
@property(nonatomic,strong) NSString    *noDataStr_;
@property(nonatomic,assign) BOOL        bDataParser_;
@property(nonatomic,assign) RequestModelType    requestModelType_;
@property(nonatomic,assign) BOOL    bOld;

@end
