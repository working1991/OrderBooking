//
//  ShopCarCtl.h
//  EherEducation
//
//  Created by Luoqw on 2017/2/9.
//  Copyright © 2017年 eher. All rights reserved.
//

#import "BaseListController.h"
#import "ExRequestCon.h"
#import "Standard_Modal.h"

@interface ShopCarCtl : BaseListController

@property (weak, nonatomic) IBOutlet UIView      *noDataView;
@property (weak, nonatomic) IBOutlet UIButton   *allChooseBtn;
@property (weak, nonatomic) IBOutlet UIButton   *confirmBtn;
@property (weak, nonatomic) IBOutlet UILabel            *priceLb;

@property(nonatomic,copy)   void (^finished)(void);

//添加
+ (BOOL)addContent:(Standard_Modal *)typeModal prodcut:(Product_Modal *)productModal;

+ (void)removeProductArr:(NSArray *)productArr;

@end
