//
//  GBTacticsViewController.m
//  GB_Football
//
//  Created by 王时温 on 2017/7/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBLineUpViewController.h"

#import "GBCourtLineUpView.h"
#import "LineUpPlayerSelectView.h"
#import "LineUpSelectView.h"

#import "TeamRequest.h"

@interface GBLineUpViewController () <
GBCourtLineUpViewDelegate,
LineUpPlayerSelectViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *tracticsNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *turnImageView;
@property (weak, nonatomic) IBOutlet GBCourtLineUpView *courtTracticsView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *playerSelectContainView;
@property (strong, nonatomic) LineUpPlayerSelectView *playerSelectView;
@property (strong, nonatomic) LineUpSelectView *tracticsSelectView;

@property (nonatomic, strong) UIButton *yesButton;
@property (nonatomic, strong) UIButton *cancelButton;

//NSLayoutConstraint
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *centerViewTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;

//static label
@property (weak, nonatomic) IBOutlet UILabel *clickEditTipsLabel;


//数据
@property (nonatomic, strong) GBLineUpViewModel *viewModel;
//是否是编辑
@property (nonatomic, assign) BOOL useSelect;
@property (nonatomic, assign) BOOL isCreateTeamGame;

@end

@implementation GBLineUpViewController

- (instancetype)initWithTeamInfo:(TeamHomeRespone *)teamHomeInfo useSelect:(BOOL)useSelect {
    
    self = [super init];
    if (self) {
        _useSelect = useSelect;
        _viewModel = [[GBLineUpViewModel alloc] initWithHomeTeamInfo:teamHomeInfo];
    }
    return self;
}

- (instancetype)initWithTracticModel:(GBLineUpViewModel *)viewModel useSelect:(BOOL)useSelect {
    self = [super init];
    if (self) {
        _useSelect = useSelect;
        _isCreateTeamGame = YES;
        _viewModel = viewModel == nil ? [[GBLineUpViewModel alloc] initWithHomeTeamInfo:nil] : viewModel;
    }
    return self;
}

- (void)localizeUI {
    
    NSString *tipsString = [NSString stringWithFormat:@"%@ %@ %@", LS(@"team..tractics.captain"), LS(@"team.tractics.click.location"), LS(@"team.tractics.handler.tractics")];
    if (self.useSelect) {
        tipsString = [NSString stringWithFormat:@"%@ %@", LS(@"team.tractics.click.location"), LS(@"team.tractics.pitch.tractics")];
    }
    NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:tipsString];
    NSRange kmRange = [tipsString rangeOfString:LS(@"team.tractics.click.location")];
    [mString addAttribute:NSForegroundColorAttributeName
                    value:[UIColor whiteColor]
                    range:kmRange];
    self.clickEditTipsLabel.attributedText = [mString copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.tracticsSelectView dismiss];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    self.playerSelectView.frame = self.playerSelectContainView.bounds;
}

#pragma mark - Public

- (void)loadLineUpList {
    
    [self showLoadingToast];
    @weakify(self)
        [self.viewModel tracticsPlayerListWithHandle:^(NSArray<NSArray<LineUpPlayerModel *> *> *list, NSError *error) {
    
            @strongify(self)
            [self dismissToast];
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                self.courtTracticsView.dataList = list;
            }
        }];
}

#pragma mark - Analytics

- (NSString *)pageName {
    return Analy_Page_Team_Tactic;
}

#pragma mark - Action

- (void)actionCancel {
    
    [self.viewModel cancelEdit];
    [self refreshUI];
}

- (void)actionYes {
    
    if (!self.viewModel.isEdit || self.useSelect) {
        [self.viewModel saveTempEditDataWithClearOther:^(NSError *error) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Team_Tractic_Select object:self.viewModel];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } else {
        [self showLoadingToast];
        @weakify(self)
        [self.viewModel saveEditWithHandle:^(NSError *error) {
            
            @strongify(self)
            [self dismissToast];
            if (error) {
                [self showToastWithText:error.domain];
            }else {
            }
        }];
        
    } 

}

