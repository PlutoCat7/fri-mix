//
//  GBAlertViewOneWay.m
//  GB_TransferMarket
//
//  Created by Pizza on 2017/2/17.
//  Copyright © 2017年 gxd. All rights reserved.
//

#import "GBAlertViewOneWay.h"
#import <pop/POP.h>

@interface GBAlertViewOneWay()
@property (weak, nonatomic) IBOutlet UIButton *okButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *sheetView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic, copy) void (^okBlock)();
@end

@implementation GBAlertViewOneWay

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    [self setupAnimation];
}

- (IBAction)actionOnClickOk:(id)sender {
    [GBAlertViewOneWay hide];
    BLOCK_EXEC(self.okBlock)
}


+(GBAlertViewOneWay*)showWithTitle:(NSString*)title
                           content:(NSString*)content
                            button:(NSString*)button
                              onOk:(void (^)())okBlock
                             style:(GBALERT_STYLE)style
{
    GBAlertViewOneWay *hud = [GBAlertViewOneWay HUDForView:[UIApplication sharedApplication].keyWindow];
    if (hud)  [GBAlertViewOneWay remove];
    UIWindow *keywindow = [UIApplication sharedApplication].keyWindow;
    NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"GBAlertViewOneWay" owner:self options:nil];
    for (UIView *view in viewArray)
    {
        if ([view isKindOfClass:[GBAlertViewOneWay class]])
        {
            GBAlertViewOneWay *sheet = (GBAlertViewOneWay *)view;
            sheet.frame = [UIScreen mainScreen].bounds;
            [sheet.titleLabel setText:title];
            NSMutableAttributedString *mString = [[NSMutableAttributedString alloc]initWithString:content];
            [mString addAttribute:NSFontAttributeName
                            value:[UIFont systemFontOfSize:12.f]
                            range:NSMakeRange(0, [content length])];
            [mString addAttribute:NSForegroundColorAttributeName
                            value:[UIColor whiteColor]
                            range:NSMakeRange(0, [content length])];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
            [paragraphStyle setLineSpacing:10];
            [mString addAttribute:NSParagraphStyleAttributeName
                            value:paragraphStyle
                            range:NSMakeRange(0,[content length])];
            sheet.contentLabel.attributedText = mString;
            [sheet.okButton setTitle:button forState:UIControlStateNormal];
            if (style == GBALERT_STYLE_SURE_GREEN) {
                [sheet.okButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
            }
            sheet.okBlock = okBlock;
            [keywindow addSubview:sheet];
            return sheet;
        }
    }
    return nil;
    
}

+ (void)remove
{
    GBAlertViewOneWay *hud = [GBAlertViewOneWay HUDForView:[UIApplication sharedApplication].keyWindow];
    if (hud)[hud removeFromSuperview];
}

+ (BOOL)hide
{
    GBAlertViewOneWay *hud = [GBAlertViewOneWay HUDForView:[UIApplication sharedApplication].keyWindow];
    if (hud)
    {
        POPBasicAnimation *positionAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
        positionAnimation.toValue = @([UIScreen mainScreen].bounds.size.height);
        [hud.sheetView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
        positionAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished)
        {
            if (finished)
            {
                [hud.sheetView.layer pop_removeAnimationForKey:@"positionAnimation"];
                [hud removeFromSuperview];
            }
        };
        POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
        opacityAnimation.fromValue = @(1);
        opacityAnimation.toValue   = @(0);
        [hud.backView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
        opacityAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished)
        {
            if (finished)
            {
                [hud.backView.layer pop_removeAnimationForKey:@"opacityAnimation"];
            }
        };
        return YES;
    }
    return NO;
}

+ (GBAlertViewOneWay *)HUDForView: (UIView *)view
{
    GBAlertViewOneWay *hud = nil;
    NSArray *subViewsArray = view.subviews;
    Class hudClass = [GBAlertViewOneWay class];
    for (UIView *aView in subViewsArray) {
        if ([aView isKindOfClass:hudClass]) {
            hud = (GBAlertViewOneWay *)aView;
        }
    }
    return hud;
}


- (void)setupUI
{
    self.backView.opaque = 1.f;
    self.backView.alpha = 0.f;
    self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
}

- (void)setupAnimation{
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(0.2, 0.2)];
    scaleAnimation.toValue   = [NSValue valueWithCGSize:CGSizeMake(1,1)];
    scaleAnimation.springBounciness = 15.f;
    scaleAnimation.completionBlock = ^(POPAnimation * animation, BOOL finish){
        if(finish)[self.sheetView.layer pop_removeAnimationForKey:@"scaleAnim"];
    };
    [self.sheetView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnim"];
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.fromValue = @(0);
    opacityAnimation.toValue   = @(1);
    opacityAnimation.completionBlock = ^(POPAnimation *anim, BOOL finished){if (finished){
        self.backView.alpha = 1.0f;
        if (finished)[self.backView.layer pop_removeAnimationForKey:@"opacityAnimation"];
    }};
    [self.backView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

-(void)dealloc
{
    [self.sheetView.layer pop_removeAllAnimations];
    [self.backView.layer pop_removeAllAnimations];
}
@end
