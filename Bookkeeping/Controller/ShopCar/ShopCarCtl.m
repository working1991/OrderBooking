//
//  ShopCarCtl.m
//  EherEducation
//
//  Created by Luoqw on 2017/2/9.
//  Copyright © 2017年 eher. All rights reserved.
//

#import "ShopCarCtl.h"
#import "ChooseStandardCell.h"
#import "ShopCarHeaderView.h"
#import "ManagerCtl.h"
#import "Standard_Modal.h"
#import "UIImageView+WebCache.h"
#import "ConfirmOrderCtl.h"

@interface ShopCarCtl () <UITextFieldDelegate>

@property (strong, nonatomic) NSMutableArray    *sourceArr;

@end

@implementation ShopCarCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"购物车";
        bHeadRefresh_ = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([ChooseStandardCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([ChooseStandardCell class])];
    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([ShopCarHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([ShopCarHeaderView class])];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self queryShopCar];
    [self updateAllChooseBtnStatus];
    [self.tableView_ reloadData];
}

- (void)queryShopCar
{
    self.sourceArr = [NSMutableArray arrayWithArray:[ManagerCtl getRoleInfo].selectProductArr];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewClickResponse:(id)sender
{
    if (sender == _allChooseBtn) {
        _allChooseBtn.selected = !_allChooseBtn.selected;
        for (Product_Modal *modal in self.sourceArr) {
            modal.bSelected_ = _allChooseBtn.selected;
            for (Standard_Modal *typeModel in modal.typeArr) {
                typeModel.bSelected_ = _allChooseBtn.selected;
            }
        }
        [self updateTotalPriceInfo];
        [self.tableView_ reloadData];
        
    } else if (sender == self.confirmBtn) {
        NSMutableArray *selectArr = [NSMutableArray array];
        for (Product_Modal *modal in [ManagerCtl getRoleInfo].selectProductArr) {
            NSMutableArray *typeArr= [NSMutableArray array];
            for (Standard_Modal *typeModel in modal.typeArr) {
                if (typeModel.bSelected_) {
                    [typeArr addObject:typeModel];
                }
            }
            if (typeArr.count>0) {
                Product_Modal *selectModal = [modal mutableCopy];
                selectModal.typeArr = typeArr;
                [selectArr addObject:selectModal];
            }
        }
        if (selectArr.count == 0) {
            [BaseUIViewController showAlertView:@"未选择任一产品" msg:nil cancel:@"知道了"];
        } else {
            ConfirmOrderCtl *ctl = [ConfirmOrderCtl new];
            [ctl beginLoad:nil exParam:selectArr];
            [self.navigationController pushViewController:ctl animated:YES];
        }
    }
}

#pragma mark - Pravite
-(void) udpateNoDataView
{
    _noDataView.alpha = ![self.sourceArr count];
}

- (void)deleteProduct:(NSIndexPath *)indexPath
{
    Product_Modal *modal = self.sourceArr[indexPath.section];
    Standard_Modal *typeModel = modal.typeArr[indexPath.row];
    NSMutableArray *typeArr = [NSMutableArray arrayWithArray:modal.typeArr];
    [typeArr removeObject:typeModel];
    modal.typeArr = typeArr;
    
    if (typeArr.count == 0) {
        [self.sourceArr removeObject:modal];
    }
    [ManagerCtl getRoleInfo].selectProductArr = self.sourceArr;
    [self.tableView_ reloadData];
    [self updateTotalPriceInfo];
}

- (void)updateChooseBtnStatus:(NSInteger)index
{
    [self.tableView_ reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
    [self updateAllChooseBtnStatus];
}

- (void)updateAllChooseBtnStatus
{
    BOOL bAllChoose = YES;
    for (Product_Modal *modal in self.sourceArr) {
        for (Standard_Modal *typeModel in modal.typeArr) {
            if (!typeModel.bSelected_) {
                bAllChoose = NO;
                break;
            }
        }
    }
    _allChooseBtn.selected = bAllChoose;
    [self updateTotalPriceInfo];
}

- (void)updateTotalPriceInfo
{
    [self udpateNoDataView];
    double totalPrice = 0;
    int count = 0;
    for (Product_Modal *modal in self.sourceArr) {
        for (Standard_Modal *typeModel in modal.typeArr) {
            if (typeModel.bSelected_) {
                count += typeModel.saleCount;
                totalPrice += typeModel.realPrice*typeModel.saleCount;
                break;
            }
        }
    }
    self.priceLb.text = [NSString stringWithFormat:@"¥%.2lf", totalPrice];
    NSString *normalStr = @"下单";
    NSDictionary *attribs = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:normalStr attributes:attribs];
    if (count > 0) {
        NSString *countStr = [NSString stringWithFormat:@"%@(%d)", normalStr,count];
        str = [[NSMutableAttributedString alloc]initWithString:countStr];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0] range:[countStr rangeOfString:[NSString stringWithFormat:@"(%d)", count]]];
    }
    self.confirmBtn.titleLabel.attributedText = str;
    [self.confirmBtn setAttributedTitle:str forState:UIControlStateNormal];
    
    if (count == 0) {
        self.confirmBtn.userInteractionEnabled = NO;
        [self.confirmBtn setBackgroundColor:[UIColor lightGrayColor]];
    } else {
        self.confirmBtn.userInteractionEnabled = YES;
        [self.confirmBtn setBackgroundColor:Color_Default];
    }
}


