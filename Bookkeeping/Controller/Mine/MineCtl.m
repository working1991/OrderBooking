//
//  MineCtl.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/11.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "MineCtl.h"
#import "MineItemCell.h"
#import "CustomerCtl.h"
#import "SettingCtl.h"
#import "ManagerCtl.h"
#import "SaleTotal_Modal.h"

@interface MineCtl ()

{
    NSArray     *itemInfoArray;
    SaleTotal_Modal *totalModal;
}

@property (weak, nonatomic) IBOutlet UIView *nameView;
@property (weak, nonatomic) IBOutlet UIView *amoutView;
@property (weak, nonatomic) IBOutlet UIView *orderNumView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *amoutLb;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLb;

@end

@implementation MineCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"我的";
        bHeadRefresh_ = NO;
    }
    return self;
}

- (void)initItemInfo
{
    itemInfoArray = @[
                      @[@{@"itemName":@"我的客户",@"icon":@"customer_list",@"itemType":@0},
                        @{@"itemName":@"设置",@"icon":@"icon_setting",@"itemType":@1}]
                      ];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([MineItemCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([MineItemCell class])];
    
    [self initViewShape];
    [self initItemInfo];
    [self.tableView_ reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.nameLb.text = [ManagerCtl getRoleInfo].name;
    [self onStart];
}


- (void)initViewShape
{
    CALayer *layer = self.nameView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 10;
    
    layer = self.orderNumView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 10;
    
    layer = self.amoutView.layer;
    layer.masksToBounds = YES;
    layer.cornerRadius = 10;
}

#pragma mark - Base
- (void)startRequest:(RequestCon *)request
{
    [request querySaleTotalInfo:[ManagerCtl getRoleInfo].id_ companyId:[ManagerCtl getRoleInfo].companyId];
}

- (void)finishLoadData:(BaseRequest *)request dataArr:(NSArray *)dataArr
{
    if (request == requestCon_) {
        totalModal = dataArr.firstObject;
        [self updatSaleTotalInfo];
    }
}


#pragma mark - Pravite
- (void)updatSaleTotalInfo
{
    self.amoutLb.text = [NSString stringWithFormat:@"¥%.2lf", totalModal.saleAmount];
    self.orderNumLb.text = [NSString stringWithFormat:@"%d", totalModal.orderCount];
}


#pragma mark - UITableView
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return itemInfoArray.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *subItems = itemInfoArray[section];
    return subItems.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineItemCell *myCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MineItemCell class]) forIndexPath:indexPath];
    NSArray *items = itemInfoArray[indexPath.section];
    NSDictionary *itemDic = items[indexPath.row];
    [myCell showItemInfo:itemDic];
    
    myCell.lineView.hidden = indexPath.row == items.count -1;
    myCell.detailLb.alpha = 0.0;
    
    return myCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *itemDic = itemInfoArray[indexPath.section][indexPath.row];
    int type = [itemDic[@"itemType"] intValue];
    switch (type) {
        case 0:
        {
            CustomerCtl *ctl = [[CustomerCtl alloc] init];
            ctl.title = itemDic[@"itemName"];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        case 1:
        {
            SettingCtl *ctl = [[SettingCtl alloc] init];
            ctl.title = itemDic[@"itemName"];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
        
        default:
            break;
    }
}

@end
