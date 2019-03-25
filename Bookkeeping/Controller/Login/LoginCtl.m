//
//  LoginCtl.m
//  EherEmployee
//
//  Created by Luoqw on 2018/1/3.
//  Copyright © 2018年 eher. All rights reserved.
//

#import "LoginCtl.h"
#import "ManagerCtl.h"

@interface LoginCtl () <UITextFieldDelegate>

{
    RequestCon          *loginCon;
    User_Modal          *loginModal;
}

@end

@implementation LoginCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self regNotification];
    }
    return self;
}

- (void)regNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideFrame:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:UITextFieldTextDidChangeNotification object:self.accountTf];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:UITextFieldTextDidChangeNotification object:self.pwdTf];
}

-(void) dealloc
{
    [self unregNotification];
}

- (void)unregNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.accountTf.delegate = self;
    self.pwdTf.delegate = self;
    
    //获取用户缓存
    loginModal = [ManagerCtl getUserNameForUserDefault];
    if (loginModal) {
        self.accountTf.text = loginModal.account;
        self.pwdTf.text = loginModal.password;
    }
    
    [self change:nil];

}

- (void)initUIShape
{
    CALayer *layer = self.accountView.layer;
    layer.cornerRadius = layer.bounds.size.height/2;
    
    layer = self.pwdView.layer;
    layer.cornerRadius = layer.bounds.size.height/2;
    
    layer = self.loginBtn.layer;
    layer.cornerRadius = layer.bounds.size.height/2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}

#pragma mark - Base

- (void)finishLoadData:(BaseRequest *)request dataArr:(NSArray *)dataArr
{
    if (request == loginCon) {
        User_Modal *modal = [dataArr firstObject];
        if ([modal.restCode isEqualToString:Request_OK] && [modal isKindOfClass:[User_Modal class]]) {
            modal.password = loginModal.password;
            [[ManagerCtl defaultManagerCtl] loginOK:self modal:modal];
            [BaseUIViewController showHUDSuccessView:@"登录成功" msg:nil];
        } else {
            [BaseUIViewController showAlertView:@"登录失败" msg:modal.restMsg?modal.restMsg:@"请稍后重试" cancel:@"知道了"];
        }
    }
}

-(void) viewClickResponse:(id)sender
{
    if( sender == self.loginBtn ){
        [self loginInfoVerification];
    }
}

#pragma mark - Login

- (void)loginInfoVerification {
    if( [self.accountTf.text length] == 0 ){
        [BaseUIViewController showAlertView:@"请输入您的账号" msg:nil cancel:@"知道了"];
        [self.accountTf becomeFirstResponder];
        return;
    }
    if( [self.pwdTf.text length] == 0 ){
        [BaseUIViewController showAlertView:@"请输入您的密码" msg:nil cancel:@"知道了"];
        [self.pwdTf becomeFirstResponder];
        return;
    }
    [self.accountTf resignFirstResponder];
    [self.pwdTf resignFirstResponder];
    
    
    loginModal = [[User_Modal alloc] init];
    loginModal.account = self.accountTf.text;
    loginModal.password = self.pwdTf.text;

    loginCon = [self getNewRequestCon:NO];
    [loginCon doLogin:loginModal.account pwd:loginModal.password];
}

-(void)change:(NSNotification *)mesg
{
    if ( [self.accountTf.text length] > 0 && [self.pwdTf.text length] > 0 ) {
        self.loginBtn.enabled = YES;
        [self.loginBtn setBackgroundColor:Color_Default];
    } else {
        self.loginBtn.enabled = NO;
        [self.loginBtn setBackgroundColor:[Common getColor:@"CCCCCC" alpha:0.8]];
    }
}

#pragma mark - notification handler
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    CGFloat yOffset = endKeyboardRect.size.height - logInView.frame.origin.y;
    CGPoint point = [self.loginView convertPoint:self.loginBtn.frame.origin toView:self.view];
    CGFloat h = self.view.bounds.size.height - point.y - self.loginBtn.bounds.size.height-2;
    CGRect rect = self.view.frame;
    
    if( endKeyboardRect.size.height-h > 0){
        rect.origin.y = h - endKeyboardRect.size.height;
    }
    [UIView animateWithDuration:duration animations:^{
        [self.view setFrame:rect];
    } completion:^(BOOL finished) {
        
    }];
}

-(void) keyboardDidHideFrame:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    [UIView animateWithDuration:duration animations:^{
        [self.view setFrame:rect];
    } completion:^(BOOL finished) {
        
    }];
    
}

#pragma UITextFieldDelegate
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    if( textField == self.accountTf ){
        [self.pwdTf becomeFirstResponder];
    }else{
        [textField resignFirstResponder];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.accountTf) {
        NSMutableString *inputName = [NSMutableString stringWithString:self.accountTf.text];
        [inputName replaceCharactersInRange:range withString:string];
        if ([inputName isEqualToString:@""]) {
            self.pwdTf.text = @"";
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.pwdTf.text = @"";
    return YES;
}

@end
