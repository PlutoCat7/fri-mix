//
//  AllSearchViewController.m
//  TiHouse
//
//  Created by weilai on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "AllSearchViewController.h"

#import "SearchHistoryCell.h"
#import "SANumTitleTableViewCell.h"
#import "SANumContentTableViewCell.h"
#import "SAAnswerTableViewCell.h"
#import "SATitleTableViewCell.h"
#import "PosterMSubTableViewCell.h"
#import "SingleArticleViewController.h"
#import "SASearchViewController.h"
#import "TagView.h"
#import "SearchMoreView.h"
#import <UIScrollView+EmptyDataSet.h>

#import "AllSearchPageRequest.h"
#import "KnowledgeRequest.h"
#import "KSearchManager.h"

@interface AllSearchViewController ()<UITextFieldDelegate, TagViewDelegate, UITableViewDelegate, UITableViewDataSource, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (weak, nonatomic) IBOutlet UITableView *thinkTableView;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelTrailing;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateBarHeightLayout;

@property (strong, nonatomic) UIView *setionHeader;
@property (strong, nonatomic) TagView *tagView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *searchLabel;
@property (strong, nonatomic) UIButton *clearBtn;

@property (strong, nonatomic) KSearchManager       *searchManager;
@property (strong, nonatomic) NSArray<KnowLabelInfo *> *assWordsArray;

@property (strong, nonatomic) AllSearchPageRequest *recordPageRequest;
@property (nonatomic, strong) NSArray<NSString *> *keyArray;
@property (strong, nonatomic) NSMutableArray<NSMutableArray<KnowModeInfo *> *> *resultArray;

@property (nonatomic, assign) BOOL isShowEmptyView;

@end

@implementation AllSearchViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.thinkTableView reloadData];
    [self.resultTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.stateBarHeightLayout.constant = kDevice_Is_iPhoneX?24:0;
}

#pragma mark - NSNotification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    UITextField *textField = [notification object];
    if (textField != self.searchTextField) return;
    
    // 现实联想词
    if ([textField.text length] == 0 ) {
        [self showThinkTableView];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *content = [textField.text stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string isEqualToString:@"\n"] && content.length>0) {
        
        KnowLabelInfo *info = [[KnowLabelInfo alloc] init];
        info.lableknowname = content;
        
        [self searWithInfo:info];
        
    }
    return YES;
}

#pragma mark - Getters & Setters

- (AllSearchPageRequest *)recordPageRequest {
    
    if (!_recordPageRequest) {
        _recordPageRequest = [[AllSearchPageRequest alloc] init];
        
    }
    
    return _recordPageRequest;
}

- (UIView *)setionHeader {
    if (!_setionHeader) {
        _setionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kRKBHEIGHT(70))];
        _setionHeader.backgroundColor = [UIColor whiteColor];
        
    }
    
    return _setionHeader;
}

- (TagView *)tagView {
    if (!_tagView) {
        _tagView = [[TagView alloc]initWithFrame:CGRectMake(0, kRKBHEIGHT(30), kScreen_Width, 0)];
        _tagView.backgroundColor = [UIColor clearColor];
        _tagView.delegate = self;
        
        [self.setionHeader addSubview:_tagView];
    }
    
    return _tagView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [UIColor colorWithRGBHex:0x2D2F35];
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        _titleLabel.text = @"大家都在搜";
        
        [self.setionHeader addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UILabel *)searchLabel {
    if (!_searchLabel) {
        _searchLabel = [[UILabel alloc] init];
        _searchLabel.textAlignment = NSTextAlignmentLeft;
        _searchLabel.textColor = [UIColor colorWithRGBHex:0x2D2F35];
        _searchLabel.font = [UIFont systemFontOfSize:14.f];
        _searchLabel.text = @"最近搜索";
        
        [self.setionHeader addSubview:_searchLabel];
    }
    
    return _searchLabel;
}

- (UIButton *)clearBtn {
    if (!_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clearBtn setTitle:@"清空历史记录" forState:UIControlStateNormal];
        [_clearBtn setTitleColor:[UIColor colorWithRGBHex:0xAAAAAA] forState:UIControlStateNormal];
        _clearBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _clearBtn.enabled = YES;
        [_clearBtn addTarget:self action:@selector(clickClearBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.setionHeader addSubview:_clearBtn];
    }
    
    return _clearBtn;
}

#pragma mark - Action

- (IBAction)actionBack:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self showThinkTableView];
    [self.searchTextField becomeFirstResponder];
}

