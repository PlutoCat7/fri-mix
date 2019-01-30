// UIImage+Resize.m
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

#import "UIImage+Resize.h"
#import "UIImage+RoundedCorner.h"
#import "UIImage+Alpha.h"


NSData *UIImageCompress(UIImage *image)
{

	CGSize size = image.size;
	float width = image.size.width;
	float height = image.size.height;
	float compressLen = 480;
	BOOL isCompress = YES;
	float qua = 0.6;
	float min = (width > height) ? height:width;
    
	if (min < 240)
    {
		isCompress = NO;
	}
	if (width<480 && height<480)
    {
		qua=1;
	}
	
	if (isCompress)
    {
		if (height > width)
        {
			size.height = (int)(height * compressLen / width);
			size.width = compressLen;
		}else
        {
			size.width = (int)(width * compressLen / height);
			size.height = compressLen;
		}
	}
	
	NSData *data;
	UIImage * thImage;
	thImage = [image resizedImage:size interpolationQuality:kCGInterpolationMedium];
	data = UIImageJPEGRepresentation(thImage,0.9);
	
	// 1 512k
	//0.9 119k
	//0.8 90k
	//0.7 90k
	//0.6 53k
	//0.5 70k
	
	return data;
}


@implementation UIImage (Resize)

// Returns a copy of this image that is cropped to the given bounds.
// The bounds will be adjusted using CGRectIntegral.
// This method ignores the image's imageOrientation setting.
- (UIImage *)croppedImage:(CGRect)bounds {
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

// Returns a copy of this image that is squared to the thumbnail size.
// If transparentBorder is non-zero, a transparent border of the given size will be added around the edges of the thumbnail. (Adding a transparent border of at least one pixel in size has the side-effect of antialiasing the edges of the image when rotating it using Core Animation.)
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality {
    UIImage *resizedImage = [self resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                       bounds:CGSizeMake(thumbnailSize, thumbnailSize)
                                         interpolationQuality:quality];
    
    // Crop out any part of the image that's larger than the thumbnail size
    // The cropped rect must be centered on the resized image
    // Round the origin points so that the size isn't altered when CGRectIntegral is later invoked
    CGRect cropRect = CGRectMake(round((resizedImage.size.width - thumbnailSize) / 2),
                                 round((resizedImage.size.height - thumbnailSize) / 2),
                                 thumbnailSize,
                                 thumbnailSize);
    UIImage *croppedImage = [resizedImage croppedImage:cropRect];
    
    UIImage *transparentBorderImage = borderSize ? [croppedImage transparentBorderImage:borderSize] : croppedImage;

    return [transparentBorderImage roundedCornerImage:cornerRadius borderSize:borderSize];
}
- (UIImage *) maskWithColor:(UIColor *) color
{
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGRect bounds = CGRectMake(0,0,width,height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL, width, height, 8, 0, colorSpace, kCGBitmapFloatComponents);
    CGContextClipToMask(bitmapContext, bounds, self.CGImage);
    CGContextSetFillColorWithColor(bitmapContext, color.CGColor);
    CGContextFillRect(bitmapContext, bounds);
    
    CGImageRef cImage = CGBitmapContextCreateImage(bitmapContext);
    UIImage *coloredImage = [UIImage imageWithCGImage:cImage];
    
    CGContextRelease(bitmapContext);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(cImage);
    
    return coloredImage;
    
}
- (UIImage *) renderAtSize:(const CGSize) size
{
    UIGraphicsBeginImageContext(size);
    const CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    const CGImageRef cgImage = CGBitmapContextCreateImage(context);
    UIImage *renderedImage = [UIImage imageWithCGImage:cgImage];
    
    CGImageRelease(cgImage);
    UIGraphicsEndImageContext();
    
    return renderedImage;
}
- (UIImage *) maskWithImage:(const UIImage *) maskImage
{
    const CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    const CGImageRef maskImageRef = maskImage.CGImage;
    
    const CGContextRef mainViewContentContext = CGBitmapContextCreate (NULL, maskImage.size.width, maskImage.size.height, 8, 0, colorSpace, kCGBitmapFloatComponents);
    CGColorSpaceRelease(colorSpace);
    
    if (! mainViewContentContext)
    {
        return nil;
    }
    
    CGFloat ratio = maskImage.size.width / self.size.width;
    
    if (ratio * self.size.height < maskImage.size.height)
    {
        ratio = maskImage.size.height / self.size.height;
    }
    
    const CGRect maskRect  = CGRectMake(0, 0, maskImage.size.width, maskImage.size.height);
    
    const CGRect imageRect  = CGRectMake(-((self.size.width * ratio) - maskImage.size.width) / 2,
                                         -((self.size.height * ratio) - maskImage.size.height) / 2,
                                         self.size.width * ratio,
                                         self.size.height * ratio);
    
    CGContextClipToMask(mainViewContentContext, maskRect, maskImageRef);
    CGContextDrawImage(mainViewContentContext, imageRect, self.CGImage);
    
    CGImageRef newImage = CGBitmapContextCreateImage(mainViewContentContext);
    CGContextRelease(mainViewContentContext);
    
    UIImage *theImage = [UIImage imageWithCGImage:newImage];
    
    CGImageRelease(newImage);
    
    return theImage;
    
}
// Returns a rescaled copy of the image, taking into account its orientation
// The image will be scaled disproportionately if necessary to fit the bounds specified by the parameter
- (UIImage *)resizedImage:(CGSize)newSize interpolationQuality:(CGInterpolationQuality)quality {
    BOOL drawTransposed;
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    return [self resizedImage:newSize
                    transform:[self transformForOrientation:newSize]
               drawTransposed:drawTransposed
         interpolationQuality:quality];
}
static inline CGFloat DegreesToRadians(CGFloat degrees)
{
	return M_PI * (degrees / 180.0);
}
// Resizes the image according to the given content mode, taking into account the image's orientation
- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality {
    CGFloat horizontalRatio = bounds.width / self.size.width;
    CGFloat verticalRatio = bounds.height / self.size.height;
    CGFloat ratio;
    
    switch (contentMode) {
        case UIViewContentModeScaleAspectFill:
            ratio = MAX(horizontalRatio, verticalRatio);
            break;
            
        case UIViewContentModeScaleAspectFit:
            ratio = MIN(horizontalRatio, verticalRatio);
            break;
            
        default:
            [NSException raise:NSInvalidArgumentException format:@"Unsupported content mode: %@", @(contentMode)];
    }
    
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    
    return [self resizedImage:newSize interpolationQuality:quality];
}
- (UIImage *)rotatedByDegrees:(CGFloat)degrees
{
	// calculate the size of the rotated view's containing box for our drawing space
	UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
	CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
	rotatedViewBox.transform = t;
	CGSize rotatedSize = rotatedViewBox.frame.size;
	
	// Create the bitmap context
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	
	// Move the origin to the middle of the image so we will rotate and scale around the center.
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	
	//   // Rotate the image context
	CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
	
	// Now, draw the rotated/scaled image into the context
	CGContextScaleCTM(bitmap, 1.0, -1.0);
	CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
	
	
}

- (UIImage *)rotatedMirror
{
	// calculate the size of the rotated view's containing box for our drawing space
	UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,self.size.width, self.size.height)];
	 CGAffineTransform transform = CGAffineTransformIdentity;
	transform = CGAffineTransformTranslate(transform, self.size.width, 0);
 transform = CGAffineTransformRotate(transform, M_PI_2);
