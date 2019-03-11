//
//  BaseListController.m
//  XZD
//
//  Created by sysweal on 14/11/14.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import "BaseListController.h"

@interface BaseListController ()

@end

@implementation BaseListController

@synthesize tableView_;

-(id) init
{
    self = [super init];

    bHeadRefresh_ = YES;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    tableView_.delegate = self;
    tableView_.dataSource = self;
    tableView_.tintColor = Color_Default;

    [tableView_ registerNib:[UINib nibWithNibName:@"BaseListMore_Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BaseListMore_Cell"];
    [tableView_ registerNib:[UINib nibWithNibName:@"BaseListDefault_Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BaseListDefault_Cell"];
    
    if( bHeadRefresh_ )
    {
        refresh_ = [[UIRefreshControl alloc] init];
        refresh_.tintColor = [UIColor lightGrayColor];
        refresh_.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"下拉刷新", nil)];
        [refresh_ addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];

        [tableView_ addSubview:refresh_];
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
{
//    if( refresh_.refreshing )
//        [refresh_ endRefreshing];
    [refresh_ removeFromSuperview];
    refresh_ = nil;
    tableView_.delegate = nil;
    tableView_.dataSource = nil;
    [tableView_ setContentOffset:CGPointMake(0, -1000) animated:NO];
    [tableView_ removeFromSuperview];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//辅助
-(CGFloat) getProcessViewTopMore
{
    return 0;
}

-(UIView *) getRequestProcessView:(BaseRequest *)request
{
    if( request == requestCon_ ){
        return tableView_;
    }else
        return [super getRequestProcessView:request];
}

//开始
-(void) onStart
{
    [MyLog Log:@"onStart" obj:self];
    
    requestCon_ = nil;
    [tableView_ reloadData];
    
    requestCon_ = [self getNewRequestCon:YES];
    [self startRequest:requestCon_];
}

-(void) refreshView:(UIRefreshControl *)refresh
{
    [MyLog Log:@"refresh" obj:self];
    requestCon_ = nil;
    [tableView_ reloadData];
    
    requestCon_ = [self getNewRequestCon:YES];
    requestCon_.pageModal_.currentPage_ = PageStart_Index;
    [self startRequest:requestCon_];
}

-(void) showLoadingView:(BaseRequest *)request
{
    if( request == requestCon_ ){
        if( requestCon_.pageModal_.currentPage_ == PageStart_Index )
        {
            if( bHeadRefresh_ ){
                refresh_.attributedTitle = [[NSAttributedString alloc] initWithString:@"Loading..."];
                if( !refresh_.refreshing )
                    [refresh_ beginRefreshing];
                
                [tableView_ setContentOffset:CGPointMake(0, -80) animated:NO];
            }else{
                [super showLoadingView:request];
            }
        }
    }else{
        [super showLoadingView:request];
    }
}

-(void) hideLoadingView:(BaseRequest *)request
{
    if( request == requestCon_ && bHeadRefresh_ ){
        if( requestCon_.pageModal_.currentPage_ <= PageStart_Index + 1 )
        {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
            NSString *lastUpdated = [NSString stringWithFormat:NSLocalizedString(@"上次更新日期 %@", nil),
                                     [formatter stringFromDate:[NSDate date]]];
            refresh_.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
            [refresh_ endRefreshing];
            [UIView animateWithDuration:0.15f animations:^{
                [tableView_ setContentOffset:CGPointZero animated:NO];
            }];
        }
    }else{
        [super hideLoadingView:request];
    }
}

-(void) showNoDataView:(BaseRequest *)request
{
    if( [request.dataArr_ count] == 0 ){
        [super showNoDataView:request];
    }
}

-(void) showErrorDataView:(BaseRequest *)request code:(BaseErrorCode)code
{
    switch ( request.cfgModal_.type_ ) {
        case RequestLoadingType_Model:
            [super showErrorDataView:request code:code];
            break;
        case RequestLoadingType_Normal:
        {
            if (request.state_ != RequestState_Fail) {
                [tableView_ setContentOffset:CGPointZero animated:YES];
            }
            if( [request.dataArr_ count] > 0 ){
                if( request.pageModal_.currentPage_ == PageStart_Index ){
                    [BaseUIViewController showHUDFailView:[BaseErrorInfo getErrorMsg:code] msg:nil];
                }else
                {
                    //不处理
                }
            }else{
                [super showErrorDataView:request code:code];
            }
        }
            break;
        default:
            break;
    }
}

-(void) loadDataCompleate:(BaseRequest *)request dataArr:(NSArray *)dataArr code:(BaseErrorCode)code
{
    [super loadDataCompleate:request dataArr:dataArr code:code];

    if( request == requestCon_ && code == ErrorCode_Success ){
        [tableView_ reloadData];
    }
}

-(BOOL) haveMoreData:(RequestCon *)request
{
//    return request.pageModal_.bHaveMore;
    
    BOOL flag = NO;
    if( request.dataArr_.count > 0 && request.pageModal_.currentPage_ < request.pageModal_.totalPage_ + PageStart_Index && request.pageModal_.totalPage_ > 1 && request.pageModal_.currentPage_ > PageStart_Index ){
        flag = YES;
    }
    return flag;
}

//加载更多数据
-(void) loadMore:(RequestCon *)request indexPath:(NSIndexPath *)indexPath
{
    [MyLog Log:@"loadMore" obj:self];
    @try {
        [tableView_ reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    @catch (NSException *exception) {
        [tableView_ reloadData];
    }
    @finally {
        [self startRequest:request];
    }
}

//是否是更多的Cell
-(BOOL) isMoreCell:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    BOOL flag = NO;
    
    if( tableView == tableView_ && [self haveMoreData:requestCon_] && indexPath.row == [requestCon_.dataArr_ count] && indexPath.row != 0 ){
        flag = YES;
    }
    
    return flag;
}

//加载详情
-(void) loadDetail:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    [MyLog Log:[NSString stringWithFormat:@"tableView Cell Clicked index=%d",indexPath.row] obj:self];
}

#pragma UITableViewDataSource/UITableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [requestCon_.dataArr_ count] + [self haveMoreData:requestCon_];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *myCell = nil;
    //更多Cell
    if( [self isMoreCell:tableView indexPath:indexPath] ){
        BaseListMore_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseListMore_Cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        //已经正在加载了
        if( requestCon_.state_ == RequestState_Loading ){
            cell.detailLb_.textColor = [UIColor blackColor];
            cell.detailLb_.text = NSLocalizedString(@"正在加载...", nil);
            [cell.indicatorView_ startAnimating];
        }
        //去加载更多
        else if( requestCon_.state_ == RequestState_Finish || requestCon_.state_ == RequestState_Null ){
            cell.detailLb_.textColor = [UIColor blackColor];
            cell.detailLb_.text = NSLocalizedString(@"加载更多", nil);
            [cell.indicatorView_ stopAnimating];
            
            
            requestCon_.state_ = RequestState_Loading;
            
            double delayInSeconds = 0.33f;//allow enough time for progress to animate
            dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
            dispatch_after(time, dispatch_get_main_queue(), ^(void){
                [self loadMore:requestCon_ indexPath:indexPath];
            });
        }
        //加载出错了
        else if( requestCon_.state_ == RequestState_Fail ){
            cell.detailLb_.textColor = [UIColor redColor];
            cell.detailLb_.text = NSLocalizedString(@"加载更多失败", nil);
            [cell.indicatorView_ stopAnimating];
            
            //将状态转换成Finish，以供下次再次加载
            requestCon_.state_ = RequestState_Finish;
        }
        
        myCell = cell;
    }
    else{

    }
    
    return myCell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( [self isMoreCell:tableView indexPath:indexPath] ){
        return 44;
    }else
        return tableView.rowHeight;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if( [self isMoreCell:tableView indexPath:indexPath] && !(requestCon_.state_ == RequestState_Finish) ){
        return;
    }
    [self.searchKeyBar resignFirstResponder];
    
    if( [self isMoreCell:tableView indexPath:indexPath] && requestCon_.state_ != RequestState_Loading ){
        [self loadMore:requestCon_ indexPath:indexPath];
    }else{
        [self loadDetail:tableView indexPath:indexPath];
    }
}

-(void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}



@end
