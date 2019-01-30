//
//  UITextView+YHPlaceHolder.m
//  YHCommon
//
//  Created by gxd on 2018/1/19.
//  Copyright © 2018年 Go Brother. All rights reserved.
//

#import "UITextView+YHPlaceHolder.h"
#import <objc/runtime.h>
static const void *yh_placeHolderKey;

@interface UITextView ()
@property (nonatomic, readonly) UILabel *yh_placeHolderLabel;
@end

@implementation UITextView (YHPlaceHolder)
+(void)load{
    [super load];
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")),
                                   class_getInstanceMethod(self.class, @selector(yhPlaceHolder_swizzling_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(yhPlaceHolder_swizzled_dealloc)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"setText:")),
                                   class_getInstanceMethod(self.class, @selector(yhPlaceHolder_swizzled_setText:)));
}
#pragma mark - swizzled
- (void)yhPlaceHolder_swizzled_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self yhPlaceHolder_swizzled_dealloc];
}
- (void)yhPlaceHolder_swizzling_layoutSubviews {
    if (self.yh_placeHolder) {
        UIEdgeInsets textContainerInset = self.textContainerInset;
        CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
        CGFloat x = lineFragmentPadding + textContainerInset.left + self.contentInset.left;
        CGFloat y = textContainerInset.top + self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds) - x - textContainerInset.right - 2*self.layer.borderWidth;
        CGFloat height = [self.yh_placeHolderLabel sizeThatFits:CGSizeMake(width, 0)].height;
        self.yh_placeHolderLabel.frame = CGRectMake(x, y, width, height);
    }
    [self yhPlaceHolder_swizzling_layoutSubviews];
}
- (void)yhPlaceHolder_swizzled_setText:(NSString *)text{
    [self yhPlaceHolder_swizzled_setText:text];
    if (self.yh_placeHolder) {
        [self updatePlaceHolder];
    }
}
#pragma mark - associated

//- (void)setContentInset:(UIEdgeInsets)contentInset {
//    
//    [super setContentInset:contentInset];
//    self.yh_placeHolderLabel.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
//}

-(NSString *)yh_placeHolder{
    return objc_getAssociatedObject(self, &yh_placeHolderKey);
}
-(void)setYh_placeHolder:(NSString *)yh_placeHolder{
    objc_setAssociatedObject(self, &yh_placeHolderKey, yh_placeHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updatePlaceHolder];
}
-(UIColor *)yh_placeHolderColor{
    return self.yh_placeHolderLabel.textColor;
}
-(void)setYh_placeHolderColor:(UIColor *)yh_placeHolderColor{
    self.yh_placeHolderLabel.textColor = yh_placeHolderColor;
}
-(NSString *)placeholder{
    return self.yh_placeHolder;
}
-(void)setPlaceholder:(NSString *)placeholder{
    self.yh_placeHolder = placeholder;
}
#pragma mark - update
- (void)updatePlaceHolder{
    if (self.text.length) {
        [self.yh_placeHolderLabel removeFromSuperview];
        return;
    }
    self.yh_placeHolderLabel.font = self.font?self.font:self.cacutDefaultFont;
    self.yh_placeHolderLabel.textAlignment = self.textAlignment;
    self.yh_placeHolderLabel.text = self.yh_placeHolder;
    [self insertSubview:self.yh_placeHolderLabel atIndex:0];
}
#pragma mark - lazzing
-(UILabel *)yh_placeHolderLabel{
    UILabel *placeHolderLab = objc_getAssociatedObject(self, @selector(yh_placeHolderLabel));
    if (!placeHolderLab) {
        placeHolderLab = [[UILabel alloc] init];
        placeHolderLab.numberOfLines = 0;
        placeHolderLab.textColor = [UIColor lightGrayColor];
        objc_setAssociatedObject(self, @selector(yh_placeHolderLabel), placeHolderLab, OBJC_ASSOCIATION_RETAIN);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlaceHolder) name:UITextViewTextDidChangeNotification object:self];
    }
    return placeHolderLab;
}
- (UIFont *)cacutDefaultFont{
    static UIFont *font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextView *textview = [[UITextView alloc] init];
        textview.text = @" ";
        font = textview.font;
    });
    return font;
}
@end
