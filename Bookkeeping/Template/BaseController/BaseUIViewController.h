//
//  BaseUIViewController.h
//  XZD
//
//  Created by sysweal on 14/11/14.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>
#import <UIKit/UIKit.h>
#import "BaseCommon.h"
#import "BaseErrorInfo.h"
#import "BaseErrorView.h"
#import "BaseLoadingView.h"
#import "BaseLockView.h"
#import "BaseNoDataView.h"
#import "BaseTmpView.h"
#import "Common.h"
#import "MMProgressHUD.h"
#import "MsgView.h"
#import "RequestCon.h"
#import "ExRequestCon.h"
//#import "UIWindow+YzdHUD.h"

typedef enum {
  BGType_Copy,
  BGType_Fill,
} BGType;


@interface BaseUIViewController
    : UIViewController<BaseRequestDelegate, UISearchBarDelegate> {
  BGType bgType_;

  NSString *leftBarStr_;
  NSString *rightBarStr_;
  NSString *leftBarImg_;
  NSString *rightBarImg_;

  RequestCon *requestCon_;

  BOOL bAutoStart_;
  BOOL bSearch;

  float bgTopMore_;
}

@property (nonatomic, weak  ) IBOutlet UIButton    *backBtn_;
@property (nonatomic, weak  ) IBOutlet UIImageView *navImgView_;
@property (nonatomic, weak  ) IBOutlet UIView      *navView_;
@property (nonatomic, weak  ) IBOutlet UILabel     *barTitleLb_;
@property (weak, nonatomic  ) IBOutlet UISearchBar *searchKeyBar;
@property (weak, nonatomic  ) IBOutlet UIButton    *searchButton;
@property (assign, nonatomic) BOOL                 haveBackBtn;

//显示AlertView
+ (void)showAlertView:(NSString *)title
                  msg:(NSString *)msg
               cancel:(NSString *)cancel;

//显示HUD
+ (void)showHUDView:(NSString *)title status:(NSString *)status;

//自动消失的操作成功视图
+ (void)showHUDSuccessView:(NSString *)title msg:(NSString *)msg;

//自动消失的操作成功视图(自定义消失时间)
+ (void)showHUDSuccessView:(NSString *)title msg:(NSString *)msg delayTime:(NSInteger)delayTime;

//自动消息的操作失败视图
+ (void)showHUDFailView:(NSString *)title msg:(NSString *)msg;

//隐藏HUD
+ (void)hideHUDView;

- (void)showChooseAlertViewCtl:(NSString *)title msg:(NSString *)msg confirmHandle:(void(^)(void))confirmBlock;

- (void)showChooseAlertViewCtl:(NSString *)title msg:(NSString *)msg
                    okBtnTitle:(NSString *)okBtnTitle
                cancelBtnTitle:(NSString *)cancelBtnTitle
                 confirmHandle:(void(^)(void))confirmBlock
                  cancleHandle:(void(^)(void))cancleBlock;

//显示AlertViewCtl
- (void)showAlertViewCtl:(NSString *)title msg:(NSString *)msg cancel:(NSString *)cancel cancleHandle:(void(^)(void))cancleBlock;

//文本输入
-(void)showTextAlert:(UIKeyboardType)keyboardType title:(NSString *)title msg:(NSString *)msg placeholder:(NSString *)placeholder confirmHandle:(void(^)(NSString *))confirmBlock;

//设置返回按扭属性
- (void)setBackBtnAtt;

//设置背景
- (void)setBG;

//获取背景图片名称
- (NSString *)getBGName;

//获取加载的处理视图
- (UIView *)getRequestProcessView:(BaseRequest *)request;

//辅助
- (CGFloat)getProcessViewTopMore;

//显示锁住视图
- (void)showLockView;

//获取加载视图
- (BaseLoadingView *)getLoadingView:(BaseRequest *)request;

//获取没有视图
- (BaseNoDataView *)getNoDataView;

//显示加载视图
- (void)showLoadingView:(BaseRequest *)request;

//隐藏加载视图
- (void)hideLoadingView:(BaseRequest *)request;

//显示没有数据视图
- (void)showNoDataView:(BaseRequest *)request;

//隐藏没有数据视图
- (void)hideNoDataView:(BaseRequest *)request;

//显示异常数据视图
- (void)showErrorDataView:(BaseRequest *)request code:(BaseErrorCode)code;

//隐藏异常数据视图
- (void)hideErrorDataView:(BaseRequest *)request;

//获取一个请求类
- (RequestCon *)getNewRequestCon:(BOOL)bSaveData;

//repeatCheck
- (RequestCon *)getNewRequestCon:(BOOL)bSaveData repeatCheck:(RequestCon *)request;

//开始加载(设置入参)
- (void)beginLoad:(id)dataModal exParam:(id)exParam;

//开始
- (void)onStart;

//开始加载
- (void)startRequest:(RequestCon *)request;

//加载数据完成
- (void)loadDataCompleate:(BaseRequest *)request
                  dataArr:(NSArray *)dataArr
                     code:(BaseErrorCode)code;

//加载数据有误
- (void)errorLoadData:(BaseRequest *)request code:(BaseErrorCode)code;

//加载数据完成
- (void)finishLoadData:(BaseRequest *)request dataArr:(NSArray *)dataArr;

//更新消息量
- (BOOL)shouldUpdateMsgCnt;

//点击事件
- (IBAction)viewClicked:(id)sender;

//返回按扭点击了
- (void)backBtnResponse:(id)sender;

//事件响应
- (void)viewClickResponse:(id)sender;

//左边的按扭点击了
- (void)leftBarBtnResponse:(id)sender;

//右边的按扭点击了
- (void)rightBarBtnResponse:(id)sender;

//国际化文本
- (void)initTextXib;

//初始化UI
- (void)initUIShape;

//版本更新
- (void)showUpdateVersion;

@end
