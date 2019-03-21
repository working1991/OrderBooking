//
//  TypeListCtl.m
//  Bookkeeping
//
//  Created by BaiYun004 on 2019/3/20.
//  Copyright © 2019 luoqw. All rights reserved.
//

#import "TypeListCtl.h"
#import "ChooseStandardCell.h"
#import "Standard_Modal.h"

@interface TypeListCtl ()

{
    NSArray *sourceArr;
}

@end

@implementation TypeListCtl

- (instancetype)init
{
    self = [super init];
    if (self) {
        bHeadRefresh_ = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.tableView_ registerNib:[UINib nibWithNibName:NSStringFromClass([ChooseStandardCell class]) bundle:[NSBundle mainBundle]] forCellReuseIdentifier:NSStringFromClass([ChooseStandardCell class])];
}

- (void)beginLoad:(id)dataModal exParam:(id)exParam
{
    if ([exParam isKindOfClass:[NSArray class]]) {
        sourceArr = (NSArray *)exParam;
        [self.tableView_ reloadData];
    }
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return sourceArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 90;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseStandardCell *myCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ChooseStandardCell class]) forIndexPath:indexPath];
    
    Standard_Modal *model = sourceArr[indexPath.row];
    myCell.minNum = 0;
    myCell.nameLb.text = [NSString stringWithFormat:@"尺码：%@", model.secondSpecName];
    myCell.originalPriceLb.hidden = YES;
    myCell.priceLb.text = [NSString stringWithFormat:@"¥%.2lf元/件", model.productSpecPrice];
    [myCell updateNum:model.saleCount];
    myCell.numChange = ^(int currentNum) {
        model.saleCount = currentNum;
    };
    
    return myCell;
}


@end
