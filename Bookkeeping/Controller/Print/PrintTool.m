//
//  PrintTool.m
//  XZD
//
//  Created by LcGero on 15/11/25.
//  Copyright © 2015年 sysweal. All rights reserved.
//

#import "PrintTool.h"
#import "UartXCtl.h"

@interface PrintTool ()
@property (nonatomic, strong) NSArray   *infos;
@property (nonatomic, assign) BOOL      bReprint;
@end

@implementation PrintTool

+ (PrintTool *)sharedManager
{
    static PrintTool *sharedPrintTool = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedPrintTool = [[self alloc] init];
    });
    return sharedPrintTool;
}

//订单
- (BOOL)printOrderInfo:(Base_Modal *)dataModal bReprint:(BOOL)bReprint
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    [arr addObject:[NSString stringWithFormat:NSLocalizedString(@"编号：%@\n", nil),dataModal.orderNum]];
//    if( dataModal.customerCode && ![dataModal.customerCode isEqualToString:@""] ){
//        [arr addObject:[NSString stringWithFormat:NSLocalizedString(@"客户名称：%@(%@)\n", nil),dataModal.customerName,dataModal.customerCode]];
//    }else {
//        [arr addObject:[NSString stringWithFormat:NSLocalizedString(@"客户名称：%@\n", nil),dataModal.customerName]];
//    }
//    [arr addObject:[NSString stringWithFormat:NSLocalizedString(@"开单时间：%@\n", nil),dataModal.createTime]];
//    [arr addObject:[NSString stringWithFormat:NSLocalizedString(@"参与员工：%@\n", nil),[Employee_Modal getEmployeesNameAndPostNameString:dataModal.partorArr]]];
//    [arr addObject:[NSString stringWithFormat:NSLocalizedString(@"订单总金额：￥%@\n", nil),dataModal.realPrice ? dataModal.realPrice :dataModal.totalPrice]];
//    if ( dataModal.productArr.count > 0 || dataModal.presentArr.count > 0 ) {
//        [arr addObject:@"--------------------------------\n"];
//    }
//
//    for ( int i = 0 ; i < [dataModal.productArr count]; ++i ) {
//        Product_Modal *productModal = [dataModal.productArr objectAtIndex:i];
//        if( dataModal.orderType == OrderType_MemberCardOrder ){
//            [arr addObject:[NSString stringWithFormat:NSLocalizedString(@"  名称：%@\n", nil),NSLocalizedString(@"客户充值", nil)]];
//            [arr addObject:[NSString stringWithFormat:NSLocalizedString(@"  充值金额：￥%@\n", nil),dataModal.totalPrice]];
//        }
//        else if( dataModal.orderType == OrderType_ChargeCardOrder ){
//            [arr addObject:[NSString stringWithFormat:NSLocalizedString(@"  名称：%@\n", nil),NSLocalizedString(@"金额卡充值", nil)]];
//            [arr addObject:[NSString stringWithFormat:NSLocalizedString(@"  充值金额：￥%@\n", nil),dataModal.totalPrice]];
//        }else{
//            [arr addObject:[NSString stringWithFormat:NSLocalizedString(@"  名称：%@\n", nil),productModal.name]];
//            [arr addObject:[NSString stringWithFormat:NSLocalizedString(@"  数量：%@\n", nil),productModal.times]];
//            [arr addObject:[NSString stringWithFormat:NSLocalizedString(@"  单价：￥%@\n", nil),productModal.price]];
//        }
//    }
//    if ( [dataModal getAllPresent].count > 0 ) {
//        if ( dataModal.productArr.count > 0 ) {
//            [arr addObject:@"  ----------------------------\n"];
//        }
//        [arr addObject:NSLocalizedString(@"  赠品清单：\n", nil)];
//        for (MyPresent_Modal *subModal in [dataModal getAllPresent]) {
//            [arr addObject:[NSString stringWithFormat:@"   %@ x%@\n",subModal.name,subModal.useTiems]];
//        }
//    }
//
//    [arr addObject:@"--------------------------------\n"];
    [arr addObject:@"温馨提示：离店时请携带随身物品\n"];
//    [arr addObject:[NSString stringWithFormat:NSLocalizedString(@"操作者：%@\n", nil),[ManagerCtl getRoleInfo].name]];
//    [arr addObject:[NSString stringWithFormat:NSLocalizedString(@"打单时间：%@\n", nil),[Common getCurrentDateTime]]];
    [arr addObject:@"\n\n\n"];
    
    return [self printInfos:arr bReprint:bReprint];
}



-(BOOL) printInfos:(NSArray *)infos bReprint:(BOOL)bReprint
{
    return [UartXCtl print:infos bReprint:bReprint];
}


@end
