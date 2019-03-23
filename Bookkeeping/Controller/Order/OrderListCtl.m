//
//  OrderListCtl.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/11.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "OrderListCtl.h"
#import "OrderListItemCtl.h"

@interface OrderListCtl ()

{
    NSArray     *homeArr;
}

@property (weak, nonatomic) IBOutlet UIView     *titleView;
@property (weak, nonatomic) IBOutlet UIView     *contentView;

@end

@implementation OrderListCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"订单";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    homeArr = @[@(OrderStatus_All), @(OrderStatus_WaitPay), @(OrderStatus_Complete), @(OrderStatus_Incomplete)];
    self.segmentControl.backgroundColor = [UIColor clearColor];
    self.segmentTitleColor = [Common getColor:@"999999"];
    self.segmentHighlightColor = Color_Default;
    self.segmentTitleFont = [UIFont systemFontOfSize:16];
    self.scrollView.bounces = NO;
    [self updateSegmentView:homeArr];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.frame) * self.viewControllers.count, CGRectGetHeight(self.scrollView.frame));
}

- (void)layoutInfoView
{
    [self.titleView addSubview:self.segmentControl];
    self.segmentControl.translatesAutoresizingMaskIntoConstraints = NO;
    [Common copyConstraint:self.titleView srcView:self.titleView desView:self.segmentControl];
    
    [self.contentView addSubview:self.scrollView];
    self.scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [Common copyConstraint:self.contentView srcView:self.contentView desView:self.scrollView];
}

#pragma mark - Pravite

- (void)updateSegmentView:(NSArray *)infoArr
{
    self.segmentType = XHSegmentTypeScreen;
    NSMutableArray *viewCtls = [NSMutableArray array];
    for (NSNumber *code in infoArr) {
        OrderListItemCtl *ctl = [[OrderListItemCtl alloc] init];
        ctl.title = [Order_Model getOrderStatusName:[code integerValue]];
        [ctl beginLoad:nil exParam:code];
        [viewCtls addObject:ctl];
    }
    if (viewCtls.count>0) {
        self.viewControllers = viewCtls;
    }
    
}

@end