- (void)modifyPrice:(NSIndexPath *)indexPath
{
    [self showTextAlert:UIKeyboardTypeDecimalPad title:@"修改单价" msg:nil placeholder:@"请输入价格" confirmHandle:^(NSString *text) {
        Product_Modal *modal = self.sourceArr[indexPath.section];
        Standard_Modal *typeModel = modal.typeArr[indexPath.row];
        typeModel.realPrice = [text doubleValue];
        [self.tableView_ reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self updateTotalPriceInfo];
    }];
}
#pragma mark - UITableView

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sourceArr.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Product_Modal *modal = self.sourceArr[section];
    return modal.typeArr.count;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShopCarHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([ShopCarHeaderView class])];

    Product_Modal *modal = self.sourceArr[section];
    headView.titleLb.text = modal.name;
    [headView.iconImgView sd_setImageWithURL:[NSURL URLWithString:modal.imgUrl]];
    headView.itemChoosed = ^(BOOL bSelect) {
        for (Standard_Modal *typeModel in modal.typeArr) {
            typeModel.bSelected_ = bSelect;
        }
        [self updateChooseBtnStatus:section];
    };
    BOOL bAllChoose = YES;
    for (Standard_Modal *typeModel in modal.typeArr) {
        if (!typeModel.bSelected_) {
            bAllChoose = NO;
            break;
        }
    }
    headView.chooseBtn.selected = bAllChoose;

    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseStandardCell *itemCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChooseStandardCell class]) forIndexPath:indexPath];
    itemCell.minNum = Add_Product_Num;
    Product_Modal *modal = self.sourceArr[indexPath.section];
    Standard_Modal *typeModel = modal.typeArr[indexPath.row];
    
    itemCell.itemChoosed = ^(BOOL isChoose) {
        typeModel.bSelected_ = isChoose;
        [self updateChooseBtnStatus:indexPath.section];
    };
    itemCell.chooseBtn.selected = typeModel.bSelected_;
    
    itemCell.numChange = ^(int count){
        typeModel.saleCount = count;
        [self updateTotalPriceInfo];
    };
    
    itemCell.modifyPriceBlock = ^{
        [self modifyPrice:indexPath];
    };
    
    [itemCell setTypeModle:typeModel];
    
    itemCell.cntTf.delegate = self;
    
    return itemCell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 60;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self showChooseAlertViewCtl:@"确定删除" msg:nil confirmHandle:^{
            [self deleteProduct:indexPath];
        }];
    }
}

