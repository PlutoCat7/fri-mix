//
//  TacticsContentViewModel.m
//  GB_Football
//
//  Created by yahua on 2017/12/26.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "TacticsContentViewModel.h"



static const NSInteger kDefaultHomePlayerCount = 3;
static const NSInteger kDefaultGuestPlayerCount = 3;
static const NSInteger kMaxHomePlayerCount = 11;
static const NSInteger kMaxGuestPlayerCount = 11;

static NSString *const kFootballIndentifier = @"kFootballIndentifier";
static NSString *const kHomeTeamPreIndentifier = @"kHomeTeamPreIndentifier";
static NSString *const kGuestTeamPreIndentifier = @"kGuestTeamPreIndentifier";

@interface TacticsContentViewModel ()

@property (nonatomic, strong) NSMutableArray<GBTacticsPlayerModel *> *homeTeamAddedPlayers;
@property (nonatomic, strong) NSMutableArray<GBTacticsPlayerModel *> *guestTeamAddedPlayers;
@property (nonatomic, strong) NSMutableArray<GBTacticsPlayerModel *> *allPlayers;

@end

@implementation TacticsContentViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _homeTeamAddedPlayers = [NSMutableArray arrayWithCapacity:1];
        _guestTeamAddedPlayers = [NSMutableArray arrayWithCapacity:1];
        _allPlayers = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

#pragma mark - Public

- (GBTacticsPlayerModel *)getBallModel {
    
    GBTacticsPlayerModel *model = [[GBTacticsPlayerModel alloc] init];
    model.image = [UIImage imageNamed:@"tactics_ball"];
    model.playerType = TacticsPlayerType_Football;
    model.identifier = kFootballIndentifier;
    
    if (_stepList.firstObject) {
        TacticsJsonPointModel *point = _stepList.firstObject.footballMove.pathList.firstObject;
        model.playerOriginPos = CGPointMake(kTacticsContentViewWidth*point.x, kTacticsContentViewHeight*point.y);
    }else {
        model.playerOriginPos = CGPointMake(kTacticsContentViewWidth*0.5, kTacticsContentViewHeight*0.5);
    }
    model.playerCurrentPos = model.playerOriginPos;
    
    return model;
}

- (NSArray<GBTacticsPlayerModel *> *)getDefaultPlayers {
    
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:1];
    if (_stepList.firstObject) {
        for (TacticsJsonPlayerMoveModel *moveModel in _stepList.firstObject.homePlayersMoveList) {
            
            GBTacticsPlayerModel *model = [[GBTacticsPlayerModel alloc] init];
            model.playerOriginPos = CGPointMake(kTacticsContentViewWidth*moveModel.pathList.firstObject.x, kTacticsContentViewHeight*moveModel.pathList.firstObject.y);
            model.playerCurrentPos = model.playerOriginPos;
            model.playerColor = [UIColor colorWithHex:0x3FA1EC];
            model.playerType = TacticsPlayerType_Home;
            model.identifier = moveModel.identifier;
            
            [result addObject:model];
            [self.homeTeamAddedPlayers addObject:model];
        }
        for (TacticsJsonPlayerMoveModel *moveModel in _stepList.firstObject.guestPlayersMoveList) {
            
            GBTacticsPlayerModel *model = [[GBTacticsPlayerModel alloc] init];
            model.playerOriginPos = CGPointMake(kTacticsContentViewWidth*moveModel.pathList.firstObject.x, kTacticsContentViewHeight*moveModel.pathList.firstObject.y);
            model.playerCurrentPos = model.playerOriginPos;
            model.playerColor = [UIColor colorWithHex:0xf1b03a];
            model.playerType = TacticsPlayerType_Guest;
            model.identifier = moveModel.identifier;
            
            [result addObject:model];
            [self.homeTeamAddedPlayers addObject:model];
        }
    }else {
        for (NSInteger i=0; i<kDefaultGuestPlayerCount; i++) { //客队
            GBTacticsPlayerModel *model = [[GBTacticsPlayerModel alloc] init];
            model.playerOriginPos = [self guestPalyerPointWithIndex:i];
            model.playerCurrentPos = model.playerOriginPos;
            model.playerColor = [UIColor colorWithHex:0xf1b03a];
            model.playerType = TacticsPlayerType_Guest;
            model.identifier = [self playerIdentifierWithIndex:i isHome:NO];
            
            [result addObject:model];
            [self.guestTeamAddedPlayers addObject:model];
        }
        
        for (NSInteger i=0; i<kDefaultHomePlayerCount; i++) {  //主队
            GBTacticsPlayerModel *model = [[GBTacticsPlayerModel alloc] init];
            model.playerOriginPos = [self homePalyerPointWithIndex:i];
            model.playerCurrentPos = model.playerOriginPos;
            model.playerColor = [UIColor colorWithHex:0x3FA1EC];
            model.playerType = TacticsPlayerType_Home;
            model.identifier = [self playerIdentifierWithIndex:i isHome:YES];
            
            [result addObject:model];
            [self.homeTeamAddedPlayers addObject:model];
        }
    }
    
    [self.allPlayers addObjectsFromArray:result];
    return [result copy];
}

