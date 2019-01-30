//
//  FindArticleEditViewController.m
//  TiHouse
//
//  Created by yahua on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindArticleEditViewController.h"
#import "FindDraftViewController.h"
#import "LMWordViewController.h"
#import "FindArticleUploadCoverViewController.h"
#import "LMWordView.h"
#import "FindManager.h"
#import "LMTextHTMLParser.h"
#import "IQKeyboardManager.h"

@interface FindArticleEditViewController ()

@property (nonatomic, strong) LMWordViewController *wordViewController;
@property (nonatomic, strong) UIButton *saveButton;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) FindDraftSaveModel *saveModel;

@end

@implementation FindArticleEditViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithSaveDraftInfo:(FindDraftSaveModel *)saveModel {
    
    self = [super init];
    if (self) {
        _saveModel = saveModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputNotification:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputNotification:) name:UITextViewTextDidChangeNotification object:nil];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:YES];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.wordViewController.view.frame = self.view.bounds;
}

#pragma mark - NSNotification

- (void)inputNotification:(NSNotification *)notification {
    
    [self checkInputValid];
}

#pragma mark - Action

- (void)saveArticle {
    
    if (!self.saveModel) {
        self.saveModel = [[FindDraftSaveModel alloc] init];
        self.saveModel.createTimeInterval = [NSDate date].timeIntervalSince1970;
    }
    self.saveModel.title = self.wordViewController.textView.titleTextField.text;
    self.saveModel.contentAttributedString = self.wordViewController.textView.attributedText;
    self.saveModel.htmlString = [LMTextHTMLParser HTMLFromAttributedString:self.saveModel.contentAttributedString];
    self.saveModel.editTimeInterval = [NSDate date].timeIntervalSince1970;
}

- (void)actionSave {
    
    [self saveArticle];
    [FindManager modifyOrInsertDraftWithModel:self.saveModel];
    [NSObject showHudTipStr:self.view tipStr:@"保存成功"];
    
//    NSMutableArray *vcList = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//    [vcList removeLastObject];
//    if ([vcList.lastObject isKindOfClass:[FindDraftViewController class]]) {
//        [vcList removeLastObject];
//    }
//    FindDraftViewController *vc = [FindDraftViewController new];
//        [vcList addObject:vc];
//
//    [self.navigationController setViewControllers:[vcList copy] animated:YES];
}

- (void)actionNext {
    
    [self saveArticle];
    
    FindArticleUploadCoverViewController *vc = [[FindArticleUploadCoverViewController alloc] initWithSaveDraftInfo:self.saveModel];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

- (void)setupUI {
    
    UIBarButtonItem *rightBtn1 = [[UIBarButtonItem alloc] initWithCustomView:self.nextButton];
    UIBarButtonItem *rightBtn2 = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    self.navigationItem.rightBarButtonItems = @[rightBtn1,rightBtn2];
    self.nextButton.enabled = NO;
    self.saveButton.enabled = NO;
    
    [self addChildViewController:self.wordViewController];
    [self.view addSubview:self.wordViewController.view];
    
    if (self.saveModel) {
        self.wordViewController.textView.titleTextField.text = self.saveModel.title;
        self.wordViewController.textView.attributedText = self.saveModel.contentAttributedString;
    }
    [self checkInputValid];
}

- (void)checkInputValid {
    
    self.nextButton.enabled = _wordViewController.textView.text.length>0 && _wordViewController.textView.titleTextField.text.length>0;
    self.saveButton.enabled =  _wordViewController.textView.titleTextField.text.length>0;
}

#pragma mrak - Setter and Getter

- (LMWordViewController *)wordViewController {
    
    if (!_wordViewController) {
        _wordViewController = [[LMWordViewController alloc] init];
        [self addChildViewController:_wordViewController];
    }
    return _wordViewController;
}

- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_saveButton setTitleColor:[UIColor colorWithRGBHex:0x383838] forState:UIControlStateNormal];
         [_saveButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
        _saveButton.size = CGSizeMake(kRKBWIDTH(50), 44);
    }
    return _saveButton;
}

- (UIButton *)nextButton {
    
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_nextButton setTitleColor:[UIColor colorWithRGBHex:0x383838] forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextButton addTarget:self action:@selector(actionNext) forControlEvents:UIControlEventTouchUpInside];
        _nextButton.size = CGSizeMake(kRKBWIDTH(65), 44);
    }
    return _nextButton;
}

@end
