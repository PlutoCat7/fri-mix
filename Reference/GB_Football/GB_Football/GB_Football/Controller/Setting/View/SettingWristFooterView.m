//
//  SettingWristFooterView.m
//  GB_Football
//
//  Created by gxd on 2018/1/11.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "SettingWristFooterView.h"

@interface SettingWristFooterView()

@property (weak, nonatomic) IBOutlet UILabel *restartStLbl;
@property (weak, nonatomic) IBOutlet UILabel *closeStLbl;
@property (weak, nonatomic) IBOutlet UIButton *restartBtn;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation SettingWristFooterView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self.restartBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.restartBtn addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    
    [self.closeBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self.closeBtn addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    
    self.restartStLbl.text = LS(@"setting.label.restart");
    self.closeStLbl.text = LS(@"setting.label.close");
}

-(void)touchDown:(id)sender
{
    UIButton *button = sender;
    button.backgroundColor = [UIColor colorWithHex:0x202020 andAlpha:0.5f];
}

-(void)touchUp:(id)sender
{
    UIButton *button = sender;
    button.backgroundColor = [UIColor colorWithHex:0x202020];
}

- (IBAction)actionClickRestart:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickRestart)]) {
        [self.delegate didClickRestart];
    }
}

- (IBAction)actionClickClose:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didClickClose)]) {
        [self.delegate didClickClose];
    }
}

@end
