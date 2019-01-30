//
//  GBMessageContainerViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/5.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBMessageContainerViewController.h"
#import "GBMessageViewController.h"
#import "GBMessageInvitedViewController.h"
#import "GBMessageTeamViewController.h"
#import "GBMenuViewController.h"

#import "GBSegmentView.h"
#import "NewMessageTipsView.h"

#import "MessageRequest.h"

@interface GBMessageContainerViewController ()<
GBSegmentViewDelegate>


@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet NewMessageTipsView *messageTipsView;
@property (nonatomic,strong) GBSegmentView *segmentView;
@property (nonatomic,strong) GBMessageViewController   *systemVC;
@property (nonatomic,strong) GBMessageInvitedViewController *inviteVC;
@property (nonatomic,strong) GBMessageTeamViewController *teamVC;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIButton *deleteButton;

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) NSArray *deleteMessageList;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) NSInteger systemMessageCount;
@property (nonatomic, assign) NSInteger inviteMessageCount;
@property (nonatomic, assign) NSInteger teamMessageCount;

@end

@implementation GBMessageContainerViewController

- (instancetype)initWithNewMessageInfo:(NewMessageInfo *)newMessageInfo {

    self = [super init];
    if (self) {
        _systemMessageCount = newMessageInfo.newMessageSystemCount;
        _inviteMessageCount = newMessageInfo.newMessageMatchInviteCount;
        _teamMessageCount = newMessageInfo.newMessageTeamCount;
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.segmentView goCurrentController:self.currentIndex];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    if ([self.navigationController.topViewController isMemberOfClass:[GBMenuViewController class]]) {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
}

#pragma mark - Delegate

- (void)GBSegmentView:(GBSegmentView *)segment toViewController:(PageViewController *)viewController {
    
    if ([viewController isKindOfClass:[GBMessageViewController class]]) {
        self.currentIndex = 0;
    }else if ([viewController isKindOfClass:[GBMessageInvitedViewController class]]) {
        self.currentIndex = 1;
    }else {
        self.currentIndex = 2;
    }
    [self refreshNavigationBarItem];
    [viewController initLoadData];
}

#pragma mark - Action

- (void)actionDelete {
    
    if (self.currentIndex == 1) { //比赛消息删除
        [self showLoadingToast];
        NSMutableArray *deleteList = [NSMutableArray arrayWithCapacity:self.deleteMessageList.count];
        for (MessageMatchInviteInfo *info in _deleteMessageList) {
            [deleteList addObject:@(info.match_id)];
        }
        @weakify(self)
        [MessageRequest deleteMatchInviteWithMatchIdList:[deleteList copy]
                                                 handler:^(id result, NSError *error) {
                                                     
                                                     @strongify(self)
                                                     [self dismissToast];
                                                     if (error) {
                                                         [self showToastWithText:error.domain];
                                                     }else {
                                                         [self.inviteVC removeMessageWithList:self.deleteMessageList];
                                                         [self actionEdit];
                                                     }
                                                 }];
    }else if (self.currentIndex == 2) { //球队消息删除
        
        [self showLoadingToast];
        @weakify(self)
        [MessageRequest deleteTeamMessageWithList:self.deleteMessageList handler:^(id result, NSError *error) {
            @strongify(self)
            [self dismissToast];
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                [self.teamVC removeMessageWithList:self.deleteMessageList];
                [self actionEdit];
            }
        }];
    }
    
}

- (void)actionEdit {
    
    self.isEdit = !self.isEdit;
    if (self.currentIndex == 1) {
        self.inviteVC.isEdit = self.isEdit;
    }else {
        self.teamVC.isEdit = self.isEdit;
    }
    if (self.isEdit) {
        [self.segmentView resetTopItemHeight:16];
        [UIView animateWithDuration:0.25f animations:^{
            self.messageTipsView.alpha = 0;
        } completion:nil];
    }else {
        [self.segmentView resetTopItemHeight:76.0f];
        [UIView animateWithDuration:0.25f animations:^{
            self.messageTipsView.alpha = 1;
        } completion:nil];
    }
    self.deleteMessageList = @[];
    [self refreshNavigationBarItem];
}

#pragma mark - Private

- (void)setupUI
{
    self.title = LS(@"message.nav.title");
    [self setupBackButtonWithBlock:nil];
    
    [self.containerView insertSubview:self.segmentView belowSubview:self.messageTipsView];
    [self refreshTipsMessageView];
}

- (void)refreshTipsMessageView{
    
    [self.messageTipsView showWithSystemMessageCount:self.systemMessageCount inviteCount:self.inviteMessageCount teamCount:self.teamMessageCount];
}

