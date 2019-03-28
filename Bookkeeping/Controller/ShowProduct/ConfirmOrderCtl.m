//
//  ConfirmOrderCtl.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/12.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "ConfirmOrderCtl.h"
#import "ChooseStandardCell.h"
#import "ChoosePayCtl.h"
#import "ChooseCustomerCtl.h"
#import "Product_Modal.h"
#import "Standard_Modal.h"
#import "UIImageView+WebCache.h"
#import "Order_Model.h"
#import "ManagerCtl.h"
#import "ShopCarHeaderView.h"
#import "PrintTool.h"
#import "ShopCarCtl.h"

@interface ConfirmOrderCtl () <UITextFieldDelegate>

{
    int  sourceType;   //1为立即购买，2为购物车
    Base_Modal *payModel;
    Customer_Modal *customerModel;
    NSMutableArray  *selectArr;
    double    totalAmount;
    double    realAmount;
    int       totalCount;
    RequestCon *confirmCon;
    RequestCon *detailCon;
}

@property (weak, nonatomic) IBOutlet UIButton *customerBtn;
@property (weak, nonatomic) IBOutlet UITextField *realAmoutTf;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalAmoutLb;
@property (weak, nonatomic) IBOutlet UILabel *totalInfoLb;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation ConfirmOrderCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"下单";
        bHeadRefresh_ = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([ChooseStandardCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([ChooseStandardCell class])];
    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([ShopCarHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:NSStringFromClass([ShopCarHeaderView class])];
    self.realAmoutTf.delegate = self;
    [self updateDetailInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Base
- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    if ([dataModal isKindOfClass:[Product_Modal class]]) {
        selectArr = [NSMutableArray arrayWithObject:dataModal];
        sourceType = 1;
    }
    if ([exParam isKindOfClass:[NSArray class]]) {
        selectArr = [NSMutableArray arrayWithArray:exParam];
        sourceType = 2;
    }
    [self updateDetailInfo];
}

- (void)finishLoadData:(BaseRequest *)request dataArr:(NSArray *)dataArr
{
    if (request == confirmCon) {
        Base_Modal *modal = [dataArr firstObject];
        if ([modal.restCode isEqualToString:Request_OK]) {
            [BaseUIViewController showHUDSuccessView:@"下单成功" msg:nil];
            detailCon = [self getNewRequestCon:NO];
            [detailCon queryOrderDetail:modal.id_];
            if (sourceType == 2) {
                [ShopCarCtl removeProductArr:selectArr];
            }
        } else {
            [BaseUIViewController showAlertView:@"下单失败" msg:modal.restMsg?modal.restMsg:@"请稍后重试" cancel:@"知道了"];
        }
    }else if (request == detailCon) {
        [self.navigationController popViewControllerAnimated:YES];
        Order_Model *detailModel = dataArr.firstObject;
        [[PrintTool sharedManager] printOrderInfo:detailModel];
    }
}

- (void)viewClickResponse:(id)sender
{
    if (sender == self.customerBtn) {
        [self chooseCustomer:sender];
    } else if (sender == self.payBtn) {
        [self choosePayType:sender];
    } else if (sender == self.confirmBtn) {
        if (!payModel) {
            [BaseUIViewController showAlertView:@"未选择支付方式" msg:@"请选择支付方式" cancel:@"知道了"];
            return;
        }
        double realPrice = [self.realAmoutTf.text doubleValue];
        if (realPrice > totalAmount+0.001) {
            [BaseUIViewController showAlertView:@"实付金额大于应付金额" msg:@"请重新输入实付金额" cancel:@"知道了"];
            return;
        }
        if (realPrice > totalAmount-0.001 && realPrice < totalAmount+0.001) {
            [self showChooseAlertViewCtl:@"确定下单" msg:nil confirmHandle:^{
                [self confirmOrderInfo:[payModel.code isEqualToString:@"4"]?OrderStatus_WaitPay:OrderStatus_Complete];
            }];
        } else {
            NSString *title = [NSString stringWithFormat:@"应付金额：¥%.2lf\n实付金额：¥%.2f", totalAmount, [self.realAmoutTf.text doubleValue]];
            NSString *msg = @"确认支付完成？";
            UIAlertController *alertCtl =
            [UIAlertController alertControllerWithTitle:title
                                                message:msg
                                         preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *confirmAction =
            [UIAlertAction actionWithTitle:@"支付完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                [self confirmOrderInfo:OrderStatus_Complete];
            }];
            [alertCtl addAction:confirmAction];
            
            if (customerModel.id_.length>0) {
                UIAlertAction *notConfirmAction =
                [UIAlertAction actionWithTitle:@"支付未完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
                    [self confirmOrderInfo:OrderStatus_Incomplete];
                }];
                [alertCtl addAction:notConfirmAction];
            }
            UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
            [alertCtl addAction:cancleAction];
            [self presentViewController:alertCtl animated:YES completion:nil];
        }
        
    }
}

#pragma mark - Private

- (void)updateDetailInfo
{
    [self.tableView_ reloadData];
    [self updateTotalPriceInfo];
}

- (void)updateTotalPriceInfo
{
    double totalPrice = 0;
    int count = 0;
    for (Product_Modal *modal in selectArr) {
        for (Standard_Modal *typeModel in modal.typeArr) {
            count += typeModel.saleCount;
            totalPrice += typeModel.realPrice*typeModel.saleCount;
        }
    }
    totalAmount = totalPrice;
    totalCount = count;
    self.totalAmoutLb.text = [NSString stringWithFormat:@"¥%.2lf", totalAmount];
    self.totalInfoLb.text = [NSString stringWithFormat:@"共%ld种%d件商品", selectArr.count, count];
}

- (void)confirmOrderInfo:(OrderStatus)status
{
    Order_Model *modal = [Order_Model new];
    modal.oporaterId = [ManagerCtl getRoleInfo].id_;
    modal.companyId = [ManagerCtl getRoleInfo].companyId;
    modal.customerModal = customerModel;
    modal.orderPrice = totalAmount;
    modal.realPrice = [self.realAmoutTf.text doubleValue];
    modal.payTypeCode = payModel.code;
    modal.orderStatus = status;
    modal.saleCount = totalCount;
    modal.productTypeArr = selectArr;
    confirmCon = [self getNewRequestCon:NO];
    [confirmCon confirmOrder:modal];
}

- (void)chooseCustomer:(UIButton *)sender
{
    ChooseCustomerCtl *ctl = [[ChooseCustomerCtl alloc] initWithFinish:^(Customer_Modal *model) {
        customerModel = model;
        [sender setTitle:model.name forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)choosePayType:(UIButton *)sender
{
    ChoosePayCtl *ctl = [ChoosePayCtl start:self.view finished:^(Base_Modal *model) {
        payModel = model;
        [sender setTitle:model.name forState:UIControlStateNormal];
    }];
    [self addChildViewController:ctl];
}

- (void)modifyPrice:(NSIndexPath *)indexPath
{
    [self showTextAlert:UIKeyboardTypeDecimalPad title:@"修改单价" msg:nil placeholder:@"请输入价格" confirmHandle:^(NSString *text) {
        Product_Modal *modal = selectArr[indexPath.section];
        Standard_Modal *typeModel = modal.typeArr[indexPath.row];
        typeModel.realPrice = [text doubleValue];
        [self.tableView_ reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self updateTotalPriceInfo];
    }];
}
#pragma mark - UITableView

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return selectArr.count;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Product_Modal *modal = selectArr[section];
    return modal.typeArr.count;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ShopCarHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([ShopCarHeaderView class])];
    
    headView.widthCons.constant = 0;
    Product_Modal *modal = selectArr[section];
    headView.titleLb.text = modal.name;
    [headView.iconImgView sd_setImageWithURL:[NSURL URLWithString:modal.imgUrl]];
    
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
    itemCell.widthCons.constant = 0;
    Product_Modal *modal = selectArr[indexPath.section];
    Standard_Modal *typeModel = modal.typeArr[indexPath.row];
    
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

@end