- (IBAction)actionCancel:(id)sender {
//    if (self.resultTableView.alpha == 1.f) {
//        self.searchTextField.text = @"";
//        [self showThinkTableView];
//    } else {
//        [self.navigationController popViewControllerAnimated:YES];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clickClearBtn:(id)sender {
    [self.searchManager clearAllHistory];
    [self.thinkTableView reloadData];
}

#pragma mark - private


- (void)setupUI {
    [self.searchView.layer setMasksToBounds:YES];
    [self.searchView.layer setCornerRadius:5.f];
    
    [self setupTableView];
    
    self.searchManager = [[KSearchManager alloc] initWithType:SearchType_All];
    self.assWordsArray = [[NSArray alloc] init];
    
    [self.searchTextField setValue:[UIColor colorWithRGBHex:0xafb1b5] forKeyPath:@"_placeholderLabel.textColor"];
    self.searchTextField.delegate = self;
    [self.searchTextField becomeFirstResponder];
    
    [self showThinkTableView];
}

- (void)setupTableView {
    
    [self.resultTableView registerNib:[UINib nibWithNibName:@"SANumTitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"SANumTitleTableViewCell"];
    [self.resultTableView registerNib:[UINib nibWithNibName:@"SANumContentTableViewCell" bundle:nil] forCellReuseIdentifier:@"SANumContentTableViewCell"];
    [self.resultTableView registerNib:[UINib nibWithNibName:@"SAAnswerTableViewCell" bundle:nil] forCellReuseIdentifier:@"SAAnswerTableViewCell"];
    [self.resultTableView registerNib:[UINib nibWithNibName:@"SATitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"SATitleTableViewCell"];
    [self.resultTableView registerNib:[UINib nibWithNibName:@"PosterMSubTableViewCell" bundle:nil] forCellReuseIdentifier:@"PosterMSubTableViewCell"];
    self.resultTableView.backgroundColor = [UIColor clearColor];
    self.resultTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.resultTableView.delegate = self;
    self.resultTableView.dataSource = self;
    self.resultTableView.emptyDataSetSource = self;
    self.resultTableView.emptyDataSetDelegate = self;
    
    [self.thinkTableView registerNib:[UINib nibWithNibName:@"SearchHistoryCell" bundle:nil]
              forCellReuseIdentifier:@"SearchHistoryCell"];
    self.thinkTableView.backgroundColor = [UIColor whiteColor];
    self.thinkTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.thinkTableView.delegate = self;
    self.thinkTableView.dataSource = self;
}

- (void)loadNetworkData {
    
    [self requsetWordsList];
}

-(void)showThinkTableView {
    self.thinkTableView.alpha  = 1.f;
    self.resultTableView.alpha  = 0.f;
//    self.backLeading.constant = kRKBWIDTH(-34.f);
//    self.cancelTrailing.constant = -0.f;
//    [UIView animateWithDuration:0.25 animations:^{
//        [self.view layoutIfNeeded];
//    }];
    
    [self.thinkTableView reloadData];
}

-(void)showResultTableView {
//    self.backView.hidden = NO;
    [self.searchTextField resignFirstResponder];
    self.resultTableView.alpha = 1.f;
    self.thinkTableView.alpha  = 0.f;
//    self.backLeading.constant = 0.f;
//    self.cancelTrailing.constant = kRKBWIDTH(-52.f);
//    [UIView animateWithDuration:0.25 animations:^{
//        [self.view layoutIfNeeded];
//    }];
    
    [self.resultTableView reloadData];
}

-(void)requsetWordsList {
    WEAKSELF
    [KnowledgeRequest getKnowledgeLabel:1 handler:^(id result, NSError *error) {
        if (error) {
            [NSObject showHudTipStr:error.domain];
        } else {
            weakSelf.assWordsArray = result;
            [weakSelf.thinkTableView reloadData];
        }
    }];
}

- (void)searWithInfo:(KnowLabelInfo *)info {
    [self.searchManager insertHistory:info];
    [self showResultTableView];
    
    self.recordPageRequest.keyword = info.lableknowname;
    
    [self getFirstRecordList];
}

- (void)getFirstRecordList {
    
    @weakify(self)
    [self.recordPageRequest reloadPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        
        if (error) {
            [NSObject showHudTipStr:error.domain];
        }else {
            [self compareRecordList:self.recordPageRequest.responseInfo.items];
        }
        
        self.isShowEmptyView = self.resultArray.count == 0 ? YES : NO;
        [self.resultTableView reloadData];
    }];
}

- (void)getNextRecordList {
    
    @weakify(self)
    [self.recordPageRequest loadNextPageWithHandle:^(id result, NSError *error) {
        @strongify(self)
        if (error) {
            [NSObject showHudTipStr:error.domain];
        }else {
            [self compareRecordList:self.recordPageRequest.responseInfo.items];
            [self.resultTableView reloadData];
        }
    }];
}

- (void)compareRecordList:(NSArray<KnowModeInfo *> *)recordList {
    
    NSMutableArray *keyList = [NSMutableArray arrayWithCapacity:1];
    NSMutableArray<NSMutableArray <KnowModeInfo *> *> *valueList = [NSMutableArray arrayWithCapacity:1];
    for (KnowModeInfo *knowModeInfo in recordList) {
        
        NSString *key = @"";
        KnowType knowType = knowModeInfo.knowtype;
        switch (knowType) {
            case KnowType_Poster:
                key = @"有数小报";
                break;
                
            case KnowType_SFurniture:
            case KnowType_SIndoor:
            case KnowType_SLiveroom:
            case KnowType_SRestaurant:
            case KnowType_SRoom:
            case KnowType_SKitchen:
                key = @"尺寸宝典";
                break;
                
            case KnowType_FLiveroom:
            case KnowType_FRoom:
            case KnowType_FToilet:
            case KnowType_FKitchen:
            case KnowType_FRestaurant:
            case KnowType_FOther:
                key = @"家居风水";
                break;
                
            default:
                break;
        }
        
        if (key.length == 0) {
            continue;
        }
        
        if ([keyList containsObject:key]) {
            NSInteger index = [keyList indexOfObject:key];
            NSMutableArray <KnowModeInfo *> *array = valueList[index];
            [array addObject:knowModeInfo];
            
        } else {
            [keyList addObject:key];
            NSMutableArray <KnowModeInfo *> *array = [NSMutableArray arrayWithCapacity:1];
            [array addObject:knowModeInfo];
            
            [valueList addObject:array];
        }
    }
    
    self.keyArray = [keyList copy];
    self.resultArray = valueList;
}


#pragma mark - DZNEmptyDataSetSource

///是否显示没有数据界面
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView{
    
    return self.isShowEmptyView;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text = @"没有找到相关内容，换个词试试吧";
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

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"search_e.png"];
}

#pragma mark UITableViewDelegate
// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.resultTableView) {
        return self.keyArray == nil ? 0 : self.keyArray.count;
    }
    
    return 1;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.resultTableView) {
        return section < self.resultArray.count ? self.resultArray[section].count : 0;
    }
    
    return [[self.searchManager getHistory] count];
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.resultTableView) {
        UITableViewCell *tableViewCell = nil;
        KnowModeInfo *knowModeInfo = self.resultArray[indexPath.section][indexPath.row];
        
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
                SANumTitleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SANumTitleTableViewCell"];
                [cell refreshWithKnowModeInfo:knowModeInfo isFontBold:YES];
                    
                WEAKSELF
                cell.clickExpandBlock = ^(KnowModeInfo *knowModeInfo) {
                    [weakSelf clickExpand:indexPath knowModeInfo:knowModeInfo];
                };
                cell.clickItemBlock = ^(KnowModeInfo *knowModeInfo) {
                    [weakSelf clickItem:knowModeInfo];
                };
                cell.clickFavorBlock = ^(KnowModeInfo *knowModeInfo) {
                    [weakSelf clickFavor:knowModeInfo];
                };
                tableViewCell = cell;
                
            }
                break;
                
            case KnowType_Temp: {
                SANumContentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SANumContentTableViewCell"];
                [cell refreshWithKnowModeInfo:knowModeInfo];
                
//                WEAKSELF
//                cell.clickItemBlock = ^(KnowModeInfo *knowModeInfo) {
//                    [weakSelf clickItem:knowModeInfo];
//                };
                
                tableViewCell = cell;
            }
                break;
                
            case KnowType_SLiveroom:
            case KnowType_SRestaurant:
            case KnowType_SRoom:
            case KnowType_SKitchen: {
                SAAnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SAAnswerTableViewCell"];
                [cell refreshWithKnowModeInfo:knowModeInfo isFontBold:YES];
                
                WEAKSELF
//                cell.clickItemBlock = ^(KnowModeInfo *knowModeInfo) {
//                    [weakSelf clickItem:knowModeInfo];
//                };
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
                [cell refreshWithKnowModeInfo:knowModeInfo isFontBold:YES];
                
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
    
    SearchHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchHistoryCell"];
    cell.backgroundColor = [UIColor whiteColor];
    [cell refreshWithKnowLabelInfo: [self.searchManager getHistory][indexPath.row]];
    
    WEAKSELF
    cell.clickItemDel = ^(KnowLabelInfo *knowLabelInfo) {
        NSInteger index = [[weakSelf.searchManager getHistory] indexOfObject:knowLabelInfo];
        [weakSelf.searchManager clearHistoryFromIndex:index];
        
        [weakSelf.thinkTableView reloadData];
    };
    
    return cell;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.resultTableView) {
        KnowModeInfo *knowModeInfo = self.resultArray[indexPath.section][indexPath.row];
        switch (knowModeInfo.knowtype) {
            case KnowType_Poster: {
                return kRKBHEIGHT(86);
            }
                break;
                
            case KnowType_SFurniture:
            case KnowType_SIndoor: {
                return kRKBHEIGHT(75);
            }
                break;
                
            case KnowType_Temp: {
                return [SANumContentTableViewCell defaultHeight:knowModeInfo.knowcontentdown];
            }
                break;
                
            case KnowType_SLiveroom:
            case KnowType_SRestaurant:
            case KnowType_SRoom:
            case KnowType_SKitchen: {
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
    
    return kRKBHEIGHT(50);
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.resultTableView) {
        return kRKBHEIGHT(40);
    }
    
    NSMutableArray<NSString *> *key = [NSMutableArray arrayWithCapacity:1];
    for (KnowLabelInfo *knowLabelInfo in self.assWordsArray) {
        [key addObject:knowLabelInfo.lableknowname];
    }
    
    return kRKBHEIGHT(70) + [TagView calculateHeight:key];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.resultTableView) {
        return [self isShowMoreSearch:self.resultArray[section]] ? kRKBHEIGHT(48) : kRKBHEIGHT(8);
    }
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.resultTableView) {
        UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.resultTableView.bounds.size.width, kRKBHEIGHT(40))];
        sectionView.backgroundColor = [UIColor whiteColor];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRGBHex:0xF2F3F5];
        
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.resultTableView.bounds.size.width - 20, kRKBHEIGHT(40))];
        title.font = [UIFont systemFontOfSize:14.f];
        title.textColor = [UIColor colorWithRGBHex:0xaaaaaa];
        title.text = self.keyArray[section];
        
        [sectionView addSubview:line];
        [sectionView addSubview:title];
        
        return sectionView;
    }
    
    UIView *setionHeaderView = self.setionHeader;
    
    NSMutableArray<NSString *> *key = [NSMutableArray arrayWithCapacity:1];
    for (KnowLabelInfo *knowLabelInfo in self.assWordsArray) {
        [key addObject:knowLabelInfo.lableknowname];
    }
    self.tagView.arr = key;
    
    CGRect setionFrame = setionHeaderView.frame;
    setionFrame.size.height = kRKBHEIGHT(70) + [TagView calculateHeight:key];
    setionHeaderView.frame = setionFrame;
    
    self.titleLabel.frame = CGRectMake(15, 0, setionFrame.size.width - 30, kRKBHEIGHT(30));
    self.tagView.top = self.titleLabel.bottom;
    
    [self.searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(setionHeaderView).offset(15);
        make.right.equalTo(setionHeaderView).offset(-15);
        make.bottom.equalTo(setionHeaderView.mas_bottom);
        make.height.equalTo(@(kRKBHEIGHT(30)));
    }];
    
    [self.clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(setionHeaderView).offset(-15);
        make.centerY.equalTo(self.searchLabel.mas_centerY);
        make.height.equalTo(@(kRKBHEIGHT(40)));
    }];
    
    return setionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (tableView == self.resultTableView) {
        if ([self isShowMoreSearch:self.resultArray[section]]) {
            UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.resultTableView.bounds.size.width, kRKBHEIGHT(48))];
            sectionView.backgroundColor = [UIColor clearColor];
        
            UIView *lineTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, kRKBHEIGHT(1))];
            lineTop.backgroundColor = [UIColor colorWithRGBHex:0xF2F3F5];
            
            SearchMoreView *view = [[NSBundle mainBundle] loadNibNamed:@"SearchMoreView" owner:self options:nil].firstObject;
            KnowModeInfo *info = self.resultArray[section][0];
            [view updateMoreLabe:info.knowtype];
            WEAKSELF
            view.clickItemBlock = ^(KnowType knowType) {
                [weakSelf showMoreSearchResul:knowType key:weakSelf.recordPageRequest.keyword];
            };
            
            CGRect frame = view.frame;
            frame = CGRectMake(0, kRKBHEIGHT(1), tableView.bounds.size.width, kRKBHEIGHT(39));
            view.frame = frame;
            
            UIView *lineBottom = [[UIView alloc] initWithFrame:CGRectMake(0, kRKBHEIGHT(40), tableView.bounds.size.width, kRKBHEIGHT(1))];
            lineBottom.backgroundColor = [UIColor colorWithRGBHex:0xF2F3F5];
            
            [sectionView addSubview:lineTop];
            [sectionView addSubview:view];
            [sectionView addSubview:lineBottom];
            
            return sectionView;
            
        } else {
            UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.resultTableView.bounds.size.width, kRKBHEIGHT(8))];
            sectionView.backgroundColor = [UIColor clearColor];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 1)];
            line.backgroundColor = [UIColor colorWithRGBHex:0xF2F3F5];
            
            [sectionView addSubview:line];
            
            return sectionView;
        }
        
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.resultTableView) {
        return;
    }
    
    KnowLabelInfo *info = [self.searchManager getHistory][indexPath.row];
    self.searchTextField.text = info.lableknowname;
    
    [self searWithInfo:info];
}

