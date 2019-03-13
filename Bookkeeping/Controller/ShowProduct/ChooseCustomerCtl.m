//
//  ChooseCustomerCtl.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/13.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "ChooseCustomerCtl.h"

@interface ChooseCustomerCtl ()

@property (strong, nonatomic) void (^finished)(Base_Modal *);

@end

@implementation ChooseCustomerCtl

- (instancetype)initWithFinish:(void(^)(Base_Modal *))finished
{
    self = [super init];
    if (self) {
        self.finished = finished;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.finished) {
        self.finished(nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
