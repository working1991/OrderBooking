//
//  ExDataParser.m
//  XZD
//
//  Created by sysweal on 14/12/2.
//  Copyright (c) 2014年 sysweal. All rights reserved.
//

#import "ExDataParser.h"




@implementation DataParser (ExDataParser)


//解析数据
+(NSArray *) parserData:(NSString *)opKey data:(NSData *)data
{
    [MyLog Log:[NSString stringWithFormat:@"parserData opKey=%@",opKey] obj:nil];
    
    NSArray *arr = nil;
    NSDictionary *responseDic = nil;
    NSDictionary *dic = nil;
    NSString *restCode;
    NSString *restMsg;
    
    if( opKey ){
        responseDic = [BaseCommon getDataDic:data];
    }else{
        arr = [NSArray arrayWithObject:data];
    }
    
    if( responseDic ){
        if ([responseDic isKindOfClass:[NSDictionary class]]) {
            restCode = [NSString stringWithFormat:@"%@", [responseDic objectForKey:@"retCode"]];
            restMsg = [responseDic objectForKey:@"retMsg"];
            dic = [responseDic objectForKey:@"data"];
        }
      
        //公共解析方法
        if ([opKey isEqualToString:@"modifyPassword"] ||
            [opKey isEqualToString:@"addCutomer"] ||
            [opKey isEqualToString:@"confirmOrder"]
            ) {
            arr = [self parserBaseReturnRestCode:dic];
        }
        
        //登录
        else if([opKey isEqualToString:@"doLogin"]){
            arr = [self parserDoLogin:dic];
        }
        //商品分类
        else if ([opKey isEqualToString:@"getProductGrop"]){
            arr = [self parserProductGrop:dic];
        }
        //商品列表
        else if ([opKey isEqualToString:@"getProductList"] ||
                 [opKey isEqualToString:@"searchProduct"]){
            arr = [self parserProductList:dic];
        }
        //商品详情
        else if ([opKey isEqualToString:@"getProductDetail"]){
            arr = [self parserProductDetail:dic];
        }
        //订单列表
        else if ([opKey isEqualToString:@"queryOrderList"]){
            arr = [self parserOrderList:dic];
        }
        //订单详情
        else if ([opKey isEqualToString:@"queryOrderDetail"]){
            arr = [self parserOrderDetail:dic];
        }
        //销售汇总
        else if ([opKey isEqualToString:@"querySaleTotalInfo"]){
            arr = [self parserSaleTotalInfo:dic];
        }
        //客户列表
        else if ([opKey isEqualToString:@"queryCustomerList"]){
            arr = [self parserCustomerList:dic];
        }
    }
    
    //date:2015-11-17 如果返回成功了，但是arr没有，则赋值一下arr
    if(!arr){
        arr = [NSMutableArray new];
    }
    
    for ( id obj in arr ) {
        if( [obj isKindOfClass:[Base_Modal class]] ){
            Base_Modal *dataModal = obj;
            dataModal.restCode = restCode;
            dataModal.restMsg = restMsg;
        }
    }
    
    return arr;
}

//登录
+ (NSMutableArray *)parserDoLogin:(NSDictionary *)dic
{
    NSMutableArray *arr = nil;
    arr = [[NSMutableArray alloc] init];
    Base_Modal *baseModal = [[Base_Modal alloc]init];
    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
        User_Modal *modal = [[User_Modal alloc] init];
        modal.id_ = dic[@"id"];
        modal.createTime = dic[@"createTime"];
        modal.updateTime = dic[@"updateTime"];
        modal.account = dic[@"userName"];
        modal.name = dic[@"name"];
        modal.telphone = dic[@"mobile"];
        modal.companyId = dic[@"companyId"];
        
        baseModal = modal;
    }
    [arr addObject:baseModal];
    return arr;
}

//商品分类
+ (NSMutableArray *)parserProductGrop:(NSDictionary *)dic
{
    NSMutableArray *arr = nil;
    if (dic && [dic isKindOfClass:[NSArray class]]) {
        arr = [[NSMutableArray alloc] init];
        NSArray *list = (NSArray *)dic;
        for (NSDictionary *productDic in list) {
            Base_Modal *modal = [Base_Modal new];
            modal.id_ = productDic[@"id"];
            modal.name = productDic[@"name"];
            modal.des = productDic[@"description"];
            [arr addObject:modal];
        }
    }
    return arr;
}

