// UIImage+Alpha.h
// Created by Trevor Harmon on 9/20/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.
// guoxj:copy from http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/
// Helper methods for adding an alpha layer to an image
#import <UIKit/UIKit.h>
@interface UIImage (Alpha)
- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;
- (CGImageRef)newBorderMask:(NSUInteger)borderSize size:(CGSize)size;
@end
