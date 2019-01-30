//
//  TallyVoiceInputTipCell.m
//  Demo2018
//
//  Created by AlienJunX on 2018/2/1.
//  Copyright © 2018年 AlienJunX. All rights reserved.
//

#import "TallyVoiceInputTipCell.h"

@implementation TallyVoiceInputTipCell
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        if (self.label == nil) {
            UIView *bgView = [UIView new];
            bgView.backgroundColor = XWColorFromHex(0xfefada);
            [self addSubview:bgView];
            
            
            UILabel *label = [UILabel new];
            [self addSubview:label];
            self.label = label;
            [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self);
                make.top.equalTo(self);
            }];
            label.backgroundColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:14];
            label.textColor = XWColorFromHex(0x646455);
            label.backgroundColor = [UIColor clearColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.clipsToBounds = YES;
            
            [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(self.label).offset(-5);
                make.trailing.equalTo(self.label).offset(5);
                make.height.equalTo(@8);
                make.top.equalTo(self.label).offset(3);
            }];
            
        }
    }
    
    return self;
}
@end
