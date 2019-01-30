//
//  RemindListView.m
//  TiHouse
//
//  Created by ccx on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "RemindListView.h"
#import "RemindListCell.h"

@interface RemindListView ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray * dataArray;
@property (assign, nonatomic) NSInteger selectRow;

@end

@implementation RemindListView

+ (instancetype)shareInstanceWithViewModel:(id<BaseViewModelProtocol>)viewModel {
    
    RemindListView * remindListView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] firstObject];
    
    [remindListView xl_setupViews];
    [remindListView xl_bindViewModel];
    
    return remindListView;
}

-(void)xl_setupViews {
    
    self.selectRow = -1;
    
    //tableView
    [self.tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

-(void)xl_bindViewModel {
    
    self.dataArray = [[NSArray alloc] initWithObjects:@"不提醒",@"事件开始时",@"提前5分钟",@"提前30分钟",@"提前1小时",@"提前1天",@"提前2天", nil];
    [self.tableView reloadData];
}

#pragma mark - UITableView Delegate

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.separatorInset = UIEdgeInsetsMake(0, 10, 0, 10);
    cell.layoutMargins = UIEdgeInsetsZero;
    cell.preservesSuperviewLayoutMargins = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString * cellID = @"RemindListCell";
    RemindListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RemindListCell" owner:nil options:nil] firstObject];
    }
    
    cell.titleLabel.text = self.dataArray[indexPath.row];
    if (indexPath.row == self.selectRow) {
        [cell.selectImg setHidden:NO];
    } else {
        [cell.selectImg setHidden:YES];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 55;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectRow = indexPath.row;
    [tableView reloadData];
    
    if (_SelectRemindBlock) {
        _SelectRemindBlock(self.dataArray[indexPath.row], indexPath.row + 1);
    }
}

#pragma mark - set fun
-(void)setScheduletiptype:(long)scheduletiptype {
    _scheduletiptype = scheduletiptype;
    
    self.selectRow = (NSInteger )self.scheduletiptype - 1;
    [self.tableView reloadData];
}

@end
