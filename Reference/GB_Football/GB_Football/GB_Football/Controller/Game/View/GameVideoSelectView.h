//
//  GameVideoSelectView.h
//  GB_Football
//
//  Created by yahua on 2017/12/11.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXNibBridge.h"
#import "MatchGamePhotosUploadManager.h"

@interface GameVideoSelectView : UIView <XXNibBridge>

@property (nonatomic, assign) NSInteger maxVideoCount;

@property (nonatomic, weak) UIViewController *superViewController;

- (NSArray<MatchGamePhotoUploadObject *> *)getMatchVideoUploadObjectList;

@end
