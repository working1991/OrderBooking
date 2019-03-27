//
//  LQWCardDetailCtl.m
//  XZD
//
//  Created by luoqingwu on 15/11/13.
//  Copyright © 2015年 sysweal. All rights reserved.
//

#import "OrderDetailCtl.h"
#import "OrderDetailCell.h"
#import "PrintTool.h"
#import "OrderDetailHeadView.h"

@interface OrderDetailCtl ()

{
    Order_Model *inModel;
    Order_Model *detailModel;
}

@end


@implementation OrderDetailCtl


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"订单详情";
        bHeadRefresh_ = NO;
    }
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([OrderDetailHeadView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([OrderDetailHeadView class])];
    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([OrderDetailCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([OrderDetailCell class])];
    
    CALayer *layer = self.operateBtn.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 5;
    layer.borderColor = self.operateBtn.titleLabel.textColor.CGColor;
    layer.borderWidth = 1.0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Base

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    inModel = dataModal;
    [super beginLoad:dataModal exParam:exParam];
}

- (void)startRequest:(RequestCon *)request
{
    [request queryOrderDetail:inModel.id_];
}

- (void)finishLoadData:(BaseRequest *)request dataArr:(NSArray *)dataArr
{
    if (request == requestCon_) {
        detailModel = dataArr.firstObject;
        [self updateDetailInfo:detailModel];
    }
}

- (void)viewClickResponse:(id)sender
{
    if(sender == self.operateBtn) {
        [[PrintTool sharedManager] printOrderInfo:detailModel];
    }
}

#pragma mark - Pravite
- (void)updateDetailInfo:(Order_Model *)modal
 {
     self.customerLb.text = modal.customerModal.name;
     self.statusLb.text = modal.orderStatusName;
     self.orderCodeLb.text = modal.id_;
     self.operaterLb.text = modal.oporaterName;
     self.timeLb.text = modal.createTime;
     self.totalPriceLb.text = [NSString stringWithFormat:@"¥%.2lf", modal.orderPrice];
     self.realPayLb.text = [NSString stringWithFormat:@"¥%.2lf", modal.realPrice];
     [self.tableView_ reloadData];
 }

#pragma mark - Delegate

#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return detailModel.productTypeArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderDetailHeadView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([OrderDetailHeadView class])];
    
    Product_Modal *productModal = detailModel.productTypeArr[section];
    headView.productName.text = productModal.name;
    
    return headView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Product_Modal *productModal = detailModel.productTypeArr[section];
    return productModal.typeArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailCell *myCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDetailCell class]) forIndexPath:indexPath];
    
    Product_Modal *productModal = detailModel.productTypeArr[indexPath.section];
    Standard_Modal *modal = productModal.typeArr[indexPath.row];
    myCell.typeLb.text = [NSString stringWithFormat:@"尺码：%@（%@）", modal.secondSpecName, modal.firstSpecName];
    myCell.countLb.text = [NSString stringWithFormat:@"%d件", modal.saleCount];
    
    return myCell;
}

@end
