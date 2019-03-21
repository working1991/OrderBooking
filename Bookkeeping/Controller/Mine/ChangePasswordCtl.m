//
//  ChangePasswordCtl.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/11.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "ChangePasswordCtl.h"
#import "ManagerCtl.h"

@interface ChangePasswordCtl ()
{
    RequestCon *saveCon;
}

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTf;
@property (weak, nonatomic) IBOutlet UITextField *firstPasswordTf;
@property (weak, nonatomic) IBOutlet UITextField *secondPasswordTf;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;

@end

@implementation ChangePasswordCtl

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)finishLoadData:(BaseRequest *)request dataArr:(NSArray *)dataArr
{
    if (request == saveCon) {
        Base_Modal *modal = [dataArr firstObject];
        if ([modal.restCode isEqualToString:Request_OK]) {
            [BaseUIViewController showHUDSuccessView:@"修改成功" msg:nil];
            [[ManagerCtl defaultManagerCtl] loginOff];
        } else {
            [BaseUIViewController showAlertView:@"修改失败" msg:modal.restMsg?modal.restMsg:@"请稍后重试" cancel:@"知道了"];
        }
    }
}

- (void)viewClickResponse:(id)sender
{
    if (sender == self.saveBtn) {
        if (self.oldPasswordTf.text.length==0) {
            [BaseUIViewController showAlertView:@"请输入旧密码" msg:nil cancel:@"知道了"];
            return;
        }else if (self.firstPasswordTf.text.length==0) {
            [BaseUIViewController showAlertView:@"请输入新密码" msg:nil cancel:@"知道了"];
            return;
        } else if (![self.firstPasswordTf.text isEqualToString:self.secondPasswordTf.text]) {
            [BaseUIViewController showAlertView:@"两次密码不一致" msg:@"请重新输入" cancel:@"知道了"];
            return;
        } else  {
            saveCon = [self getNewRequestCon:NO];
            [saveCon modifyPassword:[ManagerCtl getRoleInfo].account oldPassword:self.oldPasswordTf.text newPassword:self.firstPasswordTf.text];
        }
    }
}

@end
