//
//  ColorBigCellViewController.m
//  TiHouse
//
//  Created by weilai on 2018/5/6.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "ColorBigCellViewController.h"

#define kColorCardCollectionViewCellWidth kRKBWIDTH(160)
#define kColorCardCollectionViewCellHeight kRKBWIDTH(210)

@interface ColorBigCellViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *bgShadowView;
@property (weak, nonatomic) IBOutlet UIButton *favorButton;
@property (weak, nonatomic) IBOutlet UIImageView *cardImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vSpace;

@property (strong, nonatomic) ColorModeInfo *colorModeInfo;

@end

@implementation ColorBigCellViewController

- (void)setupUI {
    [self.bgView.layer setMasksToBounds:YES];
    [self.bgView.layer setCornerRadius:8.f];
    CALayer *shadowlayer =[CALayer layer];
    shadowlayer.backgroundColor = [UIColor whiteColor].CGColor;
    shadowlayer.shadowOffset = CGSizeMake(0, 1);
    shadowlayer.shadowRadius = 2.0;
    shadowlayer.shadowColor =[UIColor grayColor].CGColor;
    shadowlayer.shadowOpacity = 0.5;
    shadowlayer.frame = CGRectMake(0, 0, kColorCardCollectionViewCellWidth, kColorCardCollectionViewCellHeight);
    shadowlayer.cornerRadius = 8.0;
    [self.bgShadowView.layer addSublayer:shadowlayer];
}

- (void)refreshWithColorModeInfo:(ColorModeInfo *)colorModeInfo {
    
    self.colorModeInfo = colorModeInfo;
    
    if (colorModeInfo.colorcardiscoll) {
        [self.favorButton setBackgroundImage:[UIImage imageNamed:@"kcolorfavor.png"] forState:UIControlStateNormal];
    } else {
        [self.favorButton setBackgroundImage:[UIImage imageNamed:@"kcolorunfavor.png"] forState:UIControlStateNormal];
    }
    
    [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:colorModeInfo.colorcardurl] placeholderImage:nil];
    
}

- (void)refreshWithColorModeInfo:(ColorModeInfo *)colorModeInfo big:(BOOL)big {
    self.colorModeInfo = colorModeInfo;
    
    if (colorModeInfo.colorcardiscoll) {
        [self.favorButton setBackgroundImage:[UIImage imageNamed:@"kcolorfavor.png"] forState:UIControlStateNormal];
    } else {
        [self.favorButton setBackgroundImage:[UIImage imageNamed:@"kcolorunfavor.png"] forState:UIControlStateNormal];
    }
    
    [self.cardImageView sd_setImageWithURL:[NSURL URLWithString:colorModeInfo.colorcardurl] placeholderImage:nil];
    
    self.hSpace.constant = kRKBWIDTH(16);
    self.vSpace.constant = kRKBWIDTH(16);
}

- (IBAction)actionFavor:(id)sender {
    if (self.clickBlock) {
        self.clickBlock(self.colorModeInfo);
    }
}

@end
