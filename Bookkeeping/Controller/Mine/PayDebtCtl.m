//
//  PayDebtCtl.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/4/30.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "PayDebtCtl.h"
#import "ManagerCtl.h"
#import "ChoosePayCtl.h"

@interface PayDebtCtl ()<UITextFieldDelegate>

{
    Base_Modal *payModel;
    Customer_Modal *customerModel;
    double    payAmount;
    RequestCon *confirmCon;
}

@property (weak, nonatomic) IBOutlet UIButton *customerBtn;
@property (weak, nonatomic) IBOutlet UITextField *payAmoutTf;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation PayDebtCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"还款";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.payAmoutTf.delegate = self;
    self.payAmoutTf.placeholder = [NSString stringWithFormat:@"欠款金额：¥%.2lf", customerModel.debtAmount];
    [self updateDetailInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Base
- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    if ([dataModal isKindOfClass:[Customer_Modal class]]) {
        customerModel = dataModal;
    }
    
    [self updateDetailInfo];
}

- (void)finishLoadData:(BaseRequest *)request dataArr:(NSArray *)dataArr
{
    if (request == confirmCon) {
        Base_Modal *modal = [dataArr firstObject];
        if ([modal.restCode isEqualToString:Request_OK]) {
            [BaseUIViewController showHUDSuccessView:@"还款成功" msg:nil];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [BaseUIViewController showAlertView:@"还款失败" msg:modal.restMsg?modal.restMsg:@"请稍后重试" cancel:@"知道了"];
        }
    }
}

- (void)viewClickResponse:(id)sender
{
    if (sender == self.payBtn) {
        [self choosePayType:sender];
    } else if (sender == self.confirmBtn) {
        if (!payModel) {
            [BaseUIViewController showAlertView:@"未选择支付方式" msg:@"请选择支付方式" cancel:@"知道了"];
            return;
        }
        double amount = [self.payAmoutTf.text doubleValue];
        if (amount > customerModel.debtAmount+0.001) {
            [BaseUIViewController showAlertView:@"还款金额大于欠款金额" msg:@"请重新输入还款金额" cancel:@"知道了"];
            return;
        } else if (amount < 0) {
            [BaseUIViewController showAlertView:@"还款金额大于欠款金额" msg:@"请重新输入还款金额" cancel:@"知道了"];
            return;
        }
        
        NSString *title = [NSString stringWithFormat:@"还款金额：¥%.2lf", [self.payAmoutTf.text doubleValue]];
        NSString *msg = @"确认还款完成？";
        
        
        UIAlertController *alertCtl =
        [UIAlertController alertControllerWithTitle:title
                                            message:msg
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertCtl addAction:cancleAction];
        UIAlertAction *confirmAction =
        [UIAlertAction actionWithTitle:@"还款完成" style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
            [self confirmOrderInfo:OrderStatus_Complete];
        }];
        [alertCtl addAction:confirmAction];
        
        
        [self presentViewController:alertCtl animated:YES completion:nil];
    }
        
    
}

#pragma mark - Private

- (void)updateDetailInfo
{
    [self.customerBtn setTitle:customerModel.name forState:UIControlStateNormal];
}

- (void)confirmOrderInfo:(OrderStatus)status
{
    Order_Model *modal = [Order_Model new];
    modal.oporaterId = [ManagerCtl getRoleInfo].id_;
    modal.companyId = [ManagerCtl getRoleInfo].companyId;
    modal.customerModal = customerModel;
    modal.orderPrice = [self.payAmoutTf.text doubleValue];
    modal.payTypeCode = payModel.code;

    confirmCon = [self getNewRequestCon:NO];
    [confirmCon confirmRefund:modal];
}

- (void)choosePayType:(UIButton *)sender
{
    ChoosePayCtl *ctl = [ChoosePayCtl startRefundPayType:self.view finished:^(Base_Modal *model) {
        payModel = model;
        [sender setTitle:model.name forState:UIControlStateNormal];
    }];
    [self addChildViewController:ctl];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [Common onlyInputNumber:textField shouldChangeCharactersInRange:range replacementString:string decimalDigits:2];
}

@end
