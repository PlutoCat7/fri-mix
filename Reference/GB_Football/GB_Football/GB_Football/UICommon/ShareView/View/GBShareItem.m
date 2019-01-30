//
//  GBShareItem.m
//  GB_Football
//
//  Created by Pizza on 2016/11/18.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBShareItem.h"
#import "XXNibBridge.h"


@interface GBShareItem()<XXNibBridge>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) UIImage *imageNomal;
@property (strong, nonatomic) UIImage *imagePress;
@property (weak, nonatomic) IBOutlet UIButton *button;

@end

@implementation GBShareItem

-(void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

-(void)setup
{
    [self.button addTarget:self action:@selector(touchDown) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self.button addTarget:self action:@selector(touchUp) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside];
    switch (self.tag)
    {
        case SHARE_TYPE_WECHAT:
        {
            self.titleLabel.text = LS(@"share.item.wechat");
            self.iconImageView.image = [UIImage imageNamed:@"WeChat"];
            self.imageNomal = [UIImage imageNamed:@"WeChat"];
            self.imagePress = [UIImage imageNamed:@"WeChat_view"];
            self.button.userInteractionEnabled = YES;
        }
            break;
        case SHARE_TYPE_CIRCLE:
        {
           self.titleLabel.text = LS(@"share.item.timeline");
            self.iconImageView.image = [UIImage imageNamed:@"WeChatp"];
            self.imageNomal = [UIImage imageNamed:@"WeChatp"];
            self.imagePress = [UIImage imageNamed:@"WeChatp_view"];
            self.button.userInteractionEnabled = YES;
        }
            break;
        case SHARE_TYPE_QQ:
        {
           self.titleLabel.text = LS(@"share.item.qq");
           self.iconImageView.image = [UIImage imageNamed:@"qq"];
            self.imageNomal = [UIImage imageNamed:@"qq"];
            self.imagePress = [UIImage imageNamed:@"qq_view"];
            self.button.userInteractionEnabled = YES;
        }
            break;
        case SHARE_TYPE_QQZONE:
        {
            self.titleLabel.text = LS(@"share.item.qqzone");
            self.iconImageView.image = [UIImage imageNamed:@"qqk"];
            self.imageNomal = [UIImage imageNamed:@"qqk"];
            self.imagePress = [UIImage imageNamed:@"qqk_view"];
            self.button.userInteractionEnabled = YES;
        }
            break;
        case SHARE_TYPE_WEIBO:
        {
            self.titleLabel.text = LS(@"share.item.weibo");
            self.iconImageView.image = [UIImage imageNamed:@"weibo"];
            self.imageNomal = [UIImage imageNamed:@"weibo"];
            self.imagePress = [UIImage imageNamed:@"weibo_view"];
            self.button.userInteractionEnabled = YES;
        }
            break;
        case SHARE_TYPE_NONE:
        {
            self.titleLabel.text = LS(@"");
            self.iconImageView.image = nil;
            self.imageNomal = nil;
            self.imagePress = nil;
            self.button.userInteractionEnabled = NO;
        }
            break;
        default:
        {
            self.titleLabel.text = LS(@"");
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
    if ([self.delegate respondsToSelector:@selector(GBShareItemAction:tag:)])
    {
        [self.delegate GBShareItemAction:self tag:self.tag];
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
