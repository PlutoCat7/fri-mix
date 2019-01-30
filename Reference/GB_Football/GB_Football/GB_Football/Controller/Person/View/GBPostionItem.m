//
//  GBPostionItem.m
//  GB_Football
//
//  Created by Leo Lin Software Engineer on 16/8/1.
//  Copyright © 2016年 Go Brother. All rights reserved.
//

#import "GBPostionItem.h"
#import "XXNibBridge.h"
#import <pop/POP.h>

typedef NS_ENUM(NSUInteger, POS_TYPE) {
    POS_CF = 0,
    POS_LWF,
    POS_SS,
    POS_RWF,
    POS_AMF,
    POS_LMF,
    POS_CMF,
    POS_RMF,
    POS_DMF,
    POS_LB,
    POS_CB,
    POS_RB,
    POS_GK,
};

@interface GBPostionItem ()<XXNibBridge>
@property (strong, nonatomic) IBOutlet UILabel *cnNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *enNameLabel;
@property (strong, nonatomic) IBOutlet UIView *colorBar;
@end

@implementation GBPostionItem

-(void)awakeFromNib
{
   [super awakeFromNib];
   [self setupUI];
}

// 点击了按钮
- (IBAction)actionClick:(id)sender {
}

-(void)setupUI
{
    self.layer.shadowRadius = 2.f;
    self.layer.shadowColor  = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2,4);
    self.layer.shadowOpacity = 1;
    
    self.colorBar.backgroundColor = [LogicManager positonColorWithIndex:self.tag];
    self.cnNameLabel.text = [LogicManager chinesePositonWithIndex:self.tag];
    self.enNameLabel.text = [LogicManager englishPositonWithIndex:self.tag];
    
    [self.button addTarget:self action:@selector(scaleToSmall)
   forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
    [self.button addTarget:self action:@selector(scaleAnimation)
   forControlEvents:UIControlEventTouchUpInside];
    [self.button addTarget:self action:@selector(scaleToDefault)
   forControlEvents:UIControlEventTouchDragExit];
}

#pragma mark - Getter and Setter

- (void)setSelected:(BOOL)selected {
    
    _selected = selected;
    self.enNameLabel.textColor = selected?[ColorManager styleColor]:[ColorManager textColor];
}

- (void)scaleToSmall
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(0.95f, 0.95f)];
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished)
    {
        [self.layer pop_removeAnimationForKey:@"layerScaleSmallAnimation"];
    };
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSmallAnimation"];
}

- (void)scaleAnimation
{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.velocity = [NSValue valueWithCGSize:CGSizeMake(3.f, 3.f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.springBounciness = 18.0f;
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished)
    {
        [self.layer pop_removeAnimationForKey:@"layerScaleSpringAnimation"];
    };
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleSpringAnimation"];
}

- (void)scaleToDefault
{
    POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.f, 1.f)];
    scaleAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished)
    {
        [self.layer pop_removeAnimationForKey:@"layerScaleDefaultAnimation"];
    };
    [self.layer pop_addAnimation:scaleAnimation forKey:@"layerScaleDefaultAnimation"];
}

-(void)dealloc
{
    [self.layer pop_removeAllAnimations];
}

@end
