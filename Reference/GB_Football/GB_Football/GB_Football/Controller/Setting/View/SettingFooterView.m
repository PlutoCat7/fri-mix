//
//  SettingFooterView.m
//  GB_Football
//
//  Created by 王时温 on 2017/6/9.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "SettingFooterView.h"

@interface SettingFooterView ()

@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation SettingFooterView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self.button addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown];
    [self.button addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
}

-(void)touchDown
{
    self.button.backgroundColor = [UIColor colorWithHex:0x202020 andAlpha:0.5f];
}

-(void)touchUp
{
    self.button.backgroundColor = [UIColor colorWithHex:0x202020];
}

- (IBAction)actionRelease:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(didClickFooterView)]) {
        [self.delegate didClickFooterView];
    }
}


@end
