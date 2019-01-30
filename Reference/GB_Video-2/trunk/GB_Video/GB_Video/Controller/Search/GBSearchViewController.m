//
//  GBSearchViewController.m
//  GB_Video
//
//  Created by gxd on 2018/1/25.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import "GBSearchViewController.h"
#import "GBSearchResultViewController.h"
#import "SearchAssociationsResponseInfo.h"
#import "SearchAssociationsRequest.h"
#import "IQKeyboardManager.h"
#import "GBSearchManager.h"

#import "GBSearchThinkCell.h"
#import "TagView.h"

@interface GBSearchViewController () <UITextFieldDelegate, TagViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *thinkTableView;
@property (weak, nonatomic) IBOutlet UIView *resultTableView;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backLeading;
@property (weak, nonatomic) IBOutlet UIView *backView;

@property (strong, nonatomic) UIView *setionHeader;
@property (strong, nonatomic) TagView *tagView;
@property (strong, nonatomic) UIView *historyView;
@property (nonatomic, strong) GBSearchResultViewController *resultVC;

@property (strong, nonatomic) GBSearchManager       *searchManager;
@property (assign, nonatomic) BOOL thinkState;//  联想YES  历史NO
@property (assign, nonatomic) BOOL requestState;

@property (strong, nonatomic) NSArray<NSString *> *assWordsArray;// 搜索联想词列表
@property (strong, nonatomic) NSArray<NSString *> *hotWordsArray;// 搜索热词列表

@end

@implementation GBSearchViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UITextField appearance] setTintColor:[UIColor colorWithHex:0x909090]];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.resultVC.view.frame = self.resultTableView.bounds;
    });
}

#pragma mark - NSNotification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    UITextField *textField = [notification object];
    if (textField != self.searchTextField) return;
    [self showThinkTableView];
    // 现实联想词
    if ([textField.text length] >0 ) {
        self.thinkState = YES;
        [self.thinkTableView reloadData];
        
        if (!self.requestState) {
            self.requestState = YES;
            [self performSelector:@selector(requsetWordsList) withObject:nil afterDelay:0.2];
        }
        
    } else {// 现实历史记录
        self.thinkState = NO;
        [self.thinkTableView reloadData];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *content = [textField.text stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([string isEqualToString:@"\n"] && content.length>0) {
        
        [self searWithInfo:content];
        
    }
    return YES;
}

#pragma mark - Action

- (IBAction)actionBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionCancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)actionEditBegin:(id)sender {
}

- (void)clickClearBtn:(id)sender {
    [self.searchManager clearAllHistory];
    [self.thinkTableView reloadData];
}

#pragma mark - Private

-(void)setupUI{
    [self setupRuseltView];
    [self setupTableView];
    [self showThinkTableView];
    self.searchManager = [[GBSearchManager alloc] init];
    self.assWordsArray = [[NSArray alloc] init];
    self.thinkState = NO;
    [self.searchTextField setValue:[UIColor colorWithHex:0xafb1b5] forKeyPath:@"_placeholderLabel.textColor"];
    
    [self.searchTextField becomeFirstResponder];
}

- (void)setupRuseltView {
    self.resultVC = [[GBSearchResultViewController alloc] init];
    [self addChildViewController:self.resultVC];
    self.resultVC.view.frame = self.resultTableView.bounds;
    [self.resultTableView addSubview:self.resultVC.view];
}

-(void)setupTableView {
    [self.thinkTableView registerNib:[UINib nibWithNibName:@"GBSearchThinkCell" bundle:nil]
          forCellReuseIdentifier:@"GBSearchThinkCell"];
}

-(void)showThinkTableView {
    self.backView.hidden = YES;
    self.thinkTableView.alpha  = 1.f;
    self.resultTableView.alpha  = 0.f;
    self.backLeading.constant = -34.f*kAppScale;
    self.cancelTrailing.constant = -0.f;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(void)showResultTableView {
    self.backView.hidden = NO;
    [self.searchTextField resignFirstResponder];
    self.resultTableView.alpha = 1.f;
    self.thinkTableView.alpha  = 0.f;
    self.backLeading.constant = 0.f;
    self.cancelTrailing.constant = -52.f*kAppScale;
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)loadNetworkData {
    @weakify(self)
    [SearchAssociationsRequest searchHotKeyword:^(id result, NSError *error) {
        @strongify(self)
        if (!error) {
            self.hotWordsArray = result;
            [self.thinkTableView reloadData];
        }
    }];
}

-(void)requsetWordsList {
    self.requestState = NO;
    
    if ([self.searchTextField.text length] == 0 || self.searchTextField.text == nil) {
        return;
    }
    
    @weakify(self)
    [SearchAssociationsRequest searchAssociation:self.searchTextField.text handler:^(id result, NSError *error) {
        @strongify(self)
        if (error) {
            [self showToastWithText:error.domain];
            
        }else {
            self.assWordsArray = result;
            self.thinkState = YES;
            [self.thinkTableView reloadData];
        }
    }];
}

- (void)searWithInfo:(NSString *)info {
    
    [self.searchManager insertHistory:info];
    [self showResultTableView];

    [self.resultVC reSearchWithName:info];
}


#pragma mark - Getters & Setters

- (UIView *)setionHeader {
    if (!_setionHeader) {
        _setionHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40*kAppScale)];
        _setionHeader.backgroundColor = [UIColor whiteColor];
    }
    
    return _setionHeader;
}

