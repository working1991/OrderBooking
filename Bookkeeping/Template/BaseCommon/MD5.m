//
//  MD5.m
//  CampusClient
//
//  Created by job1001 job1001 on 12-5-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MD5.h"
#import <CommonCrypto/CommonDigest.h> //Import for CC_MD5 access

@implementation MD5

//获取str的md5值
+(NSString *) getMD5:(NSString *)str
{
    if( !str ){
        return nil;
    }
    
	const char *cStr = [str UTF8String]; 
	unsigned char result[16]; 
	CC_MD5(cStr, (CC_LONG)strlen(cStr), result); //This is the MD5 calculate
    
    NSString *newMD5 = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                        result[0], result[1], result[2], result[3],
                        result[4], result[5], result[6], result[7],
                        result[8], result[9], result[10], result[11],
                        result[12], result[13], result[14], result[15] 
                        ];
    
	return newMD5;
}

+ (NSString*)md532BitUpper:(NSString *)str

{
    
    const char* original_str=[str UTF8String];
    
    unsigned char digist[CC_MD5_DIGEST_LENGTH]; //CC_MD5_DIGEST_LENGTH = 16
    
    CC_MD5(original_str, (CC_LONG)strlen(original_str), digist);
    
    NSMutableString* outPutStr = [NSMutableString stringWithCapacity:10];
    
    for(int  i =0; i<CC_MD5_DIGEST_LENGTH;i++){
        
        [outPutStr appendFormat:@"%02x", digist[i]];// 小写 x 表示输出的是小写 MD5 ，大写 X 表示输出的是大写 MD5
        
    }
    
    return [outPutStr lowercaseString];
    
}


//16位MD5加密方式
+ (NSString *)getMd5_16Bit_String:(NSString *)srcString{
    //提取32位MD5散列的中间16位
    NSString *md5_32Bit_String=[self getMd5_32Bit_String:srcString];
    NSString *result = [[md5_32Bit_String substringToIndex:24] substringFromIndex:8];//即9～25位
    
    return result;
}


//32位MD5加密方式
+ (NSString *)getMd5_32Bit_String:(NSString *)srcString{
    const char *cStr = [srcString UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest );
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    
    return result;
}

+ (NSData *)getMD_5_Str:(NSString *)str
{
    //    NSMutableString *md5Str = [[NSMutableString alloc]initWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    
    //    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    //    {
    //        [md5Str appendString:[NSString stringWithFormat:@"%02x",result[i]]];
    //    }
    
    NSData *data = [[NSData alloc]initWithBytes:result length:CC_MD5_DIGEST_LENGTH];
    
    return data;
}



@end
