//
//  BaseUIViewController.m
//  XZD
//
//  Created by sysweal on 14/11/14.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <objc/runtime.h>
#import "BaseUIViewController.h"

@interface BaseUIViewController ()

{
    BOOL    bhaveNavBackItem;
}

@end

@implementation BaseUIViewController

@synthesize backBtn_, navImgView_, navView_, barTitleLb_, searchKeyBar,
searchButton;

+ (void)load {
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE_8_0
    /*
     Method originMethod = class_getInstanceMethod(
     [self class],
     @selector(showChooseAlertView:title:msg:okBtnTitle:cancelBtnTitle:));
     Method replaceMethod = class_getInstanceMethod(
     [self class],
     @selector(showChooseAlertViewCtl:title:msg:okBtnTitle:cancelBtnTitle:));
     
     static dispatch_once_t onceToken;
     dispatch_once(&onceToken, ^{
     BOOL isAdd = class_addMethod(
     self,
     @selector(showChooseAlertView:title:msg:okBtnTitle:cancelBtnTitle:),
     method_getImplementation(replaceMethod),
     method_getTypeEncoding(replaceMethod));
     if (isAdd) {
     class_replaceMethod(self, @selector(showChooseAlertViewCtl:
     title:
     msg:
     okBtnTitle:
     cancelBtnTitle:),
     method_getImplementation(replaceMethod),
     method_getTypeEncoding(originMethod));
     } else {
     method_exchangeImplementations(originMethod, replaceMethod);
     }
     
     });
     */
#endif
}

//显示AlertView
+ (void)showAlertView:(NSString *)title
                  msg:(NSString *)msg
               cancel:(NSString *)cancel {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:cancel
                                          otherButtonTitles:nil, nil];
    [alert show];
}

//显示HUD
+ (void)showHUDView:(NSString *)title status:(NSString *)status {
    [[MMProgressHUD sharedHUD] killDismissDelayTimer];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:title status:status];
}

//自动消失的操作成功视图
+ (void)showHUDSuccessView:(NSString *)title msg:(NSString *)msg {
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [MMProgressHUD dismissWithSuccess:msg title:title afterDelay:1.1];
}

//自动消失的操作成功视图(自定义消失时间)
+ (void)showHUDSuccessView:(NSString *)title msg:(NSString *)msg delayTime:(NSInteger)delayTime {
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [MMProgressHUD dismissWithSuccess:msg title:title afterDelay:delayTime];
}

//自动消息的操作失败视图
+ (void)showHUDFailView:(NSString *)title msg:(NSString *)msg {
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleShrink];
    [MMProgressHUD showWithTitle:@"" status:@""];
    [MMProgressHUD dismissWithError:msg title:title afterDelay:1.1];
}

//隐藏HUD
+ (void)hideHUDView {
    //[[[UIApplication sharedApplication].windows lastObject] showHUDWithText:nil
    // Type:ShowDismiss Enabled:YES];
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleNone];
    [MMProgressHUD dismissAfterDelay:0.1];
}

//用于处理插放界面的btn,index
int tmpProcessPlayerControlViewIndex;
//处理插放视图中的控制视图
+ (void)processPlayControlView:(UIView *)view {
    for (UIView *subView in [view subviews]) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subView;
            
            if (tmpProcessPlayerControlViewIndex == 0) {
                // btn.alpha = 0.0;
            } else if (tmpProcessPlayerControlViewIndex == 1) {
                btn.alpha = 0.0;
            } else if (tmpProcessPlayerControlViewIndex == 2) {
                btn.alpha = 0.0;
            } else if (tmpProcessPlayerControlViewIndex == 3) {
                // btn.alpha = 0.0;
            }
            
            ++tmpProcessPlayerControlViewIndex;
        } else {
            [self processPlayControlView:subView];
        }
    }
}

