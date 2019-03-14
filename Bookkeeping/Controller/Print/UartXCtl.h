//
//  UartXCtl.h
//  XZD
//
//  Created by sysweal on 15/1/22.
//  Copyright (c) 2015年 sysweal. All rights reserved.
//

#import "BaseUIViewController.h"
#import "UartLib.h"
#import "UartXCtl_Cell.h"

#define DBKey_LastConnectedDevice           @"last_connect_device"

#define TimeOut_ConnectPrint                8.0

//通知Key
#define Notify_UartX_Connected              @"uartX_connected"
#define Notify_UartX_Disconnected           @"uartX_disconnected"

@interface TmpClass : NSObject<CBCentralManagerDelegate>

@property(nonatomic,strong)   NSArray *printArr;

@end

@interface UartXCtl : BaseUIViewController<UartDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UartLib *uartLib;
    NSMutableArray  *dataArr;
    
    CBPeripheral    *connectedPeripheral;
}

@property(nonatomic,weak)   IBOutlet    UILabel     *promptLb_;
@property(nonatomic,weak)   IBOutlet    UITableView *tableView_;
@property(nonatomic,strong)   NSArray         *printArr;

//默认的
+(UartXCtl *) defaultUartXCtl;

//显示
+(void) show;

//打印
+(BOOL) print:(NSArray *)arr bReprint:(BOOL)bReprint;

-(void) check;

//开始扫描
-(void) startScan;

//停止扫描
-(void) stopScan;

//清空
-(void) clear;

//打印
-(BOOL) printStr:(NSString *)valueStr;

//获取已经连接的周边
-(CBPeripheral *) getConnectedPeripheral;

@property(weak, nonatomic) IBOutlet UILabel *auto_651_label;
@property(weak, nonatomic) IBOutlet UILabel *auto_652_label;
@end