- (NSArray<ArrowBrush *> *)getDefaultBurshList {
    
    if (!self.stepList) {
        return nil;
    }
    NSMutableArray<ArrowBrush *> *result = [NSMutableArray arrayWithCapacity:1];
    for (TacticsJsonLineModel *lineModel in self.stepList.firstObject.arrowLineList) {
        ArrowBrush *brush = [BaseBrush brushWithType:BrushTypeArrow];
        [brush beginAtPoint:CGPointMake(kTacticsContentViewWidth*lineModel.beginPoint.x, kTacticsContentViewHeight*lineModel.beginPoint.y)];
        [brush moveToPoint:CGPointMake(kTacticsContentViewWidth*lineModel.endPoint.x, kTacticsContentViewHeight*lineModel.endPoint.y)];
        [result addObject:brush];
    }
    
    return [result copy];
}

- (GBTacticsPlayerModel *)getNextHomeTeamPlayer {
    
    if (self.homeTeamAddedPlayers.count >= kMaxHomePlayerCount) {
        return nil;
    }
    
    NSInteger index = self.homeTeamAddedPlayers.count;
    
    GBTacticsPlayerModel *model = [[GBTacticsPlayerModel alloc] init];
    model.playerOriginPos = [self homePalyerPointWithIndex:index];
    model.playerCurrentPos = model.playerOriginPos;
    model.playerColor = [UIColor colorWithHex:0x3FA1EC];
    model.playerType = TacticsPlayerType_Home;
    model.identifier = [self playerIdentifierWithIndex:index isHome:YES];
    [self.homeTeamAddedPlayers addObject:model];
    
    [self.allPlayers addObject:model];
    
    return model;
}

- (GBTacticsPlayerModel *)getNextGuestTeamPlayer {
    
    if (self.guestTeamAddedPlayers.count == kMaxGuestPlayerCount) {
        return nil;
    }
    
    NSInteger index = self.guestTeamAddedPlayers.count;
    
    GBTacticsPlayerModel *model = [[GBTacticsPlayerModel alloc] init];
    model.playerOriginPos = [self guestPalyerPointWithIndex:index];
    model.playerCurrentPos = model.playerOriginPos;
    model.playerColor = [UIColor colorWithHex:0xf1b03a];
    model.playerType = TacticsPlayerType_Guest;
    model.identifier = [self playerIdentifierWithIndex:index isHome:NO];
    [self.guestTeamAddedPlayers addObject:model];
    
    [self.allPlayers addObject:model];
    
    return model;
}

- (BOOL)back {
    
    if ([self isCanBack]) {
        GBTacticsPlayerModel *object = self.allPlayers.lastObject;
        if (object) {
            [self.allPlayers removeObject:object];
            if ([self.homeTeamAddedPlayers containsObject:object]) {
                [self.homeTeamAddedPlayers removeObject:object];
            }
            if ([self.guestTeamAddedPlayers containsObject:object]) {
                [self.guestTeamAddedPlayers removeObject:object];
            }
            return YES;
        }
    }
    return NO;
}

