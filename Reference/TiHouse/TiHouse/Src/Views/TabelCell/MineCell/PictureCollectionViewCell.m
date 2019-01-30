//
//  PictureCollectionViewCell.m
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import "PictureCollectionViewCell.h"
#import "HXPhotoTools.h"
#import "UIButton+HXExtension.h"

@interface PictureCollectionViewCell()

@end

@implementation PictureCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self imageView];
        [self selectBtn];
        [self changeSelectStatus:NO];
    }
    return self;
}

- (void)setAssemarcFile:(AssemarcFile *)assemarcFile {
    _assemarcFile = assemarcFile;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:_assemarcFile.assemarcfileurl]];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.clipsToBounds = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_imageView];
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [_imageView.layer addSublayer:self.selectMaskLayer];
    }
    return _imageView;
}

- (UIButton *)selectBtn {
    if (!_selectBtn) {
        _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectBtn setBackgroundImage:[HXPhotoTools hx_imageNamed:@"photo_-unselected1"] forState:UIControlStateNormal];
        [_selectBtn setBackgroundImage:[HXPhotoTools hx_imageNamed:@"photo_select"] forState:UIControlStateSelected];
        [_selectBtn setTitleColor:[UIColor clearColor] forState:UIControlStateSelected];
        _selectBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        _selectBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        [_selectBtn addTarget:self action:@selector(didSelectClick:) forControlEvents:UIControlEventTouchUpInside];
        [_selectBtn setEnlargeEdgeWithTop:0 right:0 bottom:20 left:20];
        _selectBtn.layer.cornerRadius = 21 / 2;
        [self.contentView addSubview:_selectBtn];
    }
    return _selectBtn;
}

- (CALayer *)selectMaskLayer {
    if (!_selectMaskLayer) {
        _selectMaskLayer = [CALayer layer];
        _selectMaskLayer.hidden = YES;
        _selectMaskLayer.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3].CGColor;
    }
    return _selectMaskLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.selectBtn.frame = CGRectMake(self.hx_w - 27, 2, 21, 21);
    self.selectMaskLayer.frame = self.bounds;
}

- (void)didSelectClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(datePhotoViewCell:didSelectBtn:)]) {
        [self.delegate datePhotoViewCell:self didSelectBtn:button];
    }
}

- (void)changeSelectStatus:(BOOL)b {
    if (b) {
        _selectBtn.hidden = NO;
        _selectBtn.userInteractionEnabled = YES;
    } else {
        _selectBtn.hidden = YES;
        _selectBtn.userInteractionEnabled = NO;
    }
}

- (UIImage *)currentImage {
    return _imageView.image;
}

@end
