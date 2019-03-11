
//
//  BaseRequest.m
//  XZD
//
//  Created by sysweal on 14/11/14.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import "BaseRequest.h"
#import "RequestOperator.h"
#import "Common.h"
#import "Config.h"

static RequestCfg_DataModal *oldRequestCfgModal;
static RequestCfg_DataModal *requestCfgModal;
static NSString             *myCookie;
static BOOL                 bShowModelCacheEnable = NO;
static BOOL                 bAdminModelCacheEnable = NO;

@interface BaseRequest ()

@end

@implementation BaseRequest

@synthesize tag_,index_,state_,cfgModal_,pageModal_,bSaveData_,dataArr_,delegate_,bAvailable;

//获取ReqeustCfg_DataModal
+(OpCfg_DataModal *) getRequestCfgModal:(NSString *)opKey
{
    OpCfg_DataModal *modal = nil;
    if( !requestCfgModal ){
        requestCfgModal = [[RequestCfg_DataModal alloc] init];
    }
    
    for ( OpCfg_DataModal *dataModal in requestCfgModal.opArr_ ) {
        if( [dataModal.key_ isEqualToString:opKey] ){
            modal = dataModal;
            break;
        }
    }
    return modal;
}

//获取其他URL的ReqeustCfg_DataModal
+(OpCfg_DataModal *) getRequestCfgModal:(NSString *)opKey withOtherURL:(NSString *)otherURL
{
    OpCfg_DataModal *modal = nil;
    RequestCfg_DataModal *otherRequestCfgModal = [[RequestCfg_DataModal alloc] init];
    otherRequestCfgModal.otherURL = otherURL;
    for ( OpCfg_DataModal *dataModal in otherRequestCfgModal.opArr_ ) {
        if( [dataModal.key_ isEqualToString:opKey] ){
            modal = dataModal;
            break;
        }
    }
    
    return modal;
}

//设置BaseURL
+(void) setBaseURL:(NSString *)value
{
    [RequestCfg_DataModal setBaseURL:value];
    requestCfgModal = nil;
}

//获取BaseURL
+(NSString *) getBaseURL
{
    return [RequestCfg_DataModal getBaseURL];
}

//获取BaseURL,不包含api
+(NSString *) getBaseURLNoApi
{
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@",[BaseRequest getBaseURL]];
    NSRange rang;
    rang.location = 8;
    rang.length = [str length] - rang.location;
    [str replaceOccurrencesOfString:@"/api" withString:@"" options:NSCaseInsensitiveSearch range:rang];
    return str;
}

//设置Cookie信息
+(void) setCookieInfo:(NSString *)cookie
{
    myCookie = cookie;
}

//获取Cookie
+(NSString *) getCookie
{
    return myCookie;
}

//设置展示部份是否采用缓存
+(void) setShowModelCacheEnable:(BOOL)flag
{
    bShowModelCacheEnable = flag;
}

//设置经理部份是否采用缓存
+(void) setAdminModelCacheEnable:(BOOL)flag
{
    bAdminModelCacheEnable = flag;
}

-(id) init
{
    self = [super init];

    pageModal_ = [[PageInfo_DataModal alloc] init];
    bAvailable = YES;
    
    return self;
}

-(void) dealloc
{
    [MyLog Log:@"dealloc" obj:self];
    
    [self clear];
}

//清除
-(void) clear
{
    [conn_ cancel];
    conn_ = nil;
    delegate_ = nil;
}

//qhl 2016.2.2 搜索清除
-(void) searchClear
{
    [conn_ cancel];
//    conn_ = nil;
}

//获取请求的Key
-(NSString *) getConnKey{
    return [NSString stringWithFormat:@"%@+%@",url_,body_];
}

//开始请求
-(void) startGetReqeust:(NSString *)opKey param:(NSString *)param body:(NSString *)body
{
    cfgModal_ = [BaseRequest getRequestCfgModal:opKey];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@?%@",cfgModal_.url_,cfgModal_.value_,param?param:@""];
    [self startReqeust:@"GET" url:url body:body];
}

