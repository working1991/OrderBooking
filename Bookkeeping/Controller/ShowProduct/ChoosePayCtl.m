//
//  ChoosePayCtl.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/13.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "ChoosePayCtl.h"
#import "ChoosePayCell.h"

@interface ChoosePayCtl ()

{
    NSArray *payTypeArr;
}

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;


@property (strong, nonatomic) void (^finished)(Base_Modal *);

@end

@implementation ChoosePayCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    payTypeArr = @[
  @{@"name": @"现金", @"code": @"1"},
  @{@"name": @"支付宝", @"code": @"2"},
  @{@"name": @"微信", @"code": @"3"},
  @{@"name": @"赊账", @"code": @"4"}];
    
    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([ChoosePayCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([ChoosePayCell class])];
    
    [Common addTapGesture:self.topView target:self numberOfTap:1 sel:@selector(hide)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Base
- (void)viewClickResponse:(id)sender
{
    if (sender == self.closeBtn) {
        [self hide];
    }
}

#pragma mark - Private

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return payTypeArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChoosePayCell *myCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChoosePayCell class]) forIndexPath:indexPath];
    
    NSDictionary *payDic = payTypeArr[indexPath.row];
    myCell.nameLb.text = payDic[@"name"];
    
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.finished) {
        Base_Modal *model = [Base_Modal new];
        NSDictionary *payDic = payTypeArr[indexPath.row];
        model.name = payDic[@"name"];
        model.code = payDic[@"code"];
        self.finished(model);
    }
    [self hide];
}

#pragma mark - Public
//开始
+(ChoosePayCtl *) start:(UIView *)showInfoView finished:(void(^)(Base_Modal *))finished
{
    ChoosePayCtl *ctl = [ChoosePayCtl new];
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
