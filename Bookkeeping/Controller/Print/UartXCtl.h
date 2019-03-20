//
//  UartXCtl.h
//  XZD
//
//  Created by sysweal on 15/1/22.
//  Copyright (c) 2015年 sysweal. All rights reserved.
//

#import "BaseUIViewController.h"
#import "SEPrinterManager.h"
#import "SVProgressHUD.h"
#import "UartXCtl_Cell.h"

@interface UartXCtl : BaseUIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic)   NSArray              *deviceArray;  /**< 蓝牙设备个数 */
@property(nonatomic,weak)   IBOutlet    UITableView *tableView_;
@property(nonatomic,strong)   NSArray         *printArr;

//打印
+(BOOL) print:(HLPrinter *)printer;


@end
