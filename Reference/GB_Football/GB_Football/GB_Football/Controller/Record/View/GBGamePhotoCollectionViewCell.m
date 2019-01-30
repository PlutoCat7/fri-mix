//
//  GBGameCollectionViewCell.m
//  GB_Football
//
//  Created by yahua on 2017/12/15.
//  Copyright © 2017年 Go Brother. All rights reserved.
//

#import "GBGamePhotoCollectionViewCell.h"
#import "GBGamePhotosViewModel.h"
#import "UIImageView+WebCache.h"
#import "YAHPhotoTools.h"

@interface GBGamePhotoCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;

@property (nonatomic, strong) GBGamePhotosCellModel *model;

@end

@implementation GBGamePhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshWithModel:(GBGamePhotosCellModel *)mode {
    
    _model = mode;
    if (mode.state == 0) {
        self.playImageView.hidden = YES;
        if (mode.photoImage) {
            self.imageView.image = mode.photoImage;
        }else {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:mode.url] placeholderImage:[UIImage imageNamed:@"photo_default2"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error) {
                    mode.photoImage = image;
                }
            }];
        }
    }else {
        self.playImageView.hidden = NO;
        if (mode.videoImage) {
            self.imageView.image = mode.videoImage;
        }else {
            self.imageView.image = [UIImage imageNamed:@"photo_default2"];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                UIImage *image = [YAHPhotoTools getCoverImage:[NSURL URLWithString:mode.url] atTime:0 isKeyImage:YES];
                mode.videoImage = image;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (self.model == mode) {
                        self.imageView.image = image;
                    }
                    
                });
            });
        }
    }
}

@end
