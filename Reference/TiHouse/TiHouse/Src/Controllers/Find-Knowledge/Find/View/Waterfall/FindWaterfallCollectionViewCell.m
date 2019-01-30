//
//  FindWaterfallCollectionViewCell.m
//  TiHouse
//
//  Created by yahua on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "FindWaterfallCollectionViewCell.h"
#import "UIImageView+WebCache.h"

#import "FindWaterfallModel.h"

@interface FindWaterfallCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatorImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UIImageView *zanImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightLayoutConstraint;

@property (strong, nonatomic) FindWaterfallModel *model;

@end

@implementation FindWaterfallCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentImageView.clipsToBounds = YES;
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImageView.layer.cornerRadius = 5.0f;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    self.userAvatorImageView.layer.cornerRadius = self.userAvatorImageView.width/2;
}

- (void)refreshWithModel:(FindWaterfallModel *)model {
    _model = model;
    
    [self.contentImageView sd_setImageWithURL:model.imageUrl completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        
//        if (image) {
//            model.imageWidth = image.size.width;
//            model.imageHeight = image.size.height;
//        }
    }];
    
    self.titleLabel.text = model.title;
    [self.titleLabel sizeToFit];
    
    [self.userAvatorImageView sd_setImageWithURL:model.userAvatorUrl];
    self.userNameLabel.text = model.userName;
    self.likeCount.text = @(model.likeCount).stringValue;
    self.zanImageView.image = [UIImage imageNamed:model.isMeLike?@"find_root_has_like":@"find_root_like"];
    
    self.textViewHeightLayoutConstraint.constant = self.titleLabel.bottom + kFindWaterfallCollectionViewCellTextHeight;
}

- (void)refreshWithLikeCount:(NSInteger)likeCount isLike:(BOOL)isLike {
    
    self.likeCount.text = @(likeCount).stringValue;
    self.zanImageView.image = [UIImage imageNamed:isLike?@"find_root_has_like":@"find_root_like"];
}

- (IBAction)actionZan:(id)sender {
    if (self.clickZanBlock) {
        self.clickZanBlock(_model);
    }
}

@end