//商品列表
+(NSMutableArray *)parserProductList:(NSDictionary *)dic
{
    NSMutableArray *arr = nil;
    if ( dic && [dic isKindOfClass:[NSDictionary class]] ) {
        int totalCount = [[dic objectForKey:@"total"] intValue];
        int totalPage = totalCount / PageSize + (totalCount % PageSize == 0 ? 0 : 1);
        NSArray *tmpArr = [dic objectForKey:@"list"];
        
        if( tmpArr && [tmpArr isKindOfClass:[NSArray class]] ){
            arr = [[NSMutableArray alloc] init];
            for ( NSDictionary *tmpDic in tmpArr ) {
                Product_Modal *modal = [[Product_Modal alloc] init];
                modal.id_ = tmpDic[@"id"];
                modal.createTime = tmpDic[@"createTime"];
                modal.updateTime = tmpDic[@"update_time"];
                modal.imgUrl = tmpDic[@"thumbnail"];
                modal.name = tmpDic[@"name"];
                modal.code = tmpDic[@"code"];
                modal.companyId = tmpDic[@"company_id"];
                modal.unitPrice = tmpDic[@"cost_price"];
                modal.des = tmpDic[@"description"];
                
                modal.totalPage_ = totalPage;
                modal.totalSize_ = totalCount;
                
                [arr addObject:modal];
            }
        }
    }
    return arr;
}

//商品详情
+ (NSMutableArray *)parserProductDetail:(NSDictionary *)tmpDic
{
    NSMutableArray *arr = nil;
    arr = [[NSMutableArray alloc] init];
    if (tmpDic && [tmpDic isKindOfClass:[NSDictionary class]]) {
        Product_Modal *modal = [[Product_Modal alloc] init];
        modal.id_ = tmpDic[@"id"];
        modal.imgUrl = tmpDic[@"thumbnail"];
        modal.name = tmpDic[@"name"];
        modal.unitPrice = tmpDic[@"cost_price"];
        NSMutableArray *typeArr = [NSMutableArray array];
        for (NSDictionary *typeDic in tmpDic[@"productSysSpecDtos"]) {
            Standard_Modal *typeModel = [Standard_Modal new];
            typeModel.firstSpecId = typeDic[@"firstSpecId"];
            typeModel.firstSpecName = typeDic[@"firstSpecName"];
            typeModel.productReSpecId = typeDic[@"productReSpecId"];
            typeModel.productSpecPrice = [typeDic[@"productSpecPrice"] doubleValue];
            typeModel.secondSpecName = typeDic[@"secondSpecName"];
            
            [typeArr addObject:typeModel];
        }
        modal.typeArr = typeArr;
        
        [arr addObject:modal];
    }
    
    return arr;
}

//订单列表
+(NSMutableArray *)parserOrderList:(NSDictionary *)dic
{
    NSMutableArray *arr = nil;
    if ( dic && [dic isKindOfClass:[NSDictionary class]] ) {
        int totalCount = [[dic objectForKey:@"total"] intValue];
        int totalPage = totalCount / PageSize + (totalCount % PageSize == 0 ? 0 : 1);
        NSArray *tmpArr = [dic objectForKey:@"list"];
        
        if( tmpArr && [tmpArr isKindOfClass:[NSArray class]] ){
            arr = [[NSMutableArray alloc] init];
            for ( NSDictionary *tmpDic in tmpArr ) {
                Order_Model *modal = [Order_Model new];
                modal.id_ = tmpDic[@"id"];
                modal.orderStatus = [tmpDic[@"orderStatus"] integerValue];
                modal.orderPrice = [tmpDic[@"orderPrice"] doubleValue];
                modal.payTypeCode = tmpDic[@"payType"];
                modal.realPrice = [tmpDic[@"realPrice"] doubleValue];
                modal.code = tmpDic[@"code"];
                modal.oporaterName = tmpDic[@"managerName"];
                modal.customerName = tmpDic[@"customerName"];
                modal.createTime = tmpDic[@"createTime"];
                
                modal.totalPage_ = totalPage;
                modal.totalSize_ = totalCount;
                
                [arr addObject:modal];
            }
        }
    }
    return arr;
}

