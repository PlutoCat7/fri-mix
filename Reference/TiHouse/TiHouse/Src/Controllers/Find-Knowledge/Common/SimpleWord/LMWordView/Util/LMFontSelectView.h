//
//  LMFontSelectView.h
//  TiHouse
//
//  Created by yahua on 2018/2/8.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LMFontSelectView : UIView

+ (instancetype)showWithView:(UIView *)view completeBlock:(void(^)(NSInteger index))completeBlock cancelBlock:(void(^)(void))cancelBlock;

@property (nonatomic, assign) NSInteger selectFontIndex;  //选择的字体索引
@property (nonatomic, assign) BOOL isBlod;  //是否粗体

- (void)close;
@end