- (TagView *)tagView {
    if (!_tagView) {
        _tagView = [[TagView alloc]initWithFrame:CGRectMake(0, 30*kAppScale, [UIScreen mainScreen].bounds.size.width, 0)];
        _tagView.backgroundColor = [UIColor clearColor];
        _tagView.delegate = self;
        
        [self.setionHeader addSubview:_tagView];
    }
    
    return _tagView;
}

- (UIView *)historyView {
    if (!_historyView) {
        _historyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40*kAppScale)];
        _historyView.backgroundColor = [UIColor colorWithHex:0xF1F2F3];
        
        UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, [UIScreen mainScreen].bounds.size.width- 30, 40*kAppScale)];
        searchLabel.textAlignment = NSTextAlignmentLeft;
        searchLabel.textColor = [UIColor colorWithHex:0x2D2F35];
        searchLabel.font = [UIFont systemFontOfSize:14.f];
        searchLabel.text = @"最近搜索";
        
        NSString *btnText = @"清空历史记录";
        UIButton *clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [clearBtn setTitle:btnText forState:UIControlStateNormal];
        [clearBtn setTitleColor:[UIColor colorWithHex:0xAAAAAA] forState:UIControlStateNormal];
        clearBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        clearBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        clearBtn.enabled = YES;
        [clearBtn addTarget:self action:@selector(clickClearBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        CGSize titleSize = [btnText sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:clearBtn.titleLabel.font.fontName size:clearBtn.titleLabel.font.pointSize]}];
        clearBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 15 - titleSize.width, 0, titleSize.width, 40*kAppScale);
        
        [_historyView addSubview:searchLabel];
        [_historyView addSubview:clearBtn];
        
        [self.setionHeader addSubview:_historyView];
    }
    return _historyView;
}

#pragma mark - TagViewDelegate
-(void)handleSelectTag:(NSString *)keyWord {
    self.searchTextField.text = keyWord;
    
    [self searWithInfo:keyWord];
}

#pragma mark - Delegate

// section数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.thinkState ? [self.assWordsArray count] : [[self.searchManager getHistory] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    GBSearchThinkCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GBSearchThinkCell"];
    cell.isThink = self.thinkState;
    [cell setupConent:self.thinkState ? self.assWordsArray[indexPath.row] : [self.searchManager getHistory][indexPath.row] high:self.searchTextField.text];
    return cell;
    
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50*kAppScale;
}

// section头高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (self.thinkState) {
        return 0;
    }
    
    NSMutableArray<NSString *> *key = [NSMutableArray arrayWithCapacity:1];
    for (NSString *info in self.hotWordsArray) {
        [key addObject:info];
    }
    
    return 40*kAppScale + [TagView calculateHeight:key];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (self.thinkState) {
        return nil;
    }
    
    UIView *setionHeaderView = self.setionHeader;
    
    NSMutableArray<NSString *> *key = [NSMutableArray arrayWithCapacity:1];
    for (NSString *info in self.hotWordsArray) {
        [key addObject:info];
    }
    self.tagView.arr = key;
    
    CGRect setionFrame = setionHeaderView.frame;
    setionFrame.size.height = 40*kAppScale + [TagView calculateHeight:key];
    setionHeaderView.frame = setionFrame;
    
    CGRect tagFrame = self.tagView.frame;
    tagFrame = CGRectMake(0, 0, tagFrame.size.width, tagFrame.size.height);
    self.tagView.frame = tagFrame;
    
    CGRect searchFrame = CGRectMake(0, tagFrame.size.height, setionFrame.size.width, 40*kAppScale);
    self.historyView.frame = searchFrame;
    
    return setionHeaderView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.thinkTableView) {
        NSString *info = self.thinkState ? self.assWordsArray[indexPath.row] :[self.searchManager getHistory][indexPath.row];
        self.searchTextField.text = info;
        [self searWithInfo:info];
    }
}

@end
