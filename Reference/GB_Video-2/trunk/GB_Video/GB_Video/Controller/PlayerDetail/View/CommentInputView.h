//
//  CommentInputView.h
//  GB_Video
//
//  Created by yahua on 2018/1/26.
//  Copyright © 2018年 GoBrother. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentInputView : UIView

+ (void)showWithCommentBlock:(void(^)(NSString *comment))block;

@end
