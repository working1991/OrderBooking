//
//  ShopCarCell.h
//  EherEducation
//
//  Created by Luoqw on 2017/2/9.
//  Copyright © 2017年 eher. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICustomLineLabel.h"
#import "Standard_Modal.h"

@interface ChooseStandardCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthCons;
@property (weak, nonatomic) IBOutlet UIButton       *chooseBtn;
@property (weak, nonatomic) IBOutlet UIImageView    *icoImgView;
@property (weak, nonatomic) IBOutlet UILabel        *nameLb;
@property (weak, nonatomic) IBOutlet UILabel            *priceLb;
@property (weak, nonatomic) IBOutlet UICustomLineLabel  *originalPriceLb;

@property (weak, nonatomic) IBOutlet UIView      *numView;
@property (weak, nonatomic) IBOutlet UIButton    *addBtn;
@property (weak, nonatomic) IBOutlet UITextField *cntTf;
@property (weak, nonatomic) IBOutlet UIButton    *desBtn;
@property (weak, nonatomic) IBOutlet UIButton    *modifyBtn;

@property (assign ,nonatomic) int minNum;
@property (strong, nonatomic) void (^numChange)(int currentNum);
@property (strong, nonatomic) void (^itemChoosed)(BOOL isChoose);
@property (strong, nonatomic) void (^modifyPriceBlock)(void);

- (void)setTypeModle:(Standard_Modal *)model;

- (void)updateNum:(int)newNum;

@end
