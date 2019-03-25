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
#import "Product_Modal.h"
#import "UIImageView+WebCache.h"
#import "ShopCarCtl.h"

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
        rightBarImg_ = @"icon_shopcart_white";
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
    if (bSearch) {
        [request searchProductList:[ManagerCtl getRoleInfo].companyId keyword:self.searchKeyBar.text];
    } else {
        Base_Modal *grouModal = groupArr[selectIndex];
        [request getProductList:[ManagerCtl getRoleInfo].companyId groupId:grouModal.id_];
    }
}

- (void)finishLoadData:(BaseRequest *)request dataArr:(NSArray *)dataArr
{
    if (request == groupCon) {
        groupArr = dataArr;
        [self.firstClassTableView reloadData];
        if (groupArr.count > 0) {
            selectIndex = 0;
            [self onStart];
        }
        
    }
}

- (void)searchButtonResponse:(id)sender {
    if (self.searchKeyBar.text.length==0) {
        [BaseUIViewController showAlertView:@"请输入关键字" msg:nil cancel:@"知道了"];
        return;
    } else {
        bSearch = YES;
        [self.firstClassTableView reloadData];
        [self onStart];
    }
}

- (void)rightBarBtnResponse:(id)sender
{
    [self.navigationController pushViewController:[ShopCarCtl new] animated:YES];
}

#pragma mark - Private

- (void)chooseStandard:(UIButton *)sender
{
    Product_Modal *modal = requestCon_.dataArr_[sender.tag];
    ChooseStandardCtl *ctl = [ChooseStandardCtl start:modal showInfoView:self.view finished:^(Product_Modal *product) {
        ConfirmOrderCtl *ctl = [ConfirmOrderCtl new];
        [ctl beginLoad:product exParam:nil];
        [self.navigationController pushViewController:ctl animated:YES];
    }];
    [self addChildViewController:ctl];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.firstClassTableView) {
        return groupArr.count;
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
        
        Base_Modal *model = groupArr[indexPath.row];
        myCell.nameLb.text = model.name;
        myCell.nameLb.textColor = (!bSearch&&selectIndex==indexPath.row)?Color_Default:[Common getColor:@"333333"];
        myCell.backgroundColor = (!bSearch&&selectIndex==indexPath.row)?[Common getColor:@"f2f2f2"]:[UIColor whiteColor];
        
        return myCell;
    }
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (!cell) {
        ShowProductCell *myCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ShowProductCell class]) forIndexPath:indexPath];
        
        Product_Modal *modal = requestCon_.dataArr_[indexPath.row];
        myCell.nameLb.text = modal.name;
        [myCell.iconImgView sd_setImageWithURL:[NSURL URLWithString:modal.imgUrl]];
        myCell.priceLb.text = [NSString stringWithFormat:@"¥%@元/件", modal.unitPrice];
        
        myCell.chooseBtn.tag = indexPath.row;
        [myCell.chooseBtn addTarget:self action:@selector(chooseStandard:) forControlEvents:UIControlEventTouchUpInside];
        
        cell = myCell;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.firstClassTableView) {
        selectIndex = indexPath.row;
        bSearch = NO;
        self.searchKeyBar.text = nil;
        [self.firstClassTableView reloadData];
        [self onStart];
    } else {
        
    }
}

#pragma mark - searchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    bSearch = YES;
    [self.firstClassTableView reloadData];
    [super searchBarSearchButtonClicked:searchBar];
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        bSearch = NO;
        [self onStart];
    }
}

@end
