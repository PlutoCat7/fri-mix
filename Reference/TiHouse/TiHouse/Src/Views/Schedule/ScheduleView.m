//
//  ScheduleView.m
//  TiHouse
//
//  Created by 陈晨昕 on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ScheduleView.h"
#import "ScheduleOptionsView.h"
#import "ScheduleViewModel.h"
#import "UITableView+RegisterNib.h"
#import "ScheduleListHeaderView.h"
#import "ScheduleListTipTableViewCell.h"
#import "ScheduleListTableViewCell.h"
#import "Login.h"
#import <UIScrollView+EmptyDataSet.h>

@interface ScheduleView ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UIGestureRecognizerDelegate,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


@property (nonatomic, strong) ScheduleOptionsView *scheduleOptionsV;

@property (nonatomic, strong) ScheduleViewModel *viewModel;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ScheduleView

- (instancetype)initWithViewModel:(id<BaseViewModelProtocol>)viewModel{
    
    _viewModel = (ScheduleViewModel *)viewModel;
    
    return [super initWithViewModel:viewModel];
}

- (void)xl_bindViewModel{
    [self.viewModel.refreshDataCommand execute:nil];
    @weakify(self);
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self);
        
        NSLog(@"%@",self.viewModel.result);
        
    }];
    [self.viewModel.scheduleOptionsViewModel.reloadData subscribeNext:^(id x) {
        @strongify(self);
        self.viewModel.currentPage = 0;
        self.viewModel.params = [self.viewModel getParamWithPage:self.viewModel.currentPage];
        [self.viewModel.refreshDataCommand execute:nil];
    }];
    
    //刷新结束->网络请求数据回来
    [self.viewModel.refreshEndSubject subscribeNext:^(id x) {
        @strongify(self);
        
        id object = self.viewModel.result;
        if ([object[@"is"] integerValue] != 1) {
            [NSObject showHudTipStr:object[@"msg"]];
            [self.tableView.mj_header endRefreshing];
//            [self.tableView.mj_footer endRefreshing];
            return ;
        }
        
        //判断下载数据是否有更多
        switch ([x integerValue]) {
            case XLHeaderRefresh_HasMoreData: {
                self.viewModel.arrSysData = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ScheduleModel class] json:self.viewModel.result[@"data"]]];
                [self.tableView.mj_header endRefreshing];
                
////                加载更多
//                self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//                    self.viewModel.params = [self.viewModel getParamWithPage:self.viewModel.currentPage+ 1];//下一页
//                    [self.viewModel.nextPageCommand execute:nil];
//                }];
            }
                break;
            case XLHeaderRefresh_HasNoMoreData: {
                
                self.viewModel.arrSysData = [NSMutableArray arrayWithArray:[NSArray yy_modelArrayWithClass:[ScheduleModel class] json:self.viewModel.result[@"data"]]];
                [self.tableView.mj_header endRefreshing];
                self.tableView.mj_footer = nil;
                
            }
                break;
            case XLFooterRefresh_HasMoreData: {
                
//                [self.tableView.mj_footer resetNoMoreData];
//                [self.tableView.mj_footer endRefreshing];
                [self.viewModel.arrSysData addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ScheduleModel class] json:self.viewModel.result[@"data"]]];
                self.viewModel.arrSysData = self.viewModel.arrSysData;
            }
                break;
            case XLFooterRefresh_HasNoMoreData: {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
                [self.viewModel.arrSysData addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ScheduleModel class] json:self.viewModel.result[@"data"]]];
                self.viewModel.arrSysData = self.viewModel.arrSysData;
            }
                break;
            case XLRefreshError: {
                
//                [self.tableView.mj_footer endRefreshing];
                [self.tableView.mj_header endRefreshing];
                [self.viewModel.arrSysData addObjectsFromArray:[NSArray yy_modelArrayWithClass:[ScheduleModel class] json:self.viewModel.result[@"data"]]];//[@"list"]
                self.viewModel.arrSysData = self.viewModel.arrSysData;
            }
                break;
                
            default:
                break;
        }
        
        [self.tableView reloadData];
   
        
        NSInteger sectionIndex = 0;
        NSInteger shouldContinue = YES;
        NSInteger resultTime = [self.viewModel.result[@"time"] integerValue];
        for (int i = 0 ; i < self.viewModel.arrSectionData.count; i++)
        {
            NSDictionary *tmpDic = self.viewModel.arrSectionData[i];
            NSArray *tmpArray = tmpDic[kScheduleList];
            if (shouldContinue)
            {
                for (int j = 0; j < tmpArray.count; j++)
                {
                    ScheduleModel *shceduleModel = tmpArray[j]; 
                    if (shceduleModel.schedulestarttime == resultTime)
                    {
                        sectionIndex = i;
                        shouldContinue = NO;
                        break;
                    }
                    else if (shceduleModel.schedulestarttime > resultTime)
                    {
                        sectionIndex = i;
                        shouldContinue = NO;
                        break;
                    }
                }
            }
        }
        
        if (sectionIndex < self.viewModel.arrSectionData.count)
        {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:sectionIndex] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
        }
    }];
}



