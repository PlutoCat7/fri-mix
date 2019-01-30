//
//  GBTeamInstrViewController.m
//  GB_Football
//
//  Created by gxd on 17/7/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBTeamInstrViewController.h"

@interface GBTeamInstrViewController ()
@property (weak, nonatomic) IBOutlet UITextView *containView;
@property (weak, nonatomic) IBOutlet UILabel *hintLabel;

@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *headerTitle;

@end

@implementation GBTeamInstrViewController

#pragma mark -
#pragma mark Memory

- (instancetype)initWithTitle:(NSString *)title content:(NSString *)content {
    
    if(self=[super init]){
        self.headerTitle = title;
        self.content = content;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.containView becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextViewTextDidChangeNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    [self checkAndUpdateUI];
}

#pragma mark - Action

// 取消点击
-(void)actionCancel {
    
    [self.navigationController yh_popViewController:self animated:YES];
}

// 保存
-(void)actionSave {
    
    [self.containView resignFirstResponder];
    NSString *newName = [self.containView.text removeSpace];
    BLOCK_EXEC(self.saveBlock, newName);
}


#pragma mark - Private

-(void)setupUI
{
    self.title = self.headerTitle;
    
    self.containView.text = self.content;
    
    [self setupNavigationBarLeft];
    [self setupNavigationBarRight];
    
    [self checkAndUpdateUI];
}

-(void)loadData {
    
}

- (void)setupNavigationBarLeft {
    
    UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpBtn setSize:CGSizeMake(60, 24)];
    [tmpBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [tmpBtn setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
    [tmpBtn setTitle:LS(@"common.btn.cancel") forState:UIControlStateHighlighted];
    [tmpBtn setTitleColor:[ColorManager textColor] forState:UIControlStateNormal];
    [tmpBtn setTitleColor:[ColorManager textColor] forState:UIControlStateHighlighted];
    tmpBtn.backgroundColor = [UIColor clearColor];
    [tmpBtn addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:tmpBtn];
    [self.navigationItem setLeftBarButtonItem:leftButton];
}

- (void)setupNavigationBarRight {
    
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.saveButton setSize:CGSizeMake(48, 24)];
    [self.saveButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [self.saveButton setTitle:LS(@"common.btn.save") forState:UIControlStateNormal];
    [self.saveButton setTitle:LS(@"common.btn.save") forState:UIControlStateHighlighted];
    [self.saveButton setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
    [self.saveButton setTitleColor:[ColorManager styleColor_50] forState:UIControlStateDisabled];
    self.saveButton.backgroundColor = [UIColor clearColor];
    self.saveButton.enabled = NO;
    [self.saveButton addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    rightButton.enabled = NO;
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)checkAndUpdateUI {
    NSString *newName = [self.containView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.saveButton.enabled = !([NSString stringIsNullOrEmpty:newName]) && (newName.length>=self.minLenght && newName.length<=self.maxLength);
    
    NSString *hint = [NSString stringWithFormat:@"%lu/%ld", (unsigned long)newName.length, (long)self.maxLength];
    self.hintLabel.text = hint;
}


@end
