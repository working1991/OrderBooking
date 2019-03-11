//
//  CustomerCtl.m
//  EherEmployee
//
//  Created by Luoqw on 2018/1/3.
//  Copyright © 2018年 eher. All rights reserved.
//

#import "CustomerCtl.h"
#import "ManagerCtl.h"
#import "CustomerCell.h"
#import "Customer_Modal.h"
#import "UIImageView+WebCache.h"
#import "AddCustomerCtl.h"

@interface CustomerCtl ()<UITextFieldDelegate,UISearchBarDelegate>
@property (strong,nonatomic) UISearchBar *searchbar;
@end

@implementation CustomerCtl

@synthesize searchbar;

-(id)init
{
    self = [super init];
    if ( self ) {
        self.title = @"客户";
        rightBarStr_ = @"新增";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([CustomerCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([CustomerCell class])];
    
    searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
//    searchbar.showsCancelButton = NO;
    searchbar.placeholder = @"搜索关键字";
    searchbar.delegate = self;
    searchbar.tintColor=[UIColor blueColor];
    searchbar.returnKeyType = UIReturnKeySearch;
    [self clearBorderOfSearchBar:searchbar];
    self.tableView_.tableHeaderView = searchbar;
    self.tableView_.contentInset = UIEdgeInsetsZero;
    
    for (UIView * obj in searchbar.subviews) {
        if ( [obj isKindOfClass:[UITextField class]] ) {
            UITextField *tf = (UITextField *)obj;
            tf.returnKeyType = UIReturnKeyDefault;
        }
    }
    
    [self onStart];
}

//去除搜索框的边框
- (void)clearBorderOfSearchBar:(UISearchBar *)searchBar
{
    for (UIView *view in searchBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    [searchBar setBackgroundColor:[Common getColor:@"F2F2F2"]];
}

#pragma mark --UISearchDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchbar resignFirstResponder];
    
    //    if ( ![searchbar.text isEqualToString:@""] ) {
    [requestCon_.dataArr_ removeAllObjects];
    [self.tableView_ reloadData];
    [self onStart];
    //    }
    //    else {
    //        [BaseUIViewController showAlertView:@"请输入关键字" msg:nil cancel:@"确定"];
    //    }
    
    //    searchbar.text = @"";
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    searchbar.text = @"";
    [requestCon_.dataArr_ removeAllObjects];
    [self.tableView_ reloadData];
    [self onStart];
    
    [searchbar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *) searchBar
{
    UITextField *searchBarTextField = nil;
    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) ? searchBar.subviews : [[searchBar.subviews objectAtIndex:0] subviews];
    for (UIView *subview in views)
    {
        if ([subview isKindOfClass:[UITextField class]])
        {
            searchBarTextField = (UITextField *)subview;
            break;
        }
    }
    searchBarTextField.enablesReturnKeyAutomatically = NO;
}

#pragma mark - Base

-(CGFloat)getProcessViewTopMore
{
    return searchbar.bounds.size.height;
    
}

-(void) startRequest:(RequestCon *)request
{
//    [request queryCustomerList:[ManagerCtl getRoleInfo].id_ organizationId:[ManagerCtl getRoleInfo].organizationId keyword:self.searchbar.text];
}

-(void) loadDetail:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    Customer_Modal *baseModal =  [requestCon_.dataArr_ objectAtIndex:indexPath.row];

//    CustomerDetailCtl *ctl = [[CustomerDetailCtl alloc] init];
//    [ctl beginLoad:baseModal exParam:nil];
//    [self.navigationController pushViewController:ctl animated:YES];
}


- (void)rightBarBtnResponse:(id)sender
{
    [AddCustomerCtl start:^(Customer_Modal *model) {
        [self onStart];
    }];
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomerCell *myCell = (CustomerCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    if( !myCell ){
        myCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CustomerCell class]) forIndexPath:indexPath];
//        myCell.tintColor = Color_Default;
//        
//        Customer_Modal *model = [requestCon_.dataArr_ objectAtIndex:indexPath.row];
//        
//        myCell.nameLb.text = model.name;
//        [myCell.headImgView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"head_default"]];

    }
    return myCell;
}

@end
