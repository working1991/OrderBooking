//
//  BaseListController.h
//  XZD
//
//  Created by sysweal on 14/11/14.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import "BaseUIViewController.h"
#import "BaseListMore_Cell.h"
#import "BaseListDefault_Cell.h"

@interface BaseListController : BaseUIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UIRefreshControl    *refresh_;
    BOOL                bHeadRefresh_;
}

@property(nonatomic,weak)   IBOutlet    UITableView *tableView_;


//是否有更多数据
-(BOOL) haveMoreData:(RequestCon *)request;

//加载更多数据
-(void) loadMore:(RequestCon *)request indexPath:(NSIndexPath *)indexPath;

//是否是更多的Cell
-(BOOL) isMoreCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

//加载详情
-(void) loadDetail:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
