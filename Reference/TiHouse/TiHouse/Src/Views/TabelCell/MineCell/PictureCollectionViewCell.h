//
//  PictureCollectionViewCell.h
//  TiHouse
//
//  Created by 尚文忠 on 2018/1/30.
//  Copyright © 2018年 Confused小伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssemarcFile.h"
@class PictureCollectionViewCell;
@protocol PictureCollectionViewCellDelegate <NSObject>
@optional
- (void)datePhotoViewCell:(PictureCollectionViewCell *)cell didSelectBtn:(UIButton *)selectBtn;
@end

@interface PictureCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) AssemarcFile *assemarcFile;
@property (nonatomic, assign) id<PictureCollectionViewCellDelegate> delegate;
@property (strong, nonatomic) CALayer *selectMaskLayer;
@property (strong, nonatomic) UIButton *selectBtn;
@property (nonatomic, strong) UIImageView *imageView;
- (void)changeSelectStatus:(BOOL)b; // 控制按钮
- (UIImage *)currentImage; // 返回当前的图片
@end
