//
//  PrintTool.m
//  XZD
//
//  Created by LcGero on 15/11/25.
//  Copyright © 2015年 sysweal. All rights reserved.
//

#import "PrintTool.h"
#import "UartXCtl.h"
#import "HLPrinter.h"

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
- (BOOL)printOrderInfo:(Order_Model *)dataModal
{
    HLPrinter *printer = [[HLPrinter alloc] init];
    NSString *title = @"销售单";
    [printer appendText:title alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleBig];
    [printer appendSeperatorLine];
    
    [printer appendTitle:@"订单编号:" value:dataModal.id_];
    [printer appendTitle:@"开单时间:" value:dataModal.createTime];
    
    [printer appendTitle:@"客户姓名:" value:dataModal.customerModal.name.length>0?dataModal.customerModal.name:@""];
    [printer appendTitle:@"客户手机:" value:dataModal.customerModal.telphone.length>0?dataModal.customerModal.telphone:@""];
    [printer appendTitle:@"客户地址:" value:dataModal.customerModal.address.length>0?dataModal.customerModal.address:@""];
    
    for (Product_Modal *productModal in dataModal.productTypeArr) {
        [printer appendSeperatorLine];
        [printer appendTitle:@"商品:" value:productModal.name];
        [printer appendLeftText:@"尺码" middleText:@"数量" rightText:@"单价" isTitle:YES];
        for (Standard_Modal *typeModal in productModal.typeArr) {
            NSString *type = [NSString stringWithFormat:@"%@（%@）", typeModal.secondSpecName, typeModal.firstSpecName];
            NSString *count = [NSString stringWithFormat:@"%d", typeModal.saleCount];
            NSString *price = [NSString stringWithFormat:@"%.2lf", typeModal.productSpecPrice];
            [printer appendLeftText:type middleText:count rightText:price isTitle:NO];
        }
    }
    
    [printer appendSeperatorLine];
    NSString *totalStr = [NSString stringWithFormat:@"%.2f",dataModal.orderPrice];
    [printer appendTitle:@"应收:" value:totalStr];
    NSString *realStr = [NSString stringWithFormat:@"%.2f",dataModal.realPrice];
    [printer appendTitle:@"实收:" value:realStr];
    [printer appendTitle:@"状态:" value:dataModal.orderStatusName];
    
    [printer appendSeperatorLine];

    [printer appendTitle:@"打单时间:" value:[Common getDateStr:nil format:nil]];
    [printer appendFooter:nil];
    [printer appendNewLine];
    [printer appendNewLine];
    // 你也可以利用UIWebView加载HTML小票的方式，这样可以在远程修改小票的样式和布局。
    // 注意点：需要等UIWebView加载完成后，再截取UIWebView的屏幕快照，然后利用添加图片的方法，加进printer
    // 截取屏幕快照，可以用UIWebView+UIImage中的catogery方法 - (UIImage *)imageForWebView
    return [self printInfos:printer];
}

- (BOOL)printExInfo
{
    HLPrinter *printer = [[HLPrinter alloc] init];
    NSString *title = @"测试电商";
    NSString *str1 = @"测试电商服务中心(销售单)";
    [printer appendText:title alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleBig];
    [printer appendText:str1 alignment:HLTextAlignmentCenter];
    [printer appendBarCodeWithInfo:@"RN3456789012"];
    [printer appendSeperatorLine];
    
    [printer appendTitle:@"时间:" value:@"2016-04-27 10:01:50" valueOffset:150];
    [printer appendTitle:@"订单:" value:@"4000020160427100150" valueOffset:150];
    [printer appendText:@"地址:深圳市南山区学府路东深大店" alignment:HLTextAlignmentLeft];
    
    [printer appendSeperatorLine];
    [printer appendLeftText:@"商品" middleText:@"数量" rightText:@"单价" isTitle:YES];
    CGFloat total = 0.0;
    NSDictionary *dict1 = @{@"name":@"铅笔测试一下哈哈",@"amount":@"5",@"price":@"2.0"};
    NSDictionary *dict2 = @{@"name":@"abcdefghijfdf",@"amount":@"1",@"price":@"1.0"};
    NSDictionary *dict3 = @{@"name":@"abcde笔记本啊啊",@"amount":@"3",@"price":@"3.0"};
    NSArray *goodsArray = @[dict1, dict2, dict3];
    for (NSDictionary *dict in goodsArray) {
        [printer appendLeftText:dict[@"name"] middleText:dict[@"amount"] rightText:dict[@"price"] isTitle:NO];
        total += [dict[@"price"] floatValue] * [dict[@"amount"] intValue];
    }
    
    [printer appendSeperatorLine];
    NSString *totalStr = [NSString stringWithFormat:@"%.2f",total];
    [printer appendTitle:@"总计:" value:totalStr];
    [printer appendTitle:@"实收:" value:@"100.00"];
    NSString *leftStr = [NSString stringWithFormat:@"%.2f",100.00 - total];
    [printer appendTitle:@"找零:" value:leftStr];
    
    [printer appendSeperatorLine];
    
    [printer appendText:@"位图方式二维码" alignment:HLTextAlignmentCenter];
    [printer appendQRCodeWithInfo:@"www.baidu.com"];
    
    [printer appendSeperatorLine];
    [printer appendText:@"指令方式二维码" alignment:HLTextAlignmentCenter];
    [printer appendQRCodeWithInfo:@"www.baidu.com" size:10];
    
    [printer appendFooter:nil];
    [printer appendImage:[UIImage imageNamed:@"ico180"] alignment:HLTextAlignmentCenter maxWidth:300];
    
    // 你也可以利用UIWebView加载HTML小票的方式，这样可以在远程修改小票的样式和布局。
    // 注意点：需要等UIWebView加载完成后，再截取UIWebView的屏幕快照，然后利用添加图片的方法，加进printer
    // 截取屏幕快照，可以用UIWebView+UIImage中的catogery方法 - (UIImage *)imageForWebView
    return [self printInfos:printer];
}


-(BOOL) printInfos:(HLPrinter *)printer
{
    return [UartXCtl print:printer];
}


@end