- (IBAction)actionTacticsSelect:(id)sender {
    
    @weakify(self)
    self.tracticsSelectView = [LineUpSelectView showWithTopY:self.topView.height entries:self.viewModel.tracticsNameList selectIndex:self.viewModel.currentTracticsIndex cancel:^{
        
        @strongify(self)
        [self rotateArrow:0];
    } complete:^(NSInteger index) {
        
        @strongify(self)
        self.viewModel.currentTracticsIndex = index;
        self.tracticsNameLabel.text = [self.viewModel.tracticsList objectAtIndex:index].name;
        [self rotateArrow:0];
        
        //刷新战术
        [self showLoadingToast];
        @weakify(self)
        [self.viewModel tracticsPlayerListWithHandle:^(NSArray<NSArray<LineUpPlayerModel *> *> *list, NSError *error) {
            
            @strongify(self)
            [self dismissToast];
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                self.courtTracticsView.dataList = list;
            }
        }];
        
    }];
    [self rotateArrow:M_PI];
}

- (void)rotateArrow:(float)degrees {
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.turnImageView.layer.transform = CATransform3DMakeRotation(degrees, 0, 0, 1);
    } completion:NULL];
}

#pragma mark - Private

- (void)setupUI {
    
    [self setupDefaultNavigationBarItem];
    
    if (self.viewModel.currentTracticsIndex < self.viewModel.tracticsList.count) {
        self.tracticsNameLabel.text = [self.viewModel.tracticsList objectAtIndex:self.viewModel.currentTracticsIndex].name;
    } else {
        self.tracticsNameLabel.text = [self.viewModel tracticsNameList].firstObject;
    }
    
    self.playerSelectView = [[NSBundle mainBundle] loadNibNamed:@"LineUpPlayerSelectView" owner:nil options:nil].firstObject;
    self.playerSelectView.delegate = self;
    [self.playerSelectContainView addSubview:self.playerSelectView];
    
    //阵型详情
    self.courtTracticsView.delegate = self;
    
    self.clickEditTipsLabel.hidden = self.isCreateTeamGame;
    
    [self addViewModelObserver];
}

- (void)refreshUI {
    
    @weakify(self)
    [self.viewModel tracticsPlayerListWithHandle:^(NSArray<NSArray<LineUpPlayerModel *> *> *list, NSError *error) {
        @strongify(self)
        if (!error) {
            self.courtTracticsView.dataList = list;
        }
    }];
    self.playerSelectView.dataList = self.viewModel.otherPlayerList;
}

- (void)addViewModelObserver {
    
    @weakify(self)
    [self.yah_KVOController observe:self.viewModel keyPath:@"isEdit" block:^(id observer, id object, NSDictionary *change) {
        
        @strongify(self)
        [self refreshNavigationBarItem:self.viewModel.isEdit];
        self.courtTracticsView.isEdit = self.viewModel.isEdit;
        if (self.viewModel.isEdit) {
            self.playerSelectView.dataList = self.viewModel.otherPlayerList;
        }
    }];
    
    [self.yah_KVOController observe:self.viewModel keyPath:@"selectIndexPath" block:^(id observer, id object, NSDictionary *change) {
        
        @strongify(self)
        self.courtTracticsView.selectIndexPath = self.viewModel.selectIndexPath;
    }];
}

- (void)setupDefaultNavigationBarItem {
    
    self.title = LS(@".team.tractics.tractics");
    [self setupBackButtonWithBlock:nil];
    
    if (self.useSelect) {
        NSString *title = LS(@"team.tractics.select");
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToHeight:24];
        self.yesButton.size = size;
        [self.yesButton setTitle:title forState:UIControlStateNormal];
        [self.yesButton setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
        [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.yesButton] animated:YES];
    }else {
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    }
    //默认位置
    self.topViewHeightConstraint.constant = (NSInteger)(55*kAppScale);
    self.centerViewTopConstraint.constant = (NSInteger)((55+8)*kAppScale + kUIScreen_NavigationBarHeight);
}

