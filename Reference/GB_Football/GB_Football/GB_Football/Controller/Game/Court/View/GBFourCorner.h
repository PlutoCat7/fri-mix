//
//  GBFourCorner.h
//  GB_Football
//
//  Created by Pizza on 16/8/18.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, STATE_CORNER) {
    STATE_WHITE = 0,
    STATE_RED,
    STATE_HEAD,
};

@class GBFourCorner;

@protocol GBFourCornerDelegate <NSObject>
@optional
- (void)GBFourCorner:(GBFourCorner*)cornerView didSelectAtIndex:(NSInteger)index;
@end

@interface GBFourCorner : UIView
@property(nonatomic, weak) id <GBFourCornerDelegate> delegate;
@property(nonatomic, assign)STATE_CORNER pointA;
@property(nonatomic, assign)STATE_CORNER pointB;
@property(nonatomic, assign)STATE_CORNER pointC;
@property(nonatomic, assign)STATE_CORNER pointD;
@end
