//
//  TacticsContentView.m
//  GB_Football
//
//  Created by yahua on 2017/12/25.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TacticsContentView.h"
#import "WMDragView.h"
#import "PaintingLayer.h"
#import "ArrowBrush.h"

#import "TacticsContentViewModel.h"
#import "AnimationManager.h"
#import "AnimationStepObject.h"

@interface TacticsContentView () <
AnimationManagerDelegate>

@property (nonatomic, strong) WMDragView *ballView;
@property (nonatomic, strong) NSMutableArray<WMDragView *> *playerViewList;
/** 涂鸦图层. */
@property (nonatomic, strong) PaintingLayer *paintingLayer;
/** 是否应该开始触摸系列事件. */
@property (nonatomic) BOOL touchShouldBegin;

@property (nonatomic, strong) TacticsContentViewModel *viewModel;
@property (nonatomic, assign) BOOL isInit;

//动画管理
@property (nonatomic, strong) AnimationManager *manager;
//view动画集合
@property (nonatomic, strong) AnimationStepObject *stepObject;

@end

@implementation TacticsContentView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    if (!_isInit) {  //由于引入xxnibbridge 会调用两次
        _isInit = YES;
        [self initData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stepMoveCountChangeNotification:) name:AnimationStepMoveCountChangeNotification object:nil];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (CGRectIsEmpty(self.paintingLayer.frame)) {
        self.paintingLayer.frame = self.bounds;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [super touchesBegan:touches withEvent:event];
    self.touchShouldBegin = NO;
    if (!self.isEdit || !self.isBursh) {
        return;
    }
    UIView *view = touches.anyObject.view;
    if (view) {
        //转换坐标
        CGRect rect = [view convertRect:view.bounds toView:nil];
        BOOL isTouchDragView = NO;
        for (WMDragView *dragView in self.playerViewList) {
            CGRect dragViewRect = [dragView convertRect:view.bounds toView:nil];
            if (CGRectEqualToRect(rect, dragViewRect)) {
                isTouchDragView = YES;
            }
        }
        if (isTouchDragView) {
            self.touchShouldBegin = NO;
        }else {
            CGPoint point = [self.paintingLayer convertPoint:[touches.anyObject locationInView:self]
                                                fromLayer:self.layer];
            
            self.touchShouldBegin = CGRectContainsPoint(self.paintingLayer.bounds, point);
            if (self.touchShouldBegin && self.stepObject) {
                ArrowBrush *paintBrush = [BaseBrush brushWithType:BrushTypeArrow];
                [self.paintingLayer touchAction:touches.anyObject brush:paintBrush];
                
                [self.stepObject.lineMoveObject.paintBrushList addObject:paintBrush];
                [self.stepObject addNewMove:self.stepObject.lineMoveObject.identifier];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchShouldBegin) {
        id<PaintBrush> paintBrush = [self.stepObject.lineMoveObject.paintBrushList lastObject];
        [self.paintingLayer touchAction:touches.anyObject brush:paintBrush];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchShouldBegin) {
        id<PaintBrush> paintBrush = [self.stepObject.lineMoveObject.paintBrushList lastObject];
        [self.paintingLayer touchAction:touches.anyObject brush:paintBrush];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.touchShouldBegin) {
        id<PaintBrush> paintBrush = [self.stepObject.lineMoveObject.paintBrushList lastObject];
        [self.paintingLayer touchAction:touches.anyObject brush:paintBrush];
    }
}

#pragma mark - Public

- (void)loadWithNetworkData:(NSArray<TacticsJsonStepModel *> *)stepList {
    
    if (stepList && stepList.count>0) {
        self.currentStep = 1;
        self.totalStep = stepList.count;
        
        self.viewModel.stepList = stepList;
        //创建相应view
        [self initSubViews];
        //为view创建动画
        for (TacticsJsonStepModel *stepModel in stepList) {
            AnimationStepObject *animationStepObject = [self createDefaultStep];
            
            [self refreshMoveStep:animationStepObject moveViewJsonList:@[stepModel.footballMove]];
            [self refreshMoveStep:animationStepObject moveViewJsonList:stepModel.homePlayersMoveList];
            [self refreshMoveStep:animationStepObject moveViewJsonList:stepModel.guestPlayersMoveList];
            //画线
            NSMutableArray<ArrowBrush *> *result = [NSMutableArray arrayWithCapacity:1];
            for (TacticsJsonLineModel *lineModel in stepModel.arrowLineList) {
                ArrowBrush *brush = [BaseBrush brushWithType:BrushTypeArrow];
                [brush beginAtPoint:CGPointMake(kTacticsContentViewWidth*lineModel.beginPoint.x, kTacticsContentViewHeight*lineModel.beginPoint.y)];
                [brush moveToPoint:CGPointMake(kTacticsContentViewWidth*lineModel.endPoint.x, kTacticsContentViewHeight*lineModel.endPoint.y)];
                [result addObject:brush];
            }

            [animationStepObject.lineMoveObject.paintBrushList addObjectsFromArray:[result copy]];
            
            animationStepObject.moveList = [NSMutableArray arrayWithArray:stepModel.moveList];
            
            [self.manager addFrameAnimation:animationStepObject];
        }
    }else {
        [self initSubViews];
    }
}

- (NSArray<AnimationStepObject *> *)stepList {
    
    return [self.manager.stepList copy];
}

- (void)playTactics:(BOOL)isPlay {
    
    if (isPlay) {
        //位置复原
        for (WMDragView *dragView in self.playerViewList) {
            dragView.center = dragView.tacticsPlayerModel.playerOriginPos;
        }
        [self.manager startAnimation];
    }else {
        [self.manager pauseAnimation];
    }
}

- (void)addNewStep {
    
    self.isEdit = YES;
    if (self.totalStep == self.currentStep) {
        self.totalStep += 1;
        self.currentStep = self.totalStep;
        
        //动画添加
        self.stepObject = [self createDefaultStep];
        [self.manager addFrameAnimation:self.stepObject];
        
        [_paintingLayer clear];
    }else { //当前步处于中间， eg：动画时被暂停了
        self.totalStep += 1;
        //动画添加
        [self.manager addFrameAnimation:[self createDefaultStep]];
    }
}

- (void)deleteStep {
    
    if (self.totalStep == 0) {
        return;
    }

    [self.manager removeFrameWithStep:self.currentStep-1];
    
    self.totalStep -= 1;
    if (self.totalStep == 0) {
        self.isEdit = NO;
    }
    self.currentStep -= 1;
    if (self.currentStep == 0 && self.totalStep>0) {
        self.currentStep = 1;
    }
}

- (void)addHomeTeamPlayer {
    
    WMDragView *view = [self dragViewWithModel:[self.viewModel getNextHomeTeamPlayer]];
    if (!view) {
        return;
    }
    [self.playerViewList addObject:view];
    self.isCanBack = YES;
}

- (void)addGuestTeamPlayer {
    
    WMDragView *view = [self dragViewWithModel:[self.viewModel getNextGuestTeamPlayer]];
    if (!view) {
        return;
    }
    [self.playerViewList addObject:view];
    self.isCanBack = YES;
}

- (void)back {
    
    if (_isEdit) {//删除动画
        AnimationBaseMoveObject *removeObject = [_stepObject removeLastMove];
        if ([removeObject isMemberOfClass:[AnimationLineMoveObject class]]) {
            [_paintingLayer refreshWithBrushList:[_stepObject.lineMoveObject.paintBrushList copy]];
        }
    }else { //删除小球
        if ([_viewModel back]) {
            UIView *view = self.playerViewList.lastObject;
            if (view) {
                [view removeFromSuperview];
            }
            [self.playerViewList removeLastObject];
        }
        self.isCanBack = [_viewModel isCanBack];
    }
}

- (void)stepMoveCountChangeNotification:(NSNotification *)notification {
    
    id object = notification.object;
    if (![object isKindOfClass:[NSNumber class]]) {
        return;
    }
    NSInteger count = [object integerValue];
    self.isCanBack = count>0;
}

#pragma mark - Private

- (void)initData {
    
    _viewModel = [[TacticsContentViewModel alloc] init];
    _playerViewList = [NSMutableArray arrayWithCapacity:1];
    self.manager = [[AnimationManager alloc] init];
    self.manager.delegate = self;
}

- (void)initSubViews {
    
    _paintingLayer = [PaintingLayer layer];
    [_paintingLayer refreshWithBrushList:[self.viewModel getDefaultBurshList]];
    [self.layer addSublayer:_paintingLayer];
    
    self.ballView = [self dragViewWithModel:[self.viewModel getBallModel]];
    [self.playerViewList addObject:self.ballView];
    NSArray *list = [self.viewModel getDefaultPlayers];
    for (GBTacticsPlayerModel *model in list) {
        WMDragView *view = [self dragViewWithModel:model];
        if (!view) {
            continue;
        }
        [self.playerViewList addObject:view];
    }
}

- (WMDragView *)dragViewWithModel:(GBTacticsPlayerModel *)model {
    
    if (!model) {
        return nil;
    }
    
    WMDragView *view = [[NSBundle mainBundle] loadNibNamed:@"WMDragView" owner:self options:nil].firstObject;
    view.dragEnable = NO;
    view.tacticsPlayerModel = model;
    if (self.ballView) { //足球展示在最前面
        [self insertSubview:view aboveSubview:self.ballView];
    }else {
        [self addSubview:view];
    }
    
    
    @weakify(self)
    view.beginDragBlock = ^(WMDragView *dragView) {
        
    };
    view.duringDragBlock = ^(WMDragView *dragView) {
        
    };
    view.endDragBlock = ^(WMDragView *dragView) {
        
        @strongify(self)
        AnimationBaseMoveObject *object = [self.stepObject findAnimationObjectWithIdenfier:dragView.tacticsPlayerModel.identifier];
        if (![object isMemberOfClass:[AnimationViewMoveObject class]]) {
            return;
        }
        AnimationViewMoveObject *moveObject = (AnimationViewMoveObject *)object;
        moveObject.endPoint = dragView.center;
        [moveObject.keyPointList addObject:[NSValue valueWithCGPoint:dragView.center]];
        
        //添加到当前步的移动集合
        [self.stepObject addNewMove:moveObject.identifier];
        
    };
    
    return view;
}

- (AnimationStepObject *)createDefaultStep {
    
    AnimationStepObject *lastStep = self.manager.lastStepObject;
    AnimationStepObject *newStep = [[AnimationStepObject alloc] init];
    if (lastStep.viewMoveList.count>0) { //第一步可能为空
        //为已存在的view创建默认move
        for (AnimationViewMoveObject *oldMove in self.manager.lastStepObject.viewMoveList) {
            AnimationViewMoveObject *newMove = [[AnimationViewMoveObject alloc] init];
            newMove.beginPoint = oldMove.endPoint;
            newMove.endPoint = oldMove.endPoint;
            newMove.identifier = oldMove.identifier;
            newMove.moveView = oldMove.moveView;
            newMove.moveType = oldMove.moveType;
            [newStep.viewMoveList addObject:newMove];
        }
    }else {
        for (WMDragView *view in self.playerViewList) {
            AnimationViewMoveObject *newMove = [[AnimationViewMoveObject alloc] init];
            newMove.beginPoint = view.center;
            newMove.endPoint = view.center;
            newMove.identifier = view.tacticsPlayerModel.identifier;
            newMove.moveView = view;
            newMove.moveType = view.tacticsPlayerModel.playerType;
            [newStep.viewMoveList addObject:newMove];
        }
    }
   
    return newStep;
}

- (void)refreshMoveStep:(AnimationStepObject *)stepObject moveViewJsonList:(NSArray<TacticsJsonPlayerMoveModel *> *)homePlayersMoveList {
    
    for (TacticsJsonPlayerMoveModel *moveModel in homePlayersMoveList) {
        for (AnimationViewMoveObject *moveObject in stepObject.viewMoveList) {
            if ([moveObject.identifier isEqualToString:moveModel.identifier]) {
                NSMutableArray<NSValue *> *pointValues = [NSMutableArray arrayWithCapacity:1];
                for (TacticsJsonPointModel *pointModel in moveModel.pathList) {
                    [pointValues addObject:[NSValue valueWithCGPoint:CGPointMake(pointModel.x*kTacticsContentViewWidth, pointModel.y*kTacticsContentViewHeight)]];
                }
                moveObject.beginPoint = pointValues.firstObject.CGPointValue;
                moveObject.endPoint = pointValues.lastObject.CGPointValue;
                moveObject.keyPointList = pointValues;
                break;
            }
        }
    }
}

#pragma mark - Setter and Getter

- (void)setIsEdit:(BOOL)isEdit {
    
    _isEdit = isEdit;
    for (WMDragView *view in self.playerViewList) {
        view.dragEnable = isEdit;
    }
}

- (void)setStepObject:(AnimationStepObject *)stepObject {
    
    _stepObject = stepObject;
    self.isCanBack = stepObject.isMove;
}

#pragma mark - Delegate
#pragma mark AnimationManagerDelegate

- (void)animationAtStep:(NSInteger)step stepObject:(AnimationStepObject *)stepObject {
    
    self.isPalying = YES;
    if (step+1<=self.totalStep) {
        self.currentStep = step+1;
    }
    [_paintingLayer refreshWithBrushList:[stepObject.lineMoveObject.paintBrushList copy]];
}

- (void)animationDidStop:(AnimationStepObject *)stepObject isFinish:(BOOL)isFinish {
    
    self.isPalying = NO;
    self.stepObject = stepObject;
}

- (void)animationDidDelete:(AnimationStepObject *)stepObject nowStepObject:(AnimationStepObject *)nowStepObject {
    
    self.stepObject = nowStepObject;
    
    [_paintingLayer refreshWithBrushList:[nowStepObject.lineMoveObject.paintBrushList copy]];
}

@end
