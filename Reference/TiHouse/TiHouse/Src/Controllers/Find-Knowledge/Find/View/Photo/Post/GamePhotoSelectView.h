//
//  GamePhotoView.h
//  GB_Football
//
//  Created by yahua on 2017/10/18.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindPhotoLabelModel.h"

@class GamePhotoSelectView;
@protocol GamePhotoSelectViewDelegate <NSObject>

- (void)GamePhotoSelectViewFrameChange;

@end

@interface GamePhotoSelectView : UIView

@property (nonatomic, weak) id<GamePhotoSelectViewDelegate> delegate;
@property (nonatomic, weak) UIViewController *superViewController;
@property (nonatomic, assign) NSInteger maxImageCount;
@property (nonatomic, strong) NSMutableArray<FindPhotoHandleModel *> *photoModelList;

@end
