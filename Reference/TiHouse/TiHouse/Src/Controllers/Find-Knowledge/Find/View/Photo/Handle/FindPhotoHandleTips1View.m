//
//  FindPhotoHandleTips1View.m
//  TiHouse
//
//  Created by yahua on 2018/1/31.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindPhotoHandleTips1View.h"

@interface FindPhotoHandleTips1View ()

@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

@end

@implementation FindPhotoHandleTips1View

+ (instancetype)showWithSuperView:(UIView *)superView {
    
    FindPhotoHandleTips1View *view = [[NSBundle mainBundle] loadNibNamed:@"FindPhotoHandleTips1View" owner:self options:nil].firstObject;
    [superView addSubview:view];
    
    return view;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.center = CGPointMake(self.superview.width/2, self.superview.height/2);
    self.size = CGSizeMake(kRKBWIDTH(250), kRKBWIDTH(50));
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.tipsLabel.text = @"点击任意位置添加标签\n完善标签，你的图片会更容易被发现哦";
}

@end