//	CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));
	rotatedViewBox.transform = transform;
	CGSize rotatedSize = rotatedViewBox.frame.size;
	
	// Create the bitmap context
	UIGraphicsBeginImageContext(rotatedSize);
	CGContextRef bitmap = UIGraphicsGetCurrentContext();
	
	// Move the origin to the middle of the image so we will rotate and scale around the center.
	CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
	
	//   // Rotate the image context
	CGContextRotateCTM(bitmap, 0);
	
	// Now, draw the rotated/scaled image into the context
	CGContextScaleCTM(bitmap, 1.0, -1.0);
	CGContextDrawImage(bitmap, CGRectMake(-self.size.width / 2, -self.size.height / 2, self.size.width, self.size.height), [self CGImage]);
	
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
	
	
}


/*
 CGAffineTransform transform = CGAffineTransformIdentity;
 
 switch (self.imageOrientation) {
 case UIImageOrientationDown:           // EXIF = 3
 case UIImageOrientationDownMirrored:   // EXIF = 4
 transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
 transform = CGAffineTransformRotate(transform, M_PI);
 break;
 
 case UIImageOrientationLeft:           // EXIF = 6
 case UIImageOrientationLeftMirrored:   // EXIF = 5
 transform = CGAffineTransformTranslate(transform, newSize.width, 0);
 transform = CGAffineTransformRotate(transform, M_PI_2);
 */
