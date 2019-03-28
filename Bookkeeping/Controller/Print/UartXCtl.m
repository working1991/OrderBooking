//
//  UartXCtl.m
//  XZD
//
//  Created by sysweal on 15/1/22.
//  Copyright (c) 2015年 sysweal. All rights reserved.
//

#import "UartXCtl.h"



#import "Common.h"
#import "ManagerCtl.h"
#import "Config.h"

@interface UartXCtl ()

@property (nonatomic ,strong) HLPrinter *dataPrinter;

@end

@implementation UartXCtl

//打印
+(BOOL) print:(HLPrinter *)printer
{
    if ([SEPrinterManager sharedInstance].isConnected) {
        [self printInfo:printer];
    } else if([SEPrinterManager sharedInstance].connectedPerpheral) {
        [[SEPrinterManager sharedInstance] autoConnectLastPeripheralTimeout:10 completion:^(CBPeripheral *perpheral, NSError *error) {
            NSLog(@"自动重连返回");
            //因为自动重连后，特性还没扫描完，所以延迟一会开始写入数据
            [self performSelector:@selector(printInfo:) withObject:printer afterDelay:1.0];
        }];
        [self performSelector:@selector(printInfo:) withObject:printer afterDelay:1.0];
    } else {
        UartXCtl *ctl = [UartXCtl new];
        ctl.dataPrinter = printer;
        [[ManagerCtl getCurrentNav] pushViewController:ctl animated:YES];
    }
    
    return YES;
}

+ (BOOL)printInfo:(HLPrinter *)printer
{
    [BaseUIViewController showHUDView:@"打印中..." status:nil];
    NSData *mainData = [printer getFinalData];
    [[SEPrinterManager sharedInstance] sendPrintData:mainData completion:^(CBPeripheral *connectPerpheral, BOOL completion, NSString *error) {
        NSLog(@"写入结：%d---错误:%@",completion,error);
        [BaseUIViewController hideHUDView];
    }];
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView_.dataSource = self;
    self.tableView_.delegate = self;
    
    self.title = @"蓝牙未连接";
    SEPrinterManager *_manager = [SEPrinterManager sharedInstance];
    [_manager startScanPerpheralTimeout:10 Success:^(NSArray<CBPeripheral *> *perpherals,BOOL isTimeout) {
        NSLog(@"perpherals:%@",perpherals);
        _deviceArray = perpherals;
        [self.tableView_ reloadData];
    } failure:^(SEScanError error) {
        NSLog(@"error:%ld",(long)error);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([SEPrinterManager sharedInstance].connectedPerpheral) {
        self.title = [SEPrinterManager sharedInstance].connectedPerpheral.name;
    } else {
        [[SEPrinterManager sharedInstance] autoConnectLastPeripheralTimeout:10 completion:^(CBPeripheral *perpheral, NSError *error) {
            if (!error) {
                self.title = perpheral.name;
            }
            NSLog(@"自动重连返回");
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _deviceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"deviceId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    CBPeripheral *peripherral = [self.deviceArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"名称：%@",peripherral.name];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CBPeripheral *peripheral = [self.deviceArray objectAtIndex:indexPath.row];
    if (self.dataPrinter) {
        //如果你需要连接，立刻去打印
        [[SEPrinterManager sharedInstance] fullOptionPeripheral:peripheral completion:^(SEOptionStage stage, CBPeripheral *perpheral, NSError *error) {
            if (stage == SEOptionStageSeekCharacteristics) {
                [UartXCtl printInfo:self.dataPrinter];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    } else {
        [[SEPrinterManager sharedInstance] connectPeripheral:peripheral completion:^(CBPeripheral *perpheral, NSError *error) {
            if (error) {
                [SVProgressHUD showErrorWithStatus:@"连接失败"];
            } else {
                self.title = perpheral.name;
                [SVProgressHUD showSuccessWithStatus:@"连接成功"];
            }
        }];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
