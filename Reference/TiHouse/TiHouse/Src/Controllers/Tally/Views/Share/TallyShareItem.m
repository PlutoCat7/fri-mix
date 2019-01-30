//
//  TallyShareItem.m
//
//  Created by Pizza on 2016/11/18.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "TallyShareItem.h"
#import "XXNibBridge.h"


@interface TallyShareItem()<XXNibBridge>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) UIImage *imageNomal;
@property (strong, nonatomic) UIImage *imagePress;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation TallyShareItem

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

-(void)setup
{
    [self.button addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self.button addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    
    [self updateUI];
}

- (void)setTag:(NSInteger)tag {
    [super setTag:tag];
    
    [self updateUI];
}

- (void)updateUI {
    switch (self.tag)
    {
        case SHARE_TYPE_WECHAT:
        {
            self.titleLabel.text = @"微信好友";
            self.iconImageView.image = [UIImage imageNamed:@"swechat"];
            self.imageNomal = [UIImage imageNamed:@"swechat"];
            self.imagePress = [UIImage imageNamed:@"swechat"];
            self.button.userInteractionEnabled = YES;
        }
            break;
        case SHARE_TYPE_CIRCLE:
        {
            self.titleLabel.text = @"微信朋友圈";
            self.iconImageView.image = [UIImage imageNamed:@"swechatp"];
            self.imageNomal = [UIImage imageNamed:@"swechatp"];
            self.imagePress = [UIImage imageNamed:@"swechatp"];
            self.button.userInteractionEnabled = YES;
        }
            break;
        case SHARE_TYPE_QQ:
        {
            self.titleLabel.text = @"QQ好友";
            self.iconImageView.image = [UIImage imageNamed:@"sqq"];
            self.imageNomal = [UIImage imageNamed:@"sqq"];
            self.imagePress = [UIImage imageNamed:@"sqq"];
            self.button.userInteractionEnabled = YES;
        }
            break;
        case SHARE_TYPE_WEIBO:
        {
            self.titleLabel.text = @"新浪微博";
            self.iconImageView.image = [UIImage imageNamed:@"sweibo"];
            self.imageNomal = [UIImage imageNamed:@"sweibo"];
            self.imagePress = [UIImage imageNamed:@"sweibo"];
            self.button.userInteractionEnabled = YES;
        }
            break;
        case SHARE_TYPE_Favor:
        {
            self.titleLabel.text = @"收藏";
            self.iconImageView.image = [UIImage imageNamed:@"sfavor"];
            self.imageNomal = [UIImage imageNamed:@"sfavor"];
            self.imagePress = [UIImage imageNamed:@"sfavor"];
            self.button.userInteractionEnabled = YES;
        }
            break;
        case SHARE_TYPE_Download:
        {
            self.titleLabel.text = @"下载";
            self.iconImageView.image = [UIImage imageNamed:@"sdownload"];
            self.imageNomal = [UIImage imageNamed:@"sdownload"];
            self.imagePress = [UIImage imageNamed:@"sdownload"];
            self.button.userInteractionEnabled = YES;
        }
            break;
        case SHARE_TYPE_NONE:
        {
            self.titleLabel.text = @"";
            self.iconImageView.image = nil;
            self.imageNomal = nil;
            self.imagePress = nil;
            self.button.userInteractionEnabled = NO;
        }
            break;
        default:
        {
            self.titleLabel.text = @"";
            self.iconImageView.image = nil;
            self.imageNomal = nil;
            self.imagePress = nil;
            self.button.userInteractionEnabled = NO;
        }
            break;
    }
}

- (IBAction)actionPress:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(TallyShareItemAction:tag:)])
    {
        [self.delegate TallyShareItemAction:self tag:self.tag];
    }
}

-(void)touchDown
{
    self.iconImageView.image = self.imagePress;
}

-(void)touchUp
{
    self.iconImageView.image = self.imageNomal;
}

@end