- (UIImage *)fixOrientation {
	
	// No-op if the orientation is already correct
	if (self.imageOrientation == UIImageOrientationUp) return self;
	
	// We need to calculate the proper transformation to make the image upright.
	// We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
	CGAffineTransform transform = CGAffineTransformIdentity;
	
	switch (self.imageOrientation) {
		case UIImageOrientationDown:
		case UIImageOrientationDownMirrored:
			transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
			transform = CGAffineTransformRotate(transform, M_PI);
			break;
			
		case UIImageOrientationLeft:
		case UIImageOrientationLeftMirrored:
			transform = CGAffineTransformTranslate(transform, self.size.width, 0);
			transform = CGAffineTransformRotate(transform, M_PI_2);
			break;
			
		case UIImageOrientationRight:
		case UIImageOrientationRightMirrored:
			transform = CGAffineTransformTranslate(transform, 0, self.size.height);
			transform = CGAffineTransformRotate(transform, -M_PI_2);
			break;
		case UIImageOrientationUp:
		case UIImageOrientationUpMirrored:
			break;
	}
	
	switch (self.imageOrientation) {
		case UIImageOrientationUpMirrored:
		case UIImageOrientationDownMirrored:
			transform = CGAffineTransformTranslate(transform, self.size.width, 0);
			transform = CGAffineTransformScale(transform, -1, 1);
			break;
			
		case UIImageOrientationLeftMirrored:
		case UIImageOrientationRightMirrored:
			transform = CGAffineTransformTranslate(transform, self.size.height, 0);
			transform = CGAffineTransformScale(transform, -1, 1);
			break;
		case UIImageOrientationUp:
		case UIImageOrientationDown:
		case UIImageOrientationLeft:
		case UIImageOrientationRight:
			break;
	}
	
	// Now we draw the underlying CGImage into a new context, applying the transform
	// calculated above.
	CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
											 CGImageGetBitsPerComponent(self.CGImage), 0,
											 CGImageGetColorSpace(self.CGImage),
											 CGImageGetBitmapInfo(self.CGImage));
	CGContextConcatCTM(ctx, transform);
	switch (self.imageOrientation) {
		case UIImageOrientationLeft:
		case UIImageOrientationLeftMirrored:
		case UIImageOrientationRight:
		case UIImageOrientationRightMirrored:
			// Grr...
			CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
			break;
			
		default:
			CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
			break;
	}
	
	// And now we just create a new UIImage from the drawing context
	CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
	UIImage *img = [UIImage imageWithCGImage:cgimg];
	CGContextRelease(ctx);
	CGImageRelease(cgimg);
	return img;
}

#pragma mark -
#pragma mark Private helper methods

// Returns a copy of the image that has been transformed using the given affine transform and scaled to the new size
// The new image's orientation will be UIImageOrientationUp, regardless of the current image's orientation
// If the new size is not integral, it will be rounded up
- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality {
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0, newSize.width, newSize.height));
    CGRect transposedRect = CGRectMake(0, 0, newRect.size.height, newRect.size.width);
    CGImageRef imageRef = self.CGImage;
    //bugfix:refer http://developer.apple.com/library/mac/#qa/qa1037/_index.html
    CGColorSpaceRef spaceRef = CGImageGetColorSpace(imageRef);
    //转换为RGB
    BOOL newCreated = NO;
    if (CGColorSpaceGetModel(spaceRef) != kCGColorSpaceModelRGB) {
        newCreated = YES;
        spaceRef = CGColorSpaceCreateDeviceRGB();
    }