- (void)xl_setupViews{
    [self addSubview:self.tableView];
    [self addSubview:self.scheduleOptionsV];
    [self tableVConfig];
    
    [self updateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)tableVConfig{
    
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedSectionFooterHeight = 0.1;
    }
    WS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.viewModel.params = [weakSelf.viewModel getParamWithPage:0];
        weakSelf.viewModel.currentPage = 0;
        [weakSelf.viewModel.refreshDataCommand execute:nil];
    }];
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        weakSelf.viewModel.params = [weakSelf.viewModel getParamWithPage:self.viewModel.currentPage+ 1];//下一页
//        [weakSelf.viewModel.nextPageCommand execute:nil];
//
//    }];
    
    [self.tableView registerNibName:NSStringFromClass([ScheduleListTableViewCell class])];
    [self.tableView registerNibName:NSStringFromClass([ScheduleListTipTableViewCell class])];
    
    [self.tableView registerClass:[ScheduleListHeaderView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([ScheduleListHeaderView class])];
    
}

- (void)updateConstraints{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(35);
    }];
    
    [super updateConstraints];
}

- (ScheduleOptionsView *)scheduleOptionsV{
    if (!_scheduleOptionsV) {
        _scheduleOptionsV = [ScheduleOptionsView sharedInstanceWithViewModel:self.viewModel.scheduleOptionsViewModel];
    }
    return _scheduleOptionsV;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"0xf8f8f8"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
    }
    return _tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.viewModel.arrSectionData.count;
    //    return self.viewModel.arrSysData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSMutableDictionary *dictM = self.viewModel.arrSectionData[section];
    NSMutableArray *arr = dictM[kScheduleList];
    
    return arr.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    ScheduleListHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([ScheduleListHeaderView class])];
    NSMutableDictionary *dictM = self.viewModel.arrSectionData[section];
    
    view.strDate = dictM[kDate];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSMutableDictionary *dictM = self.viewModel.arrSectionData[indexPath.section];
    NSMutableArray *arr = dictM[kScheduleList];
    
    ScheduleModel *sModel = arr[indexPath.row];
    
    /* 提醒谁看隐藏
    if (sModel.scheduleremark.length>0 || sModel.urlschedulearruidtip.length>0) {
        ScheduleListTipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ScheduleListTipTableViewCell class]) forIndexPath:indexPath];
        cell.sModel = sModel;
        
        return cell;
    }else {
        ScheduleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ScheduleListTableViewCell class]) forIndexPath:indexPath];
        cell.sModel = sModel;
        return cell;
    }
     */
    if (sModel.scheduleremark.length > 0) {
        ScheduleListTipTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ScheduleListTipTableViewCell class]) forIndexPath:indexPath];
        cell.sModel = sModel;
        
        return cell;
    }else {
        ScheduleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ScheduleListTableViewCell class]) forIndexPath:indexPath];
        cell.sModel = sModel;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dictM = self.viewModel.arrSectionData[indexPath.section];
    NSMutableArray *arr = dictM[kScheduleList];
    
    ScheduleModel *sModel = arr[indexPath.row];
    
    /* 提醒谁看隐藏
    if (sModel.scheduleremark.length>0 || sModel.urlschedulearruidtip.length>0) {
        return 100;
    }
     */
    if (sModel.scheduleremark.length > 0) {
        return 100;
    }
    
    return 70;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary *dictM = self.viewModel.arrSectionData[indexPath.section];
    NSMutableArray *arr = dictM[kScheduleList];
    
    ScheduleModel *sModel = arr[indexPath.row];
    
    [self.viewModel.cellClickSubject sendNext:sModel];
}

