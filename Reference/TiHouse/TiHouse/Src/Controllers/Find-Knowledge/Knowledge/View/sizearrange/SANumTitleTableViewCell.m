//
//  SANumTitleTableViewCell.m
//  TiHouse
//
//  Created by weilai on 2018/2/1.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "SANumTitleTableViewCell.h"

@interface SANumTitleTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *favorImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;

@property (strong, nonatomic) KnowModeInfo *knowModeInfo;

@end

@implementation SANumTitleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)refreshWithKnowModeInfo:(KnowModeInfo *)knowModeInfo isFontBold:(BOOL)isFontBold {
    _knowModeInfo = knowModeInfo;
    
    if (_knowModeInfo.knowiscoll) {
        self.favorImageView.image = [UIImage imageNamed:@"klistfavor.png"];
    } else {
        self.favorImageView.image = [UIImage imageNamed:@"klistunfavor.png"];
    }
    self.titleLabel.text = _knowModeInfo.knowtitle;
    if (isFontBold) {
        [self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    }
    
    if (_knowModeInfo.isExpand) {
        
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _arrowImageView.layer.transform = CATransform3DMakeRotation(M_PI/2, 0, 0, 1);
        } completion:NULL];
        
    } else {
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _arrowImageView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
        } completion:NULL];
    }
}

- (IBAction)actionExpand:(id)sender {
    if (_knowModeInfo.isExpand) {
        
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _arrowImageView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
        } completion:NULL];
        
    } else {
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _arrowImageView.layer.transform = CATransform3DMakeRotation(M_PI/2, 0, 0, 1);
        } completion:NULL];
    }
    
    _knowModeInfo.isExpand = !_knowModeInfo.isExpand;
    if (self.clickExpandBlock) {
        self.clickExpandBlock(_knowModeInfo);
    }
}

- (IBAction)actionItem:(id)sender {
//    if (self.clickItemBlock) {
//        self.clickItemBlock(_knowModeInfo);
//    }
    if (_knowModeInfo.isExpand) {
        
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _arrowImageView.layer.transform = CATransform3DMakeRotation(0, 0, 0, 1);
        } completion:NULL];
        
    } else {
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            _arrowImageView.layer.transform = CATransform3DMakeRotation(M_PI/2, 0, 0, 1);
        } completion:NULL];
    }
    
    _knowModeInfo.isExpand = !_knowModeInfo.isExpand;
    if (self.clickExpandBlock) {
        self.clickExpandBlock(_knowModeInfo);
    }
}

- (IBAction)actionFavor:(id)sender {
    if (self.clickFavorBlock) {
        self.clickFavorBlock(_knowModeInfo);
    }
}

@end