#if 0
    CGBitmapInfo info = CGImageGetBitmapInfo(imageRef);
    if (info == kCGImageAlphaLast) {
        info = kCGImageAlphaNoneSkipLast;
    }
    info = info & ~kCGBitmapAlphaInfoMask;
    info = info | kCGImageAlphaNoneSkipLast;
#endif
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                //guoxj:capture img should use |8|
                                                CGImageGetBitsPerComponent(imageRef), 
                                                0,
                                                spaceRef,
                                                //may use |info|
                                                kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast);
    
    // Rotate and/or flip the image if required by its orientation
    CGContextConcatCTM(bitmap, transform);
    
    // Set the quality level to use when rescaling
    CGContextSetInterpolationQuality(bitmap, quality);
    
    // Draw into the context; this scales the image
    CGContextDrawImage(bitmap, transpose ? transposedRect : newRect, imageRef);
    
    // Get the resized image from the context and a UIImage
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    if (newCreated) {
        CGColorSpaceRelease(spaceRef);
    }

    return newImage;
}

// Returns an affine transform that takes into account the image orientation when drawing a scaled image
- (CGAffineTransform)transformForOrientation:(CGSize)newSize {
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:           // EXIF = 3
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, newSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:           // EXIF = 6
        case UIImageOrientationLeftMirrored:   // EXIF = 5
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:          // EXIF = 8
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, 0, newSize.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:     // EXIF = 2
        case UIImageOrientationDownMirrored:   // EXIF = 4
            transform = CGAffineTransformTranslate(transform, newSize.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:   // EXIF = 5
        case UIImageOrientationRightMirrored:  // EXIF = 7
            transform = CGAffineTransformTranslate(transform, newSize.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    return transform;
}

- (UIImage *)resizedImageWithVRect:(CGRect)vRect hRect:(CGRect)hRect destSize:(CGSize)destSize
{
    UIGraphicsBeginImageContext(destSize); 
    [self drawInRect:CGRectMake(0, 0, destSize.width, destSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext(); 
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIImage *)getImageFromLayer:(CALayer *)layer
{
	//UIGraphicsBeginImageContext(theView.bounds.size);
	UIGraphicsBeginImageContextWithOptions(layer.bounds.size, NO, layer.contentsScale);
	[layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}
+(UIImage *)getImageFromView:(UIView *)theView
{
	//UIGraphicsBeginImageContext(theView.bounds.size);
	UIGraphicsBeginImageContextWithOptions(theView.bounds.size, NO, theView.layer.contentsScale);
	[theView.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return image;
}

- (UIImage *)hFlip
{
	
	
	CGContextRef context = CGBitmapContextCreate(
												 NULL,
												 self.size.width,
												 self.size.height,

												 CGImageGetBitsPerComponent(self.CGImage),
												 0,
												 CGImageGetColorSpace(self.CGImage),
												 CGImageGetBitmapInfo(self.CGImage)
												 );
	
	CGAffineTransform transform = CGAffineTransformIdentity;
	
 
//	transform = CGAffineTransformRotate(transform, M_PI_2);

	transform = CGAffineTransformScale(transform, -1, 1);
	transform = CGAffineTransformTranslate(transform, -self.size.width, 0);
//	transform = CGAffineTransformTranslate(transform, 0, 0);
//	transform = CGAffineTransformRotate(transform, 2*M_PI);
//	transform = CGAffineTransformTranslate(transform, -self.size.height, -self.size.width);
	
	CGContextConcatCTM(context, transform);
	CGContextDrawImage(context, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
	
	// And now we just create a new UIImage from the drawing context
	CGImageRef cgimg = CGBitmapContextCreateImage(context);
	UIImage *imgf = [UIImage imageWithCGImage:cgimg];
	CGContextRelease(context);
	CGImageRelease(cgimg);
	
	return imgf;
}

@end
