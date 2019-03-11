//
//  ReqeustCfg_DataModal.m
//  XZD
//
//  Created by sysweal on 14/11/18.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import "RequestCfg_DataModal.h"

static NSString     *baseURL;

@implementation RequestCfg_DataModal

@synthesize debugURL_,releaseURL_,bDebug_,cookie_,loadStr_,noDataStr_,opArr_;

//设置BaseURL
+(void) setBaseURL:(NSString *)value
{
    baseURL = value;
}

//获取BaseURL
+(NSString *) getBaseURL
{
    return baseURL;
}

-(id) init
{
    self = [super init];
    
    //从FileName_ReqeustConfig中解析
    NSDictionary *dic = [BaseCommon getDataDic:[NSData dataWithContentsOfFile:[BaseCommon getResourcePath:FileName_ReqeustConfig]]];
    
    if( dic ){
        NSDictionary *baseDic = [dic objectForKey:@"BaseInfo"];
//        if( bOld ){
//            debugURL_ = [baseDic objectForKey:@"debugURL"];
//            releaseURL_ = [baseDic objectForKey:@"releaseURL"];
//        }else{
            debugURL_ = baseURL;//[baseDic objectForKey:@"debugURL"];
            releaseURL_ = baseURL;//[baseDic objectForKey:@"releaseURL"];
//        }
        
        bDebug_ = [[baseDic objectForKey:@"isDebug"] boolValue];
        cookie_ = [baseDic objectForKey:@"cookie"];
        loadStr_ = Localization([baseDic objectForKey:@"loadingStr"]);
        noDataStr_ = Localization([baseDic objectForKey:@"noDataStr"]);
        opArr_ = [[NSMutableArray alloc] init];
        
        @try {
            for ( NSDictionary *opDic in [dic objectForKey:@"Op"] ) {
                OpCfg_DataModal *dataModal = [[OpCfg_DataModal alloc] init];
                dataModal.key_ = [opDic objectForKey:@"key"];
                dataModal.des_ = [opDic objectForKey:@"des"];
                dataModal.value_ = [opDic objectForKey:@"value"];
                NSString *typeStr = [opDic objectForKey:@"loadType"];
                if( [typeStr isEqualToString:@"normal"] ){
                    dataModal.type_ = RequestLoadingType_Normal;
                }
                else if( [typeStr isEqualToString:@"modal"] ){
                    dataModal.type_ = RequestLoadingType_Model;
                }
                
                NSString *modelTypeStr = [opDic objectForKey:@"modelType"];
                if( modelTypeStr && [modelTypeStr isKindOfClass:[NSString class]] ){
                    dataModal.requestModelType_ = [modelTypeStr intValue];
                }
                                
                dataModal.url_ = [opDic objectForKey:@"url"];
                dataModal.loadingStr_ = Localization([opDic objectForKey:@"loadingStr"]);
                dataModal.noDataStr_ = Localization([opDic objectForKey:@"noDataStr"]);
                if( !dataModal.url_ )
                    dataModal.url_ = bDebug_?debugURL_:releaseURL_;
                if( !dataModal.loadingStr_ )
                    dataModal.loadingStr_ = loadStr_;
                if( !dataModal.noDataStr_ )
                    dataModal.noDataStr_ = noDataStr_;
                
                NSString *dataParserFlag = [opDic objectForKey:@"dataParserFlag"];
                if( dataParserFlag ){
                    dataModal.bDataParser_ = [dataParserFlag boolValue];
                }
                
                [opArr_ addObject:dataModal];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    
    return self;
}

- (void)setOtherURL:(NSString *)otherURL {
    _otherURL = otherURL;
    for (OpCfg_DataModal *modal in opArr_) {
        modal.url_ = otherURL;
    }
}

@end
