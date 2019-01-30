//
//  GBProgressLabelView.m
//  GB_Football
//
//  Created by Pizza on 2016/11/9.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBProgressLabelView.h"
#import "XXNibBridge.h"

@interface GBProgressLabelView()<XXNibBridge>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation GBProgressLabelView

-(void)setState:(PROGRESS_STATE)state
{
    _state = state;
    switch (state)
    {
        case PROGRESS_STATE_GUIDE:
        {
            self.titleLabel.text = LS(@"football.label.idle");
            self.tipLabel.text   = @"";
            self.titleLabel.textColor = [UIColor colorWithHex:0x909090];
            self.tipLabel.textColor = [UIColor cyanColor];
        }
            break;
        case PROGRESS_STATE_IDLE:
        {
            self.titleLabel.text = LS(@"football.label.swtich");
            self.tipLabel.text   = LS(@"football.label.start");
            self.titleLabel.textColor = [UIColor whiteColor];
            self.tipLabel.textColor = [UIColor cyanColor];
        }
            break;
        case PROGRESS_STATE_ING0:
        {
            self.titleLabel.text = LS(@"football.label.swtich");
            self.tipLabel.text   = LS(@"football.label.writing0");
            self.titleLabel.textColor = [UIColor whiteColor];
            self.tipLabel.textColor = [UIColor cyanColor];
        }
            break;
        case PROGRESS_STATE_ING1:
        {
            self.titleLabel.text = LS(@"football.label.swtich");
            self.tipLabel.text   = LS(@"football.label.writing1");
            self.titleLabel.textColor = [UIColor whiteColor];
            self.tipLabel.textColor = [UIColor cyanColor];
        }
            break;
        case PROGRESS_STATE_ING2:
        {
            self.titleLabel.text = LS(@"football.label.swtich");
            self.tipLabel.text   = LS(@"football.label.writing2");
            self.titleLabel.textColor = [UIColor whiteColor];
            self.tipLabel.textColor = [UIColor cyanColor];
        }
            break;
        case PROGRESS_STATE_ING3:
        {
            self.titleLabel.text = LS(@"football.label.swtich");
            self.tipLabel.text   = LS(@"football.label.writing3");
            self.titleLabel.textColor = [UIColor whiteColor];
            self.tipLabel.textColor = [UIColor cyanColor];
        }
            break;
        case PROGRESS_STATE_FAILED:
        {
            self.titleLabel.text = LS(@"football.label.swtich");
            self.tipLabel.text   = LS(@"football.toast.join.failed");
            self.titleLabel.textColor = [UIColor whiteColor];
            self.tipLabel.textColor = [UIColor redColor];
        }
            break;
        default:
            break;
    }
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.state = PROGRESS_STATE_GUIDE;
}

@end
