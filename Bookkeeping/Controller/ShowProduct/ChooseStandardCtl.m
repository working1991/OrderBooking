//
//  ChooseStandardCtl.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/12.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "ChooseStandardCtl.h"
#import "ManagerCtl.h"
#import "Product_Modal.h"
#import "Standard_Modal.h"
#import "UIImageView+WebCache.h"
#import "TypeListCtl.h"

@interface ChooseStandardCtl ()

{
    Product_Modal *inModal;
    Product_Modal *detailModal;
}

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;

@property (weak, nonatomic) IBOutlet UIView     *titleView;
@property (weak, nonatomic) IBOutlet UIView     *contentView;

@property (strong, nonatomic) void (^finished)(Product_Modal *);

@end

@implementation ChooseStandardCtl



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    
    [Common addTapGesture:self.topView target:self numberOfTap:1 sel:@selector(hide)];
    
    self.segmentControl.backgroundColor = [UIColor clearColor];
    self.segmentTitleColor = [Common getColor:@"999999"];
    self.segmentHighlightColor = Color_Default;
    self.segmentTitleFont = [UIFont systemFontOfSize:16];
    self.scrollView.bounces = NO;
    self.segmentType = XHSegmentTypeFilledSelf;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


#pragma mark - Base
- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    inModal = dataModal;
    [super beginLoad:dataModal exParam:exParam];
}

- (UIView *)getRequestProcessView:(BaseRequest *)request
{
    return self.scrollView;
}

- (void)startRequest:(RequestCon *)request
{
    [request getProductDetail:inModal.id_];
}

- (void)finishLoadData:(BaseRequest *)request dataArr:(NSArray *)dataArr
{
    if (request == requestCon_) {
        detailModal = dataArr.firstObject;
        [self updateDetailInfo];
    }
}

- (void)viewClickResponse:(id)sender
{
    if (sender == self.closeBtn) {
        [self hide];
    } else if (sender == self.buyBtn) {
        BOOL bHave = NO;
        for (Standard_Modal *modal in detailModal.typeArr) {
            if (modal.saleCount > 0) {
                bHave = YES;
                break;
            }
        }
        if (bHave) {
            if (self.finished) {
                self.finished(detailModal);
            }
            [self hide];
        } else {
            [BaseUIViewController showAlertView:@"未选择规格" msg:nil cancel:@"确定"];
        }
        
    }
}

#pragma mark - Private
- (void)updateDetailInfo
{
    self.nameLb.text = detailModal.name;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:detailModal.imgUrl]];
    
    NSMutableArray *typeArr = [NSMutableArray array];
    for (NSInteger i=0; i<detailModal.typeArr.count; i++) {
        Standard_Modal *model = detailModal.typeArr[i];
        BOOL bHave = NO;
        for (NSInteger j=0; j<typeArr.count; j++) {
            NSDictionary *typeDic = typeArr[j];
            if ([model.firstSpecId isEqualToString:typeDic[@"id"]]) {
                NSMutableArray *list = [NSMutableArray arrayWithArray:typeDic[@"list"]];
                [list addObject:model];
                NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:typeDic];
                mDic[@"list"] = list;
                [typeArr replaceObjectAtIndex:j withObject:mDic];
                bHave = YES;
                break;
            }
        }
        if (!bHave) {
            [typeArr addObject:@{@"id":model.firstSpecId?model.firstSpecId:@"", @"name":model.firstSpecName?model.firstSpecName:@"", @"list": @[model]}];
        }
    }
    
    NSMutableArray *viewCtls = [NSMutableArray array];
    for (NSDictionary *typeDic in typeArr) {
        TypeListCtl *ctl = [[TypeListCtl alloc] init];
        ctl.title = typeDic[@"name"];
        [ctl beginLoad:nil exParam:typeDic[@"list"]];
        [viewCtls addObject:ctl];
    }
    if (viewCtls.count>0) {
        self.viewControllers = viewCtls;
    }
}



#pragma mark - Public
//开始
+(ChooseStandardCtl *) start:(Product_Modal *)model showInfoView:(UIView *)showInfoView finished:(void(^)(Product_Modal *))finished
{
    ChooseStandardCtl *ctl = [ChooseStandardCtl new];
    ctl.finished = finished;
    [ctl beginLoad:model exParam:nil];
    [ctl showChooseDate:showInfoView];
    return ctl;
}

//显示
- (void) showChooseDate:(UIView *)showInfoView
{
    [showInfoView addSubview:self.view];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.view.alpha = 0;
    
    [Common copyConstraint:showInfoView srcView:showInfoView desView:self.view];
    
    double delayInSeconds = 0.15f;//allow enough time for progress to animate
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:0.3f
                         animations:^{
                             self.view.alpha = 1.0;
                             [showInfoView layoutIfNeeded];
                         }];
    });
    
    
}

//隐藏
-(void) hide
{
    self.view.alpha = 0.0;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
