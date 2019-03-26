//
//  Standard_Modal.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/20.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "Standard_Modal.h"

@implementation Standard_Modal

-(id)mutableCopyWithZone:(NSZone *)zone
{
    Standard_Modal *copy= [Standard_Modal allocWithZone:zone];
    
    copy.id_=[self.id_ copyWithZone:zone];
    copy.name = self.name;
    copy.code = self.code;
    copy.des = self.des;
    copy.imgUrl = self.imgUrl;
    copy.companyId = self.companyId;
    copy.unitPrice = self.unitPrice;
    copy.typeArr = [NSArray arrayWithArray:self.typeArr];
    
    copy.firstSpecId = self.firstSpecId;
    copy.firstSpecName = self.firstSpecName;
    copy.productReSpecId = self.productReSpecId;
    copy.secondSpecName = self.secondSpecName;
    copy.productSpecPrice = self.productSpecPrice;
    copy.saleCount = self.saleCount;
    copy.realPrice = self.realPrice;
    
    return copy;
}

@end
