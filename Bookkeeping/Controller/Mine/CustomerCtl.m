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
#import "PinYinForObjc.h"

@interface CustomerCtl ()

{
    NSMutableArray      *keyArr_;
    NSMutableDictionary *dataDic_;
}

@end

@implementation CustomerCtl

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
    [self onStart];
}

#pragma mark - Base

- (void)rightBarBtnResponse:(id)sender
{
    AddCustomerCtl *ctl = [AddCustomerCtl new];
    ctl.title = @"新增客户";
    ctl.finished = ^(Customer_Modal *model) {
        [self onStart];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

-(void) startRequest:(RequestCon *)request
{
    [request queryCustomerList:[ManagerCtl getRoleInfo].companyId];
}

-(void) loadDataCompleate:(BaseRequest *)request dataArr:(NSArray *)dataArr code:(BaseErrorCode)code
{
    if( request == requestCon_ ){
        self.tableView_.tintColor = Color_Default;
        [self processData];
    }
    [super loadDataCompleate:request dataArr:dataArr code:code];
}


-(void) loadDetail:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    Customer_Modal *modal =  [[dataDic_ objectForKey:[keyArr_ objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    AddCustomerCtl *ctl = [AddCustomerCtl new];
    ctl.title = @"新增客户";
    [ctl beginLoad:modal exParam:nil];
    ctl.finished = ^(Customer_Modal *model) {
        [self onStart];
    };
    [self.navigationController pushViewController:ctl animated:YES];
}

#pragma mark - TableView Delegate

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[dataDic_ objectForKey:[keyArr_ objectAtIndex:section]] count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [keyArr_ count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *key = [keyArr_ objectAtIndex:section];
    return key;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return keyArr_;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomerCell *myCell = (CustomerCell*)[super tableView:tableView cellForRowAtIndexPath:indexPath];
    //更多Cell
    if( !myCell ){
        myCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CustomerCell class]) forIndexPath:indexPath];
        Customer_Modal *modal =  [[dataDic_ objectForKey:[keyArr_ objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
        
        [myCell setDefineTypeName:modal.name];
        myCell.nameLb.text = modal.name;
        myCell.phoneLb.text = modal.telphone;
        
    }
    return myCell;
}


#pragma mark - Private

//排序
-(void) processData
{
    //处理索引
    [keyArr_ removeAllObjects];
    keyArr_ = [[NSMutableArray alloc] init];
    dataDic_ = [[NSMutableDictionary alloc] init];
    
    BOOL bHaveOther = NO;
    for ( Customer_Modal * dataModal in requestCon_.dataArr_ ) {
        if( dataModal.name && [dataModal.name isKindOfClass:[NSString class]] ){
            dataModal.fristChar = [PinYinForObjc chineseConvertToPinYinHead:dataModal.name];
        }
        if( dataModal.fristChar && [dataModal.fristChar isKindOfClass:[NSString class]] ){
            const int *pChar = (const int *)[dataModal.fristChar cStringUsingEncoding:NSUTF8StringEncoding];
            int value = *pChar;
            if( value >= 'A' && value <= 'Z' ){
                NSString *tmp = [NSString stringWithFormat:@"%c",value];
                //判断是否已经添加
                BOOL bFind = NO;
                for ( NSString *str in keyArr_ ) {
                    if( [str isEqualToString:tmp] ){
                        bFind = YES;
                        break;
                    }
                }
                if( !bFind ){
                    [keyArr_ addObject:tmp];
                    NSMutableArray *arr = [[NSMutableArray alloc] init];
                    [dataDic_ setObject:arr forKey:tmp];
                    [arr addObject:dataModal];
                }else{
                    NSMutableArray *arr = [dataDic_ objectForKey:tmp];
                    [arr addObject:dataModal];
                }
            }else if( !bHaveOther ){
                bHaveOther = YES;
                
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                [dataDic_ setObject:arr forKey:@"#"];
                [arr addObject:dataModal];
            }else{
                NSMutableArray *arr = [dataDic_ objectForKey:@"#"];
                [arr addObject:dataModal];
            }
        }
    }
    
    NSArray *sortArr = [keyArr_ sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [(NSString*)obj1 compare:(NSString*)obj2];
    }];
    keyArr_ = [NSMutableArray arrayWithArray:sortArr];
    
    if( bHaveOther ){
        //[keyArr_ addObject:@"#"];
        [keyArr_ insertObject:@"#" atIndex:0];
    }
}


@end
