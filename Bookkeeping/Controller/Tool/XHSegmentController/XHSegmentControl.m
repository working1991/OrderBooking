//
//  XHSegmentControl.m
//
//  Created by xihe on 15-9-17.
//  Copyright (c) 2015年 xihe. All rights reserved.
//

#import "XHSegmentControl.h"
#import "Common.h"

#define EdgeSpace       10

@interface XHSegmentControl()
<
    UIScrollViewDelegate
>

{
    CGFloat     edgeOffsetX;
}

@property(nonatomic)            CGRect              lastSelectRect;
@property(nonatomic, strong)    NSArray             *items;
@property(nonatomic, strong)    UIScrollView        *scrollView;
@property(nonatomic, strong)    CALayer             *lineLayer;
@property(nonatomic)            CGFloat             beginOffsetX;




- (void)segmentItemClicked:(XHSegmentItem *)item;

@end

@implementation XHSegmentControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

-(void)awakeFromNib
{
    [self initialize];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
    CGContextSetLineWidth(context, self.borderWidth);
    CGContextMoveToPoint(context, 0, CGRectGetMaxY(rect) - self.borderWidth);
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect) - self.borderWidth);
    CGContextStrokePath(context);
}

- (void)layoutSubviews
{
    CGSize size = self.frame.size;
    self.scrollView.frame = CGRectMake(0, 0, size.width, size.height);
    
    //  contentSize
    XHSegmentItem *item = [self.items lastObject];
    self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(item.frame)+edgeOffsetX, CGRectGetHeight(self.scrollView.frame));
    
}

#pragma mark - Initialize Method

- (void)initialize
{
    // 初始化数据
    self.highlightColor = Default_Highlight_Color;    
    self.titleColor = Default_Color;
    self.titleFont = Default_Title_font;
    self.lineWidth = Default_Line_Width;
    self.backgroundColor = [UIColor whiteColor];
    
    self.items = [[NSMutableArray alloc] init];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
    self.scrollView.autoresizesSubviews = NO;
    self.scrollView.alwaysBounceHorizontal = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.scrollsToTop = NO;
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
    
    
    edgeOffsetX = EdgeSpace;
    
    
    //  初始化高亮线
    self.lineLayer = [[CALayer alloc] init];
    self.lineLayer.backgroundColor = self.highlightColor.CGColor;
    [self.scrollView.layer addSublayer:self.lineLayer];
    _selectIndex = -1;
}