//开始请求
-(void) startPostRequest:(NSString *)opKey param:(NSString *)param body:(NSString *)body
{
    if ( !self.bAvailable ) {
        return;
    }
    cfgModal_ = [BaseRequest getRequestCfgModal:opKey];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@?%@",cfgModal_.url_,cfgModal_.value_,param?param:@""];
    [self startReqeust:@"POST" url:url body:body];
}

//开始请求
-(void) startNewPostRequest:(NSString *)opKey body:(NSString *)body
{
    cfgModal_ = [BaseRequest getRequestCfgModal:opKey];
    NSString *url = [NSString stringWithFormat:@"%@/%@",[BaseRequest getBaseURLNoApi],cfgModal_.value_];
    [self startReqeust:@"POST" url:url body:body];
}

//开始其他URL请求
-(void) startPostRequestOtherURL:(NSString *)otherURL opKey:(NSString *)opKey param:(NSString *)param body:(NSString *)body
{
    cfgModal_ = [BaseRequest getRequestCfgModal:opKey withOtherURL:otherURL];
    NSString *url = [NSString stringWithFormat:@"%@?%@",cfgModal_.url_,param?param:@""];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self startReqeust:@"POST" url:url body:body];
}
 //开始请求
-(void) startReqeust:(NSString *)method url:(NSString *)url body:(NSString *)body
{
    if ( !self.bAvailable ) {
        return;
    }
    self.parameter = [NSString stringWithFormat:@"%@+%@",url,body];
    
    [MyLog Log:[NSString stringWithFormat:@"请求时间戳：totalMilliseconds=%llu",self.startTime] obj:nil];
    
    //url = [BaseCommon convertStringToURLString:url];
    [MyLog Log:url obj:self];
    [MyLog Log:[NSString stringWithFormat:@"body====>%@",body] obj:self];
    
    url_ = url;
    body_ = body;
    
    double timeout = Request_Timeout;
    
    state_ = RequestState_Loading;
    [delegate_ requestBegin:self];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *cacheData = nil;
        //需要缓存
        if( cfgModal_.bOld || !cfgModal_ ||
           (cfgModal_.requestModelType_ == RequestModelType_Show && bShowModelCacheEnable) ||
           (cfgModal_.requestModelType_ == RequestModelType_Other && bAdminModelCacheEnable) ){
            
            cacheData = [DataManger getData:[self getConnKey] cacheSeconds:-1 type:Data_File];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if( cacheData ){
                //直接返回CacheData
                bCacheData_ = YES;
                
                receiveData_ = [[NSMutableData alloc] initWithData:cacheData];
                [self connectionDidFinishLoading:nil];
            }
            else{
                NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]
                                                                            cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                                        timeoutInterval:timeout];
                
                [request setHTTPMethod:method];
                if( body && ![body isEqualToString:@""] ){
                  
                    NSUInteger msgLength = [body length];
                    [request addValue: [NSString stringWithFormat:@"%d",msgLength] forHTTPHeaderField:@"Content-Length"];
                    [request setHTTPBody: [body dataUsingEncoding:NSUTF8StringEncoding]];

                   
                    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
                    
                    
                    if( myCookie )
                        [request addValue: myCookie forHTTPHeaderField:@"cookie"];

                    
                }
                [MyLog Log:[NSString stringWithFormat:@"cookie==>%@",myCookie] obj:self];
                
                //发起请求
                conn_ = [[NSURLConnection alloc] initWithRequest:request delegate:self];
            }
        });
    });
}



-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    receiveData_ = [[NSMutableData alloc] init];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [receiveData_ appendData:data];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSDictionary *dic= error.userInfo;
    [MyLog Log:[NSString stringWithFormat:@"error===>%@",[[[SBJsonWriter alloc]init] stringWithObject:dic]] obj:self];
    state_ = RequestState_Fail;
    [delegate_ requestFail:self code:ErrorCode_Internet];
}

//- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
//    // 判断是否是信任服务器证书
//    if(challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
//        // 告诉服务器，客户端信任证书
//        // 创建凭据对象
//        NSURLCredential *credntial = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
//        // 告诉服务器信任证书
//        [challenge.sender useCredential:credntial forAuthenticationChallenge:challenge];
//    }
//}


-(void) connection:(NSConnection *)connection willSendRequestForAuthenticationChallenge:(nonnull NSURLAuthenticationChallenge *)challenge
{
    if ( [challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust] ) {
        [[challenge sender] useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
        [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
    }
//    return [challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
//    static CFArrayRef certs;
//    if (!certs) {
//        NSData*certData =[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"eher" ofType:@"cer"]];
//        SecCertificateRef rootcert =SecCertificateCreateWithData(kCFAllocatorDefault,CFBridgingRetain(certData));
//        const void *array[1] = { rootcert };
//        certs = CFArrayCreate(NULL, array, 1, &kCFTypeArrayCallBacks);
//        CFRelease(rootcert);    // for completeness, really does not matter
//    }
//    
//    SecTrustRef trust = [[challenge protectionSpace] serverTrust];
//    int err;
//    SecTrustResultType trustResult = 0;
//    err = SecTrustSetAnchorCertificates(trust, certs);
//    if (err == noErr) {
//        err = SecTrustEvaluate(trust,&trustResult);
//    }
////    CFRelease(trust);
//    BOOL trusted = (err == noErr) && ((trustResult == kSecTrustResultProceed)||(trustResult == kSecTrustResultConfirm) || (trustResult == kSecTrustResultUnspecified));
//    
//    if (trusted) {
//        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//    }else{
//        [challenge.sender cancelAuthenticationChallenge:challenge];
//    }
    
    
    
//    NSURLProtectionSpace* protectionSpace = challenge.protectionSpace;
//    SecTrustRef trust = protectionSpace.serverTrust;
//    
//    CFIndex numCerts = SecTrustGetCertificateCount(trust);
//    NSMutableArray* certs = [NSMutableArray arrayWithCapacity: numCerts];
//    for (CFIndex idx = 0; idx < numCerts; ++idx)
//    {
//        SecCertificateRef cert = SecTrustGetCertificateAtIndex(trust, idx);
//        [certs addObject: CFBridgingRelease(cert)];
//    }
//    
//    //  Create a policy that ignores the host name…
//    
//    SecPolicyRef policy = SecPolicyCreateSSL(true, NULL);
//    OSStatus err = SecTrustCreateWithCertificates(CFBridgingRetain(certs), policy, &trust);
//    CFRelease(policy);
//    if (err != noErr)
//    {
////        NSLogDebug(@"Error creating trust: %d", err);
//        [challenge.sender cancelAuthenticationChallenge: challenge];
//        return;
//    }
//    
//    //  Set the root cert and evaluate the trust…
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"eher(1)" ofType:@"cer"];
//
//    NSData*cerData =[NSData dataWithContentsOfFile:cerPath];
//    SecCertificateRef certificate=SecCertificateCreateWithData(NULL,(__bridge CFDataRef)(cerData));
//    NSArray* rootCerts = @[ CFBridgingRelease(certificate) ];
//    err = SecTrustSetAnchorCertificates(trust, CFBridgingRetain(rootCerts));
//    if (err == noErr)
//    {
//        SecTrustResultType trustResult;
//        err = SecTrustEvaluate(trust, &trustResult);
////        CFRelease(trust);
//        
//        bool trusted = err == noErr;
//        trusted = trusted && (trustResult == kSecTrustResultProceed || trustResult == kSecTrustResultUnspecified);
//        if (trusted)
//        {
//            
//            [challenge.sender useCredential:[NSURLCredential credentialForTrust:trust] forAuthenticationChallenge:challenge];
////            [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
////            NSURLCredential* credential = [NSURLCredential credentialForTrust: trust];
////            [challenge.sender useCredential: credential forAuthenticationChallenge: challenge];
//            return;
//        }
//    }
//    
//    //  An error occurred, or we don't trust the cert, so disallow it…
//    
//    [challenge.sender cancelAuthenticationChallenge: challenge];

    
    
    
    
//    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"eher(1)" ofType:@"cer"];
//    
//    NSData*cerData =[NSData dataWithContentsOfFile:cerPath];
//    SecCertificateRef certificate=SecCertificateCreateWithData(NULL,(__bridge CFDataRef)(cerData));
//    
////    self.trustedCertificates=@[CFBridgingRelease(certificate)];
//    NSArray *trustedCertificates = @[CFBridgingRelease(certificate)];
//    
//    SecTrustRef trust=challenge.protectionSpace.serverTrust;
//    SecTrustResultType result;
//    
//    //注意：这里将之前导入的证书设置成下面验证的Trust Object的anchor certificate
//    SecTrustSetAnchorCertificates(trust,(__bridge CFArrayRef)trustedCertificates);
//    
//    //2)SecTrustEvaluate会查找前面SecTrustSetAnchorCertificates设置的证书或者系统默认提供的证书，对trust进行验证
//    OSStatus status=SecTrustEvaluate(trust,&result);
//    if(status==errSecSuccess &&
//       (result==kSecTrustResultProceed ||
//        result==kSecTrustResultUnspecified)){
//           
//           //3)验证成功，生成NSURLCredential凭证cred，告知challenge的sender使用这个凭证来继续连接
//           NSURLCredential*cred=[NSURLCredential credentialForTrust:trust];
//           [challenge.sender useCredential:cred forAuthenticationChallenge:challenge];
//           
//       }else{
//           
//           //5)验证失败，取消这次验证流程
//           [challenge.sender cancelAuthenticationChallenge:challenge];
//       }
}


-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    state_ = RequestState_Finish;
    
    NSString *str = [[NSString alloc] initWithData:receiveData_ encoding:NSUTF8StringEncoding];
    [MyLog Log:[NSString stringWithFormat:@"%@==>%@",delegate_,str] obj:self];
    
    [MyLog Log:[NSString stringWithFormat:@"conn finished<%@>",[delegate_ class]] obj:self];
    
    //去解析数据
    NSArray *arr = nil;
    if( cfgModal_.bDataParser_ ){
        @try {
            if( cfgModal_.bOld ){
                arr = [DataParser parserOldData:cfgModal_.key_ data:receiveData_];
            }else{
                arr = [DataParser parserData:cfgModal_.key_ data:receiveData_];
            }
                        
            //赋值分页数据
            @try {
                if (arr.count > 0) {
                    id obj = [arr objectAtIndex:0];
                    if( [obj isKindOfClass:[PageInfo_DataModal class]] ){
                        PageInfo_DataModal *pageModal = obj;
                        pageModal_.totalPage_ = pageModal.totalPage_;
                        pageModal_.totalSize_ = pageModal.totalSize_;
                    }
                }
                
            }
            @catch (NSException *exception) {
                
            }
            @finally {
                
            }
            
            //如果需要存放数据集
            if( bSaveData_ ){
                if( !dataArr_ ){
                    dataArr_ = [[NSMutableArray alloc] init];
                }
                if( pageModal_.totalPage_ <= 1 || pageModal_.currentPage_ == PageStart_Index ){
                    [dataArr_ removeAllObjects];
                }
                [dataArr_ addObjectsFromArray:arr];
            }
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }else{
        arr = [[NSMutableArray alloc] initWithObjects:receiveData_, nil];
    }
    
    if( !arr ){
        //解析出错了
        [delegate_ requestFail:self code:ErrorCode_DataParser];
    }else{
        ++pageModal_.currentPage_;
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //如果不是缓存数据
            if( !bCacheData_ && receiveData_ ){
                [DataManger saveData:[self getConnKey] data:receiveData_ type:Data_File];
                
                url_ = nil;
                body_ = nil;
                receiveData_ = nil;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate_ requestFinish:self dataArr:arr];
            });
        });
    }
}

@end
