//
//  CloudRecordCollectHeadView.m
//  TiHouse
//
//  Created by 陈晨昕 on 2018/3/6.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "CloudRecordCollectHeadView.h"

@implementation CloudRecordCollectHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel = [[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textColor = XWColorFromHex(0x999999);
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(12);
            make.bottom.mas_equalTo(10);
            make.height.mas_equalTo(13);
        }];
    }
    return self;
}

@end
