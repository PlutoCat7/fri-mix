// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.
// guoxj:copy from http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/
// other refer:https://github.com/coryalder/UIImage_Resize
// Extends the UIImage class to support resizing/cropping
#import <UIKit/UIKit.h>
NSData *UIImageCompress(UIImage *image);
@interface UIImage (Resize)
- (UIImage *)croppedImage:(CGRect)bounds;
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageWithVRect:(CGRect)vRect hRect:(CGRect)hRect destSize:(CGSize)destSize; 
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;
- (UIImage *) maskWithImage:(const UIImage *) maskImage;
- (UIImage *) renderAtSize:(const CGSize) size;
- (UIImage *) maskWithColor:(UIColor *) color;

- (UIImage *)rotatedByDegrees:(CGFloat)degrees;
- (UIImage *)rotatedMirror;
- (UIImage *)fixOrientation;
+(UIImage *)getImageFromLayer:(CALayer *)layer;
+ (UIImage *)getImageFromView:(UIView *)theView;
- (UIImage *)hFlip;
@end
