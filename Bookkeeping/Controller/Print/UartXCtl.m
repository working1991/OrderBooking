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

static CBCentralManager *tmpMgr;
static TmpClass        *tmpCls;

@implementation TmpClass

@synthesize printArr;

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    CBCentralManagerState state = central.state;
    NSLog(@"state=%d",state);
    
    if( state != CBCentralManagerStatePoweredOn ){
        [BaseUIViewController showAlertView:NSLocalizedString(@"蓝牙异常", nil) msg:[NSString stringWithFormat:NSLocalizedString(@"请确保蓝牙开关已经打开并授权以及支持蓝牙4.0 蓝牙状态:%d", nil),state] cancel:NSLocalizedString(@"确定", nil)];
    }else{
        [BaseUIViewController showHUDView:NSLocalizedString(@"连接打印机中...", nil) status:nil];
        
        //开始连接打印机
        UartXCtl *ctl = [UartXCtl defaultUartXCtl];
        ctl.printArr = tmpCls.printArr;
        [ctl startScan];
        
        [ctl performSelector:@selector(check) withObject:nil afterDelay:TimeOut_ConnectPrint];
    }
    
    tmpMgr = nil;
    tmpCls = nil;
}

@end

@interface UartXCtl ()

@end

@implementation UartXCtl

@synthesize promptLb_,tableView_,printArr;

//默认的
+(UartXCtl *) defaultUartXCtl
{
    static UartXCtl *myUartXCtl = nil;
    if( !myUartXCtl ){
        myUartXCtl = [[UartXCtl alloc] init];
    }
    return myUartXCtl;
}

//显示
+(void) show
{
    UartXCtl *ctl = [UartXCtl defaultUartXCtl];
    ctl.printArr = nil;
    [ctl startScan];
    
    UINavigationController *nav = [ManagerCtl getNav:ctl barHidden:NO];
    nav.modalPresentationStyle = UIModalPresentationFormSheet;
    //nav.modalPresentationStyle = [];
    [[ManagerCtl getCurrentNav] presentViewController:nav animated:YES completion:^{
        //nav.view.superview.frame = CGRectMake(0, 0, 200, 200);
        //[ctl beginLoad:nil exParam:nil];
    }];
}

//打印
+(BOOL) print:(NSArray *)arr bReprint:(BOOL)bReprint
{
    [[UartXCtl defaultUartXCtl] clear];
    for (NSString *str in arr ) {
        [MyLog Log:str obj:nil];
    }
    
    tmpCls = [[TmpClass alloc] init];
    tmpCls.printArr = arr;
    tmpMgr = [[CBCentralManager alloc] initWithDelegate:tmpCls queue:nil];
    
    return YES;
}

-(void) check
{
    if( printArr ){
        [BaseUIViewController hideHUDView];
        [self showChooseAlertViewCtl:@"无法连接打印机" msg:@"是否立即查看打印机连接状态" okBtnTitle:@"查看" cancelBtnTitle:@"取消" confirmHandle:^{
            [UartXCtl show];
        } cancleHandle:nil];
        
        self.printArr = nil;
        [self clear];
    }
}

