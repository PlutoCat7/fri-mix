//
//  AnimationStepObject.m
//  GB_Football
//
//  Created by yahua on 2017/12/28.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "AnimationStepObject.h"

NSString *const  AnimationStepMoveCountChangeNotification = @"AnimationStepMoveCountChangeNotification";

@interface AnimationStepObject ()

@property (nonatomic, strong, readwrite) AnimationLineMoveObject *lineMoveObject;

@end

@implementation AnimationStepObject

- (instancetype)init
{
    self = [super init];
    if (self) {
        _viewMoveList = [NSMutableArray arrayWithCapacity:1];
        _lineMoveObject = [[AnimationLineMoveObject alloc] init];
        _lineMoveObject.identifier = @"AnimationLine";
        _moveList = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (BOOL)isMove {
    
    return self.moveList.count>0;
}

- (void)addNewMove:(NSString *)identifier {
    
    [self.moveList addObject:identifier];
    [[NSNotificationCenter defaultCenter] postNotificationName:AnimationStepMoveCountChangeNotification object:@(self.moveList.count)];
}

- (AnimationBaseMoveObject *)removeLastMove {
    
    AnimationBaseMoveObject *lastObject = [self findAnimationObjectWithIdenfier:self.moveList.lastObject];
    [lastObject removeLastMove];

    [self.moveList removeLastObject];
    [[NSNotificationCenter defaultCenter] postNotificationName:AnimationStepMoveCountChangeNotification object:@(self.moveList.count)];
    
    return lastObject;
}

- (AnimationBaseMoveObject *)findAnimationObjectWithIdenfier:(NSString *)identifier {
    
    if ([NSString stringIsNullOrEmpty:identifier]) {
        return nil;
    }
    if ([identifier isEqualToString:self.lineMoveObject.identifier]) {
        return self.lineMoveObject;
    }
    
    for (AnimationViewMoveObject *object in self.viewMoveList) {
        if ([object.identifier isEqualToString:identifier]) {
            return object;
        }
    }
    
    return nil;
}

@end
