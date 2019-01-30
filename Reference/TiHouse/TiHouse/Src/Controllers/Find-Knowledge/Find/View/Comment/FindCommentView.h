//
//  FindCommentView.h
//  TiHouse
//
//  Created by weilai on 2018/2/5.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FindAssemarcCommentInfo.h"

@interface FindCommentView : UIView

@property (nonatomic, copy) void (^clickCommentBlock)(void);

- (void)refreshWithComments:(NSArray <FindAssemarcCommentInfo *>*)commentArray;

- (CGFloat)getFindCommentHeight;

@end