-(id) init
{
    self = [super init];
    self.title = NSLocalizedString(@"连接打印机", nil);
    leftBarStr_ = NSLocalizedString(@"取消", nil);
    rightBarStr_ = NSLocalizedString(@"重新扫描", nil);
    
    dataArr = [[NSMutableArray alloc] init];
    
#if !TARGET_IPHONE_SIMULATOR
    uartLib = [[UartLib alloc] init];
    [uartLib setUartDelegate:self];
#endif

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [tableView_ registerNib:[UINib nibWithNibName:@"UartXCtl_Cell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UartXCtl_Cell"];
    
    tableView_.delegate = self;
    tableView_.dataSource = self;
    
    [self updateCom];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) dealloc
{
    [self stopScan];
    
    //断开所有的连接
    for ( CBPeripheral *peripheral in dataArr ) {
        [self disconnect:peripheral];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) updateCom
{
    if( connectedPeripheral ){
        promptLb_.text = connectedPeripheral.name ? connectedPeripheral.name : [NSString stringWithFormat:@"%@...",[[connectedPeripheral.identifier UUIDString] substringToIndex:10]];
    }else{
        promptLb_.text = NSLocalizedString(@"暂无", nil);
    }
}

//开始扫描
-(void) startScan
{
#if !TARGET_IPHONE_SIMULATOR
    [uartLib scanStart];
#endif
}

//停止扫描
-(void) stopScan
{
#if !TARGET_IPHONE_SIMULATOR
    [uartLib scanStop];
#endif
}

//清空
-(void) clear
{
    [self stopScan];
    
    connectedPeripheral = nil;
    //断开所有的连接
    for ( CBPeripheral *peripheral in dataArr ) {
        [self disconnect:peripheral];
    }
    [dataArr removeAllObjects];
    [tableView_ reloadData];
    [self updateCom];
}

//打印
-(BOOL) printStr:(NSString *)valueStr
{
    BOOL flag = NO;
    
    if( connectedPeripheral ){
        flag = YES;
        
        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000);
        
        NSData *aa = [valueStr dataUsingEncoding:enc];
        [uartLib sendValue:connectedPeripheral sendData:aa type:CBCharacteristicWriteWithResponse];
    }
    
    return flag;
}

//获取已经连接的周边
-(CBPeripheral *) getConnectedPeripheral
{
    return connectedPeripheral;
}

//连接某设备
-(void) connect:(CBPeripheral *)peripheral
{
    if( peripheral )
        [uartLib connectPeripheral:peripheral];
}

//断开连接某设备
-(void) disconnect:(CBPeripheral *)peripheral
{
    if( peripheral )
        [uartLib disconnectPeripheral:peripheral];
}

#pragma UITableViewDataSource/UITableViewDelegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArr count];
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UartXCtl_Cell *myCell = [tableView dequeueReusableCellWithIdentifier:@"UartXCtl_Cell" forIndexPath:indexPath];
    //myCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //myCell.accessoryType = UITableViewCellAccessoryNone;
    
    CBPeripheral *peripheral = [dataArr objectAtIndex:indexPath.row];
    if( peripheral.state == CBPeripheralStateConnected ){
        myCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [myCell.indicatorView_ stopAnimating];
    }else if( peripheral.state == CBPeripheralStateConnecting ){
        myCell.accessoryType = UITableViewCellAccessoryNone;
        [myCell.indicatorView_ startAnimating];
    }else{
        myCell.accessoryType = UITableViewCellAccessoryNone;
        [myCell.indicatorView_ stopAnimating];
    }
    myCell.nameLb_.text = peripheral.name ? peripheral.name : [peripheral.identifier UUIDString];
    
    return myCell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBPeripheral *peripheral = [dataArr objectAtIndex:indexPath.row];
    if( peripheral.state == CBPeripheralStateDisconnected ){
        //断开其它的连接
        for ( CBPeripheral *peripheral in dataArr ) {
            [self disconnect:peripheral];
        }
        
        //置空最近连接设备
        [BaseConfig setDBValueByKey:DBKey_LastConnectedDevice value:@""];
        
        //开始连接此设备
        [self connect:peripheral];
    
        [self refreshTableView];
    }
}

-(void) refreshTableView
{
    double delayInSeconds = 0.3f;//allow enough time for progress to animate
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^(void){
        //刷新列表
        [tableView_ reloadData];
    });
}

-(void) rightBarBtnResponse:(id)sender
{
    [self clear];
    [self startScan];
}

-(void) leftBarBtnResponse:(id)sender
{
    [self clear];
    [super leftBarBtnResponse:sender];
}

Byte calculateXor(Byte *pcData, Byte ucDataLen){
    Byte ucXor = 0;
    Byte i;
    
    for (i=0; i<ucDataLen; i++) {
        ucXor ^= *(pcData+i);
    }
    
    return ucXor;
}

#pragma mark -
#pragma mark UartDelegate
/****************************************************************************/
/*                       UartDelegate Methods                        */
/****************************************************************************/
- (void) didScanedPeripherals:(NSMutableArray  *)foundPeripherals;
{
    NSLog(@"didScanedPeripherals(%lu)", (unsigned long)[foundPeripherals count]);
    
    /*
     CBPeripheral	*peripheral;
     
     for (peripheral in foundPeripherals) {
     NSLog(@"--Peripheral:%@", [peripheral name]);
     }
     
     if ([foundPeripherals count] > 0) {
     connectPeripheral = [foundPeripherals objectAtIndex:0];
     if ([connectPeripheral name] == nil) {
     [[self peripheralName] setText:@"BTCOM"];
     }else{
     [[self peripheralName] setText:[connectPeripheral name]];
     }
     }else{
     [[self peripheralName] setText:nil];
     connectPeripheral = nil;
     }
     */
}