- (void)viewDidLoad {
    bgTopMore_ = 0;
    bhaveNavBackItem = NO;
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.edgesForExtendedLayout = UIRectEdgeNone;
    bSearch = NO;
    
    barTitleLb_.text = self.title;
    navImgView_.backgroundColor = [UIColor colorWithRed:163.0 / 255
                                                  green:86.0 / 255
                                                   blue:142.0 / 255
                                                  alpha:1.0];
    
    if (leftBarStr_) {
        UIBarButtonItem *leftBarItem =
        [[UIBarButtonItem alloc] initWithTitle:leftBarStr_
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(leftBarBtnResponse:)];
        self.navigationItem.leftBarButtonItem = leftBarItem;
    }
    if (rightBarStr_) {
        UIBarButtonItem *rightBarItem =
        [[UIBarButtonItem alloc] initWithTitle:rightBarStr_
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(rightBarBtnResponse:)];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    if (leftBarImg_) {
        UIBarButtonItem *leftBarItem =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:leftBarImg_]
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(leftBarBtnResponse:)];
        self.navigationItem.leftBarButtonItem = leftBarItem;
    }
    if (rightBarImg_) {
        UIBarButtonItem *rightBarItem =
        [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:rightBarImg_]
                                         style:UIBarButtonItemStylePlain
                                        target:self
                                        action:@selector(rightBarBtnResponse:)];
        self.navigationItem.rightBarButtonItem = rightBarItem;
    }
    
    //设置背景
    [self setBG];
    
    [self initMyNavView:navView_ bChangeHight:YES];
    
    if (navImgView_ || navView_) {
        [self initMyNavView:navImgView_ bChangeHight:NO];
        
        barTitleLb_.textColor =
        [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0];
        
        NSLayoutConstraint *leftConstrait =
        [self findViewLeftConstraint:navImgView_ ? navImgView_ : navView_
                                view:backBtn_];
        leftConstrait.constant = 0;
        // date:2015-12-1 wy 设置返回按扭属性
        [self setBackBtnAtt];
    }
    
    //搜索
    if (searchKeyBar) {
        searchKeyBar.delegate = self;
        searchKeyBar.tintColor = Color_Default;
//        searchKeyBar.showsBookmarkButton = YES;
        searchKeyBar.showsCancelButton = NO;
//        [searchKeyBar setImage:[UIImage imageNamed:@"voice_mic"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    }
    
    [self initTextXib];
    [self initUIShape];
}

-(void) setBackItem
{
    if (bhaveNavBackItem) {
        return;
    }
    if ( !leftBarImg_ && !leftBarStr_ && self.navigationController.viewControllers.count >= 2) {
        UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"top_back_return"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnResponse:)];
        self.navigationItem.leftBarButtonItem = backBarItem;
        bhaveNavBackItem = YES;
    }
}

//初始化UI
- (void)initUIShape
{
    
}

- (void)initTextXib
{
    
}

//设置返回按扭属性
- (void)setBackBtnAtt {
    if (backBtn_) {
        if ([backBtn_ backgroundImageForState:UIControlStateNormal]) {
            [backBtn_ setBackgroundImage:nil forState:UIControlStateNormal];
        }
        [backBtn_ setImage:[UIImage imageNamed:@"back_black"]
                  forState:UIControlStateNormal];
        [backBtn_ setTintColor:[Common getColor:@"666666"]];
    }
    if (_haveBackBtn) {
        if(navView_) {
            NSLayoutConstraint *leadingLc = [self findViewLeadingConstraintOfNavView];
            if (leadingLc && !backBtn_) {
                leadingLc.constant = leadingLc.constant + 70;
            }
            UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [backBtn setImage:[UIImage imageNamed:@"back_black"] forState:UIControlStateNormal];
            [backBtn addTarget:self action:@selector(backBtnResponse:) forControlEvents:UIControlEventTouchUpInside];
            [navView_ addSubview:backBtn];
            backBtn.translatesAutoresizingMaskIntoConstraints = NO;
            [navView_ addConstraint:[NSLayoutConstraint
                                     constraintWithItem:backBtn
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:navView_
                                     attribute:NSLayoutAttributeLeft
                                     multiplier:1
                                     constant:0]];
            [navView_ addConstraint:[NSLayoutConstraint
                                     constraintWithItem:backBtn
                                     attribute:NSLayoutAttributeTop
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:navView_
                                     attribute:NSLayoutAttributeTop
                                     multiplier:1
                                     constant:25]];
            [navView_ addConstraint:[NSLayoutConstraint
                                     constraintWithItem:backBtn
                                     attribute:NSLayoutAttributeWidth
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1.0
                                     constant:70]];
            [navView_ addConstraint:[NSLayoutConstraint
                                     constraintWithItem:backBtn
                                     attribute:NSLayoutAttributeHeight
                                     relatedBy:NSLayoutRelationEqual
                                     toItem:nil
                                     attribute:NSLayoutAttributeNotAnAttribute
                                     multiplier:1.0
                                     constant:42]];
            
        }
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [MyLog Log:@"dealloc" obj:self];
    [requestCon_ clear];
}

//查找navView leadingConstraint
- (NSLayoutConstraint *)findViewLeadingConstraintOfNavView {
    if (!self.navView_) {
        return nil;
    }
    NSLayoutConstraint *leadingLc = nil;
    
    for (NSLayoutConstraint *constraint in self.navView_.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeLeading) {
            leadingLc = constraint;
            break;
        }
    }
    return leadingLc;
}