- (BOOL)isShowMoreSearch:(NSMutableArray<KnowModeInfo *> *)knowModeArray {
    if (knowModeArray.count < 2) {
        return NO;
    }
    
    int count = 0;
    for (KnowModeInfo *info in knowModeArray) {
        if (info.knowtype != KnowType_Temp) {
            count++;
        }
    }
    return count >= 2 ? YES : NO;
}

- (void)showMoreSearchResul:(KnowType)knowType key:(NSString *)key {
    switch (knowType) {
        case KnowType_Poster:{
            SASearchViewController *viewController = [[SASearchViewController alloc] initWithKnowType:KnowType_None knowTypeSub:KnowTypeSub_Poster key:key];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
            
        case KnowType_SFurniture:
        case KnowType_SIndoor:
        case KnowType_SLiveroom:
        case KnowType_SRestaurant:
        case KnowType_SRoom:
        case KnowType_SKitchen:{
            SASearchViewController *viewController = [[SASearchViewController alloc] initWithKnowType:KnowType_None knowTypeSub:KnowTypeSub_Size key:key];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
            
        case KnowType_FLiveroom:
        case KnowType_FRoom:
        case KnowType_FToilet:
        case KnowType_FKitchen:
        case KnowType_FRestaurant:
        case KnowType_FOther:{
            SASearchViewController *viewController = [[SASearchViewController alloc] initWithKnowType:KnowType_None knowTypeSub:KnowTypeSub_Arrange key:key];
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - TagViewDelegate
-(void)handleSelectTag:(NSString *)keyWord {
    self.searchTextField.text = keyWord;
    
    KnowLabelInfo *info = [[KnowLabelInfo alloc] init];
    info.lableknowname = keyWord;
    
    [self searWithInfo:info];
}

- (void)clickExpand:(NSIndexPath *)indexPath knowModeInfo:(KnowModeInfo *)knowModeInfo {
    if (knowModeInfo.isExpand) {
        KnowModeInfo *newModeInfo = [knowModeInfo copy];
        newModeInfo.knowtype = KnowType_Temp;
        
        NSMutableArray *valueArray = self.resultArray[indexPath.section];
        [valueArray insertObject:newModeInfo atIndex:(indexPath.row + 1)];
        
    } else {
        NSMutableArray *valueArray = self.resultArray[indexPath.section];
        KnowModeInfo *newModeInfo = valueArray[indexPath.row + 1];
        [valueArray removeObject:newModeInfo];
    }
    
//    NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
//    [self.resultTableView reloadRowsAtIndexPaths:@[indexPath, newIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
//    [self.resultTableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:(UITableViewRowAnimationAutomatic)];
    [self.resultTableView reloadData];
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
                [weakSelf.resultTableView reloadData];
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
                
                [weakSelf.resultTableView reloadData];
            }
        }];
    }
}

@end