- (void)createItems
{
    if (!self.titles || self.titles.count == 0) {
        return;
    }
    
    NSMutableArray *arrayItem = [[NSMutableArray alloc] initWithCapacity:self.titles.count];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat itemWidth = 0.;
    CGFloat itemHeight = CGRectGetHeight(self.frame);
    CGRect  itemRect = CGRectZero;
    self.scrollView.contentOffset = CGPointZero;
    for (UIView *subView in arrayItem) {
        if ([subView isKindOfClass:[XHSegmentItem class]]) {
            [subView removeFromSuperview];
        }
    }
    
    
    CGFloat sumWidth = 0.f;
    for (NSString *title in self.titles) {
        CGFloat width = [XHSegmentItem caculateWidthWithtitle:title titleFont:self.titleFont];
        sumWidth += width;
    }
    
    //详情-目录-评论 展示样式
    if (self.segmentType == XHSegmentTypeScreen) {
        
    }else{
    
        if (sumWidth + Item_Spacing*(self.titles.count-1)+EdgeSpace*2>self.bounds.size.width) {
            self.segmentType = XHSegmentTypeFit;
        } else {
            self.segmentType = XHSegmentTypeFilledSelf;
        }

    }
    
    for (int i = 0; i < self.titles.count; i++) {
        
        NSString *title = self.titles[i];
        CGFloat space = 0;
        
        
        if (self.segmentType == XHSegmentTypeFilled) {
            
            itemWidth = screenWidth/self.titles.count;
            itemRect = CGRectMake(i * itemWidth, 0, itemWidth, itemHeight);
        }
        else if (self.segmentType == XHSegmentTypeFit) {
            
            itemWidth = [XHSegmentItem caculateWidthWithtitle:title titleFont:self.titleFont];
            XHSegmentItem *lastItem = [arrayItem lastObject];
            if (i == 0) {
                space = EdgeSpace;
                edgeOffsetX = space;
            } else {
                space = Item_Spacing;
            }
            itemRect = CGRectMake(CGRectGetMaxX(lastItem.frame)+space, 0, itemWidth, itemHeight);
        }
        //整屏宽度展示
        else if (self.segmentType == XHSegmentTypeScreen){
            CGFloat space1 = XHSegmentTypeScreen_Space1;//第一个和最后一个间隔
            CGFloat space2 = XHSegmentTypeScreen_Space2;//两个item之间的间隔
            itemWidth = ([UIScreen mainScreen].bounds.size.width-space1*2-space2*(self.titles.count-1))/self.titles.count;
            CGFloat x = space1 + i*(itemWidth+space2);
            itemRect = CGRectMake(x, 0, itemWidth, itemHeight);
        }
        else if (self.segmentType == XHSegmentTypeFilledSelf) {

            itemWidth = [XHSegmentItem caculateWidthWithtitle:title titleFont:self.titleFont];
            
            if (i == 0) {
                space = (self.bounds.size.width-sumWidth-Item_Spacing*(self.titles.count-1))/2;
                edgeOffsetX = space;
            } else {
                space = Item_Spacing;
            }
            
            XHSegmentItem *lastItem = [arrayItem lastObject];
            itemRect = CGRectMake(CGRectGetMaxX(lastItem.frame)+space, 0, itemWidth, itemHeight);
        }
        else {
            
        }
        
        XHSegmentItem *item = [self createItem:itemRect title:title];
        
        if (i == 0 && self.lineLayer) {
            CGRect lineFrame = self.lineLayer.frame;
            lineFrame.size.width = item.frame.size.width;
            lineFrame.origin.x = item.frame.origin.x;
            self.lineLayer.frame = lineFrame;
        }
        
        
        
        [arrayItem addObject:item];
    }
    
    self.items = [arrayItem mutableCopy];
}