//侧滑允许编辑cell
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSMutableDictionary *dictM = self.viewModel.arrSectionData[indexPath.section];
    NSMutableArray *arr = dictM[kScheduleList];
    
    ScheduleModel *sModel = arr[indexPath.row];
    
    User *user = [Login curLoginUser];
    
    if (user.uid == sModel.uid) {
        return YES;
    } else{
        return NO;
    }
}
////执行删除操作
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    NSMutableDictionary *dictM = self.viewModel.arrSectionData[indexPath.section];
//    NSMutableArray *arr = dictM[kScheduleList];
//
//    ScheduleModel *sModel = arr[indexPath.row];
//
//    self.viewModel.deleteScheduleId = sModel.scheduleid;
//    [self showAlertTip];
//}
////侧滑出现的文字
//- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return @"删除";
//}

/**
 *  左滑cell时出现什么按钮
 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dictM = self.viewModel.arrSectionData[indexPath.section];
    NSMutableArray *arr = dictM[kScheduleList];
    
    __block ScheduleModel *m = arr[indexPath.row];
    WS(weakSelf);

    UITableViewRowAction *action0 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"已完成" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        if (m.scheduletype == 1) {
            return ;
        }
        weakSelf.viewModel.deleteScheduleId = m.scheduleid;
        
        [weakSelf.viewModel requestFinishSchedule:^(BOOL status) {
            if (status) {
                //重新请求列表
                weakSelf.viewModel.currentPage = 0;
                weakSelf.viewModel.params = [weakSelf.viewModel getParamWithPage:0];
                [weakSelf.viewModel.refreshDataCommand execute:nil];
            }
            
        }];
        // 收回左滑出现的按钮(退出编辑模式)
        tableView.editing = NO;
    }];
    
    action0.backgroundColor = RGB(187, 187, 187);
    
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        weakSelf.viewModel.deleteScheduleId = m.scheduleid;
        
        [self showAlertTip];
        
        // 收回左滑出现的按钮(退出编辑模式)
        tableView.editing = NO;
    }];
    if (m.scheduletype == 0) {
        return @[action1, action0];
    }
    return @[action1];
}





- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}


- (void)showAlertTip{
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"" message:@"确定要将事项从日程中删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertV show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        WS(weakSelf);
        [self.viewModel requestDeleteSchedule:^(BOOL status) {
            if (status) {
                //重新请求列表
                weakSelf.viewModel.currentPage = 0;
                weakSelf.viewModel.params = [weakSelf.viewModel getParamWithPage:0];
                [weakSelf.viewModel.refreshDataCommand execute:nil];
            }
        }];
    }
}

#pragma mark - DZNEmptyDataSetSource

///是否显示没有数据界面
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    
    if (self.viewModel.arrSysData.count<1) {
        return YES;
    }
    return NO;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"暂无相关内容";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"0xbfbfbf"],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