#pragma mark - UITextField
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    ChooseStandardCell *itemCell = [self getCarCell:textField];
    if (itemCell) {
        [self showTextAlert:UIKeyboardTypeDecimalPad title:itemCell.nameLb.text msg:nil placeholder:@"请输入数量" confirmHandle:^(NSString *text) {
            [itemCell updateNum:[text intValue]];
        }];
        return NO;
    }
    return YES;
}

- (ChooseStandardCell *)getCarCell:(UIView *)subView
{
    if (subView && subView.superview) {
        if ([subView.superview isKindOfClass:[ChooseStandardCell class]]) {
            return (ChooseStandardCell *)subView.superview;
        }
        return [self getCarCell:subView.superview];
    }
    return nil;
}

#pragma mark - Public

//添加
+ (BOOL)addContent:(Standard_Modal *)typeModal prodcut:(Product_Modal *)productModal
{
    if (!productModal.id_) {
        return NO;
    }
    Standard_Modal *modal = [typeModal mutableCopy];
    modal.bSelected_ = YES;
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:[ManagerCtl getRoleInfo].selectProductArr];
    BOOL bFind = NO;
    for ( Product_Modal *tmpModal in dataArr ) {
        if ([tmpModal.id_ isEqualToString:productModal.id_]) {
            for (Standard_Modal *tmpTypeModal in tmpModal.typeArr) {
                if ([tmpTypeModal.productReSpecId isEqualToString:modal.productReSpecId]) {
                    bFind = YES;
                    tmpTypeModal.saleCount = modal.saleCount;
                    break;
                }
            }
            if (!bFind) {
                NSMutableArray *typeArr = [NSMutableArray arrayWithArray:tmpModal.typeArr];
                [typeArr addObject:modal];
                tmpModal.typeArr = typeArr;
                bFind = YES;
            }
            break;
        }
    }
    if( !bFind ){
        
        Product_Modal *proModal = [productModal mutableCopy];
        NSMutableArray *typeArr = [NSMutableArray array];
        [typeArr addObject:modal];
        proModal.typeArr = typeArr;
        [dataArr addObject:proModal];
    }
    [ManagerCtl getRoleInfo].selectProductArr = dataArr;
    return YES;
}

+ (void)removeProductArr:(NSArray *)productArr
{
    for (Product_Modal *modal in productArr) {
        for (Standard_Modal *typeModal in modal.typeArr) {
            [self remove:typeModal prodcut:modal];
        }
    }
}

//移除
+ (void)remove:(Standard_Modal *)typeModal prodcut:(Product_Modal *)productModal
{
    if (!productModal.id_) {
        return;
    }
    NSMutableArray *dataArr = [NSMutableArray arrayWithArray:[ManagerCtl getRoleInfo].selectProductArr];
    BOOL bFind = NO;
    Product_Modal *deleteModal;
    for ( Product_Modal *tmpModal in dataArr ) {
        if ([tmpModal.id_ isEqualToString:productModal.id_]) {
            for (Standard_Modal *tmpTypeModal in tmpModal.typeArr) {
                if ([tmpTypeModal.productReSpecId isEqualToString:typeModal.productReSpecId]) {
                    bFind = YES;
                    NSMutableArray *typeArr = [NSMutableArray arrayWithArray:tmpModal.typeArr];
                    [typeArr removeObject:tmpTypeModal];
                    tmpModal.typeArr = typeArr;
                }
            }
            if (tmpModal.typeArr.count == 0) {
                deleteModal = tmpModal;
                break;
            }
        }
    }
    
    if( deleteModal.id_){
        [dataArr removeObject:deleteModal];
    }
    [ManagerCtl getRoleInfo].selectProductArr = dataArr;
}

@end
