//
//  OrderListItemCtl.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/14.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "OrderListItemCtl.h"
#import "OrderListCell.h"
#import "OrderDetailCtl.h"
#import "PrintTool.h"
#import "ManagerCtl.h"

@interface OrderListItemCtl ()

{
    OrderStatus status;
    RequestCon *detailCon;
}

@end

@implementation OrderListItemCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([OrderListCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([OrderListCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Base
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    if ([exParam isKindOfClass:[NSNumber class]]) {
        status = [exParam integerValue];
    }
    [super beginLoad:dataModal exParam:exParam];
}

- (void)startRequest:(RequestCon *)request
{
    [request queryOrderList:[ManagerCtl getRoleInfo].id_ companyId:[ManagerCtl getRoleInfo].companyId orderStatus:status];
}

- (void)finishLoadData:(BaseRequest *)request dataArr:(NSArray *)dataArr
{
    if (request == detailCon) {
        Order_Model *detailModel = dataArr.firstObject;
        [[PrintTool sharedManager] printOrderInfo:detailModel];
    }
}

#pragma mark - Private

- (void)printOrderInfo:(UIButton *)sender
{
    Order_Model *modal = requestCon_.dataArr_[sender.tag];
    detailCon = [self getNewRequestCon:NO];
    [detailCon queryOrderDetail:modal.id_];
}


#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListCell *myCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderListCell class]) forIndexPath:indexPath];
    
    Order_Model *modal = requestCon_.dataArr_[indexPath.row];
    myCell.customerLb.text = modal.customerName;
    myCell.statusLb.text = modal.orderStatusName;
    myCell.orderCodeLb.text = [NSString stringWithFormat:@"订单编号：%@", modal.id_];
    myCell.operaterLb.text = [NSString stringWithFormat:@"开单人：%@", modal.oporaterName];
    myCell.productLb.text = [NSString stringWithFormat:@"共%d件商品", modal.saleCount];
    myCell.timeLb.text = [NSString stringWithFormat:@"%@", modal.createTime];
    myCell.totalPriceLb.text = [NSString stringWithFormat:@"应付金额：¥%.2lf", modal.orderPrice];
    myCell.realPayLb.text = [NSString stringWithFormat:@"实付金额：¥%.2lf", modal.realPrice];
    myCell.operateBtn.tag = indexPath.row;
    [myCell.operateBtn addTarget:self action:@selector(printOrderInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    return myCell;
}

- (void)loadDetail:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    OrderDetailCtl *ctl = [OrderDetailCtl new];
    Order_Model *modal = requestCon_.dataArr_[indexPath.row];
    [ctl beginLoad:modal exParam:nil];
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
