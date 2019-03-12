//
//  LoginCtl.h
//  EherEmployee
//
//  Created by Luoqw on 2018/1/3.
//  Copyright © 2018年 eher. All rights reserved.
//

#import "BaseUIViewController.h"

@interface LoginCtl : BaseUIViewController

@property (weak, nonatomic) IBOutlet UIView             *loginView;
@property (weak, nonatomic) IBOutlet UIView             *accountView;
@property (weak, nonatomic) IBOutlet UIView             *pwdView;
@property (weak, nonatomic) IBOutlet UITextField        *accountTf;
@property (weak, nonatomic) IBOutlet UITextField        *pwdTf;
@property (weak, nonatomic) IBOutlet UIButton           *loginBtn;
@property (weak, nonatomic) IBOutlet UILabel            *versionLb;


@end
