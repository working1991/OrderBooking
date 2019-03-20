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

@interface OrderListItemCtl ()

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


#pragma mark - Private
- (void)printOrderInfo:(UIButton *)sender
{
   [[PrintTool sharedManager] printOrderInfo:nil];
}


#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderListCell *myCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderListCell class]) forIndexPath:indexPath];
    
    [myCell.operateBtn addTarget:self action:@selector(printOrderInfo:) forControlEvents:UIControlEventTouchUpInside];
    
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailCtl *ctl = [OrderDetailCtl new];
    [self.navigationController pushViewController:ctl animated:YES];
}

@end