//查找WidthConstraint
- (NSLayoutConstraint *)findViewWidthConstraintWithView:(UIView *)view {
    NSLayoutConstraint *WidthLC = nil;
    for (NSLayoutConstraint *constraint in view.constraints) {
        if (constraint.firstAttribute == NSLayoutAttributeWidth) {
            WidthLC = constraint;
            break;
        }
    }
    return WidthLC;
}

//查找HeightConstraint
- (NSLayoutConstraint *)findViewHeightConstraint:(UIView *)superView
                                            view:(UIView *)view {
    NSLayoutConstraint *HightLC = nil;
    for (NSLayoutConstraint *constraint in superView.constraints) {
        if (constraint.firstItem == view &&
            constraint.firstAttribute == NSLayoutAttributeHeight) {
            HightLC = constraint;
            break;
        }
    }
    
    return HightLC;
}

//查找leftConstraint
- (NSLayoutConstraint *)findViewLeftConstraint:(UIView *)superView
                                          view:(UIView *)view {
    NSLayoutConstraint *leftLC = nil;
    for (NSLayoutConstraint *constraint in superView.constraints) {
        if (constraint.firstItem == view &&
            constraint.firstAttribute == NSLayoutAttributeLeft) {
            leftLC = constraint;
            break;
        }
    }
    return leftLC;
}

- (void)initMyNavView:(UIView *)v bChangeHight:(BOOL)bChangeHight {
    if (v) {
        v.backgroundColor = Color_Background_Default;
        
        UIImageView *lineV = [UIImageView new];
        lineV.translatesAutoresizingMaskIntoConstraints = NO;
        lineV.backgroundColor = [UIColor clearColor];
        lineV.image = [UIImage imageNamed:@"nav_bottom_line"];
        [v addSubview:lineV];
        
        if (bChangeHight) [self findViewHeightConstraint:v view:v].constant = 64;
        
        [v addConstraint:[NSLayoutConstraint
                          constraintWithItem:lineV
                          attribute:NSLayoutAttributeLeft
                          relatedBy:NSLayoutRelationEqual
                          toItem:v
                          attribute:NSLayoutAttributeLeft
                          multiplier:1
                          constant:0]];
        [v addConstraint:[NSLayoutConstraint
                          constraintWithItem:lineV
                          attribute:NSLayoutAttributeBottom
                          relatedBy:NSLayoutRelationEqual
                          toItem:v
                          attribute:NSLayoutAttributeBottom
                          multiplier:1
                          constant:0]];
        [v addConstraint:[NSLayoutConstraint
                          constraintWithItem:lineV
                          attribute:NSLayoutAttributeWidth
                          relatedBy:NSLayoutRelationEqual
                          toItem:v
                          attribute:NSLayoutAttributeWidth
                          multiplier:1
                          constant:0]];
        [v addConstraint:[NSLayoutConstraint
                          constraintWithItem:lineV
                          attribute:NSLayoutAttributeHeight
                          relatedBy:NSLayoutRelationEqual
                          toItem:nil
                          attribute:NSLayoutAttributeNotAnAttribute
                          multiplier:0
                          constant:1]];
    }
}

#pragma mark alertView delegate

- (void)showChooseAlertViewCtl:(NSString *)title msg:(NSString *)msg confirmHandle:(void(^)(void))confirmBlock
{
    [self showChooseAlertViewCtl:title msg:msg okBtnTitle:@"确定   " cancelBtnTitle:@"取消" confirmHandle:confirmBlock cancleHandle:nil];
}

