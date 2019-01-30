//
//  SABaseViewController.m
//  TiHouse
//
//  Created by weilai on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SABaseViewController.h"

#import "SANumTitleTableViewCell.h"
#import "SANumContentTableViewCell.h"
#import "SAAnswerTableViewCell.h"
#import "SATitleTableViewCell.h"
#import "SingleArticleViewController.h"
#import "PosterMSubTableViewCell.h"
#import "ODRefreshControl.h"
#import <UIScrollView+EmptyDataSet.h>

#import "KnowledgeUtil.h"
#import "SAPageRequest.h"
#import "KnowledgeRequest.h"

@interface SABaseViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (strong, nonatomic) UITableView *tempTableView;

@property (nonatomic, assign) BOOL isShowEmptyView;

@end

@implementation SABaseViewController

- (instancetype)initWithKnowType:(KnowType)knowType knowTypeSub:(KnowTypeSub)knowTypeSub {
    if (self = [super init]) {
        _knowType = knowType;
        _knowTypeSub = knowTypeSub;
        
        _recordPageRequest = [self createRecordPageRequest];
    }
    return self;
}

#pragma mark - Getters & Setters

- (BasePageNetworkRequest *)createRecordPageRequest {
    return nil;
}

#pragma mark - private
- (void)setupTableView:(UITableView *)tableView {
    self.tempTableView = tableView;
    
    [self.tempTableView registerNib:[UINib nibWithNibName:@"SANumTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"SANumTitleTableViewCell"];
    [self.tempTableView registerNib:[UINib nibWithNibName:@"SANumContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"SANumContentTableViewCell"];
    [self.tempTableView registerNib:[UINib nibWithNibName:@"SAAnswerTableViewCell" bundle:nil] forCellReuseIdentifier:@"SAAnswerTableViewCell"];
    [self.tempTableView registerNib:[UINib nibWithNibName:@"SATitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"SATitleTableViewCell"];
    [self.tempTableView registerNib:[UINib nibWithNibName:@"PosterMSubTableViewCell" bundle:nil] forCellReuseIdentifier:@"PosterMSubTableViewCell"];
    self.tempTableView.backgroundColor = [UIColor clearColor];
    self.tempTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tempTableView.delegate = self;
    self.tempTableView.dataSource = self;
    self.tempTableView.emptyDataSetSource = self;
    self.tempTableView.emptyDataSetDelegate = self;
    self.tempTableView.allowsSelection = NO;
    
    _refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tempTableView];
    [_refreshControl addTarget:self action:@selector(refreshRecordList) forControlEvents:UIControlEventValueChanged];
}

- (void)loadNetworkData {
    [self getFirstRecordList];
}

- (void)refreshRecordList {
    [self getFirstRecordList];
}

- (void)getFirstRecordList {
    
    @weakify(self)
    [self.recordPageRequest reloadPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        [self.refreshControl endRefreshing];
        if (error) {
            [NSObject showHudTipStr:error.domain];
        }else {
            self.recordList = self.recordPageRequest.responseInfo.items;
            
        }
        self.isShowEmptyView = self.recordList.count == 0 ? YES : NO;
        [self.tempTableView reloadData];
    }];
}

- (void)getNextRecordList {
    
    @weakify(self)
    [self.recordPageRequest loadNextPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        if (error) {
            [NSObject showHudTipStr:error.domain];
        }else {
            self.recordList = self.recordPageRequest.responseInfo.items;
        }
        [self.tempTableView reloadData];
    }];
}


#pragma mark - DZNEmptyDataSetSource

///是否显示没有数据界面
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    
    return self.isShowEmptyView;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"暂无相关内容";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:RGB(191, 191, 191),
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma mark UITableViewDelegate

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.recordList ? self.recordList.count : 0;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_knowTypeSub == KnowTypeSub_Size) {
        KnowModeInfo *knowModeInfo = self.recordList[section];
        return knowModeInfo.isExpand ? 2 : 1;
        
    } else {
        return 1;
    }
    
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableViewCell = nil;
    
    KnowModeInfo *knowModeInfo = self.recordList[indexPath.section];
    
    switch (knowModeInfo.knowtype) {
        case KnowType_Poster: {
            PosterMSubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PosterMSubTableViewCell"];
            [cell refreshWithKnowModeInfo:knowModeInfo isFontBold:YES];
            
            WEAKSELF
            cell.clickItemBlock = ^(KnowModeInfo *knowModeInfo) {
                [weakSelf clickItem:knowModeInfo];
            };
            tableViewCell = cell;
        }
            break;
            
        case KnowType_SFurniture:
        case KnowType_SIndoor: {
            if (indexPath.row == 0) {
                SANumTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SANumTitleTableViewCell"];
                [cell refreshWithKnowModeInfo:self.recordList[indexPath.section] isFontBold:self.isFontBold];
                
                WEAKSELF
                cell.clickExpandBlock = ^(KnowModeInfo *knowModeInfo) {
                    [weakSelf clickExpand:knowModeInfo];
                };
                cell.clickItemBlock = ^(KnowModeInfo *knowModeInfo) {
                    [weakSelf clickItem:knowModeInfo];
                };
                cell.clickFavorBlock = ^(KnowModeInfo *knowModeInfo) {
                    [weakSelf clickFavor:knowModeInfo];
                };
                tableViewCell = cell;
                
            } else if (indexPath.row == 1) {
                SANumContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SANumContentTableViewCell"];
                [cell refreshWithKnowModeInfo:self.recordList[indexPath.section]];
                
//                WEAKSELF
//                cell.clickItemBlock = ^(KnowModeInfo *knowModeInfo) {
//                    [weakSelf clickItem:knowModeInfo];
//                };
                
                tableViewCell = cell;
            }
        }
            break;
            
        case KnowType_SLiveroom:
        case KnowType_SRestaurant:
        case KnowType_SRoom:
        case KnowType_SKitchen: {
            SAAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SAAnswerTableViewCell"];
            [cell refreshWithKnowModeInfo:self.recordList[indexPath.section] isFontBold:self.isFontBold];
            
            WEAKSELF
//            cell.clickItemBlock = ^(KnowModeInfo *knowModeInfo) {
//                [weakSelf clickItem:knowModeInfo];
//            };
            cell.clickFavorBlock = ^(KnowModeInfo *knowModeInfo) {
                [weakSelf clickFavor:knowModeInfo];
            };
            tableViewCell = cell;
        }
            break;
            
        case KnowType_FLiveroom:
        case KnowType_FRoom:
        case KnowType_FToilet:
        case KnowType_FKitchen:
        case KnowType_FRestaurant:
        case KnowType_FOther: {
            SATitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SATitleTableViewCell"];
            [cell refreshWithKnowModeInfo:self.recordList[indexPath.section] isFontBold:self.isFontBold];
            
            WEAKSELF
            cell.clickItemBlock = ^(KnowModeInfo *knowModeInfo) {
                [weakSelf clickItem:knowModeInfo];
            };
            cell.clickFavorBlock = ^(KnowModeInfo *knowModeInfo) {
                [weakSelf clickFavor:knowModeInfo];
            };
            tableViewCell = cell;
        }
            break;
            
        default:
            break;
    }
    
    
    return tableViewCell;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    KnowModeInfo *knowModeInfo = self.recordList[indexPath.section];
    switch (knowModeInfo.knowtype) {
        case KnowType_Poster: {
            return kRKBHEIGHT(86);
        }
            break;
            
        case KnowType_SFurniture:
        case KnowType_SIndoor: {
            if (indexPath.row == 0) {
                return kRKBHEIGHT(75);
            } else if (indexPath.row == 1) {
                KnowModeInfo *knowModeInfo = self.recordList[indexPath.section];
                return [SANumContentTableViewCell defaultHeight:knowModeInfo.knowcontentdown];
            }
        }
            break;
            
        case KnowType_SLiveroom:
        case KnowType_SRestaurant:
        case KnowType_SRoom:
        case KnowType_SKitchen: {
            KnowModeInfo *knowModeInfo = self.recordList[indexPath.section];
            NSString *content = knowModeInfo.knowtitlesub.length == 0 ? knowModeInfo.knowcontentdown : [NSString stringWithFormat:@"%@\n%@", knowModeInfo.knowtitlesub, knowModeInfo.knowcontentdown];
            
            return [SAAnswerTableViewCell defaultHeight:content];
        }
            break;
            
        case KnowType_FLiveroom:
        case KnowType_FRoom:
        case KnowType_FToilet:
        case KnowType_FKitchen:
        case KnowType_FRestaurant:
        case KnowType_FOther:
            return kRKBHEIGHT(75);
            break;
            
        default:
            break;
    }
    
    return 0;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (_knowTypeSub == KnowTypeSub_Size) {
        return kRKBHEIGHT(8);
    } else {
        return 0.1;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (_knowTypeSub == KnowTypeSub_Size) {
        UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tempTableView.bounds.size.width, kRKBHEIGHT(8))];
        sectionView.backgroundColor = [UIColor clearColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRGBHex:0xF2F3F5];
        
        [sectionView addSubview:line];
        
        return sectionView;
        
    } else {
        return nil;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)clickExpand:(KnowModeInfo *)knowModeInfo {
    NSInteger section = [self.recordList indexOfObject:knowModeInfo];
    [self.tempTableView reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    
    if (section == self.recordList.count - 1) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
        [[self tempTableView] scrollToRowAtIndexPath:indexPath
                                atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
    
    
}

- (void)clickItem:(KnowModeInfo *)knowModeInfo {
    SingleArticleViewController *viewController = [[SingleArticleViewController alloc] initWithKnowModeInfo:knowModeInfo];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)clickFavor:(KnowModeInfo *)knowModeInfo {
    if (knowModeInfo.knowiscoll) {
        WEAKSELF
        [KnowledgeRequest removeKnowledgeFavor:knowModeInfo.knowid handler:^(id result, NSError *error) {
            if (!error) {
                GBResponseInfo *info = result;
                [NSObject showHudTipStr:weakSelf.view tipStr:info.msg];
                
                knowModeInfo.knowiscoll = NO;
                knowModeInfo.knownumcoll -= 1;
                [weakSelf.tempTableView reloadData];
            }
        }];
        
    } else {
        WEAKSELF
        [KnowledgeRequest addKnowledgeFavor:knowModeInfo.knowid handler:^(id result, NSError *error) {
            if (!error) {
                GBResponseInfo *info = result;
                [NSObject showHudTipStr:weakSelf.view tipStr:info.msg];
                
                knowModeInfo.knowiscoll = YES;
                knowModeInfo.knownumcoll += 1;
                
                [weakSelf.tempTableView reloadData];
            }
        }];
    }
}

@end
