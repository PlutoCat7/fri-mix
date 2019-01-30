//
//  FindSearchResultViewController.m
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindSearchResultViewController.h"
#import "FindWaterfallViewController.h"
#import "FindSearchTabViewController.h"

#import "TagView.h"
#import "KSearchManager.h"
#import "KnowledgeRequest.h"
#import "SearchHistoryCell.h"

@interface FindSearchResultViewController () <UITextFieldDelegate, TagViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *waterfallContainerView;
@property (weak, nonatomic) IBOutlet UITableView *thinkTableView;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelTrailing;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) UIView *setionHeader;
@property (strong, nonatomic) TagView *tagView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *searchLabel;
@property (strong, nonatomic) UIButton *clearBtn;

@property (nonatomic, strong) FindSearchTabViewController *resultTablVC;

@property (strong, nonatomic) KSearchManager  *searchManager;
@property (strong, nonatomic) NSArray<KnowLabelInfo *> *assWordsArray;

@end

@implementation FindSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self.thinkTableView reloadData];
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
    dispatch_async(dispatch_get_main_queue(), ^{
       
        self.resultTablVC.view.frame = self.waterfallContainerView.bounds;
    });
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

#pragma mark - Action

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionCancel:(id)sender {
//    if (self.waterfallContainerView.alpha == 1.f) {
//        self.searchTextField.text = @"";
//        [self showThinkTableView];
//    } else {
        [self.navigationController popViewControllerAnimated:YES];
//    }
}

- (void)clickClearBtn:(id)sender {
    [self.searchManager clearAllHistory];
    [self.thinkTableView reloadData];
}

#pragma mark - Getters & Setters

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

#pragma mark - Private

- (void)setupUI {
    [self.searchView.layer setMasksToBounds:YES];
    [self.searchView.layer setCornerRadius:5.f];
    
    [self setupWaterfall];
    [self setupTableView];
    
    self.searchManager = [[KSearchManager alloc] initWithType:SearchType_Find];
    self.assWordsArray = [[NSArray alloc] init];
    
    [self.searchTextField setValue:[UIColor colorWithRGBHex:0xafb1b5] forKeyPath:@"_placeholderLabel.textColor"];
    self.searchTextField.delegate = self;
    
    [self showThinkTableView];
}

- (void)setupWaterfall {
    
    self.resultTablVC = [[FindSearchTabViewController alloc] init];
    [self addChildViewController:self.resultTablVC];
    self.resultTablVC.view.frame = self.waterfallContainerView.bounds;
    [self.waterfallContainerView addSubview:self.resultTablVC.view];
//    [self.waterfallVC reSearchWithName:self.searchName];
}

- (void)setupTableView {
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
    self.waterfallContainerView.alpha  = 0.f;
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
    self.waterfallContainerView.alpha = 1.f;
    self.thinkTableView.alpha  = 0.f;
//    self.backLeading.constant = 0.f;
//    self.cancelTrailing.constant = kRKBWIDTH(-52.f);
//    [UIView animateWithDuration:0.25 animations:^{
//        [self.view layoutIfNeeded];
//    }];
    
}

-(void)requsetWordsList {
    WEAKSELF
    [KnowledgeRequest getKnowledgeLabel:2 handler:^(id result, NSError *error) {
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
    
    [self.resultTablVC reSearchWithName:info.lableknowname];
}


#pragma mark UITableViewDelegate
// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[self.searchManager getHistory] count];
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    
    return kRKBHEIGHT(50);
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    NSMutableArray<NSString *> *key = [NSMutableArray arrayWithCapacity:1];
    for (KnowLabelInfo *knowLabelInfo in self.assWordsArray) {
        [key addObject:knowLabelInfo.lableknowname];
    }
    
    return kRKBHEIGHT(70) + [TagView calculateHeight:key];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
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
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

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
