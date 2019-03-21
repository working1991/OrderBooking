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

@interface ConfirmOrderCtl () <UITextFieldDelegate>

{
    Base_Modal *payModel;
    Product_Modal *productModel;
    Customer_Modal *customerModel;
    NSMutableArray  *selectArr;
    double    totalAmount;
    double    realAmount;
    int       totalCount;
    RequestCon *confirmCon;
}

@property (weak, nonatomic) IBOutlet UIButton *customerBtn;
@property (weak, nonatomic) IBOutlet UITextField *realAmoutTf;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet UILabel *classLb;
@property (weak, nonatomic) IBOutlet UILabel *totalNumLb;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
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
    productModel = dataModal;
    [self updateDetailInfo];
}

- (void)finishLoadData:(BaseRequest *)request dataArr:(NSArray *)dataArr
{
    if (request == confirmCon) {
        Base_Modal *modal = [dataArr firstObject];
        if ([modal.restCode isEqualToString:Request_OK]) {
            [BaseUIViewController showHUDSuccessView:@"下单成功" msg:nil];
        } else {
            [BaseUIViewController showAlertView:@"下单失败" msg:modal.restMsg?modal.restMsg:@"请稍后重试" cancel:@"知道了"];
        }
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
    if (!productModel) {
        return;
    }
    self.nameLb.text = productModel.name;
    [self.iconImgView sd_setImageWithURL:[NSURL URLWithString:productModel.imgUrl]];
    
    selectArr = [NSMutableArray array];
    double amount = 0;
    int count = 0;
    for (NSInteger i=0; i<productModel.typeArr.count; i++) {
        Standard_Modal *model = productModel.typeArr[i];
        if (model.saleCount <= 0) {
            continue;
        }
        count += model.saleCount;
        amount += model.productSpecPrice * model.saleCount;
        [selectArr addObject:model];
    }
    
    totalAmount = amount;
    totalCount = count;
    self.classLb.text = [NSString stringWithFormat:@"%ld种商品", selectArr.count];
    self.totalNumLb.text = [NSString stringWithFormat:@"共%d件商品", count];
    self.totalAmoutLb.text = [NSString stringWithFormat:@"¥%.2lf", totalAmount];
    self.totalInfoLb.text = [NSString stringWithFormat:@"共%ld种%d件商品", selectArr.count, count];
    [self.tableView_ reloadData];
}

- (void)updateTotalInfo
{
    double amount = 0;
    int count = 0;
    for (NSInteger i=0; i<selectArr.count; i++) {
        Standard_Modal *model = selectArr[i];
        count += model.saleCount;
        amount += model.productSpecPrice * model.saleCount;
    }
    
    totalAmount = amount;
    totalCount = count;
    self.totalNumLb.text = [NSString stringWithFormat:@"共%d件商品", count];
    self.totalAmoutLb.text = [NSString stringWithFormat:@"¥%.2lf", totalAmount];
    self.totalInfoLb.text = [NSString stringWithFormat:@"共%ld种%d件商品", selectArr.count, count];
}

- (void)confirmOrderInfo:(OrderStatus)status
{
    Order_Model *modal = [Order_Model new];
    modal.oporaterId = [ManagerCtl getRoleInfo].id_;
    modal.companyId = [ManagerCtl getRoleInfo].companyId;
    modal.productId = productModel.id_;
    modal.customerId = customerModel.id_;
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

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return selectArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseStandardCell *myCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChooseStandardCell class]) forIndexPath:indexPath];
    
    
    Standard_Modal *model = selectArr[indexPath.row];
    myCell.nameLb.text = [NSString stringWithFormat:@"尺码：%@（%@）", model.secondSpecName, model.firstSpecName];
    myCell.originalPriceLb.hidden = YES;
    myCell.priceLb.text = [NSString stringWithFormat:@"¥%.2lf元/件", model.productSpecPrice];
    [myCell updateNum:model.saleCount];
    myCell.numChange = ^(int currentNum) {
        model.saleCount = currentNum;
        [self updateTotalInfo];
    };
    
    return myCell;
}

@end