- (BOOL)isCanBack {
    
    return self.allPlayers.count>kDefaultGuestPlayerCount + kDefaultHomePlayerCount;
}

#pragma mark - Private

- (CGPoint)homePalyerPointWithIndex:(NSInteger)index {
    
    if (index<kDefaultHomePlayerCount) {

        CGFloat yRate = 0.57;
        CGFloat xRate = 0.6;
        CGFloat spaceRate = 0.11;
        for (NSInteger i=0; i<kDefaultHomePlayerCount; i++) {  //主队
            if (i == index) {
                return CGPointMake(kTacticsContentViewWidth*xRate, kTacticsContentViewHeight*yRate);
            }
            xRate += spaceRate;
        }
    }else if(index<kMaxHomePlayerCount){
        CGFloat xPos = 25.0f*kAppScale;
        CGFloat space = 40;
        CGFloat yPos = 0.5*kTacticsContentViewHeight + 50;
        NSMutableArray<NSValue *> *posList = [NSMutableArray arrayWithCapacity:1];
        for (NSInteger i=0; i<4; i++) {
            CGPoint point = CGPointMake(xPos, yPos);
            [posList addObject:[NSValue valueWithCGPoint:point]];
            
            yPos += space;
        }
        xPos += 40;
        yPos = 0.5*kTacticsContentViewHeight + 50;
        for (NSInteger i=0; i<4; i++) {
            CGPoint point = CGPointMake(xPos, yPos);
            [posList addObject:[NSValue valueWithCGPoint:point]];
            
            yPos += space;
        }
        //下一个球员的位置
        CGPoint pos = [[posList objectAtIndex:index-kDefaultGuestPlayerCount] CGPointValue];
        return pos;
    }
    
    return CGPointZero;
}

- (CGPoint)guestPalyerPointWithIndex:(NSInteger)index {
    
    if (index<kDefaultHomePlayerCount) {
        
        CGFloat yRate = 0.43;
        CGFloat xRate = 0.6;
        CGFloat spaceRate = 0.11;
        for (NSInteger i=0; i<kDefaultGuestPlayerCount; i++) {  //主队
            if (i == index) {
                return CGPointMake(kTacticsContentViewWidth*xRate, kTacticsContentViewHeight*yRate);
            }
            xRate += spaceRate;
        }
    }else if(index<kMaxHomePlayerCount){
        CGFloat xPos = 25.0f*kAppScale;
        CGFloat space = 40;
        CGFloat yPos = 0.5*kTacticsContentViewHeight - 50;
        NSMutableArray<NSValue *> *posList = [NSMutableArray arrayWithCapacity:1];
        for (NSInteger i=0; i<4; i++) {
            CGPoint point = CGPointMake(xPos, yPos);
            [posList addObject:[NSValue valueWithCGPoint:point]];
            
            yPos -= space;
        }
        xPos += 40;
        yPos = 0.5*kTacticsContentViewHeight - 50;
        for (NSInteger i=0; i<4; i++) {
            CGPoint point = CGPointMake(xPos, yPos);
            [posList addObject:[NSValue valueWithCGPoint:point]];
            
            yPos -= space;
        }
        //下一个球员的位置
        CGPoint pos = [[posList objectAtIndex:index-kDefaultGuestPlayerCount] CGPointValue];
        return pos;
    }
    
    return CGPointZero;
}

- (NSString *)playerIdentifierWithIndex:(NSInteger)index isHome:(BOOL)isHome {
    
    NSMutableArray *identifierList = [NSMutableArray arrayWithCapacity:1];
    for(NSInteger i=0; i<kMaxHomePlayerCount; i++) {
        [identifierList addObject:[NSString stringWithFormat:@"%@_%td", isHome?kHomeTeamPreIndentifier:kGuestTeamPreIndentifier, i]];
    }
    if (index>=identifierList.count) {
        return @"";
    }else {
        return identifierList[index];
    }
}

@end
