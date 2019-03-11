//
//  XHSegmentControl.h
//
//  Created by xihe on 15-9-17.
//  Copyright (c) 2015年 xihe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHSegmentItem.h"
#import "Common.h"

#define Default_Width           80
#define Default_Line_Width      2
#define Default_Color           [Common getColor:@"333333"]
#define Default_Highlight_Color Color_Default
#define Default_Title_font      [UIFont systemFontOfSize:15]

#define Key_Title           @"title"
#define Key_Title_Detail    @"titleDetail"
#define Key_Image           @"image"

#define Item_Spacing     25


//XHSegmentTypeScreen 参数
#define    XHSegmentTypeScreen_Space1  10.0;//第一个和最后一个间隔
#define    XHSegmentTypeScreen_Space2  15.0;//两个item之间的间隔

typedef NS_ENUM(NSInteger, XHSegmentType)
{
    XHSegmentTypeFilled = 0,    //  充满屏幕高度
    XHSegmentTypeFit,           //  适应文字大小
    XHSegmentTypeFilledSelf,    //  适应自身大小
    XHSegmentTypeCircle,         //  循环
    XHSegmentTypeScreen          //整屏宽度展示
};


@protocol XHSegmentControlDelegate <NSObject>

- (void)xhSegmentSelectAtIndex:(NSInteger)index animation:(BOOL)animation;

@end

@interface XHSegmentControl : UIView

@property(nonatomic, weak)      id<XHSegmentControlDelegate>    delegate;

//  选中
@property(nonatomic)            NSInteger       selectIndex;
@property(nonatomic, strong)    NSArray         *titles;

@property(nonatomic)            XHSegmentType   segmentType;
@property(nonatomic, strong)    UIImage         *backgroundImage;
@property(nonatomic)            CGFloat         lineWidth;      //  linewidth > 0，底部高亮线
@property(nonatomic, strong)    UIColor         *highlightColor;
@property(nonatomic, strong)    UIColor         *borderColor;
@property(nonatomic)            CGFloat         borderWidth;
@property(nonatomic, strong)    UIColor         *titleColor;
@property(nonatomic, strong)    UIFont          *titleFont;

@property(nonatomic, strong, readonly)          UIScrollView        *scrollView;

- (void)load;
- (void)scrollToRate:(CGFloat)rate;

@end
