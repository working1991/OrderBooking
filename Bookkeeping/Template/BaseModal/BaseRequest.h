//
//  BaseRequest.h
//  XZD
//
//  Created by sysweal on 14/11/14.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RequestCfg_DataModal.h"
#import "BaseErrorInfo.h"
#import "PageInfo_DataModal.h"
#import "DataParser.h"
#import "DataManger.h"

@class BaseRequest;
@protocol BaseRequestDelegate <NSObject>

-(void) requestBegin:(BaseRequest *)request;

-(void) requestFinish:(BaseRequest *)request dataArr:(NSArray *)dataArr;

-(void) requestFail:(BaseRequest *)request code:(BaseErrorCode)code;

@end

typedef enum
{
    RequestState_Null,
    RequestState_Loading,
    RequestState_Fail,
    RequestState_Finish,
}RequestState;

@interface BaseRequest : NSObject
{
    NSString                *url_;
    NSString                *body_;
    
    NSURLConnection         *conn_;             //数据请求
    NSMutableData           *receiveData_;      //收到的数据
    
    BOOL                    bCacheData_;
}

@property(nonatomic,assign) long long               startTime;
@property(nonatomic,assign) NSInteger               tag_;
@property(nonatomic,assign) NSInteger               index_;
@property(nonatomic,assign) RequestState            state_;
@property(nonatomic,strong) NSString                *parameter;
@property(nonatomic,strong) OpCfg_DataModal         *cfgModal_;
@property(nonatomic,strong) PageInfo_DataModal      *pageModal_;
@property(nonatomic,assign) BOOL                    bSaveData_;
@property(nonatomic,assign) BOOL                    bAvailable;
@property(nonatomic,strong) NSMutableArray          *dataArr_;
@property(nonatomic,weak)   id<BaseRequestDelegate> delegate_;

//获取ReqeustCfg_DataModal
+(OpCfg_DataModal *) getRequestCfgModal:(NSString *)opKey;

//获取其他URL的ReqeustCfg_DataModal
+(OpCfg_DataModal *) getRequestCfgModal:(NSString *)opKey withOtherURL:(NSString *)otherURL;

//设置BaseURL
+(void) setBaseURL:(NSString *)value;

//获取BaseURL
+(NSString *) getBaseURL;

//获取BaseURL,不包含api
+(NSString *) getBaseURLNoApi;

//设置Cookie信息
+(void) setCookieInfo:(NSString *)cookie;

//获取Cookie
+(NSString *) getCookie;

//设置展示部份是否采用缓存
+(void) setShowModelCacheEnable:(BOOL)flag;

//设置经理部份是否采用缓存
+(void) setAdminModelCacheEnable:(BOOL)flag;

//清除
-(void) clear;

//qhl 2016.2.2 搜索清除
-(void) searchClear;
//开始请求
-(void) startGetReqeust:(NSString *)opKey param:(NSString *)param body:(NSString *)body;

//开始请求
-(void) startPostRequest:(NSString *)opKey param:(NSString *)param body:(NSString *)body;

//开始请求
-(void) startNewPostRequest:(NSString *)opKey body:(NSString *)body;

//开始请求
-(void) startReqeust:(NSString *)method url:(NSString *)url body:(NSString *)body;

//开始其他URL请求
-(void) startPostRequestOtherURL:(NSString *)otherURL opKey:(NSString *)opKey param:(NSString *)param body:(NSString *)body;

@end
