//
//  SystemPickerCtl.h
//  XZD
//
//  Created by LcGero on 16/6/21.
//  Copyright © 2016年 sysweal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SystemPhotoSourceType)
{
    SystemPhotoSourceType_Camera,
    SystemPhotoSourceType_PhotoLibray,
};

typedef void(^PickPictureFinished)(NSArray *fileUrls , NSArray *selectImages);

@interface SystemPicker : NSObject
@property (strong, nonatomic) UIViewController    *fromCtl;
@property (copy, nonatomic) PickPictureFinished   finished;

+(void) systemPickerWithType:(SystemPhotoSourceType)type maximumNumberOfSelection:(NSUInteger)maximumNumberOfSelection withFromCtl:(UIViewController *)fromCtl finished:(PickPictureFinished)finished;

@end
