//
//  RefundListCtl.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/4/29.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "RefundListCtl.h"
#import "RefundListCell.h"

@interface RefundListCtl ()

{
    Customer_Modal *inModal;
}

@end

@implementation RefundListCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"还款记录";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([RefundListCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([RefundListCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Base
-(void)beginLoad:(id)dataModal exParam:(id)exParam
{
    if ([dataModal isKindOfClass:[Customer_Modal class]]) {
        inModal = dataModal;
    }
    [super beginLoad:dataModal exParam:exParam];
}

- (void)startRequest:(RequestCon *)request
{
    [request queryRefundList:inModal.id_];
}

#pragma mark - Private


#pragma mark - UITableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RefundListCell *myCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RefundListCell class]) forIndexPath:indexPath];
    
    Order_Model *modal = requestCon_.dataArr_[indexPath.row];
    myCell.customerLb.text = modal.customerModal.name.length==0?@"-":modal.customerModal.name;
    myCell.operaterLb.text = [NSString stringWithFormat:@"开单人：%@", modal.oporaterName];;
    myCell.timeLb.text = [NSString stringWithFormat:@"%@", modal.createTime];
    myCell.amountLb.text = [NSString stringWithFormat:@"还款金额：¥%.2lf", modal.orderPrice];
    myCell.payTypeLb.text = [NSString stringWithFormat:@"还款方式：%@", [Order_Model getPayTypeName:modal.payTypeCode]];
    
    return myCell;
}

@end