- (void)showChooseAlertViewCtl:(NSString *)title msg:(NSString *)msg
                    okBtnTitle:(NSString *)okBtnTitle
                cancelBtnTitle:(NSString *)cancelBtnTitle
                 confirmHandle:(void(^)(void))confirmBlock
                  cancleHandle:(void(^)(void))cancleBlock {
    UIAlertController *alertCtl =
    [UIAlertController alertControllerWithTitle:title
                                        message:msg
                                 preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction =
    [UIAlertAction actionWithTitle:okBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
       [MyLog Log:[NSString stringWithFormat:@"Alert View Choosed Confirm."] obj:self];
       if (confirmBlock) {
           confirmBlock();
       }
       
   }];
    
    UIAlertAction *cancleAction =
    [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [MyLog Log:[NSString stringWithFormat:@"Alert View Choosed Cancel."] obj:self];
       if (cancleBlock) {
           cancleBlock();
       }
       
   }];
    
    [alertCtl addAction:confirmAction];
    [alertCtl addAction:cancleAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

//显示AlertViewCtl
- (void)showAlertViewCtl:(NSString *)title msg:(NSString *)msg cancel:(NSString *)cancel cancleHandle:(void(^)(void))cancleBlock
{
    
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:cancel style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        if (cancleBlock) {
            cancleBlock();
        }
    }];
    [alertCtl addAction:confirmAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
}

-(void)showTextAlert:(UIKeyboardType)keyboardType title:(NSString *)title msg:(NSString *)msg placeholder:(NSString *)placeholder confirmHandle:(void(^)(NSString *))confirmBlock {
    [self showTextAlert:keyboardType title:title msg:msg placeholder:placeholder  okBtnTitle:@"确定" cancelBtnTitle:@"取消" confirmHandle:confirmBlock cancleHandle:nil];
}

-(void)showTextAlert:(UIKeyboardType)keyboardType title:(NSString *)title msg:(NSString *)msg placeholder:(NSString *)placeholder
          okBtnTitle:(NSString *)okBtnTitle
      cancelBtnTitle:(NSString *)cancelBtnTitle
       confirmHandle:(void(^)(NSString *))confirmBlock
        cancleHandle:(void(^)(void))cancleBlock
{
    UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField *inputField = [UITextField new];
    [alertCtl addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = placeholder;
        textField.keyboardType = keyboardType;
        textField.textAlignment = NSTextAlignmentCenter;
        
        inputField = textField;
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:okBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        [inputField resignFirstResponder];
        if (confirmBlock) {
            confirmBlock(inputField.text);
        }
        [MyLog Log:[NSString stringWithFormat:@"Alert View Choosed Confirm."] obj:self];
    }];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *_Nonnull action) {
        if (cancleBlock) {
            cancleBlock();
        }
        [MyLog Log:[NSString stringWithFormat:@"Alert View Choosed Cancel."] obj:self];
    }];
    [alertCtl addAction:cancleAction];
    [alertCtl addAction:confirmAction];
    [self presentViewController:alertCtl animated:YES completion:nil];
    
}

//设置背景
- (void)setBG {
    NSString *bgName = [self getBGName];
    if (bgName && ![bgName isEqualToString:@""]) {
        switch (bgType_) {
            case BGType_Copy: {
                UIImage *img = [UIImage imageNamed:bgName];
                if (img)
                    self.view.backgroundColor = [UIColor colorWithPatternImage:img];
            } break;
            case BGType_Fill: {
                UIImageView *imgView =
                [[UIImageView alloc] initWithFrame:self.view.frame];
                imgView.translatesAutoresizingMaskIntoConstraints = NO;
                [imgView setImage:[UIImage imageNamed:bgName]];
                [self.view insertSubview:imgView atIndex:0];
                
                [self.view addConstraint:[NSLayoutConstraint
                                          constraintWithItem:imgView
                                          attribute:NSLayoutAttributeLeft
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.view
                                          attribute:NSLayoutAttributeLeft
                                          multiplier:1
                                          constant:0]];
                [self.view addConstraint:[NSLayoutConstraint
                                          constraintWithItem:imgView
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.view
                                          attribute:NSLayoutAttributeTop
                                          multiplier:1
                                          constant:-bgTopMore_]];
                [self.view addConstraint:[NSLayoutConstraint
                                          constraintWithItem:imgView
                                          attribute:NSLayoutAttributeBottom
                                          relatedBy:NSLayoutRelationEqual
                                          toItem:self.view
                                          attribute:NSLayoutAttributeBottom
                                          multiplier:1
                                          constant:0]];
                [self.view
                 addConstraint:[NSLayoutConstraint
                                constraintWithItem:imgView
                                attribute:NSLayoutAttributeTrailing
                                relatedBy:NSLayoutRelationEqual
                                toItem:self.view
                                attribute:NSLayoutAttributeTrailing
                                multiplier:1
                                constant:0]];
            } break;
            default:
                break;
        }
    }
}

