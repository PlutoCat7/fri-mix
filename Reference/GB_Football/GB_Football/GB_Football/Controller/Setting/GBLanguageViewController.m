//
//  GBLanguageViewController.m
//  GB_Football
//
//  Created by gxd on 16/10/19.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBLanguageViewController.h"

#import "SettingSelectTableViewCell.h"
#import "GBCircleHub.h"

#import "GBSettingConstant.h"

@interface GBLanguageViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong,nonatomic) UIActivityIndicatorView *indicator;

@property (nonatomic, strong) UIButton *saveButton;

// 选择的语言
@property (nonatomic, strong) LanguageItem *selectLanguage;

@end

@implementation GBLanguageViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)setupUI {
    
    self.title = LS(@"language.nav.title");
    [self setupBackButtonWithBlock:nil];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"SettingSelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"SettingSelectTableViewCell"];
    
    [self setupNavigationBarLeft];
    [self setupNavigationBarRight];
    
    self.selectLanguage = [[LanguageManager sharedLanguageManager] getCurrentAppLanguage];
    
    [self checkSaveEnable];
}

- (void)setupNavigationBarLeft {
    
    UIButton *leftMenuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftMenuBtn setSize:CGSizeMake(60, 24)];
    [leftMenuBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [leftMenuBtn setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
    [leftMenuBtn setTitle:LS(@"common.btn.cancel") forState:UIControlStateHighlighted];
    [leftMenuBtn setTitleColor:[ColorManager textColor] forState:UIControlStateNormal];
    [leftMenuBtn setTitleColor:[ColorManager textColor] forState:UIControlStateHighlighted];
    leftMenuBtn.backgroundColor = [UIColor clearColor];
    [leftMenuBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:leftMenuBtn];
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
    [self.saveButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    rightButton.enabled = NO;
    [self.navigationItem setRightBarButtonItem:rightButton];
}

- (void)checkSaveEnable {
    LanguageItem *languageItem = [[LanguageManager sharedLanguageManager] getCurrentAppLanguage];
    
    self.saveButton.enabled = (languageItem.langId != self.selectLanguage.langId);
    
}

#pragma mark - Action

- (void)cancelClick {
    [self.navigationController yh_popViewController:self animated:YES];
}

- (void)saveClick {
    [[LanguageManager sharedLanguageManager] saveLanguageItem:self.selectLanguage];
    
    GBCircleHub *hud = [GBCircleHub showWithTip:LS(@"language.hint.setting") view:nil];
    dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    dispatch_after(time, dispatch_get_main_queue(), ^{
        [hud hide];
        
        [self.navigationController yh_popViewController:self animated:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_ChangeLanguageRestart object:nil];
    });
    
    
}

#pragma mark - Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return SettingSectionHeader_Default_Height;
}

// 单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return SettingSelectCellHeight;
}

// row数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *languageArray = [LanguageManager sharedLanguageManager].languageList;
    return [languageArray count];
}

// cell设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SettingSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingSelectTableViewCell"];
    cell.type = SettingSelectTableViewCellType_Select;
    NSArray *languageArray = [LanguageManager sharedLanguageManager].languageList;
    LanguageItem *language = languageArray[indexPath.row];
    
    cell.titleLabel.text = language.langName;
    cell.selectImageView.hidden = (self.selectLanguage.langId != language.langId);
    cell.nextImageView.hidden = YES;
    
    return cell;
    
}

// 选择row
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *languageArray = [LanguageManager sharedLanguageManager].languageList;
    LanguageItem *language = languageArray[indexPath.row];
    
    self.selectLanguage = language;
    
    [self.tableView reloadData];
    [self checkSaveEnable];
}

@end
