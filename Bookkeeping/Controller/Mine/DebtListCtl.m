//
//  DebtListCtl.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/4/29.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "DebtListCtl.h"
#import "DebeListCell.h"
#import "ManagerCtl.h"
#import "RefundListCtl.h"
#import "PayDebtCtl.h"

@interface DebtListCtl ()

@end

@implementation DebtListCtl

-(id)init
{
    self = [super init];
    if ( self ) {
        rightBarStr_ = @"";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([DebeListCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([DebeListCell class])];
//    [self onStart];
}

#pragma mark - Base
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self onStart];
}

-(void) startRequest:(RequestCon *)request
{
    [request queryDebtList:[ManagerCtl getRoleInfo].companyId];
}


-(void) loadDetail:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
}

- (void)queryRecord:(Customer_Modal *)modal
{
    RefundListCtl *ctl = [RefundListCtl new];
    [ctl beginLoad:modal exParam:nil];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)payDebt:(Customer_Modal *)modal
{
    PayDebtCtl *ctl = [PayDebtCtl new];
    [ctl beginLoad:modal exParam:nil];
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark - TableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DebeListCell *myCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DebeListCell class]) forIndexPath:indexPath];
    Customer_Modal *modal =  [[dataDic_ objectForKey:[keyArr_ objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    [myCell setDefineTypeName:modal.fristChar];
    myCell.nameLb.text = modal.name;
    myCell.phoneLb.text = modal.telphone;
    myCell.debtLb.text = [NSString stringWithFormat:@"¥%.2lf", modal.debtAmount];
    
    myCell.recordBlock = ^{
        [self queryRecord:modal];
    };
    
    myCell.payBlock = ^{
        [self payDebt:modal];
    };
    
    return myCell;
}

@end
