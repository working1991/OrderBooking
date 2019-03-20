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

@interface ConfirmOrderCtl ()

{
    Base_Modal *payModel;
    Product_Modal *productModel;
    NSMutableArray  *selectArr;
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
        bHeadRefresh_ = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([ChooseStandardCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([ChooseStandardCell class])];
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

- (void)viewClickResponse:(id)sender
{
    if (sender == self.customerBtn) {
        [self chooseCustomer:sender];
    } else if (sender == self.payBtn) {
        [self choosePayType:sender];
    } else if (sender == self.confirmBtn) {
        [self showChooseAlertViewCtl:@"应付金额：¥1600.00\n实付金额：¥1500.00" msg:@"确认支付完成？" confirmHandle:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
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
    
    NSMutableArray *typeArr = [NSMutableArray array];
    selectArr = [NSMutableArray array];
    for (NSInteger i=0; i<productModel.typeArr.count; i++) {
        Standard_Modal *model = productModel.typeArr[i];
        if (model.saleCount <= 0) {
            continue;
        }
        [selectArr addObject:model];
        BOOL bHave = NO;
        for (NSInteger j=0; j<typeArr.count; j++) {
            NSDictionary *typeDic = typeArr[j];
            if ([model.firstSpecId isEqualToString:typeDic[@"id"]]) {
                NSMutableArray *list = [NSMutableArray arrayWithArray:typeDic[@"list"]];
                NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:typeDic];
                mDic[@"list"] = list;
                bHave = YES;
                break;
            }
        }
        if (!bHave) {
            [typeArr addObject:@{@"id":model.firstSpecId?model.firstSpecId:@"", @"name":model.firstSpecName?model.firstSpecName:@"", @"list": @[model]}];
        }
    }
    [self.tableView_ reloadData];
}

- (void)chooseCustomer:(UIButton *)sender
{
    ChooseCustomerCtl *ctl = [[ChooseCustomerCtl alloc] initWithFinish:^(Base_Modal *model) {
        [sender setTitle:@"客户" forState:UIControlStateNormal];
    }];
    [self.navigationController pushViewController:ctl animated:YES];
}

- (void)choosePayType:(UIButton *)sender
{
    ChoosePayCtl *ctl = [ChoosePayCtl start:self.view finished:^(Base_Modal *model) {
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
    myCell.cntTf.text = [NSString stringWithFormat:@"%d", model.saleCount];
    myCell.numChange = ^(int currentNum) {
        model.saleCount = currentNum;
    };
    
    return myCell;
}

@end
