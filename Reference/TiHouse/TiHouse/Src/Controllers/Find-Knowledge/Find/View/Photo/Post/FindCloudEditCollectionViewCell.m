//
//  FindCloudEditCollectionViewCell.m
//  TiHouse
//
//  Created by weilai on 2018/2/7.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindCloudEditCollectionViewCell.h"

@interface FindCloudEditCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation FindCloudEditCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setShowImage:(UIImage *)image {
    self.imageView.image = image;
}
@end
