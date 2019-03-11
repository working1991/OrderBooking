//
//  ShowProductCtl.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/11.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "ShowProductCtl.h"

@interface ShowProductCtl ()

@end

@implementation ShowProductCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.title = @"首页";
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
