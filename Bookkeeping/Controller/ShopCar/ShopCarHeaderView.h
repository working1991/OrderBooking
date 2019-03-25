//
//  ShopCarHeaderView.h
//  EherEducation
//
//  Created by Luoqw on 2017/2/9.
//  Copyright © 2017年 eher. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCarHeaderView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UIButton   *chooseBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel    *titleLb;

@property (strong, nonatomic) void (^itemChoosed)(BOOL isChoose);
@property (strong, nonatomic) void (^queryDetail)(void);

@end
