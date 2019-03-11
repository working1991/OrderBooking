//
//  BaseCleViewController.m
//  XZD
//
//  Created by shineface on 15/8/12.
//  Copyright (c) 2015年 sysweal. All rights reserved.
//

#import "BaseCleViewController.h"

@interface BaseCleViewController ()

@end

@implementation BaseCleViewController

@synthesize collectionView_;

-(id) init
{
    self = [super init];
    
    bHeadRefresh_ = NO;
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    collectionView_.dataSource = self;
    collectionView_.delegate = self;

    [collectionView_ registerNib:[UINib nibWithNibName:@"BaseCleFooterView" bundle:[NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"BaseCleFooterView"];
    
    if( bHeadRefresh_ )
    {
        refresh_ = [[UIRefreshControl alloc] init];
        refresh_.tintColor = [UIColor lightGrayColor];
        refresh_.attributedTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"下拉刷新", nil)];
        [refresh_ addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
        
        [collectionView_ addSubview:refresh_];
        self.collectionView_.alwaysBounceVertical = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
{
    [refresh_ removeFromSuperview];
    refresh_ = nil;
    [collectionView_ setContentOffset:CGPointMake(0, -1000) animated:NO];
    [collectionView_ removeFromSuperview];
}

-(float) getProcessViewTopMore
{
    return 0;
}

-(UIView *) getRequestProcessView:(BaseRequest *)request
{
    if( request == requestCon_ ){
        return collectionView_;
    }else
        return [super getRequestProcessView:request];
}

//开始
-(void) onStart
{
    [MyLog Log:@"onStart" obj:self];
    
    requestCon_ = [self getNewRequestCon:YES];
    [self startRequest:requestCon_];
}

-(void) refreshView:(UIRefreshControl *)refresh
{
    [MyLog Log:@"refresh" obj:self];
    requestCon_ = nil;
    [collectionView_ reloadData];
    
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
                
                [collectionView_ setContentOffset:CGPointMake(0, -1) animated:NO];
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
            NSString *lastUpdated = [NSString stringWithFormat:NSLocalizedString(@"上次更新时间 %@", nil),
                                     [formatter stringFromDate:[NSDate date]]];
            refresh_.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
            [refresh_ endRefreshing];
        }
    }else{
        [super hideLoadingView:request];
    }
}

-(void) showNoDataView:(BaseRequest *)request
{
    if( request.dataArr_.count == 0 ){
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
        [collectionView_ reloadData];
    }
}

-(BOOL) haveMoreData:(RequestCon *)request
{
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
    //[collectionView_ reloadItemsAtIndexPaths:@[indexPath]];
    
    [self startRequest:request];
}

//是否是更多的Cell
-(BOOL) isMoreCell:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    BOOL flag = NO;
    
    if( collectionView == collectionView_ && [self haveMoreData:requestCon_]){
        flag = YES;
    }
    
    return flag;
}

//加载详情
-(void) loadDetail:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath
{
    [MyLog Log:[NSString stringWithFormat:@"collectionView Cell Clicked index=%d",indexPath.row] obj:self];
}

#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return requestCon_.dataArr_.count ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *myCell = nil;
    return myCell;

}


//分区尾加载视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        BaseCleFooterView * footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"BaseCleFooterView" forIndexPath:indexPath];
        if( [self isMoreCell:collectionView indexPath:indexPath] ) {
            //显示加载视图
            footer.hidden = NO;
            //已经正在加载了
            if( requestCon_.state_ == RequestState_Loading ){
                footer.detailLb_.textColor = [UIColor blackColor];
                footer.detailLb_.text = NSLocalizedString(@"正在加载...", nil);
                [footer.indicatorView_ startAnimating];
            }
            //去加载更多
            else if( requestCon_.state_ == RequestState_Finish || requestCon_.state_ == RequestState_Null ){
                footer.detailLb_.textColor = [UIColor blackColor];
                footer.detailLb_.text = NSLocalizedString(@"加载更多", nil);
                [footer.indicatorView_ stopAnimating];
                
                requestCon_.state_ = RequestState_Loading;
                
                double delayInSeconds = 0.33f;//allow enough time for progress to animate
                dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
                dispatch_after(time, dispatch_get_main_queue(), ^(void){
                    [self loadMore:requestCon_ indexPath:indexPath];
                });
            }
            //加载出错了
            else if( requestCon_.state_ == RequestState_Fail ){
                footer.detailLb_.textColor = [UIColor redColor];
                footer.detailLb_.text = NSLocalizedString(@"加载更多失败", nil);
                [footer.indicatorView_ stopAnimating];
                
                //将状态转换成Finish，以供下次再次加载
                requestCon_.state_ = RequestState_Finish;
            }
    
        }
        else {
            //隐藏加载视图
            footer.hidden = YES;
        }
        
        reusableView = footer;
        
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if([self haveMoreData:requestCon_]) {
        return CGSizeMake(collectionView.bounds.size.width, 44);
    } else {
        return CGSizeMake(collectionView.bounds.size.width, 0.01);
    }
}

#pragma mark - UICollectionViewDelegate


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if( [self isMoreCell:collectionView indexPath:indexPath] && requestCon_.state_ != RequestState_Loading ){
        [self loadMore:requestCon_ indexPath:indexPath];
    }else{
        [self loadDetail:collectionView indexPath:indexPath];
    }
}

@end
