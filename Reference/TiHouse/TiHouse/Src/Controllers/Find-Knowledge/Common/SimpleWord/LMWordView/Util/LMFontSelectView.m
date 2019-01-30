//
//  LMFontSelectView.m
//  TiHouse
//
//  Created by yahua on 2018/2/8.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "LMFontSelectView.h"

@interface LMFontSelectView()

@property (weak, nonatomic) IBOutlet UIButton *h2Button;
@property (weak, nonatomic) IBOutlet UIButton *h3Button;
@property (weak, nonatomic) IBOutlet UIButton *bButton;


@property (nonatomic, copy) void(^completeBlock)(NSInteger index);
@property (nonatomic, copy) void(^cancelBlock)(void);

@end

@implementation LMFontSelectView

+ (instancetype)showWithView:(UIView *)view completeBlock:(void(^)(NSInteger index))completeBlock cancelBlock:(void(^)(void))cancelBlock {
    
    LMFontSelectView *fontView = [[NSBundle mainBundle] loadNibNamed:@"LMFontSelectView" owner:self options:nil].firstObject;
    fontView.completeBlock = completeBlock;
    fontView.cancelBlock = cancelBlock;
    fontView.frame = [UIApplication sharedApplication].keyWindow.bounds;
    //相对于屏幕的位置
    CGRect frame = [view convertRect:view.bounds toView:nil];
    fontView.frame = CGRectMake(0, 0, kScreen_Width, frame.origin.y);
    [[UIApplication sharedApplication].keyWindow addSubview:fontView];
    
    return fontView;
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
   
    if (self.completeBlock) {
        self.completeBlock(index);
    }
}


- (void)setSelectFontIndex:(NSInteger)selectFontIndex {
    
    self.h2Button.selected = selectFontIndex==0;
    self.h3Button.selected = selectFontIndex==1;
}

- (void)setIsBlod:(BOOL)isBlod {
    
    self.bButton.selected = isBlod;
}

@end