- (void)refreshNavigationBarItem:(BOOL)isEdit {
    
    if (isEdit) {
        
        self.title = self.tracticsNameLabel.text;
        NSString *title = LS(@"common.btn.cancel");
        CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToHeight:24];
        [self.cancelButton setTitle:title forState:UIControlStateNormal];
        self.cancelButton.size = size;
        [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.cancelButton] animated:YES];
        
        // 选择情况不需要保存
        if (self.useSelect) {
            title = LS(@"team.tractics.select");
            size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToHeight:24];
            self.yesButton.size = size;
            [self.yesButton setTitle:title forState:UIControlStateNormal];
            [self.yesButton setTitleColor:[ColorManager styleColor] forState:UIControlStateNormal];
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.yesButton] animated:YES];
            
        } else {
            title = LS(@"common.btn.save");
            size = [title sizeWithFont:[UIFont systemFontOfSize:16.0f] constrainedToHeight:24];
            [self.yesButton setTitle:title forState:UIControlStateNormal];
            self.yesButton.size = size;
            [self.yesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.yesButton] animated:YES];
        }
        
        self.playerSelectContainView.hidden = NO;
        self.topViewHeightConstraint.constant = 0;
        self.centerViewTopConstraint.constant = (NSInteger)(kUIScreen_NavigationBarHeight+8*kAppScale);
        [UIView animateWithDuration:0.3f animations:^{
            
            [self.view layoutIfNeeded];
        }];
    }else {
        
        [self setupDefaultNavigationBarItem];
        self.playerSelectContainView.hidden = YES;
        
        self.topViewHeightConstraint.constant = (NSInteger)(55*kAppScale);
        self.centerViewTopConstraint.constant = (NSInteger)((55+8)*kAppScale + kUIScreen_NavigationBarHeight);
        [UIView animateWithDuration:0.3f animations:^{
            
            [self.view layoutIfNeeded];
        }];
    }
    
}

#pragma mark - Delegate
#pragma mark GBCourtTracticsViewDelegate

- (void)courtTracticsView:(GBCourtLineUpView *)courtTracticsView didSelectAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.isCreateTeamGame) {  //创建球队比赛  副队长可以编辑战术
        if ([RawCacheManager sharedRawCacheManager].userInfo.roleType == TeamPalyerType_Ordinary) {
            return;
        }
    }else {
        if (!self.viewModel.homeTeamInfo.team_mess.isMineTeam) {
            return;
        }
    }
    
    [self.viewModel startEdit];
    self.viewModel.selectIndexPath = indexPath;
}

- (void)courtTracticsView:(GBCourtLineUpView *)courtTracticsView removeAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.viewModel removePlayerWithIndexPath:indexPath];
    [self refreshUI];
}

#pragma mark TracticsPlayerSelectViewDelegate

- (void)tracticsPlayerSelectView:(LineUpPlayerSelectView *)tracticsPlayerSelectView didSelectAtIndexPath:(NSIndexPath *)indexPath {
    
    //选中球员
    [self.viewModel addPlayerWithTeamPlayerInfo:[self.viewModel.otherPlayerList objectAtIndex:indexPath.row]];
    
    [self refreshUI];
}

#pragma mark - Setter and Getter


- (UIButton *)cancelButton {
    
    if (!_cancelButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(actionCancel) forControlEvents:UIControlEventTouchUpInside];
        
        _cancelButton = button;
    }
    
    return _cancelButton;
}

- (UIButton *)yesButton {
    
    if (!_yesButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setSize:CGSizeMake(60, 24)];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        
        button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(actionYes) forControlEvents:UIControlEventTouchUpInside];
        
        _yesButton = button;
    }
    
    return _yesButton;
}

@end