- (void) didConnectPeripheral:(CBPeripheral *)peripheral{
    NSLog(@"did Connect Peripheral");

    NSLog(@"===>%@",[peripheral.identifier UUIDString]);
    
    //记住该值
    if( [peripheral.identifier UUIDString] )
        [BaseConfig setDBValueByKey:DBKey_LastConnectedDevice value:[peripheral.identifier UUIDString]];
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_UartX_Connected object:nil userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:peripheral,@"obj", nil]];
    
    //将以前的连接断掉
    [self disconnect:connectedPeripheral];
    connectedPeripheral = peripheral;
    
    //开始打印
    if( [printArr count] > 0){
        [BaseUIViewController hideHUDView];
        
        for ( NSString *str in printArr ) {
            [self printStr:str];
        }
        
        printArr = nil;
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(check) object:nil];
        
        //将连接停掉
//        [self clear];
    }
    
    [self updateCom];
    [self refreshTableView];
}

- (void) didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"did Disconnect Peripheral");
    
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:Notify_UartX_Disconnected object:nil userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:peripheral,@"obj", nil]];
    
    connectedPeripheral = nil;
    [self updateCom];
    [tableView_ reloadData];
}

- (void) didWriteData:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"didWriteData:%@", [peripheral name]);
}

- (void) didReceiveData:(CBPeripheral *)peripheral recvData:(NSData *)recvData
{
    NSLog(@"uart recv(%lu):%@", (unsigned long)[recvData length], recvData);
    [self promptDisplay:recvData];
}

- (void) didDiscoverPeripheralAndName:(CBPeripheral *)peripheral DevName:(NSString *)devName{
    NSLog(@"pripheral name:%@", [peripheral name]);
    
    if( peripheral /*&& peripheral.name*/ ){
        //判断是否需要自动连接此设备
        NSString *deviceId = [BaseConfig getDBValueByKey:DBKey_LastConnectedDevice];
        if( deviceId && [deviceId isEqualToString:[peripheral.identifier UUIDString]] ){
            //自动连接
            [self connect:peripheral];
        }
        
        //是否是已有设备
        BOOL bAdd = NO;
        for ( CBPeripheral  *tmpPeripheral in dataArr ) {
            if( tmpPeripheral == peripheral ){
                bAdd = YES;
                break;
            }
        }
        if( !bAdd ){
            @try {
                CBPeripheral *tmpPeripheral = [dataArr objectAtIndex:0];
                //没连接时，插到第一条，否则插到第二条
                if( tmpPeripheral.state == CBPeripheralStateDisconnected ){
                    [dataArr insertObject:peripheral atIndex:0];
                    [tableView_ insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                }else{
                    [dataArr insertObject:peripheral atIndex:1];
                    [tableView_ insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                }
            }
            @catch (NSException *exception) {
                [dataArr addObject:peripheral];
                [tableView_ insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            }
            @finally {
                
            }
        }
    }
    
//    if (peripheral != nil) {
//        connectPeripheral = peripheral;
//        if (devName == nil) {
//            //[[self peripheralName] setText:@"BTCOM"];
//        }else{
//            //[[self peripheralName] setText:devName];
//        }
//    }else{
//        //[[self peripheralName] setText:nil];
//        connectPeripheral = nil;
//    }
}

- (void) didBluetoothPoweredOn{
    NSLog(@"didBluetoothPoweredOn");
}

- (void) didBluetoothPoweredOff{
    NSLog(@"didBluetoothPoweredOff");
}


- (void) didRetrievePeripheral:(NSArray *)peripherals{
    
}

- (void) didRecvRSSI:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI{
    
}
- (void) didDiscoverPeripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI{
    
}

#pragma mark -
#pragma mark tools function
- (void) promptDisplay:(NSData *)recvData{
    //NSString *prompt;
    
    NSString *hexStr=@"";
    
    // hexStr = [[NSString alloc] initWithData:recvData encoding:NSASCIIStringEncoding];
    ///*
    Byte *hexData = (Byte *)[recvData bytes];
    
    for(int i=0; i<[recvData length];i++)
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",hexData[i]&0xff];///16进制数
        if([newHexStr length]==1)
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        else
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    // */
    //    if ([[[self recvDataView] text] length] > 0) {
    //        if (hexStr) {
    //            prompt = [[NSString alloc]initWithFormat:@"R:%@\r\n%@", hexStr, [[self recvDataView] text]];
    //        }
    //    }else {
    //        if (hexStr) {
    //            prompt = [[NSString alloc]initWithFormat:@"R:%@\r\n", hexStr];
    //        }
    //    }
    //
    //    NSLog(@"%@", prompt);
    //    [[self recvDataView] setText:prompt];
}

- (void)initTextXib
{
     [super initTextXib];
    
    self.auto_652_label.text = NSLocalizedString(@"查找中,请确认Pad蓝牙已打开", nil);

    self.auto_651_label.text = NSLocalizedString(@"已连接设备：", nil);

     
}
@end
