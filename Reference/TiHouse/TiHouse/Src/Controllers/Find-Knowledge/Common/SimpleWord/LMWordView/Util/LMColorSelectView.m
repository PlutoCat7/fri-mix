//
//  LMColorSelectView.m
//  TiHouse
//
//  Created by yahua on 2018/2/7.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "LMColorSelectView.h"

@interface LMColorSelectView ()

@property (weak, nonatomic) IBOutlet UIButton *button1;
@property (weak, nonatomic) IBOutlet UIButton *button2;
@property (weak, nonatomic) IBOutlet UIButton *button3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuViewBottomLayout;

@property (nonatomic, copy) void(^completeBlock)(UIColor *color);
@property (nonatomic, copy) void(^cancelBlock)(void);

@end

@implementation LMColorSelectView

+ (instancetype)showWithView:(UIView *)view completeBlock:(void(^)(UIColor *color))completeBlock cancelBlock:(void(^)(void))cancelBlock {
    
    LMColorSelectView *colorView = [[NSBundle mainBundle] loadNibNamed:@"LMColorSelectView" owner:self options:nil].firstObject;
    colorView.completeBlock = completeBlock;
    colorView.cancelBlock = cancelBlock;
    colorView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    //相对于屏幕的位置
    CGRect frame = [view convertRect:view.bounds toView:nil];
    colorView.frame = CGRectMake(0, 0, kScreen_Width, frame.origin.y);
    [[UIApplication sharedApplication].keyWindow addSubview:colorView];
    
    return colorView;
}

- (void)close {
    
    [self removeFromSuperview];
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (IBAction)actionBg:(id)sender {
    
    [self close];
}

- (IBAction)actionButton:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    NSInteger index = button.tag;
    NSArray *colorList = @[[UIColor blackColor], [UIColor colorWithRGBHex:0xF8C00C], [UIColor colorWithRGBHex:0x999999]];
    UIColor *color = nil;
    if (index<colorList.count) {
        color = colorList[index];
    }
    if (self.completeBlock) {
        self.completeBlock(color);
    }
}

@end
