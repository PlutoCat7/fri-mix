//
//  GBPesonNameViewController.m
//  GB_Football
//
//  Created by Pizza on 16/8/3.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBPesonNameViewController.h"

#import "UserRequest.h"

@interface GBPesonNameViewController () <
UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (nonatomic, strong) UIButton *saveButton;

@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *headerTitle;
// 删除叉标志
@property (weak, nonatomic) IBOutlet UIImageView *deleteImgaeView;

@end

@implementation GBPesonNameViewController

#pragma mark -
#pragma mark Memory

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithTitle:(NSString *)title placeholder:(NSString *)placeholder {
    
    if(self=[super init]){
        self.headerTitle = title;
        self.placeholder = placeholder;
    }
    return self;
}

#pragma mark - Life Cycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title = self.headerTitle;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.nameTextField becomeFirstResponder];
}

#pragma mark - Notification

- (void)textFieldTextDidChange:(NSNotification *)notification {
    
    NSString *newName = [self.nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    self.saveButton.enabled = !([NSString stringIsNullOrEmpty:newName] || [newName isEqualToString:self.defaltName]) && (newName.length>=self.minLenght && newName.length<=self.maxLength);
    
    [self checkDeleteImageView];
}

#pragma mark - Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [self checkDeleteImageView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self checkDeleteImageView];
}

#pragma mark - Action

// 取消点击
-(void)actionCancel {
    
    [self.navigationController yh_popViewController:self animated:YES];
}

// 保存
-(void)actionSave {
    
    [self.nameTextField resignFirstResponder];
    NSString *newName = [self.nameTextField.text removeSpace];
    BLOCK_EXEC(self.saveBlock, newName);
}

// 点击了删除按钮
- (IBAction)actionDelete:(id)sender {
    
    self.nameTextField.text = @"";
    [self checkDeleteImageView];
}

#pragma mark - Private

-(void)setupUI
{
    self.nameTextField.attributedPlaceholder = [[NSAttributedString alloc]
                                                initWithString:self.placeholder?self.placeholder:@""
                                            attributes:@{NSForegroundColorAttributeName:[ColorManager placeholderColor]}];
    self.nameTextField.delegate = self;
    [self setupNavigationBarLeft];
    [self setupNavigationBarRight];
}

-(void)loadData {
    
    self.nameTextField.text = self.defaltName?self.defaltName:@"";
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

- (void)checkDeleteImageView {
    
    self.deleteImgaeView.hidden = !(self.nameTextField.isEditing && self.nameTextField.text.length>0);
}

#pragma mark - Getters & Setters

@end