- (void)refreshNavigationBarItem {
    
    if (self.currentIndex == 0) {
        [self setupBackButtonWithBlock:nil];
        [self.navigationItem setRightBarButtonItems:nil animated:YES];
    }else {
        if (self.isEdit) {
            
            NSString *title = [NSString stringWithFormat:@"%@(0)", LS(@"common.btn.delete")];
            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToHeight:24];
            [self.deleteButton setTitle:title forState:UIControlStateDisabled];
            self.deleteButton.size = size;
            [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.deleteButton] animated:YES];
            self.deleteButton.enabled = NO;
            
            title = LS(@"common.btn.cancel");
            size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToHeight:24];
            [self.editButton setTitle:title forState:UIControlStateNormal];
            self.editButton.size = size;
            [self.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.editButton] animated:YES];
        }else {
            [self setupBackButtonWithBlock:nil];
            
            NSString *title = LS(@"common.btn.edit");
            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToHeight:24];
            self.editButton.size = size;
            [self.editButton setTitle:title forState:UIControlStateNormal];
            [self.editButton setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.editButton] animated:YES];
        }
    }
}

- (void)checkDeleteButtonValid {
    
    if (self.deleteMessageList.count>0) {
        self.deleteButton.enabled = YES;
    }else {
        self.deleteButton.enabled = NO;
    }
    NSString *title = [NSString stringWithFormat:@"%@(%td)", LS(@"common.btn.delete"), self.deleteMessageList.count];
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToHeight:24];
    self.deleteButton.size = size;
    [self.deleteButton setTitle:title forState:UIControlStateNormal];
    [self.deleteButton setTitle:title forState:UIControlStateDisabled];
}

#pragma mark - Setter Getter

- (GBSegmentView *)segmentView {
    
    if (!_segmentView) {
        CGRect rect = [UIScreen mainScreen].bounds;
        _segmentView = [[GBSegmentView alloc]initWithFrame:CGRectMake(0,kUIScreen_NavigationBarHeight, rect.size.width,kUIScreen_AppContentHeight)
                                                     topHeight:62.f
                                               viewControllers:@[self.systemVC,self.inviteVC, self.teamVC]
                                                        titles:@[LS(@"message.system.title"),LS(@"message.match.invite.title"),
                                                                 LS(@"team.message")]
                                                      delegate:self];
        _segmentView.isNeedDelete = NO;
        [self addChildViewController:self.systemVC];
        [self addChildViewController:self.inviteVC];
        [self addChildViewController:self.teamVC];
    }
    return _segmentView;
}

- (GBMessageViewController *)systemVC {
    
    if (!_systemVC) {
        _systemVC = [[GBMessageViewController alloc]init];
        @weakify(self)
        _systemVC.didRefreshMessage = ^{
            @strongify(self)
            self.systemMessageCount = 0;
            [self refreshTipsMessageView];
        };
    }
    return _systemVC;
}

- (GBMessageInvitedViewController *)inviteVC {
    
    if (!_inviteVC) {
        _inviteVC = [[GBMessageInvitedViewController alloc]init];
        @weakify(self)
        _inviteVC.deleteMessageBlock = ^(NSArray *deleteList) {
            @strongify(self)
            self.deleteMessageList = [deleteList copy];
            [self checkDeleteButtonValid];
        };
        _inviteVC.didRefreshMessage = ^{
            @strongify(self)
            self.inviteMessageCount = 0;
            [self refreshTipsMessageView];
        };
    }
    return _inviteVC;
}

- (GBMessageTeamViewController *)teamVC {
    
    if (!_teamVC) {
        _teamVC = [[GBMessageTeamViewController alloc]init];
        @weakify(self)
        _teamVC.deleteMessageBlock = ^(NSArray *deleteList) {
            @strongify(self)
            self.deleteMessageList = [deleteList copy];
            [self checkDeleteButtonValid];
        };
        _teamVC.didRefreshMessage = ^{
            @strongify(self)
            self.teamMessageCount = 0;
            [self refreshTipsMessageView];
        };
    }
    return _teamVC;
}

- (UIButton *)deleteButton {
    
    if (!_deleteButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [button setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
        [button setTitleColor:[ColorManager styleColor_50] forState:UIControlStateDisabled];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(actionDelete) forControlEvents:UIControlEventTouchUpInside];
        
        _deleteButton = button;
    }
    
    return _deleteButton;
}

- (UIButton *)editButton {
    
    if (!_editButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setSize:CGSizeMake(60, 24)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(actionEdit) forControlEvents:UIControlEventTouchUpInside];
        
        _editButton = button;
    }
    
    return _editButton;
}

@end
