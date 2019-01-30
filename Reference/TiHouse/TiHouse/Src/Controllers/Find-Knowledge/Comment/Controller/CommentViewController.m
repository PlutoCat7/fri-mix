//
//  CommentViewController.m
//  TiHouse
//
//  Created by weilai on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CommentViewController.h"

#import "UITextView+ZWPlaceHolder.h"
#import "CommentRequest.h"
#import "NotificationConstants.h"
#import "IQKeyboardManager.h"

@interface CommentViewController ()

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;

@property (assign, nonatomic) NSInteger knowledgeId;
@property (assign, nonatomic) NSInteger commId;
@property (assign, nonatomic) NSInteger commuid;
@property (strong, nonatomic) NSString *comuname;
@property (assign, nonatomic) CommentType type;
@end

@implementation CommentViewController

- (void)dealloc {
}

- (instancetype)initWithCommentId:(NSInteger)knowledgeId commId:(NSInteger)commId commuid:(NSInteger)commuid comuname:(NSString *)comuname  type:(CommentType)type{
    if (self = [super init]) {
        _knowledgeId = knowledgeId;
        _commId = commId;
        _commuid = commuid;
        _comuname = comuname;
        _type = type;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self wr_setNavBarBarTintColor:kColorWhite];
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:YES];
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [IQKeyboardManager sharedManager].enable = YES;
}

#pragma mark - NSNotification


#pragma mark - private

- (void)setupUI {
    
    self.title = @"写评论";
    
    if (@available(iOS 11.0, *)) {
        
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    if (self.comuname == nil || self.comuname.length == 0) {
        self.commentTextView.zw_placeHolder = @"我也说一句";
    } else {
        self.commentTextView.zw_placeHolder = [NSString stringWithFormat:@"回复:%@", self.comuname];
    }
    self.commentTextView.zw_placeHolderColor = [UIColor colorWithRGBHex:0xE5E5E5];
    [self.commentTextView becomeFirstResponder];
    
    [self setupNavigationBarLeft];
    [self setupNavigationBarRight];
}

- (void)setupNavigationBarLeft {
    
    UIButton *tmpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tmpBtn setSize:CGSizeMake(60, 24)];
    [tmpBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [tmpBtn setTitle:@"取消" forState:UIControlStateNormal];
    [tmpBtn setTitle:@"取消" forState:UIControlStateHighlighted];
    [tmpBtn setTitleColor:[UIColor colorWithRGBHex:0x2D2F35] forState:UIControlStateNormal];
    [tmpBtn setTitleColor:[UIColor colorWithRGBHex:0x2D2F35] forState:UIControlStateHighlighted];
    tmpBtn.backgroundColor = [UIColor clearColor];
    [tmpBtn addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView:tmpBtn];
    [self.navigationItem setLeftBarButtonItem:leftButton];
}

- (void)setupNavigationBarRight {
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setSize:CGSizeMake(48, 24)];
    [saveButton.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
    [saveButton setTitle:@"发表" forState:UIControlStateNormal];
    [saveButton setTitle:@"发表" forState:UIControlStateHighlighted];
    [saveButton setTitleColor:[UIColor colorWithRGBHex:0xF8C106] forState:UIControlStateNormal];
    [saveButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    saveButton.backgroundColor = [UIColor clearColor];
    [saveButton addTarget:self action:@selector(actionSave) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    [self.navigationItem setRightBarButtonItem:rightButton];
}

#pragma mark - Action

// 取消点击
-(void)actionCancel {
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

// 保存
-(void)actionSave {
    
    [self.commentTextView resignFirstResponder];
    NSString *newName = [self.commentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if (newName.length == 0) {
        [NSObject showHudTipStr:@"请输入内容"];
        return;
    }
    
    if (_type == CommentType_Know) {
        [NSObject showHUDQueryStr:@"正在发布评论"];
        [CommentRequest addKnowledgeComment:_knowledgeId commId:_commId commuid:_commuid content:newName handler:^(id result, NSError *error) {
            [NSObject hideHUDQuery];
            if (!error) {
                [NSObject showHudTipStr:self.view tipStr:@"评论提交成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Comment_Success object:nil];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    } else {
        [NSObject showHUDQueryStr:@"正在发布评论"];
        [CommentRequest addAssemarcComment:_knowledgeId commId:_commId commuid:_commuid content:newName handler:^(id result, NSError *error) {
            [NSObject hideHUDQuery];
            if (!error) {
                [NSObject showHudTipStr:self.view tipStr:@"评论提交成功"];
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Comment_Success object:nil];
                [self.navigationController dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
    
}

@end
