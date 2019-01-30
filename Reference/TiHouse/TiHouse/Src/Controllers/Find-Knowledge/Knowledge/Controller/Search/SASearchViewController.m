//
//  SASearchViewController.m
//  TiHouse
//
//  Created by weilai on 2018/2/2.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SASearchViewController.h"

#import "SearchHistoryCell.h"
#import "TagView.h"

#import "SASearchPageRequest.h"
#import "KnowledgeRequest.h"
#import "KSearchManager.h"

@interface SASearchViewController () <UITextFieldDelegate, TagViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *thinkTableView;
@property (weak, nonatomic) IBOutlet UITableView *resultTableView;

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateBarHeightLayout;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) UIView *setionHeader;
@property (strong, nonatomic) TagView *tagView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *searchLabel;
@property (strong, nonatomic) UIButton *clearBtn;

@property (strong, nonatomic) KSearchManager       *searchManager;
@property (strong, nonatomic) NSArray<KnowLabelInfo *> *assWordsArray;

@property (strong, nonatomic) NSString *key;

@end

@implementation SASearchViewController

- (instancetype)initWithKnowType:(KnowType)knowType knowTypeSub:(KnowTypeSub)knowTypeSub {
    if (self = [super initWithKnowType:knowType knowTypeSub:knowTypeSub]) {
        
    }
    return self;
}

- (instancetype)initWithKnowType:(KnowType)knowType knowTypeSub:(KnowTypeSub)knowTypeSub key:(NSString *)key {
    if (self = [super initWithKnowType:knowType knowTypeSub:knowTypeSub]) {
        _key = key;
    }
    return self;
}

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

#pragma mark - private

- (BasePageNetworkRequest *)createRecordPageRequest {
    SASearchPageRequest *recordPageRequest = [[SASearchPageRequest alloc] initWithKnowType:self.knowType knowTypeSub:self.knowTypeSub];
    
    return recordPageRequest;
}

- (void)setupUI {
    
    self.isFontBold = YES;
    
    [self.searchView.layer setMasksToBounds:YES];
    [self.searchView.layer setCornerRadius:5.f];
    
    [self setupTableView:_resultTableView];
    [self setupThinkTableView];
    
    self.searchManager = [[KSearchManager alloc] initWithType:self.knowTypeSub == KnowTypeSub_Size ? SearchType_Size : SearchType_Arrange];
    self.assWordsArray = [[NSArray alloc] init];
    
    [self.searchTextField setValue:[UIColor colorWithRGBHex:0xafb1b5] forKeyPath:@"_placeholderLabel.textColor"];
    self.searchTextField.delegate = self;
    [self.searchTextField becomeFirstResponder];
    
    if (_key != nil) {
        self.searchTextField.text = _key;
        [self showResultTableView];
    } else  {
        [self showThinkTableView];
    }
    
    
}

- (void)setupThinkTableView {
    
    [self.thinkTableView registerNib:[UINib nibWithNibName:@"SearchHistoryCell" bundle:nil]
          forCellReuseIdentifier:@"SearchHistoryCell"];
    self.thinkTableView.backgroundColor = [UIColor whiteColor];
    self.thinkTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.thinkTableView.delegate = self;
    self.thinkTableView.dataSource = self;
}

- (void)loadNetworkData {
    
    [self requsetWordsList];
    if (_key != nil) {
        KnowLabelInfo *info = [[KnowLabelInfo alloc] init];
        info.lableknowname = _key;
        [self searWithInfo:info];
    }
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
    
    SASearchPageRequest *searchRequest = (SASearchPageRequest *)self.recordPageRequest;
    searchRequest.keyword = info.lableknowname;
    
    [self getFirstRecordList];
}

#pragma mark - Action

- (IBAction)actionBack:(id)sender {
    // [self.navigationController popViewControllerAnimated:YES];
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

- (IBAction)actionEditBegin:(id)sender {
}

- (void)clickClearBtn:(id)sender {
    [self.searchManager clearAllHistory];
    [self.thinkTableView reloadData];
}

#pragma mark - Getter or Setter
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
        return [super numberOfSectionsInTableView:tableView];
    }
    
    return 1;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.resultTableView) {
        return [super tableView:tableView numberOfRowsInSection:section];
    }
    
    return [[self.searchManager getHistory] count];
    
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.resultTableView) {
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
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
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    
    return kRKBHEIGHT(50);
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.resultTableView) {
        return [super tableView:tableView heightForHeaderInSection:section];
    }
    
    NSMutableArray<NSString *> *key = [NSMutableArray arrayWithCapacity:1];
    for (KnowLabelInfo *knowLabelInfo in self.assWordsArray) {
        [key addObject:knowLabelInfo.lableknowname];
    }
    
    return kRKBHEIGHT(70) + [TagView calculateHeight:key];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.resultTableView) {
        return [super tableView:tableView heightForFooterInSection:section];
    }
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.resultTableView) {
        return [super tableView:tableView viewForHeaderInSection:section];
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
        return [super tableView:tableView viewForFooterInSection:section];
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.resultTableView) {
        return [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
    
    KnowLabelInfo *info = [self.searchManager getHistory][indexPath.row];
    self.searchTextField.text = info.lableknowname;
    
    [self searWithInfo:info];
}

#pragma mark - TagViewDelegate
-(void)handleSelectTag:(NSString *)keyWord {
    self.searchTextField.text = keyWord;
    
    KnowLabelInfo *info = [[KnowLabelInfo alloc] init];
    info.lableknowname = keyWord;
    
    [self searWithInfo:info];
}

@end
