//
//  RefundListCell.h
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/4/29.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RefundListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (weak, nonatomic) IBOutlet UILabel *customerLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *operaterLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (weak, nonatomic) IBOutlet UILabel *payTypeLb;

@end

NS_ASSUME_NONNULL_END
