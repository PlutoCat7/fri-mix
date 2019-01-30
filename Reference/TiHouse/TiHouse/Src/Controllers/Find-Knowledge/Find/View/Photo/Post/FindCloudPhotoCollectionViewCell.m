//
//  FindCloudPhotoCollectionViewCell.m
//  TiHouse
//
//  Created by yahua on 2018/2/3.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindCloudPhotoCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface FindCloudPhotoCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@end

@implementation FindCloudPhotoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    self.selectImageView.image = [UIImage imageNamed:selected?@"find_cloud_photp_select":@"find_cloud_photp_unselect"];
}

- (void)refreshWithModel:(FindCloudCellModel *)model {
    
    [self.imageView sd_setImageWithURL:model.imageUrl completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
       
        if (image) {
            model.image = image;
        }
    }];
}

@end
