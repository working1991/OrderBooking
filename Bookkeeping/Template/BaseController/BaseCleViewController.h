//
//  BaseCleViewController.h
//  XZD
//
//  Created by shineface on 15/8/12.
//  Copyright (c) 2015年 sysweal. All rights reserved.
//

#import "BaseUIViewController.h"
#import "BaseCleFooterView.h"
@interface BaseCleViewController : BaseUIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

{
    UIRefreshControl    *refresh_;
    BOOL                bHeadRefresh_;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView_;

//加载详情
-(void) loadDetail:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;

@end
