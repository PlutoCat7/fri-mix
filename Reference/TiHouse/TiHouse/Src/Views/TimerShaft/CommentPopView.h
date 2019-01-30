//
//  CommentPopView.h
//  TiHouse
//
//  Created by Confused小伟 on 2018/1/29.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Dairyzan.h"
#import "House.h"
@interface CommentPopView : UIView

@property (nonatomic, copy) void(^CommentPopBtnClick)(NSInteger tag ,BOOL isZan);
-(void)ShowCommentWirhToView:(UIView *)view praises:(NSArray *)praises;
@property (nonatomic, assign) BOOL isMaster;

@end
