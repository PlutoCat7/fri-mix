//
//  FeedBackTextView.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/27.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedBackTextView : UIView

@property (nonatomic, strong) UITextView *textView;
- (void)reloadCurrentNum:(NSInteger)num;

@end
