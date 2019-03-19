//
//  ShowProductCtl.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/11.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "ShowProductCtl.h"
#import "FirstClassCell.h"
#import "ShowProductCell.h"
#import "ChooseStandardCtl.h"
#import "ConfirmOrderCtl.h"
#import "ManagerCtl.h"

@interface ShowProductCtl ()

{
    RequestCon *groupCon;
    NSArray *groupArr;
    NSInteger selectIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *firstClassTableView;

@end

@implementation ShowProductCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"首页";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.firstClassTableView.delegate = self;
    self.firstClassTableView.dataSource = self;
    [self.firstClassTableView registerNib:[UINib nibWithNibName:NSStringFromClass([FirstClassCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([FirstClassCell class])];
    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([ShowProductCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([ShowProductCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Base
- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    [self loadGropList];
}

- (void)loadGropList
{
    groupCon = [self getNewRequestCon:NO];
    [groupCon getProuductGorpByCompanyId:[ManagerCtl getRoleInfo].companyId];
}

- (void)startRequest:(RequestCon *)request
{
    Base_Modal *grouModal = groupArr[selectIndex];
    [request getProductList:[ManagerCtl getRoleInfo].companyId groupId:grouModal.id_];
}

- (void)finishLoadData:(BaseRequest *)request dataArr:(NSArray *)dataArr
{
    if (request == groupCon) {
        groupArr = dataArr;
        if (groupArr.count > 0) {
            selectIndex = 0;
            [self onStart];
        }
        
    }
}

#pragma mark - Private

- (void)chooseStandard:(UIButton *)sender
{
    ChooseStandardCtl *ctl = [ChooseStandardCtl start:nil showInfoView:self.view finished:^(Base_Modal *model) {
        ConfirmOrderCtl *ctl = [ConfirmOrderCtl new];
        [self.navigationController pushViewController:ctl animated:YES];
    }];
    [self addChildViewController:ctl];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.firstClassTableView) {
        return 50;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.firstClassTableView) {
        return 50;
    }
    return 80;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.firstClassTableView) {
        FirstClassCell *myCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FirstClassCell class]) forIndexPath:indexPath];
        
        
        
        return myCell;
    }
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        ShowProductCell *myCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShowProductCell class]) forIndexPath:indexPath];
        
        [myCell.chooseBtn addTarget:self action:@selector(chooseStandard:) forControlEvents:UIControlEventTouchUpInside];
        
        cell = myCell;
    }
    
    
    return cell;
}


@end
