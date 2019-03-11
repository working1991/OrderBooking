//
//  MineItemCell.h
//  EherEducation
//
//  Created by Luoqw on 2017/2/7.
//  Copyright © 2017年 eher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineItemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView    *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel        *itemNameLb;
@property (weak, nonatomic) IBOutlet UILabel *detailLb;
@property (weak, nonatomic) IBOutlet UIImageView    *indicatorImageView;
@property (weak, nonatomic) IBOutlet UIView         *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;

-(void) showItemInfo:(NSDictionary *)info;

@end
