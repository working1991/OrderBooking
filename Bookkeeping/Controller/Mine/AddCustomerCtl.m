//
//  AddCustomerCtl.m
//  XZD
//
//  Created by sysweal on 15/5/19.
//  Copyright (c) 2015年 sysweal. All rights reserved.
//

#import "AddCustomerCtl.h"
#import "ManagerCtl.h"


@interface AddCustomerCtl () <UITextFieldDelegate>
{
    SexType sexType;
    RequestCon *addCon;
}


@property (nonatomic, strong) Customer_Modal        *addCusModal;

@end

@implementation AddCustomerCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"新增客户";
        rightBarStr_ = @"保存";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    self.nameTf.delegate = self;
    self.nameTf.tintColor = Color_Default;
    self.phoneTf.tintColor = Color_Default;
    self.phoneTf.keyboardType = UIKeyboardTypePhonePad;
    self.phoneTf.delegate = self;
    self.addressTf.tintColor = Color_Default;
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    self.navigationItem.rightBarButtonItem.tintColor = Color_Default;
    
    self.sexSeg.selectedSegmentIndex = 0;
    sexType = self.sexSeg.selectedSegmentIndex==0;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Base

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    
}

- (void)requestFinish:(BaseRequest *)request dataArr:(NSArray *)dataArr
{
    [super requestFinish:request dataArr:dataArr];
    if (request == addCon) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.tintColor = Color_Default;
    }
}

- (void)requestFail:(BaseRequest *)request code:(BaseErrorCode)code
{
    [super requestFail:request code:code];
    if (request == addCon) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.rightBarButtonItem.tintColor = Color_Default;
    }
}

-(void) finishLoadData:(BaseRequest *)request dataArr:(NSArray *)dataArr
{
    [super finishLoadData:request dataArr:dataArr];
    
    if( addCon == request ){
        Customer_Modal *dataModal = [dataArr objectAtIndex:0];
        
        if( [dataModal.restCode isEqualToString:Request_OK] ){
            [BaseUIViewController showHUDSuccessView:@"保存成功" msg:nil];
            self.addCusModal.id_ = dataModal.id_;
            if ( self.finished ) {
                self.finished(self.addCusModal);
            }
            [self.navigationController popToViewController:self.navigationController.viewControllers.firstObject animated:YES];
        }
        else if( dataModal.restMsg ){
            [BaseUIViewController showAlertView:@"保存失败" msg:dataModal.restMsg cancel:@"确定"];
        }
        else{
            [BaseUIViewController showAlertView:@"保存失败" msg:@"请稍候再试" cancel:NSLocalizedString(@"确定", nil)];
        }
    }
}

-(void) rightBarBtnResponse:(id)sender
{
    [self save];
}

-(void) viewClickResponse:(id)sender
{
    [self.view endEditing:YES];
    if (sender == self.sexSeg) {
        sexType = self.sexSeg.selectedSegmentIndex==0;
    }
}

#pragma mark - Private


-(void) save
{
    [self.view endEditing:YES];
    if( [self.nameTf.text isEqualToString:@""] ){
        [BaseUIViewController showAlertView:@"客户姓名不能为空" msg:nil cancel:@"确定"];
    }
    else if(self.phoneTf.text.length > 0  &&  (self.phoneTf.text.length != 11)){
        [BaseUIViewController showAlertView:@"推荐人手机号码格式错误" msg:@"请重新输入" cancel:@"确定"];
    }
    else {
        Customer_Modal *dataModal = [[Customer_Modal alloc] init];
        dataModal.name = self.nameTf.text;

        
        dataModal.telphone = self.phoneTf.text;
  
        self.addCusModal = dataModal;
        addCon = [self getNewRequestCon:NO];
//        [addCon addMemberCustomer:dataModal];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.navigationItem.rightBarButtonItem.tintColor = [Common getColor:@"999999"];
    }
}

#pragma mark - Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneTf || textField == self.phoneTf) {
        NSScanner      *scanner = [NSScanner scannerWithString:string];
        NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        NSString *buffer;
        if ( ![scanner scanCharactersFromSet:numbers intoString:&buffer] && ([string length] != 0) ){
            return NO;
        }
        if (textField.text.length >= 11 && string.length > 0) {
            return NO;
        }
    }
    return YES;
}


#pragma mark - Public

//start
+(void) start:(void(^)(Customer_Modal *))finished
{
    AddCustomerCtl *ctl = [[AddCustomerCtl alloc] init];
    ctl.finished = finished;

    [[ManagerCtl getCurrentNav] pushViewController:ctl animated:YES];
}

+(void) startWithWechatUser:(NSString *)wechatUser finished:(void(^)(Customer_Modal *))finished
{
    AddCustomerCtl *ctl = [[AddCustomerCtl alloc] init];
    ctl.finished = finished;
    [ctl beginLoad:wechatUser exParam:nil];
    [[ManagerCtl getCurrentNav] pushViewController:ctl animated:YES];
}

@end