//获取背景图片名称
- (NSString *)getBGName {
    [MyLog Log:@"if you want to set BG, please rewite [self getBGName]" obj:self];
    return nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //开始
    if (bAutoStart_) {
        bAutoStart_ = NO;
        [self onStart];
    }
    [self setBackItem];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

//获取加载的处理视图
- (UIView *)getRequestProcessView:(BaseRequest *)request {
    UIView *v = nil;
    if (request == requestCon_) {
        v = self.view;
    }
    return v;
}

//辅助
- (CGFloat)getProcessViewTopMore {
    if (navView_) {
        return navView_.frame.size.height;
    } else
        return navImgView_.frame.size.height;
}

//显示锁住视图
- (void)showLockView {
    BaseLockView *lockView =
    [[[NSBundle mainBundle] loadNibNamed:@"BaseLockView"
                                   owner:self
                                 options:nil] lastObject];
    lockView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:lockView];
    
    //添加约束
    [BaseCommon copyConstraint:self.view srcView:self.view desView:lockView];
}

// get加载视图
- (BaseLoadingView *)getLoadingView:(BaseRequest *)request {
    BaseLoadingView *loadView =
    [[[NSBundle mainBundle] loadNibNamed:@"BaseLoadingView"
                                   owner:self
                                 options:nil] lastObject];
    return loadView;
}

//显示加载视图
- (void)showLoadingView:(BaseRequest *)request {
    switch (request.cfgModal_.type_) {
            //模态
        case RequestLoadingType_Model:
            [[self class] showHUDView:request.cfgModal_.loadingStr_
                                       status:nil];
            break;
            //常态
        case RequestLoadingType_Normal: {
            UIView *superView = [self getRequestProcessView:request];
            if (superView) {
                BaseLoadingView *loadView = [self getLoadingView:request];
                
                BaseTmpView *tmpView =
                [[[NSBundle mainBundle] loadNibNamed:@"BaseTmpView"
                                               owner:self
                                             options:nil] lastObject];
                tmpView.backgroundColor = superView.backgroundColor;
                tmpView.translatesAutoresizingMaskIntoConstraints = NO;
                [superView addSubview:tmpView];
                //                NSDictionary
                //                *views=NSDictionaryOfVariableBindings(tmpView);
                //                [superView addConstraints:
                //                 [NSLayoutConstraint
                //                 constraintsWithVisualFormat:@"H:|-0-[tmpView]-0-|"
                //                                                         options:0
                //                                                         metrics:nil
                //                                                           views:views]];
                //                [superView addConstraints:
                //                 [NSLayoutConstraint
                //                 constraintsWithVisualFormat:[NSString
                //                 stringWithFormat:@"V:|-%.0f-[tmpView]-0-|",[self
                //                 getProcessViewTopMore]]
                //                                                         options:0
                //                                                         metrics:nil
                //                                                           views:views]];
                [BaseCommon copyConstraint:superView
                                   srcView:superView
                                   desView:tmpView
                                   topMore:[self getProcessViewTopMore]];
                
                loadView.translatesAutoresizingMaskIntoConstraints = NO;
                loadView.txtLb_.text = request.cfgModal_.loadingStr_;
                [superView addSubview:loadView];
                
                //添加约束
                [BaseCommon addCenterConstraint:superView view:loadView];
            }
        } break;
        default:
            break;
    }
}

//隐藏加载视图
- (void)hideLoadingView:(BaseRequest *)request {
    switch (request.cfgModal_.type_) {
            //模态
        case RequestLoadingType_Model:
            [BaseUIViewController hideHUDView];
            break;
            //常态
        case RequestLoadingType_Normal: {
            UIView *superView = [self getRequestProcessView:request];
            if (superView) {
                for (UIView *subView in [superView subviews]) {
                    if ([subView isKindOfClass:[BaseLoadingView class]] ||
                        [subView isKindOfClass:[BaseTmpView class]]) {
                        [subView removeFromSuperview];
                    }
                }
            }
        } break;
        default:
            break;
    }
}

