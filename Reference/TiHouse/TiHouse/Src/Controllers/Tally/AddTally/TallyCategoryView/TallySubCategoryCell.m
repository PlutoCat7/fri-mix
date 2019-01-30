//
//  TallySubCategoryCell.m
//  TiHouse
//
//  Created by AlienJunX on 2018/1/26.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "TallySubCategoryCell.h"

@interface TallySubCategoryCell()


@end

@implementation TallySubCategoryCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        if (self.label == nil) {
            UILabel *label = [UILabel new];
            [self addSubview:label];
            self.label = label;
            [label mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            
            label.layer.cornerRadius = 3;
            label.layer.borderColor = XWColorFromHex(0xdadada).CGColor;
            label.layer.borderWidth = 0.5;
            label.backgroundColor = [UIColor whiteColor];
            label.font = [UIFont systemFontOfSize:12];
            label.textColor = XWColorFromHex(0x5d5d5d);
            label.textAlignment = NSTextAlignmentCenter;
            label.clipsToBounds = YES;
        }
        
    }
    
    return self;
}



@end
