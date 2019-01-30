//
//  TacticsViewController.m
//  GB_Football
//
//  Created by yahua on 2017/12/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TacticsViewController.h"

#import "TacticsContentView.h"
#import "TacticsEditBoardView.h"
#import "TacticeHeaderView.h"
#import "TacticsNameView.h"

#import "TacticsJsonModel.h"
#import "TeamRequest.h"
#import "TeamTacticsListResponse.h"

#define kTacticsContentViewWidth (335*kAppScale)
#define kTacticsContentViewHeight (480*kAppScale)

@interface TacticsViewController () <TacticsEditBoardViewDelegate,
TacticeHeaderViewDelegate>

@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *okButton;
@property (weak, nonatomic) IBOutlet UILabel *stepLabel;
@property (weak, nonatomic) IBOutlet TacticsContentView *tacticsContnetView;
@property (weak, nonatomic) IBOutlet TacticsEditBoardView *tacticsEditView;

@property (nonatomic, strong) TeamTacticsInfo *tacticsInfo;
@property (nonatomic, assign) BOOL isEdit;

@end

@implementation TacticsViewController

- (instancetype)initWithTacticsInfo:(TeamTacticsInfo *)tacticsInfo {
    
    self = [super init];
    if (self) {
        _tacticsInfo = tacticsInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self kvoObserve];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (void)loadData {
    
    if (_tacticsInfo) {
        [self showLoadingToast];
        @weakify(self)
        [TeamRequest downloadTacticsDataWithUrl:_tacticsInfo.tactics_mess handler:^(id result, NSError *error) {
           
            @strongify(self)
            if (error) {
                [self showToastWithText:error.domain];
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [self dismissToast];
                TacticsJsonModel *tacticsModel = (TacticsJsonModel *)result;
                [self.tacticsContnetView loadWithNetworkData:tacticsModel.stepList];
            }
        }];
    }else {
        [self.tacticsContnetView loadWithNetworkData:nil];
    }
}

- (void)setupUI {
    
    [self setupBackButtonWithBlock:nil];
    self.tacticsEditView.delegate = self;
    [self setupNavigationRightItem];
    
    [self refreshView];
}

- (void)kvoObserve {
    
    @weakify(self)
    [self.yah_KVOController observe:self.tacticsContnetView keyPaths:@[@"totalStep", @"currentStep"] block:^(id observer, id object, NSDictionary *change) {
        
        @strongify(self)
        if (self.tacticsContnetView.totalStep>0) {
            NSInteger totalStep = self.tacticsContnetView.totalStep;
            NSInteger currentStep = self.tacticsContnetView.currentStep;
            self.stepLabel.text = [NSString stringWithFormat:@"第%td步，共%td步", currentStep, totalStep];
        }else {
            self.stepLabel.text = @"";
        }
    }];
    
    [self.yah_KVOController observe:self.tacticsContnetView keyPath:@"isPalying" block:^(id observer, id object, NSDictionary *change) {
        
        @strongify(self)
        self.tacticsEditView.isPlaying = self.tacticsContnetView.isPalying;
    }];
    [self.yah_KVOController observe:self.tacticsContnetView keyPath:@"isCanBack" block:^(id observer, id object, NSDictionary *change) {
        
        @strongify(self)
        self.tacticsEditView.isCanBack = self.tacticsContnetView.isCanBack;
    }];
}

- (void)setupNavigationRightItem {
    
    UIButton *menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    menuBtn.frame = CGRectMake(0, 0, 44, 44);
    [menuBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [menuBtn setTitleColor:[ColorManager disableColor] forState:UIControlStateDisabled];
    menuBtn.titleLabel.font=[UIFont systemFontOfSize:16];
    [menuBtn setTitle:LS(@"common.btn.save") forState:UIControlStateNormal];
    @weakify(self)
    [menuBtn addActionHandler:^(NSInteger tag) {
        @strongify(self)
        if (self.tacticsInfo) {
            if (!self.isEdit) {
                self.isEdit = YES;
                self.tacticsContnetView.isEdit = YES;
                [self refreshView];
                return;
            }
        }
        [TacticsNameView showWithName:self.tacticsInfo.tactics_name block:^(NSString *name) {
            [self saveTaticsWithName:name];
        }];
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
    menuBtn.enabled = NO;
    self.okButton = menuBtn;
}

- (void)refreshView {
    
    if (_tacticsInfo) {
        self.okButton.enabled = YES;
        if (_isEdit) {
            [self.okButton setTitle:LS(@"common.btn.save") forState:UIControlStateNormal];
            [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:self.cancelButton] animated:YES];
            TacticeHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"TacticeHeaderView" owner:self options:nil].firstObject;
            headerView.delegate = self;
            self.navigationItem.titleView = headerView;
            self.tacticsEditView.hideEditBoard = NO;
        }else {
            [self.okButton setTitle:LS(@"修改") forState:UIControlStateNormal];
            [self setupBackButtonWithBlock:nil];
            self.navigationItem.titleView = nil;
            self.title = _tacticsInfo.tactics_name;
            self.tacticsEditView.hideEditBoard = YES;
        }
    }else {
        TacticeHeaderView *headerView = [[NSBundle mainBundle] loadNibNamed:@"TacticeHeaderView" owner:self options:nil].firstObject;
        headerView.delegate = self;
        self.navigationItem.titleView = headerView;
        
        self.tacticsEditView.hideEditBoard = NO;
    }
}

- (void)saveTaticsWithName:(NSString *)name {
    
    NSArray<AnimationStepObject *> *stepList = [self.tacticsContnetView stepList];
    NSInteger playerCount = stepList.firstObject.viewMoveList.count-1; //减去足球
    NSString *tacticsName = name;
    NSString *jsonString = [self convertJsonStringWithStepList:stepList];
    [self showLoadingToast];
    @weakify(self)
    if (_tacticsInfo) { //修改
        [TeamRequest modifyTacticsWithId:_tacticsInfo.tacticsId tacticsName:tacticsName playerNum:playerCount jsonDataString:jsonString handler:^(id result, NSError *error) {
            
            @strongify(self)
            [self dismissToast];
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Team_Tactics_Modify object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }else {  //保存
        [TeamRequest addTacticsWithName:tacticsName playerNum:playerCount jsonDataString:jsonString handler:^(id result, NSError *error) {
            
            @strongify(self)
            [self dismissToast];
            if (error) {
                [self showToastWithText:error.domain];
            }else {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notification_Team_Tactics_Add object:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}

- (NSString *)convertJsonStringWithStepList:(NSArray<AnimationStepObject *> *)stepList {
    
    NSInteger playerCount = stepList.firstObject.viewMoveList.count;
    TacticsJsonModel *jsonModel = [[TacticsJsonModel alloc] init];
    jsonModel.count = playerCount; //减去足球
    jsonModel.tacticsName = @"";
    NSMutableArray<TacticsJsonStepModel *> *jsonStepList = [NSMutableArray arrayWithCapacity:1];
    for (AnimationStepObject *stepObject in stepList) {
        TacticsJsonStepModel *jsonStepModel = [[TacticsJsonStepModel alloc] init];
        
        //view移动
        TacticsJsonPlayerMoveModel *footballMoveModel = [[TacticsJsonPlayerMoveModel alloc] init];
        NSMutableArray<TacticsJsonPlayerMoveModel *> *homePlayersMoveList = [NSMutableArray arrayWithCapacity:1];
        NSMutableArray<TacticsJsonPlayerMoveModel *> *guestPlayersMoveList = [NSMutableArray arrayWithCapacity:1];
        for (AnimationViewMoveObject *viewMoveObject in stepObject.viewMoveList) {
            
            TacticsJsonPlayerMoveModel *jsonPlayerMoveModel = [self jsonPlayerMoveModel:viewMoveObject];
            switch (viewMoveObject.moveType) {
                case TacticsPlayerType_Football:
                    footballMoveModel = jsonPlayerMoveModel;
                    break;
                case TacticsPlayerType_Home:
                    [homePlayersMoveList addObject:jsonPlayerMoveModel];
                    break;
                case TacticsPlayerType_Guest:
                    [guestPlayersMoveList addObject:jsonPlayerMoveModel];
                    break;
            }
        }
        jsonStepModel.footballMove = footballMoveModel;
        jsonStepModel.homePlayersMoveList = [homePlayersMoveList copy];
        jsonStepModel.guestPlayersMoveList = [guestPlayersMoveList copy];
        
        //箭头
        NSMutableArray<TacticsJsonLineModel *> *arrowLineList = [NSMutableArray arrayWithCapacity:1];
        for (id<PaintBrush> brush in stepObject.lineMoveObject.paintBrushList) {
            
            TacticsJsonPointModel *beginPoint = [[TacticsJsonPointModel alloc] init];
            beginPoint.x = brush.startPoint.x/kTacticsContentViewWidth;
            beginPoint.y = brush.startPoint.y/kTacticsContentViewHeight;
            TacticsJsonPointModel *endPoint = [[TacticsJsonPointModel alloc] init];
            endPoint.x = brush.currentPoint.x/kTacticsContentViewWidth;
            endPoint.y = brush.currentPoint.y/kTacticsContentViewHeight;
            
            TacticsJsonLineModel *jsonLineModel = [[TacticsJsonLineModel alloc] init];
            jsonLineModel.beginPoint = beginPoint;
            jsonLineModel.endPoint = endPoint;
            
            [arrowLineList addObject:jsonLineModel];
        }
        jsonStepModel.arrowLineList = [arrowLineList copy];
        
        //移动步骤
        jsonStepModel.moveList = [stepObject.moveList copy];
        
        [jsonStepList addObject:jsonStepModel];
    }
    jsonModel.stepList = [jsonStepList copy];
    
    NSString *jsonString =
     [YAHJSONAdapter jsonStringFromObject:jsonModel];
    
    return jsonString;
}

- (TacticsJsonPlayerMoveModel *)jsonPlayerMoveModel:(AnimationViewMoveObject *)moveObject {
    
    TacticsJsonPlayerMoveModel *jsonPlayerMoveModel = [[TacticsJsonPlayerMoveModel alloc] init];
    jsonPlayerMoveModel.identifier = moveObject.identifier;
    NSMutableArray<TacticsJsonPointModel *> *pointList = [NSMutableArray arrayWithCapacity:1];
    for (NSValue *pointValue in moveObject.keyPointList) {
        TacticsJsonPointModel *pointModel = [[TacticsJsonPointModel alloc] init];
        pointModel.x = pointValue.CGPointValue.x/kTacticsContentViewWidth;
        pointModel.y = pointValue.CGPointValue.y/kTacticsContentViewHeight;
        [pointList addObject:pointModel];
    }
    jsonPlayerMoveModel.pathList = [pointList copy];
    
    return jsonPlayerMoveModel;
}

#pragma mark - Delegate
#pragma mark TacticeHeaderViewDelegate

- (void)didClickAddStep {
    
    [self.tacticsContnetView addNewStep];
    self.tacticsEditView.isEdit = YES;
    self.okButton.enabled = YES;
}

- (void)didClickDeleteStep {
    
    [self.tacticsContnetView deleteStep];
    if (self.tacticsContnetView.totalStep == 0 ) {
        self.tacticsEditView.isEdit = NO;
        self.okButton.enabled = NO;
    }else {
        self.tacticsEditView.isEdit = YES;
        self.okButton.enabled = YES;
    }
}

#pragma mark TacticsEditBoardViewDelegate

- (void)didClickAddHomeTeamPlayer {
    
    [self.tacticsContnetView addHomeTeamPlayer];
}

- (void)didClickAddGuestTeamPlayer {
    
    [self.tacticsContnetView addGuestTeamPlayer];
}

- (void)didClickBrushTactics:(BOOL)isBrush {
    
    self.tacticsContnetView.isBursh = isBrush;
}

- (void)didClickRevoke {
    
    [self.tacticsContnetView back];
}

- (void)didClickPlay:(BOOL)isPlay {
    
    [self.tacticsContnetView playTactics:isPlay];
}

#pragma mark - Setter and Getter

- (UIButton *)cancelButton {
    
    if (!_cancelButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:LS(@"common.btn.cancel") forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        @weakify(self)
        [button addActionHandler:^(NSInteger tag) {
            
            @strongify(self)
            [GBAlertView alertWithCallBackBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 1) {
                    self.isEdit = NO;
                    [self refreshView];
                }
            } title:LS(@"common.popbox.title.tip") message:LS(@"您已修改战术板，确认要退出吗？") cancelButtonName:LS(@"common.btn.cancel") otherButtonTitle:LS(@"common.btn.yes") style:GBALERT_STYLE_NOMAL];
        }];
        _cancelButton = button;
    }
    
    return _cancelButton;
}

@end
