//
//  Product_Modal.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/18.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "Product_Modal.h"

@implementation Product_Modal

-(id)mutableCopyWithZone:(NSZone *)zone
{
    Product_Modal *copy= [Product_Modal allocWithZone:zone];
    
    copy.id_=[self.id_ copyWithZone:zone];
    copy.name = self.name;
    copy.code = self.code;
    copy.des = self.des;
    copy.imgUrl = self.imgUrl;
    copy.companyId = self.companyId;
    copy.unitPrice = self.unitPrice;
    
    copy.typeArr = [NSArray arrayWithArray:self.typeArr];

    return copy;
}

@end