- (XHSegmentItem *)createItem:(CGRect)rect title:title
{
    XHSegmentItem *item = [[XHSegmentItem alloc] initWithFrame:rect];
    item.title = title;
    item.titleColor = self.titleColor;
    item.titleFont = self.titleFont;
    item.highlightColor = self.highlightColor;
    [item addTarget:self action:@selector(segmentItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:item];
    return item;
}


#pragma mark - Public Method

- (void)load
{
    // 初始化scrollview
    if (self.backgroundImage) {
        self.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
    }
    
    //  load 高亮线
    self.lineLayer.backgroundColor = self.highlightColor.CGColor;
     self.lineLayer.frame = CGRectMake(CGRectGetMinX(self.lineLayer.frame), CGRectGetHeight(self.frame) - self.lineWidth, CGRectGetWidth(self.lineLayer.frame), self.lineWidth);
    
    // 初始化scrollview
    if (self.backgroundImage) {
        self.backgroundColor = [UIColor colorWithPatternImage:self.backgroundImage];
    }
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    [self createItems];
    
    //  根据type初始化items
//    self.selectIndex = 0;
    [self setSelectIndex:0 animation:YES];
    [self layoutSubviews];
}

- (void)scrollToRate:(CGFloat)rate
{
    if (!self.items || self.items.count == 0) {
        return;
    }
    XHSegmentItem *currentItem = self.items[self.selectIndex];
    XHSegmentItem *previousItem = self.selectIndex > 0 ? self.items[self.selectIndex - 1]: nil;
    XHSegmentItem *nextItem = (self.selectIndex < self.items.count - 1)? self.items[self.selectIndex + 1]: nil;
    if (fabs(rate) > 0.5) {
        
        if (rate > 0) {
            
            if (nextItem) {
                [self segmentItemSelected:nextItem];
            }
        }
        else if (rate < 0) {
            
            if (previousItem) {
                [self segmentItemSelected:previousItem];
            }
        }
    }
    else
    {
        if (currentItem) {
            [self segmentItemSelected:currentItem];
        }
    }
    
    CGFloat dx = 0.;
    CGFloat dw = 0.;
    if (rate > 0) {
        
        if (nextItem) {
            
            dx = CGRectGetMinX(nextItem.frame) - CGRectGetMinX(currentItem.frame);
            dw = CGRectGetWidth(nextItem.frame) - CGRectGetWidth(currentItem.frame);
        }
        else {
            
            dx = CGRectGetWidth(currentItem.frame);
        }
    }
    else if (rate < 0) {
        
        if (previousItem) {
            
            dx = CGRectGetMinX(currentItem.frame) - CGRectGetMinX(previousItem.frame);
            dw = CGRectGetWidth(currentItem.frame) - CGRectGetWidth(previousItem.frame);
        }
        else {
            
            dx = CGRectGetWidth(currentItem.frame);
        }
    }
    
    CGFloat x = CGRectGetMinX(self.lastSelectRect) + rate * dx;
    CGFloat w = CGRectGetWidth(self.lastSelectRect) + rate * dw;
    self.lineLayer.frame = CGRectMake(x, CGRectGetMinY(self.lastSelectRect), w, CGRectGetHeight(self.lastSelectRect));
}


#pragma mark - Private Method

- (void)segmentItemClicked:(XHSegmentItem *)item
{
    [self setSelectIndex:[self.items indexOfObject:item] animation:NO];
}

- (void)segmentItemSelected:(XHSegmentItem *)item
{
    for (XHSegmentItem *i in self.items) {
        
        i.selected = NO;
        [item refresh];
    }
    item.selected = YES;
}

#pragma mark - Setters

- (void)setSelectIndex:(NSInteger)selectIndex animation:(BOOL)animation
{
    _selectIndex = selectIndex;
    if (selectIndex < self.items.count) {
        
        XHSegmentItem *item = self.items[selectIndex];
        [self segmentItemSelected:item];
        
        self.lineLayer.frame = CGRectMake(CGRectGetMinX(item.frame), CGRectGetHeight(item.frame) - self.lineWidth, CGRectGetWidth(item.frame), self.lineWidth);
        self.lastSelectRect = self.lineLayer.frame;
        
        if (self.segmentType == XHSegmentTypeFit) {
            [self makeBtnCenter:item scrollview:self.scrollView];
        } else {
            [self.scrollView scrollRectToVisible:item.frame animated:YES];
        }
        
        [self.delegate xhSegmentSelectAtIndex:selectIndex animation:animation];
    }
}

//让按钮居中
- (void)makeBtnCenter:(UIButton *)btn scrollview:(UIScrollView *)scrollview {
    CGRect rect=btn.frame;
    CGPoint offest = CGPointMake(0, 0);
    if (rect.origin.x-(scrollview.frame.size.width-rect.size.width)/2 <0)
    {
        offest = CGPointMake(0, 0);
//        [scrollview setContentOffset:CGPointMake(0, 0)];
    }
    else if (rect.origin.x-(scrollview.frame.size.width-rect.size.width)/2 >scrollview.contentSize.width-scrollview.frame.size.width)
    {
        offest = CGPointMake(scrollview.contentSize.width+Item_Padding-scrollview.frame.size.width, 0);
//        [scrollview setContentOffset:CGPointMake(scrollview.contentSize.width-scrollview.frame.size.width, 0)];
    }
    else
    {
        offest = CGPointMake(rect.origin.x-(scrollview.frame.size.width-rect.size.width)/2, 0);
//        [scrollview setContentOffset:CGPointMake(rect.origin.x-(scrollview.frame.size.width-rect.size.width)/2, 0)];
    }
    [UIView animateWithDuration:0.5 animations:^{
        [scrollview setContentOffset:offest];
    }];
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (_selectIndex != selectIndex) {
        [self setSelectIndex:selectIndex animation:YES];
    }
    _selectIndex = selectIndex;
    
}

- (void)setHighlightColor:(UIColor *)highlightColor
{
    _highlightColor = highlightColor;
    self.lineLayer.backgroundColor = highlightColor.CGColor;
}

@end