//获取没有视图
- (BaseNoDataView *)getNoDataView {
    BaseNoDataView *loadView =
    [[[NSBundle mainBundle] loadNibNamed:@"BaseNoDataView"
                                   owner:self
                                 options:nil] lastObject];
    return loadView;
}

//显示没有数据视图
- (void)showNoDataView:(BaseRequest *)request {
    if (request.cfgModal_.type_ == RequestLoadingType_Normal) {
        UIView *superView = [self getRequestProcessView:request];
        if (superView) {
            BaseNoDataView *noDataView = [self getNoDataView];
            noDataView.translatesAutoresizingMaskIntoConstraints = NO;
            noDataView.txtLb_.text = request.cfgModal_.noDataStr_;
            [superView addSubview:noDataView];
            
            //添加约束
            [BaseCommon copyConstraint:superView
                               srcView:superView
                               desView:noDataView
                               topMore:[self getProcessViewTopMore]];
        }
    }
}

//隐藏没有数据视图
- (void)hideNoDataView:(BaseRequest *)request {
    if (request.cfgModal_.type_ == RequestLoadingType_Normal) {
        UIView *superView = [self getRequestProcessView:request];
        if (superView) {
            for (UIView *subView in [superView subviews]) {
                if ([subView isKindOfClass:[BaseNoDataView class]]) {
                    [subView removeFromSuperview];
                }
            }
        }
    }
}

//显示异常数据视图
- (void)showErrorDataView:(BaseRequest *)request code:(BaseErrorCode)code {
    switch (request.cfgModal_.type_) {
        case RequestLoadingType_Model:
            [BaseUIViewController showHUDFailView:[BaseErrorInfo getErrorMsg:code]
                                              msg:nil];
            break;
        case RequestLoadingType_Normal: {
            UIView *superView = [self getRequestProcessView:request];
            if (superView) {
                BaseErrorView *errorView =
                [[[NSBundle mainBundle] loadNibNamed:@"BaseErrorView"
                                               owner:self
                                             options:nil] lastObject];
                errorView.translatesAutoresizingMaskIntoConstraints = NO;
                errorView.txtLb_.text = [BaseErrorInfo getErrorMsg:code];
                [superView addSubview:errorView];
                
                //添加约束
                [BaseCommon copyConstraint:superView
                                   srcView:superView
                                   desView:errorView
                                   topMore:[self getProcessViewTopMore]];
            }
        } break;
        default:
            break;
    }
}

//隐藏异常数据视图
- (void)hideErrorDataView:(BaseRequest *)request {
    switch (request.cfgModal_.type_) {
        case RequestLoadingType_Model:
            //不用处理
            break;
        case RequestLoadingType_Normal: {
            UIView *superView = [self getRequestProcessView:request];
            if (superView) {
                for (UIView *subView in [superView subviews]) {
                    if ([subView isKindOfClass:[BaseErrorView class]]) {
                        [subView removeFromSuperview];
                    }
                }
            }
        } break;
        default:
            break;
    }
}

//获取一个请求类
- (RequestCon *)getNewRequestCon:(BOOL)bSaveData
{
    RequestCon *con = [[RequestCon alloc] init];
    con.bSaveData_ = bSaveData;
    con.delegate_ = self;
    return con;
}

//获取一个请求类
- (RequestCon *)getNewRequestCon:(BOOL)bSaveData repeatCheck:(RequestCon *)request {
    long long currentTime = [Common getDateTimeToMilliSeconds:[NSDate date]];
//    if (request) {
//        NSLog(@"时间差-------- %lld", currentTime - request.startTime);
//    }
    if ( request && (currentTime - request.startTime) < 0.5 * 1000) {
        
        request.startTime = currentTime;
        request.bAvailable = NO;
        return request;
    }
    RequestCon *con = [[RequestCon alloc] init];
    con.startTime = currentTime;
    con.bAvailable = YES;
    con.bSaveData_ = bSaveData;
    con.delegate_ = self;
    return con;
}

//开始加载(设置入参)
- (void)beginLoad:(id)dataModal exParam:(id)exParam {
    if (self.view)
        [self onStart];
    else
        bAutoStart_ = YES;
}

//开始
- (void)onStart {
    [MyLog Log:@"onStart" obj:self];
    
    requestCon_ = [self getNewRequestCon:NO];
    [self startRequest:requestCon_];
}

