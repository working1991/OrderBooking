//
//  SystemPickerCtl.m
//  XZD
//
//  Created by LcGero on 16/6/21.
//  Copyright © 2016年 sysweal. All rights reserved.
//

#import "SystemPicker.h"
#import "QBImagePicker.h"
#import "BaseUIViewController.h"

#define Image_Compression_Ratio             0.01

static SystemPicker      *sysPicker;
static CGSize CGSizeScale(CGSize size, CGFloat scale) {
    return CGSizeMake(size.width * scale, size.height * scale);
}

@interface SystemPicker ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate>
@property (assign, nonatomic) NSInteger             maximumNumberOfSelection;
@end

@implementation SystemPicker

+(void) systemPickerWithType:(SystemPhotoSourceType)type maximumNumberOfSelection:(NSUInteger)maximumNumberOfSelection withFromCtl:(UIViewController *)fromCtl finished:(PickPictureFinished)finished
{
    sysPicker = [[SystemPicker alloc]init];
    sysPicker.fromCtl = fromCtl;
    sysPicker.finished = finished;
    switch ( type ) {
        case SystemPhotoSourceType_Camera:
        {
            [sysPicker takePhoto:UIImagePickerControllerSourceTypeCamera];
        }
            break;
        case SystemPhotoSourceType_PhotoLibray:
        {
            if ( maximumNumberOfSelection != 0 ) {
                sysPicker.maximumNumberOfSelection = maximumNumberOfSelection;
            } else {
                sysPicker.maximumNumberOfSelection = 5;
            }
            [sysPicker PhotoLibrayPicker];
        }
            break;
            
        default:
            break;
    }
}

-(void) dealloc
{
    
}

#pragma mark - TakePhoto
- (void)takePhoto:(UIImagePickerControllerSourceType)sourceType {
    //初始化
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = sourceType;
    picker.videoQuality = UIImagePickerControllerQualityTypeMedium;
    picker.navigationBar.tintColor = [UIColor whiteColor];
    
    //进入照相界面
    [self.fromCtl presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        //获得选中的图片
        UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        image = [UIImage imageWithData:UIImageJPEGRepresentation(image, Image_Compression_Ratio)];
        //保存图片到相册
        [self saveImageToCameraRoll:image location:nil];
    }];
    
}

//保存图片到相册
- (void)saveImageToCameraRoll:(UIImage *)image location:(CLLocation *)location {
    __block PHObjectPlaceholder *placeholderAsset = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
        PHAssetChangeRequest *newAssetRequest =
        [PHAssetChangeRequest creationRequestForAssetFromImage:image];
        newAssetRequest.creationDate = [NSDate date];
        placeholderAsset = newAssetRequest.placeholderForCreatedAsset;
    }
      completionHandler:^(BOOL success, NSError *error) {
          if (success) {
              //保存的照片，加入选中的数组中
              PHFetchOptions *options = [[PHFetchOptions alloc] init];
              options.sortDescriptors = @[
                                          [NSSortDescriptor sortDescriptorWithKey:@"creationDate"
                                                                        ascending:YES]
                                          ];
              PHFetchResult *assetsFetchResults =
              [PHAsset fetchAssetsWithOptions:options];
              
              NSArray *files = [self getLocalImageUrlWithArray:@[
                                                                 assetsFetchResults.lastObject                                                 ]];
              NSURL *url = files.firstObject;
              __weak SystemPicker *weakSelf = self;
              dispatch_async(dispatch_get_global_queue(0, 0), ^{
                  dispatch_async(dispatch_get_main_queue(), ^{
                      if ( weakSelf.finished ) {
                          weakSelf.finished(@[url], @[image]);
                      }
                  });
              });
              
          } else {
              dispatch_async(dispatch_get_main_queue(), ^{
//                  [BaseUIViewController showToast: seconds:0.25f];
                  [BaseUIViewController showHUDFailView:@"保存照片失败！" msg:nil];
                  if ( self.finished ) {
                      self.finished(nil,nil);
                  }
              });
          }
      }];
}

#pragma mark - PhotoLibrayPicker
-(void) PhotoLibrayPicker
{
    QBImagePickerController *imagePickerController =
    [QBImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.mediaType = QBImagePickerMediaTypeImage;
    imagePickerController.allowsMultipleSelection = YES;
    imagePickerController.maximumNumberOfSelection = self.maximumNumberOfSelection;
    imagePickerController.showsNumberOfSelectedAssets = YES;
    [self.fromCtl presentViewController:imagePickerController
                               animated:YES
                             completion:nil];
}

- (void)qb_imagePickerController:(QBImagePickerController *)imagePickerController
          didFinishPickingAssets:(NSArray *)assets {
    [imagePickerController dismissViewControllerAnimated:YES completion:^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (PHAsset *subPHs in assets) {
                NSURL *url = [self grabLocalImageUrl:subPHs];
                UIImage *image = [self grabImageFromAsset:subPHs];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ( self.finished ) {
                        self.finished(@[url], @[image]);
                    }
                });
            }
        });
    }];
    
}

- (void)qb_imagePickerControllerDidCancel:(QBImagePickerController *)imagePickerController {
    [imagePickerController dismissViewControllerAnimated:YES completion:^{
        if ( self.finished ) {
            self.finished(nil,nil);
        }
    }];
}


#pragma ToolMethod
- (NSArray *)getLocalImageUrlWithArray:(NSArray *)assets {
    NSMutableArray *array = [NSMutableArray array];
    for (PHAsset *asset in assets) {
        [array addObject:[self grabLocalImageUrl:asset]];
    }
    return array;
}

- (NSURL *)grabLocalImageUrl:(PHAsset *)asset {
    __block NSDictionary *imageInfo;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                      options:options
                                                resultHandler:^(NSData *_Nullable imageData,
                                                 NSString *_Nullable dataUTI,
                                                 UIImageOrientation orientation,
                                                 NSDictionary *_Nullable info) {
                                                    imageInfo = info;
                                                }];
    return [imageInfo objectForKey:@"PHImageFileURLKey"];
}

- (UIImage *)grabImageFromAsset:(PHAsset *)asset {
    __block UIImage *returnImage;
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    CGSize targetSize = CGSizeScale([UIScreen mainScreen].bounds.size, [[UIScreen mainScreen] scale]);
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:targetSize
                                              contentMode:PHImageContentModeDefault
                                                  options:options
                                            resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    returnImage = result;
                                            }];
    return returnImage;
}

@end
