//
//  ChooseStandardCtl.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/12.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "ChooseStandardCtl.h"
#import "ChooseStandardCell.h"
#import "ManagerCtl.h"
#import "Product_Modal.h"

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

@property (strong, nonatomic) void (^finished)(Base_Modal *);

@end

@implementation ChooseStandardCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([ChooseStandardCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([ChooseStandardCell class])];
    
    [Common addTapGesture:self.topView target:self numberOfTap:1 sel:@selector(hide)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Base
- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    inModal = dataModal;
    [super beginLoad:dataModal exParam:exParam];
}

- (void)startRequest:(RequestCon *)request
{
    [request getProductDetail:inModal.id_];
}

- (void)finishLoadData:(BaseRequest *)request dataArr:(NSArray *)dataArr
{
    if (request == requestCon_) {
        detailModal = dataArr.firstObject;
    }
}

- (void)viewClickResponse:(id)sender
{
    if (sender == self.closeBtn) {
        [self hide];
    } else if (sender == self.buyBtn) {
        if (self.finished) {
            self.finished(nil);
        }
        [self hide];
    }
}

#pragma mark - Private

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseStandardCell *myCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChooseStandardCell class]) forIndexPath:indexPath];
    
    
    
    return myCell;
}

#pragma mark - Public
//开始
+(ChooseStandardCtl *) start:(Base_Modal *)model showInfoView:(UIView *)showInfoView finished:(void(^)(Base_Modal *))finished
{
    ChooseStandardCtl *ctl = [ChooseStandardCtl new];
    ctl.finished = finished;
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
