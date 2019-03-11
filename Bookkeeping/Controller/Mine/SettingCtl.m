//
//  SettingCtl.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/11.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "SettingCtl.h"
#import "MineItemCell.h"
#import "ChangePasswordCtl.h"

@interface SettingCtl ()

{
    NSArray     *itemInfoArray;
}

@end

@implementation SettingCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"我的";
    }
    return self;
}

- (void)initItemInfo
{
    itemInfoArray = @[
                      @[@{@"itemName":@"修改密码",@"icon":@"mine_change_password",@"itemType":@2}]
                      ];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([MineItemCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([MineItemCell class])];
    
    [self initItemInfo];
    [self.tableView_ reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Pravite


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
        case 2:
        {
            ChangePasswordCtl *ctl = [[ChangePasswordCtl alloc] init];
            ctl.title = itemDic[@"itemName"];
            [self.navigationController pushViewController:ctl animated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
