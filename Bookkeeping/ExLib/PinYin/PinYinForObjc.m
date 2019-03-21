//
//  PinYinForObjc.m
//  Search
//
//  Created by LYZ on 14-1-24.
//  Copyright (c) 2014年 LYZ. All rights reserved.
//

#import "PinYinForObjc.h"

@implementation PinYinForObjc

+ (NSString*)chineseConvertToPinYin:(NSString*)chinese {
    NSString *sourceText = chinese;
    HanyuPinyinOutputFormat *outputFormat = [[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSString *outputPinyin = [PinyinHelper toHanyuPinyinStringWithNSString:sourceText withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
    
    return outputPinyin;
}

+ (NSString*)chineseConvertToPinYinHead:(NSString *)chinese {
    NSString *returnFirst = @"#";
    
    if( [chinese length] > 0 ){
        NSString *first = [chinese substringToIndex:1];
        int v = [chinese characterAtIndex:0];
        if( (v >= 'a' && v <= 'z') || (v >= 'A' && v <= 'Z') ){
            return [first uppercaseString];
        }
    }
    
    HanyuPinyinOutputFormat *outputFormat = [[HanyuPinyinOutputFormat alloc] init];
    [outputFormat setToneType:ToneTypeWithoutTone];
    [outputFormat setVCharType:VCharTypeWithV];
    [outputFormat setCaseType:CaseTypeLowercase];
    NSMutableString *outputPinyin = [[NSMutableString alloc] init];
    //for (int i=0;i <chinese.length;i++)
    for (int i=0;i <(chinese.length>0?1:0);i++)
    {
        NSString *mainPinyinStrOfChar = [PinyinHelper getFirstHanyuPinyinStringWithChar:[chinese characterAtIndex:i] withHanyuPinyinOutputFormat:outputFormat];
        if (nil!=mainPinyinStrOfChar) {
            [outputPinyin appendString:[mainPinyinStrOfChar substringToIndex:1]];
        } else {
            break;
        }
    }
    
    returnFirst = [outputPinyin uppercaseString];
    
    return returnFirst;
}
@end
