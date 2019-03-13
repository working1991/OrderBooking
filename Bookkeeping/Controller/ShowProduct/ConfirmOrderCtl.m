//
//  ConfirmOrderCtl.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/12.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "ConfirmOrderCtl.h"
#import "ChooseStandardCell.h"
#import "ChoosePayCtl.h"
#import "ChooseCustomerCtl.h"

@interface ConfirmOrderCtl ()

{
    Base_Modal *payModel;
}

@property (weak, nonatomic) IBOutlet UIButton *customerBtn;
@property (weak, nonatomic) IBOutlet UITextField *realAmoutTf;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *classLb;
@property (weak, nonatomic) IBOutlet UILabel *totalNumLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *totalAmoutLb;
@property (weak, nonatomic) IBOutlet UILabel *totalInfoLb;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation ConfirmOrderCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([ChooseStandardCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([ChooseStandardCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Base
- (void)viewClickResponse:(id)sender
{
    if (sender == self.customerBtn) {
        [self chooseCustomer:sender];
    } else if (sender == self.payBtn) {
        [self choosePayType:sender];
    } else if (sender == self.confirmBtn) {
        [self showChooseAlertViewCtl:@"应付金额：¥1600.00\n实付金额：¥1500.00" msg:@"确认支付完成？" confirmHandle:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark - Private

- (void)chooseCustomer:(UIButton *)sender
{
    ChooseCustomerCtl *ctl = [[ChooseCustomerCtl alloc] initWithFinish:^(Base_Modal *model) {
        [sender setTitle:@"客户" forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)choosePayType:(UIButton *)sender
{
    ChoosePayCtl *ctl = [ChoosePayCtl start:self.view finished:^(Base_Modal *model) {
        [sender setTitle:model.name forState:UIControlStateNormal];
    }];
    [self addChildViewController:ctl];
}

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

@end
