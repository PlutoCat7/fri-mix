//
//  FindArticleImageTextAttachment.m
//  TiHouse
//
//  Created by yahua on 2018/2/6.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindArticleImageTextAttachment.h"
#import "LMParagraphConfig.h"

@implementation FindArticleImageTextAttachment

+ (instancetype)checkBoxAttachment {
    FindArticleImageTextAttachment *textAttachment = [[FindArticleImageTextAttachment alloc] init];
    textAttachment.bounds = CGRectMake(0, 0, 20, 20);
    textAttachment.image = [self imageWithType:LMParagraphTypeCheckbox];
    return textAttachment;
}

+ (instancetype)attachmentWithImage:(UIImage *)image width:(CGFloat)width {
    FindArticleImageTextAttachment *textAttachment = [[FindArticleImageTextAttachment alloc] init];
    CGRect rect = CGRectZero;
    rect.size.width = width;
    rect.size.height = width * image.size.height / image.size.width;
    textAttachment.bounds = rect;
    textAttachment.image = image;
    textAttachment.imageShowWidth = width;
    textAttachment.imageHeightWidthRatio = image.size.height / image.size.width;
    return textAttachment;
}

+ (UIImage *)imageWithType:(LMParagraphType)type {
    
    CGRect rect = CGRectMake(0, 0, 20, 20);
    UIGraphicsBeginImageContext(rect.size);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    [[UIColor redColor] setStroke];
    path.lineWidth = 2.f;
    [path stroke];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - NSCoding

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        id value= [coder decodeObjectForKey:@"attachmentType"];
        if (value) {
            [self setValue:value forKey:@"attachmentType"];
        }
        value= [coder decodeObjectForKey:@"imageUrl"];
        if (value) {
            [self setValue:value forKey:@"imageUrl"];
        }
        value= [coder decodeObjectForKey:@"imageShowWidth"];
        if (value) {
            [self setValue:value forKey:@"imageShowWidth"];
        }
        value= [coder decodeObjectForKey:@"imageHeightWidthRatio"];
        if (value) {
            [self setValue:value forKey:@"imageHeightWidthRatio"];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:[self valueForKey:@"attachmentType"] forKey:@"attachmentType"];
    [aCoder encodeObject:[self valueForKey:@"imageUrl"] forKey:@"imageUrl"];
    [aCoder encodeObject:[self valueForKey:@"imageShowWidth"] forKey:@"imageShowWidth"];
    [aCoder encodeObject:[self valueForKey:@"imageHeightWidthRatio"] forKey:@"imageHeightWidthRatio"];
}

- (CGRect)attachmentBoundsForTextContainer:(nullable NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex {
    
    CGRect rect = CGRectMake(0, 0, self.imageShowWidth, self.imageShowWidth*self.imageHeightWidthRatio);
    return rect;
}

@end
