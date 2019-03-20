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

@interface OrderDetailCtl ()

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
    
}


- (void)viewClickResponse:(id)sender
{
    if(sender == self.operateBtn) {
        [[PrintTool sharedManager] printOrderInfo:nil];
    }
}

#pragma mark - Pravite


#pragma mark - Delegate

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderDetailCell *myCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrderDetailCell class]) forIndexPath:indexPath];
    
    
    
    return myCell;
}

@end
