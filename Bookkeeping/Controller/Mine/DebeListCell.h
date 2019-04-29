//
//  DebeListCell.h
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/4/29.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "CustomerCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DebeListCell : CustomerCell

@property (weak, nonatomic) IBOutlet UILabel *debtLb;
@property (weak, nonatomic) IBOutlet UIButton *recordBtn;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;

@property(nonatomic,strong) void (^recordBlock)(void);
@property(nonatomic,strong) void (^payBlock)(void);

@end

NS_ASSUME_NONNULL_END