//重新加载
- (void)reStartRequest:(RequestCon *)request {
    [MyLog Log:@"reStartRequest..." obj:self];
    
    [self startRequest:request];
}

//开始加载
- (void)startRequest:(RequestCon *)request {
}

//加载数据完成
- (void)loadDataCompleate:(BaseRequest *)request
                  dataArr:(NSArray *)dataArr
                     code:(BaseErrorCode)code {
    @try {
        if (code != ErrorCode_Success) {
            [self errorLoadData:request code:code];
        } else {
            [self finishLoadData:request dataArr:dataArr];
        }
    } @catch (NSException *exception) {
    } @finally {
    }
}

//加载数据有误
- (void)errorLoadData:(BaseRequest *)request code:(BaseErrorCode)code {
}

//加载数据完成
- (void)finishLoadData:(BaseRequest *)request dataArr:(NSArray *)dataArr {
}

//更新消息量
- (BOOL)shouldUpdateMsgCnt {
    //返回YES，则代码子类自己得写相关方法
    return NO;
}

//点击事件
- (IBAction)viewClicked:(id)sender {
    [MyLog Log:@"viewClicked" obj:self];
    
    [searchKeyBar resignFirstResponder];
    
    @try {
        if (sender == backBtn_) {
            [self backBtnResponse:sender];
        } else if (sender == searchButton) {
            [self searchButtonResponse:sender];
        } else
            [self viewClickResponse:sender];
    } @catch (NSException *exception) {
        [BaseUIViewController showAlertView:NSLocalizedString(@"操作失败", nil)
                                        msg:nil
                                     cancel:NSLocalizedString(@"知道了", nil)];
    } @finally {
    }
}

- (void)searchButtonResponse:(id)sender {
    bSearch = !bSearch;
    __weak typeof(BaseUIViewController *) weakSelf = self;
    [UIView animateWithDuration:0.30
                     animations:^{
                         NSLayoutConstraint *widthConstraint = [weakSelf
                                                                findViewWidthConstraintWithView:searchKeyBar];
                         widthConstraint.constant = bSearch ? 250 : 0;
                         [self.view layoutIfNeeded];
                         
                         if (bSearch) {
                             [searchKeyBar becomeFirstResponder];
                         } else {
                             [searchKeyBar resignFirstResponder];
                         }
                     }];
}

//返回按扭点击了
- (void)backBtnResponse:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//左边的按扭点击了
- (void)leftBarBtnResponse:(id)sender {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//右边的按扭点击了
- (void)rightBarBtnResponse:(id)sender {
}

//事件响应
- (void)viewClickResponse:(id)sender {
}

// 3指或4点点击响应事件
- (void)threeOrFourTouchResponse:(id)sender {
}

#pragma BaseRequestDelegate
- (void)requestBegin:(BaseRequest *)request {
    [MyLog Log:@"requestBegin" obj:self];
    
    [self showLoadingView:request];
    [self hideNoDataView:request];
    [self hideErrorDataView:request];
}

- (void)requestFail:(BaseRequest *)request code:(BaseErrorCode)code {
    [MyLog Log:[NSString stringWithFormat:@"requestFail code=%d", code] obj:self];
    
    [self hideLoadingView:request];
    [self hideNoDataView:request];
    [self showErrorDataView:request code:code];
    
    [self loadDataCompleate:request dataArr:nil code:code];
}

- (void)requestFinish:(BaseRequest *)request dataArr:(NSArray *)dataArr {
    [MyLog
     Log:[NSString stringWithFormat:@"requestFinish count=%d", [dataArr count]]
     obj:self];
    [self hideLoadingView:request];
    [self hideErrorDataView:request];
    if ([dataArr count] == 0) {
        [self showNoDataView:request];
    }

    [self loadDataCompleate:request dataArr:dataArr code:ErrorCode_Success];
}

#pragma mark - searchBarDelegate
-(void) searchBarBookmarkButtonClicked:(UISearchBar *)searchBar
{
    [searchKeyBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchKeyBar resignFirstResponder];
    [self onStart];
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchText {
    if ([searchText isEqualToString:@""]) {
        [self onStart];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    searchBar.text = @"";
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [searchKeyBar resignFirstResponder];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [searchKeyBar resignFirstResponder];
    [self.view endEditing:YES];
}

@end