//订单详情
+ (NSMutableArray *)parserOrderDetail:(NSDictionary *)tmpDic
{
    NSMutableArray *arr = nil;
    arr = [[NSMutableArray alloc] init];
    if (tmpDic && [tmpDic isKindOfClass:[NSDictionary class]]) {
        Order_Model *modal = [Order_Model new];
        modal.id_ = tmpDic[@"id"];
        modal.orderStatus = [tmpDic[@"orderStatus"] integerValue];
        modal.orderPrice = [tmpDic[@"orderPrice"] doubleValue];
        modal.payTypeCode = tmpDic[@"payType"];
        modal.realPrice = [tmpDic[@"realPrice"] doubleValue];
        modal.code = tmpDic[@"code"];
        modal.oporaterName = tmpDic[@"managerName"];
        modal.customerName = tmpDic[@"customerName"];
        modal.saleCount = [tmpDic[@"productNumber"] intValue];
        modal.createTime = tmpDic[@"createTime"];
        NSMutableArray *typeArr = [NSMutableArray array];
        for (NSDictionary *typeDic in tmpDic[@"specs"]) {
            Standard_Modal *typeModel = [Standard_Modal new];
            typeModel.id_ = typeDic[@"productId"];
            typeModel.name = typeDic[@"productName"];
            typeModel.firstSpecName = typeDic[@"firstSpecName"];
            typeModel.productSpecPrice = [typeDic[@"specPrice"] doubleValue];
            typeModel.secondSpecName = typeDic[@"secondSpecName"];
            typeModel.realPrice = [typeDic[@"realPrice"] doubleValue];
            typeModel.saleCount = [typeDic[@"product_number"] intValue];
            
            [typeArr addObject:typeModel];
            
            modal.productId = typeDic[@"productId"];
            modal.productName = typeDic[@"productName"];
        }
        modal.productTypeArr = typeArr;
        
        [arr addObject:modal];
    }
    
    return arr;
}

//销售汇总
+ (NSMutableArray *)parserSaleTotalInfo:(NSDictionary *)tmpDic
{
    NSMutableArray *arr = nil;
    arr = [[NSMutableArray alloc] init];
    if (tmpDic && [tmpDic isKindOfClass:[NSDictionary class]]) {
        SaleTotal_Modal *modal = [SaleTotal_Modal new];
        modal.saleAmount = [tmpDic[@"saleAmount"] doubleValue];
        modal.orderCount = [tmpDic[@"orderNum"] doubleValue];
        modal.saleCount = [tmpDic[@"products"] intValue];
        
        
        [arr addObject:modal];
    }
    
    return arr;
}

//客户列表
+(NSMutableArray *)parserCustomerList:(NSDictionary *)dic
{
    NSMutableArray *arr = nil;
    if ( dic && [dic isKindOfClass:[NSArray class]] ) {
        arr = [[NSMutableArray alloc] init];
        NSArray *tmpArr = (NSArray *)dic;
        for ( NSDictionary *tmpDic in tmpArr ) {
            Customer_Modal *modal = [Customer_Modal new];
            modal.id_ = tmpDic[@"id"];
            modal.name = tmpDic[@"name"];
            modal.companyId = tmpDic[@"companyId"];
            modal.telphone = tmpDic[@"mobile"];
            modal.address = tmpDic[@"address"];
            modal.createTime = tmpDic[@"createTime"];
            modal.updateTime = tmpDic[@"updateTime"];
            
            [arr addObject:modal];
        }
    }
    return arr;
}

#pragma mark - Public

//公用部分，只需要获取code
+(NSMutableArray *)parserBaseReturnRestCode:(NSDictionary *)dic
{
    NSMutableArray *arr = [NSMutableArray array];
    Base_Modal *modal = [[Base_Modal alloc]init];
    
    if ([dic isKindOfClass:[NSString class]]) {
        modal.id_ = (NSString *)dic;
    }
    
    [arr addObject:modal];
    
    return arr;
}


@end

@implementation ExDataParser

@end

