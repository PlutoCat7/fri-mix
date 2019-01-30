//
//  FindArticleImageTextAttachment.h
//  TiHouse
//
//  Created by yahua on 2018/2/6.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LMTextAttachmentType) {
    LMTextAttachmentTypeImage,
    LMTextAttachmentTypeCheckBox,
};

@interface FindArticleImageTextAttachment : NSTextAttachment <NSCoding>

@property (nonatomic, assign) LMTextAttachmentType attachmentType;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) CGFloat imageShowWidth;
@property (nonatomic, assign) CGFloat imageHeightWidthRatio;  //高宽比


+ (instancetype)attachmentWithImage:(UIImage *)image width:(CGFloat)width;
+ (instancetype)checkBoxAttachment;

@end
